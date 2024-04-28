this:include "player_state.lua"
this:include "bone_collisions.lua"
this:include "character_sounds.lua"

-- helper functions

function this.morph( this, morphName, blendTime )
	if ( morphName ~= "" ) then
		this:blendMorphAnimation( morphName, blendTime, 0 )
	end
end

-- signals

function this.signalShoot( this )
	-- Attack with currently selected weapon is activated as secondary anim. 
	local weaponName = this:weapon():name()
	if ( weaponName == "m16" ) then
		this:setSecondaryMovementAnimation( "shoot_rifle" )
	elseif ( weaponName == "beretta" ) then
		this:setSecondaryMovementAnimation( "shoot_handgun" )
	elseif ( weaponName == "shotgun" ) then
		this:setSecondaryMovementAnimation( "shoot_shotgun" )
	end
end

function this.signalReceiveExplosion( this, damage, dirx, diry, dirz, dist )
	local stillAlive = this:receiveDamage( damage )
	if ( stillAlive == "DEAD" ) then
		this:playDeathSound( "EXPLOSION" )
	end
end

function this.signalReceiveProjectile( this, bullet, cpointx, cpointy, cpointz, timeSinceLast )
	-- being dead or hurting prevent any change in state
	if ( not this:isDead() and not this:isHurting() and not this:isRolling() and this.projectileHurts ) then
		if ( this:isAiming() ) then
			local weaponName = this:weapon():name()
			local animNameSec = ""
			if ( weaponName == "m16" ) then
				animNameSec = "hero_projectile_hurt_aiming_rifle"
			elseif ( weaponName == "beretta" ) then
				animNameSec = "hero_projectile_hurt_aiming_handgun"
			elseif ( weaponName == "shotgun" ) then
				animNameSec = "hero_projectile_hurt_aiming_shotgun"
			end
			this:setSecondaryState( "PROJECTILE_HURT_WHILE_AIMING" )
			local animLen = this:getAnimLength( animNameSec )
			this:addSecondaryStateListener( "PROJECTILE_HURT_WHILE_AIMING", this.endMark, animLen, this.STATE_ENTRY+this.STATE_REMOVE )
			this:blendSecondaryAnimation( animNameSec, 0.25 )
		else
			this:setSecondaryState( "IDLING" )
			this:clearSecondaryAnimations()
		end

		local animNamePrim = "hero_projectile_hurt"
		if ( this:isCrouched() ) then
			animNamePrim = "hero_projectile_hurt_crouching"
		end

		this:setPrimaryState( "PROJECTILE_HURT" )
		local animLen = this:getAnimLength( animNamePrim )
		this:addPrimaryStateListener( "PROJECTILE_HURT", this.endMark, animLen, this.STATE_ENTRY+this.STATE_REMOVE )
		this:blendAnimation( animNamePrim, 0.25 )
		this:morph( this.morphProjectileHurting, 0.1 )
	end

	if ( bullet:getWeapon():triggerBlood() ) then
		local weaponName = bullet:getWeapon():name()
		-- Play blood splat particle system in world space
		-- towards direction of incoming bullet (direction of particle system Z-axis = -bulletVelocity)
		if ( weaponName == "m16" ) then 
			this:cell():playParticleSystemAt( "Generic_effects/blood_splat", cpointx, cpointy, cpointz )
			this:cell():playDirectedParticleSystemAt( "Generic_effects/blood_splat_m16", cpointx, cpointy, cpointz, bullet:getVelocity(0), bullet:getVelocity(1), bullet:getVelocity(2), nil )
			this:cell():playDirectedParticleSystemAt( "Generic_effects/blood_splat_m16_2", cpointx, cpointy, cpointz, bullet:getVelocity(0), bullet:getVelocity(1), bullet:getVelocity(2), nil )
			
		elseif ( weaponName == "beretta" ) then 
			this:cell():playParticleSystemAt( "Generic_effects/blood_splat", cpointx, cpointy, cpointz )
			this:cell():playDirectedParticleSystemAt( "Generic_effects/blood_splat_beretta", cpointx, cpointy, cpointz, bullet:getVelocity(0), bullet:getVelocity(1), bullet:getVelocity(2), nil )
			this:cell():playDirectedParticleSystemAt( "Generic_effects/blood_splat_beretta2", cpointx, cpointy, cpointz, bullet:getVelocity(0), bullet:getVelocity(1), bullet:getVelocity(2), nil )
		elseif ( weaponName == "shotgun" ) then 
			this:cell():playParticleSystemAt( "Generic_effects/blood_splat", cpointx, cpointy, cpointz )
			this:cell():playDirectedParticleSystemAt( "Generic_effects/blood_splat_shotgun", cpointx, cpointy, cpointz, bullet:getVelocity(0), bullet:getVelocity(1), bullet:getVelocity(2), nil )
			this:cell():playDirectedParticleSystemAt( "Generic_effects/blood_splat_shotgun2", cpointx, cpointy, cpointz, bullet:getVelocity(0), bullet:getVelocity(1), bullet:getVelocity(2), nil )
		end	
	
		-- play bullet hit sound if last hit was more than 2 secs ago
		if ( timeSinceLast >= 2 and not this:isDead() ) then
			this:playBulletHitSound()
		end
	end
	trace( this:name().." received "..bullet:damage().." damage" )
	local stillAlive = this:receiveDamage( bullet:damage() )
	if ( stillAlive == "DEAD" ) then
		this:playDeathSound( "PROJECTILE" )
	end
end

function this.signalReceivePhysicalAttack( this, sector, height, damage )
	this:setPrimaryState( "PHYSICAL_HURT" )
	this:setSecondaryState( "IDLING" )
	this:clearSecondaryAnimations()

	-- Sectors are numbered clockwise from front starting from 0, making left sector the sector number 3
	local extraDamage = 0
	local animName = ""
	if ( sector == 0 ) then
		-- attack from front
		animName = "hero_physical_hurt_front"
	elseif ( sector == 1 ) then
		-- attack from right
		animName = "hero_physical_hurt_right"
	elseif ( sector == 2 ) then
		-- attack from behind
		animName = "hero_physical_hurt_back"
		extraDamage = 100
	else
		-- attack from left
		animName = "hero_physical_hurt_left"
	end

	trace( this:name().." received physical strike in sector="..sector..", height=".. height .. ", anim=" .. animName )
	local animLen = this:getAnimLength( animName )
	this:addPrimaryStateListener( "PHYSICAL_HURT", this.endMark, animLen, this.STATE_ENTRY+this.STATE_REMOVE )
	this:blendAnimation( animName, 0.25 )
	this:morph( this.morphPhysicalHurting, 0.1 )
	this:playPhysicalAttackHitSound()
	local stillAlive = this:receiveDamage( damage + extraDamage )
	if ( stillAlive == "DEAD" ) then
		this:playDeathSound( "PHYSICAL" )
	end
end

-- state listeners

function this.looking( this )
	-- Looking around with the head is activated as secondary anim set (disabling anything previously running)
	this:activateSecondaryMovementAnimation( "Looking" )
end

function this.moving( this )
	-- Sneak/Walk/Run is activated as primary anim set (disabling anything previously running)
	this:activateMovementAnimation( "Moving" )
	this:morph( this.morphDefault, 0.2 )
end

function this.attack( this )
	this:morph( this.morphShooting, 0.1 )
end

-- aiming before shooting
function this.aim( this )
	-- Aiming with currently selected weapon is activated as secondary anim. 
	local weaponName = this:weapon():name()
	if ( weaponName == "m16" ) then
		this:activateSecondaryMovementAnimation( "aim_rifle" )
	elseif ( weaponName == "beretta" ) then
		this:activateSecondaryMovementAnimation( "aim_handgun" )
	elseif ( weaponName == "shotgun" ) then
		this:activateSecondaryMovementAnimation( "aim_shotgun" )
	end
	this:morph( this.morphAiming, 0.2 )
end

-- aiming after shooting
function this.holdAim( this )
	-- Aiming with currently selected weapon is set immediately as secondary anim. 
	local weaponName = this:weapon():name()
	if ( weaponName == "m16" ) then
		this:setSecondaryMovementAnimation( "aim_rifle" )
	elseif ( weaponName == "beretta" ) then
		this:setSecondaryMovementAnimation( "aim_handgun" )
	elseif ( weaponName == "shotgun" ) then
		this:setSecondaryMovementAnimation( "aim_shotgun" )
	end
	this:morph( this.morphAiming, 0.2 )
end

function this.attackStrike( this )
	local moveName = nil
	if ( this:weapon() ) then
		local weaponName = this:weapon():name()
		if ( weaponName == "m16" ) then
			moveName = "rifle_knock"
		elseif ( weaponName == "shotgun" ) then
			moveName = "shotgun_knock"
		elseif ( weaponName == "beretta" ) then
			moveName = "handgun_knock"
		end
	end

	if ( moveName ) then
		this:physicalAttack( moveName )
		local animName = this:getPhysicalAnim( moveName )
		this:blendSecondaryAnimation( animName, 0.1 )
		local endTime = this:getAnimLength(animName) - 0.1
		this:addSecondaryStateListener( "PHYSICAL_STRIKE", this.endMark, endTime, this.STATE_ENTRY+this.STATE_REMOVE )
	end
end

function this.attackKick( this )
	local moveName = "kick"
	this:physicalAttack( moveName )
	this:setSecondaryState( "IDLING" )
	this:clearSecondaryAnimations()
	local animName = this:getPhysicalAnim( moveName )
	this:blendAnimation( animName, 0.1 )
	local endTime = this:getAnimLength(animName)
	this:addPrimaryStateListener( "PHYSICAL_KICK", this.endMark, endTime, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.activateLooking( this )
	this:activateSecondaryMovementAnimation( "Looking" )
end

function this.endMark( this )
end

function this.attackDamageOn( this )
	this:setAttackDamageEnabled( 1 )
end

function this.attackDamageOff( this )
	this:setAttackDamageEnabled( nil )
end

function this.hurtProjectile( this )
	this:blendAnimation( "hero_death_falldown", 0.5 ) 
end


-- DOC 
--
-- addSubAnim adds an animation to the movementanimation
-- You need to provide the animation's name, blend delay for fade-in & out and index of the layer you want to use it in
--
-- Params : source name, blend delay, layer index
-- Returns : Animation index 
--
--
-- addBlendController adds animation blend controller, these control the respectable weight of sub animations depending on the value of control 
-- control can be evaluated linearly or over 4 types of curves
--
-- Params : animation index, control attribute, control source, blend curve type, curve strength (=height), minimum value, maximum value

-- Returns : nothing
--
-- Control types are: 
--		NONE : Doesn't care about the value of control, always valid in any case
--		VECTOR3_LENGTH : Measures the length of control's vector (or just the value if its' a float) 
--		VECTOR3_DIRECTIONXZ : Absolute direction in world coordinates on XZ-plane
--		VECTOR3_DIRECTIONYZ : Absolute direction in world coordinates on YZ-plane
--		VECTOR3_DIRECTIONXZX : Like both above, but the highest angle is used
--
-- Curve types are: 
--		FLAT : Weight is always the curve strength
--		BELL : Weight is the value of gaussian normal distribution or "bell" curve evaluated at control * curve strength
--      POS_OPENING_HALF_BELL : As above, but only the negative half of the bell curve is evaluated, value is 0 at minimum value, and curve strength at maximum
--      NEG_OPENING_HALF_BELL : Like pos_opening_half_bell, but reversed.
--

-- Add anims of biped moving in 8 directions to a movement animation layer and create blend weights for walking

function this.makeBipedMovingLayer( this, movement, layer, frwd, frwd_left, frwd_right, left, right, bckw_left, bckw_right, bckw )
	local a_frwd		= movement:addSubAnim( frwd, 0.25, layer )
	local a_frwdleft	= movement:addSubAnim( frwd_left, 0.25, layer )
	local a_frwdright	= movement:addSubAnim( frwd_right, 0.25, layer )
	local a_strfleft	= movement:addSubAnim( left, 0.25, layer )
	local a_strfright	= movement:addSubAnim( right, 0.25, layer )
	local a_bckw		= movement:addSubAnim( bckw, 0.25, layer )
	local a_bckwleft	= movement:addSubAnim( bckw_left, 0.25, layer )
	local a_bckwright	= movement:addSubAnim( bckw_right, 0.25, layer )
	
	movement:addBlendController( a_frwd,		"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 0.9, -45,45 )
	movement:addBlendController( a_frwdleft,	"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 1, -90, 0 )
	movement:addBlendController( a_frwdright,	"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 1, 0, 90 )
	movement:addBlendController( a_strfleft,	"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 0.9, -135, -45 )
	movement:addBlendController( a_strfright,	"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 0.9, 45,	135 )
	movement:addBlendController( a_bckwleft,	"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 1, -179, -90 )
	movement:addBlendController( a_bckwright,	"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 1, 90, 179 )
	movement:addBlendController( a_bckw,		"VECTOR3_DIRECTIONXZ", "MOVEMENT", "BELL", 0.9, 135, -135 )

	movement:enableForcedLooping( 1 )

end

-- This function creates a movement animation suitable for aiming weapons with crosshair

function this.makeAimAnimSetCrosshair( this, name, frwd, left, up, right, down )
	this:addAnimation( frwd, "CONSTANT" )
	this:addAnimation( left, "CONSTANT" )
	this:addAnimation( up, "CONSTANT" )
	this:addAnimation( right, "CONSTANT" )
	this:addAnimation( down, "CONSTANT" )
	
	this:addSecondaryAnimation( frwd, "Bip01 Spine" )
	this:addSecondaryAnimation( left, "Bip01 Spine" )
	this:addSecondaryAnimation( up, "Bip01 Spine" )
	this:addSecondaryAnimation( right, "Bip01 Spine" )
	this:addSecondaryAnimation( down, "Bip01 Spine" )
	
	local blendTime = 0.3
	local aim = this:createSecondaryMovementAnimation( name )
	local layer = aim:addLayer( "Aim", "NONE", "NONE", 0, 0, "ADDALLBLENDS" )
	local aimF	= aim:addSubAnim( frwd, blendTime, layer )
	local aimL	= aim:addSubAnim( left, blendTime, layer )
	local aimU	= aim:addSubAnim( up, blendTime, layer )
	local aimR	= aim:addSubAnim( right, blendTime, layer )
	local aimD	= aim:addSubAnim( down, blendTime, layer )

	aim:addBlendController( aimF, "VECTOR2_DIAMONDXZYZ","AIMCROSSHAIR", "FLAT",		1, 1, 1 )
	aim:addBlendController( aimL, "VECTOR2_X",			"AIMCROSSHAIR", "RAMP_DOWN",1, -1.01, 0 )	
	aim:addBlendController( aimR, "VECTOR2_X",			"AIMCROSSHAIR", "RAMP_UP",	1, 0, 1.01 )
	aim:addBlendController( aimU, "VECTOR2_Y",			"AIMCROSSHAIR", "RAMP_DOWN",1, -1.01, 0 )	
	aim:addBlendController( aimD, "VECTOR2_Y",			"AIMCROSSHAIR", "RAMP_UP",	1, 0, 1.01 )

	aim:enableForcedLooping( nil )

	return aim;
end

-- This function creates a movement animation suitable for aiming weapons with aim vector

function this.makeAimAnimSetVector( this, name, frwd, left, up, right, down )
	this:addAnimation( frwd, "CONSTANT" )
	this:addAnimation( left, "CONSTANT" )
	this:addAnimation( up, "CONSTANT" )
	this:addAnimation( right, "CONSTANT" )
	this:addAnimation( down, "CONSTANT" )

	this:addSecondaryAnimation( frwd, "Bip01 Spine" )
	this:addSecondaryAnimation( left, "Bip01 Spine" )
	this:addSecondaryAnimation( up, "Bip01 Spine" )
	this:addSecondaryAnimation( right, "Bip01 Spine" )
	this:addSecondaryAnimation( down, "Bip01 Spine" )
	
	local aim = this:createSecondaryMovementAnimation( name )
	local layer = aim:addLayer( "Aim", "NONE", "NONE", 0, 0, "ADDALLBLENDS" )
	local aimF	= aim:addSubAnim( frwd, 0.3, layer )
	local aimL	= aim:addSubAnim( left, 0.3, layer )
	local aimU	= aim:addSubAnim( up, 0.3, layer )
	local aimR	= aim:addSubAnim( right, 0.3, layer )
	local aimD	= aim:addSubAnim( down, 0.3, layer )

	aim:addBlendController( aimF, "VECTOR3_ANGLE_DIAMONDXZYZ",	"AIM", "FLAT",		1, 25, 65 )
	aim:addBlendController( aimL, "VECTOR3_DIRECTIONXZ",		"AIM", "FLAT",		1, -90, -25 )	
	aim:addBlendController( aimL, "VECTOR3_DIRECTIONXZ",		"AIM", "RAMP_DOWN",	1, -25, 0 )	
	aim:addBlendController( aimR, "VECTOR3_DIRECTIONXZ",		"AIM", "RAMP_UP",	1, 0, 25 )	
	aim:addBlendController( aimR, "VECTOR3_DIRECTIONXZ",		"AIM", "FLAT",		1, 25, 90 )	
	aim:addBlendController( aimU, "VECTOR3_DIRECTIONYZ",		"AIM", "FLAT",		1, -90, -65 )	
	aim:addBlendController( aimU, "VECTOR3_DIRECTIONYZ",		"AIM", "RAMP_DOWN",	1, -65, 0 )	
	aim:addBlendController( aimD, "VECTOR3_DIRECTIONYZ",		"AIM", "RAMP_UP",	1, 0, 65 )
	aim:addBlendController( aimD, "VECTOR3_DIRECTIONYZ",		"AIM", "FLAT",		1, 65, 180 )

	aim:enableForcedLooping( nil )

	return aim;
end

function this.makeLookingAnimSetCrosshair( this, name, forward, left, up, right, down )
	this:addSecondaryAnimation( forward, "Bip01 Head" )
	this:addSecondaryAnimation( left, "Bip01 Head" )
	this:addSecondaryAnimation( up, "Bip01 Head" )
	this:addSecondaryAnimation( right, "Bip01 Head" )
	this:addSecondaryAnimation( down, "Bip01 Head" )

	local looking = this:createSecondaryMovementAnimation( name )

	local looklayer = looking:addLayer( "look", "NONE", "NONE", 0, 0, "ADDALLBLENDS" )

	local lookF	= looking:addSubAnim( forward, 0.05, looklayer )
	local lookL	= looking:addSubAnim( left, 0.05, looklayer )
	local lookU	= looking:addSubAnim( up, 0.05, looklayer )
	local lookR	= looking:addSubAnim( right, 0.05, looklayer )
	local lookD	= looking:addSubAnim( down, 0.05, looklayer )

	looking:addBlendController( lookF, "VECTOR2_DIAMONDXZYZ","AIMCROSSHAIR", "FLAT",1, 1, 1 )
	looking:addBlendController( lookL, "VECTOR2_X", "AIMCROSSHAIR", "RAMP_DOWN",	1, -1.01, 0 )	
	looking:addBlendController( lookR, "VECTOR2_X", "AIMCROSSHAIR", "RAMP_UP",		1, 0, 1.01 )
	looking:addBlendController( lookU, "VECTOR2_Y", "AIMCROSSHAIR", "RAMP_DOWN",	1, -1.01, 0 )	
	looking:addBlendController( lookD, "VECTOR2_Y", "AIMCROSSHAIR", "RAMP_UP",		1, 0, 1.01 )

	looking:enableForcedLooping( nil )
	this:setLookingHeadBoneTransformFix( forward )
	
	return looking;
end

function this.makeLookingAnimSetVector( this, name, forward, left, up, right, down )
	this:addSecondaryAnimation( forward, "Bip01 Head" )
	this:addSecondaryAnimation( left, "Bip01 Head" )
	this:addSecondaryAnimation( up, "Bip01 Head" )
	this:addSecondaryAnimation( right, "Bip01 Head" )
	this:addSecondaryAnimation( down, "Bip01 Head" )

	local looking = this:createSecondaryMovementAnimation( name )

	local looklayer = looking:addLayer( "look", "NONE", "NONE", 0, 0, "NORMAL" )

	local lookF	= looking:addSubAnim( forward, 0.05, looklayer )
	local lookL	= looking:addSubAnim( left, 0.05, looklayer )
	local lookU	= looking:addSubAnim( up, 0.05, looklayer )
	local lookR	= looking:addSubAnim( right, 0.05, looklayer )
	local lookD	= looking:addSubAnim( down, 0.05, looklayer )

	looking:addBlendController( lookF, "VECTOR3_ANGLE_DIAMONDXZYZ",	"LOOK", "FLAT",		1, 25, 65 )
	looking:addBlendController( lookL, "VECTOR3_DIRECTIONXZ",		"LOOK", "FLAT",		1, -90, -25 )	
	looking:addBlendController( lookL, "VECTOR3_DIRECTIONXZ",		"LOOK", "RAMP_DOWN",	1, -25, 0 )	
	looking:addBlendController( lookR, "VECTOR3_DIRECTIONXZ",		"LOOK", "RAMP_UP",	1, 0, 25 )	
	looking:addBlendController( lookR, "VECTOR3_DIRECTIONXZ",		"LOOK", "FLAT",		1, 25, 90 )	
	looking:addBlendController( lookU, "VECTOR3_DIRECTIONYZ",		"LOOK", "FLAT",		1, -90, -65 )	
	looking:addBlendController( lookU, "VECTOR3_DIRECTIONYZ",		"LOOK", "RAMP_DOWN",	1, -65, 0 )	
	looking:addBlendController( lookD, "VECTOR3_DIRECTIONYZ",		"LOOK", "RAMP_UP",	1, 0, 65 )
	looking:addBlendController( lookD, "VECTOR3_DIRECTIONYZ",		"LOOK", "FLAT",		1, 65, 180 )

	looking:enableForcedLooping( nil )
	this:setLookingHeadBoneTransformFix( forward )

	return looking;
end

-- init

function this.initBase( this )

	this:addCollisionBones()

	-- Character movement speeds (meters/second).
	this:setSneakingSpeedRange( 0.5, 1 )		-- m/s
	this:setWalkingSpeedRange( 1.3, 1.5 )		-- m/s
	this:setRunningSpeedRange( 3, 3.5 )		-- m/s
-- ---------------------------------------------------------------------------------------------------------------------------------
	-- Scales controller input circle to "egg-shape"
	-- so that max strafing/backward movement is less
	-- than forward movement.
	-- Note that these do not affect crouched movement
	-- which has explicit forward/backward/strafe speeds.
	-- note: remember 1% margin to sneaking/walking/running control ranges
	-- Control sectors obey standard trigonometric circle conventions:
	-- Angle=0 is right direction, angles increase counter-clockwise.

	-- right sector
	this:addControlSector( 359, 360, 0.83 )
	this:addControlSector( 0, 44, 0.83 )
	
	-- forward sector
	this:addControlSector( 44, 136, 1 )
	
	-- left sector
	this:addControlSector( 136, 181, 0.83 )
	
	-- sector behind
	this:addControlSector( 181, 359, 0.38 )
-- ---------------------------------------------------------------------------------------------------------------------------------
	--CROUCH MOVE SPEED
	this:setCrouchWalkingSpeed( 1 )			-- m/s
	this:setCrouchStrafingSpeed( 1 )		-- m/s
	this:setCrouchBackwardSpeed( 1 )		-- m/s
-- ---------------------------------------------------------------------------------------------------------------------------------
	--ROLLING SPEEDS FOR FORWARD, BACKWARD AND SIDEWAYS ROLLING
	this:setRollingSpeedForward( 4 )		-- m/s
	this:setRollingSpeedBackward( 3 )		-- m/s
	this:setRollingSpeedSideways( 3 )		-- m/s
-- ---------------------------------------------------------------------------------------------------------------------------------	
	-- Movement controller input mapping,
	-- must define continuous range [0,1].
	
	this:setSneakingControlRange( 0, 0.4 )
	this:setWalkingControlRange( 0.4, 0.85 )
	this:setRunningControlRange( 0.85, 1 )
-- ---------------------------------------------------------------------------------------------------------------------------------
	-- Distance to check when checking possibility to peek
	this:setPeekMoveCheckDistance( 1 )
-- ---------------------------------------------------------------------------------------------------------------------------------


-- Head turning fix enable for looking secondary state, with blend delay
-- NOTE: clearing secondary anims disables head turn fixing until one of the states below is re-activated
	this:setHeadTurnFixBlendDelay( 0.25 ) 

-- Simulation Parameters

	this:setGravity( 1 )				-- G's
	this:setSteepSurface( 65 )			-- degrees
	this:setRotationSpeed( 120 )		-- degrees/s
	this:setFriction( 0.95 )		    -- relative speed decrease in second 
	this:setFallingFriction( 0 )
	this:setAimingTimeAfterShooting( 5 ) -- seconds

	this:setMaxAnimSlewRatePrimary( 2 )			-- Maximum blending weight change per second (primary state anims)
	this:setMaxAnimSlewRateSecondary( 1000 )	-- Maximum blending weight change per second (secondary state anims)

	this:setBoundSphere( 0.5 )
	this:setCharacterCollisionRadius( 0.3 ) -- character-character contact distance
	
	this:setThrowBone( "Bip01 L Hand" )		-- Thrown shell is released from left hand
	this:setThrowAngle( 27 )				-- Amount of degrees to throw upwards
	this.throwReleaseTime = 0.5				-- Thrown shell is released at 0.5 seconds from start of state

	this:resetInputState()

	-- Projectile hit causes hurt state transition by default,
	-- se to nil if not wanted. Can be overriden later in character specific files.
	this.projectileHurts = 1

-- preload sounds
	this:loadSound( this.characterSoundPath .. "hitX" )
	
	this:loadSound( this.characterSoundPath .. "sneaking_softX" )
	this:loadSound( this.characterSoundPath .. "sneaking_sandX" )
	this:loadSound( this.characterSoundPath .. "sneaking_stoneX" )
	this:loadSound( this.characterSoundPath .. "sneaking_woodX" )
	this:loadSound( this.characterSoundPath .. "sneaking_metalX" )
	
	this:loadSound( this.characterSoundPath .. "walking_softX" )
	this:loadSound( this.characterSoundPath .. "walking_sandX" )
	this:loadSound( this.characterSoundPath .. "walking_stoneX" )
	this:loadSound( this.characterSoundPath .. "walking_woodX" )
	this:loadSound( this.characterSoundPath .. "walking_metalX" )
	
	this:loadSound( this.characterSoundPath .. "running_softX" )
	this:loadSound( this.characterSoundPath .. "running_sandX" )
	this:loadSound( this.characterSoundPath .. "running_stoneX" )
	this:loadSound( this.characterSoundPath .. "running_woodX" )
	this:loadSound( this.characterSoundPath .. "running_metalX" )
	
-- vision defaults for computer player (can be overriden per character basis in level file)
	local cc = this:getComputerControl()
	cc.visionLimit = 0 				-- 1=blind, 0=sees if possible as defined by following properties:
	cc.visionLightEffectMin = 0		-- how probable it is that player sees target in complete darkness
	cc.visionLightEffectMax = 1		-- how probable it is that player sees target in full light
	cc.visionHorzInnerCone = 40		-- character vision frustum
	cc.visionHorzOuterCone = 90
	cc.visionVertInnerCone = 30
	cc.visionVertOuterCone = 60
	cc.visionFarAttenStart = 20
	cc.visionFarAttenEnd = 50

-- hearing defaults for computer player (can be overriden per character basis in level file)
	cc.hearingLimit = 0.4			-- minimum noise level that character can hear
	
-- fire fight defaults for computer player (can be overriden per character basis in level file)
	cc:setShootDelay( 0.2 )			-- time between shots (weapon fire rate also limits shoot rate)
	cc:setAimInaccuracy( 15 )		-- max angle of inaccuracy
	cc.stupidity = 0.3				-- Probability of a player reacting to a world event
	cc.aggressiveness = 0.5			-- Probability of attack vs. evade
	cc.chicken = 0.5				-- Probability of retreat
	cc.healthLowThreshold = 30		-- Threshold of health to start checking against retreat probability

-- close combat defaults for computer player (can be overriden per character basis in level file)
	cc.physicalAttackDelay = 1		-- time (from attack start) between consequtive physical attacks 
end
