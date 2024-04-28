this:include "player_base.lua"
this:include "thug_AI.lua"

function this.playBulletHitSound( this )
	this:playSound( this.characterSoundPath .. "hit" .. this:getRandomInteger(1,4) )
end

-- ---------------------- DEATH sound for different sound types ---------------------------------------------------
function this.playDeathSound( this, type )
	if ( not type ) then 
		trace( "ERROR!! Death type not specified" )
	else
		if ( type == "PROJECTILE" ) then
			this:playSound( this.characterSoundPath .. "die_projectile" .. this:getRandomInteger(1,5) )
		elseif ( type == "PHYSICAL" ) then
			this:playSound( this.characterSoundPath .. "die_physical" .. this:getRandomInteger(1,2) )
		elseif ( type == "EXPLOSION" ) then
			this:playSound( this.characterSoundPath .. "die_explosion" .. this:getRandomInteger(1,6) )
		else
			trace( "ERROR!! Invalid death type" )
		end
	end
end

function this.playPhysicalAttackHitSound( this )
	this:playSound( this.characterSoundPath .. "hit" .. this:getRandomInteger(1,4) )
end

-- ---------------------- TAUNT or insult enemy --------------------------------------------------------------------
function this.playTauntSound( this )
	this:playSound( this.characterSoundPath .. "taunt" .. this:getRandomInteger(1,6) )
end

function this.playIdleSound( this )
	this:playSound( this.characterSoundPath .. "idle" .. this:getRandomInteger(1,7) )
	this:morph( this.morphIdling, 0.2 )
end

--------------------------------------------------------------------------------------------------------------------
--
--
-- For animation documentation see hero.lua
--
--
--------------------------------------------------------------------------------------------------------------------

-- signals

function this.signalTaunt( this, timeSinceLast )
	if ( timeSinceLast > this.tauntFrequency ) then
		this:playTauntSound()
	end
end

this.tauntFrequency = 3		-- seconds needed to be elapsed since last taunt

-- thug face animations (see hero.lua for comments)

-- name of base object to morph in character mesh
this.morphBaseMesh			= "thug1_head"

-- make sure animations used here are added in init() with addMorphAnimation()
this.morphDefault			= "thug1_head/thug1_morph_idle.gm"
this.morphAiming			= "thug1_head/thug1_morph_idle.gm"
this.morphShooting			= "thug1_head/thug1_morph_idle.gm"
this.morphDying				= "thug1_head/thug1_morph_die.gm"					-- played when character death animation starts
this.morphProjectileHurting	= "thug1_head/thug1_morph_projectile_hurt.gm"		-- played when character gets hurt by bullet
this.morphPhysicalHurting	= "thug1_head/thug1_morph_projectile_hurt.gm"			-- played when character gets hurt by close combat attack
--this.morphPhysicalHurting	= "thug1_head/thug1_morph_physical_hurt.gm"			-- played when character gets hurt by close combat attack
this.morphIdling			= "thug1_head/thug1_morph_idletalk.gm"				-- played when character plays random idle sound

-- state listeners

function this.standing( this )
	this:blendAnimation( "hero_idle_stand", 0.25 )
	this:morph( this.morphDefault, 0.2 )
end

function this.toCrouch( this )
	this:blendAnimation( "hero_crouch", 0.1, 30 )
end

function this.unCrouch( this )
	this:blendAnimation( "hero_crouch", 0.1, -30, 0.5 )
end

function this.moveCrouched( this )
	this:activateMovementAnimation( "Crouching" )
end

function this.rollForward( this )
	-- Roll Forward animation is blended with n sec delay *SS*
	local animName = "hero_roll_frwd"
	local stateEnd = this:getAnimLength(animName) - 0.4
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.1 )
	this:addPrimaryStateListener( "ROLLING_FORWARD", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.rollBackward( this )
	local animName = "hero_roll_bckw"
	local stateEnd = this:getAnimLength(animName) - 0.2
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.1, -30, this:getAnimLength(animName)-0.1 )
	this:addPrimaryStateListener( "ROLLING_BACKWARD", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.rollLeft( this )
	local animName = "hero_roll_left"
	local stateEnd = this:getAnimLength(animName) - 0.2
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.1 )
	this:addPrimaryStateListener( "ROLLING_LEFT", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.rollRight( this )
	local animName = "hero_roll_right"
	local stateEnd = this:getAnimLength(animName) - 0.2
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.1 )
	this:addPrimaryStateListener( "ROLLING_RIGHT", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.die( this )
	--this:blendAnimation( "hero_death_falldown" .. this:getRandomInteger(1,3), 0.5 )
	this:blendAnimation( "hero_death_falldown", 0.5 )
	this:morph( this.morphDying, 0.2 )
end

function this.dieSecondary( this )
	this:clearSecondaryAnimations()
end

function this.changeClipAnim( this )
	if ( this:weapon() ) then
		local animName = nil

		local weaponName = this:weapon():name()
		if ( weaponName == "m16" ) then
			animName = "hero_rifle_reload"
		elseif ( weaponName == "beretta" ) then
			animName = "hero_handgun_reload"
		elseif ( weaponName == "shotgun" ) then
			animName = "hero_shotgun_reload"
		end

		local animEnd = this:getAnimLength( animName )
		this:addSecondaryStateListener( "CHANGING_CLIP", this.changeClipRefill, animEnd-0.5, this.STATE_ENTRY+this.STATE_REMOVE )
		this:blendSecondaryAnimation( animName, 0.25 )

		this:weapon():signalLooseClip()
	end
end

function this.changeClipRefill( this )
	-- Load character's weapon with new clip
	this:weapon():reload()
end

-- Initialization

function this.initMaleBase( this )
	this:initBase()

	-- Primary state listeners
	this:addPrimaryStateListener( "WALKING", this.moving, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "WALKING_BACKWARD", this.moving, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "STRAFING", this.moving, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "FALLING", this.endMark, 90/30, this.STATE_ENTRY )
	this:addPrimaryStateListener( "STANDING", this.standing, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "CROUCHING_DOWN", this.toCrouch, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "CROUCHING_DOWN", this.endMark, 6/30, this.STATE_ENTRY )
	this:addPrimaryStateListener( "CROUCHED", this.moveCrouched, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "CROUCHED_WALKING", this.moveCrouched, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "UNCROUCHING", this.moving, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "UNCROUCHING", this.endMark, 6/30, this.STATE_ENTRY )
	this:addPrimaryStateListener( "ROLLING_FORWARD", this.rollForward, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "ROLLING_FORWARD", this.activateLooking, 0, this.STATE_EXIT )
	this:addPrimaryStateListener( "ROLLING_BACKWARD", this.rollBackward, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "ROLLING_BACKWARD", this.activateLooking, 0, this.STATE_EXIT )
	this:addPrimaryStateListener( "ROLLING_LEFT", this.rollLeft, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "ROLLING_LEFT", this.activateLooking, 0, this.STATE_EXIT )
	this:addPrimaryStateListener( "ROLLING_RIGHT", this.rollRight, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "ROLLING_RIGHT", this.activateLooking, 0, this.STATE_EXIT )
	this:addPrimaryStateListener( "DEAD", this.die, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "PHYSICAL_KICK", this.attackKick, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "PHYSICAL_KICK", this.endPhysicalAttack, 0, this.STATE_EXIT )

	-- Secondary state listeners
	this:addSecondaryStateListener( "ATTACKING", this.attack, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "AIMING", this.aim, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "HOLDING_AIM", this.holdAim, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "PHYSICAL_STRIKE", this.attackStrike, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "PHYSICAL_STRIKE", this.endPhysicalAttack, 0, this.STATE_EXIT )
	this:addSecondaryStateListener( "LOOKING", this.looking, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "CHANGING_CLIP", this.changeClipAnim, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "DEAD", this.dieSecondary, 0, this.STATE_ENTRY )

	-- addAnimation(name): data/characters/animations/<name>.sg
	
	-- Primary Animations ----------------------------------------------------------------------------------------------------------------

	this:addAnimation( "hero_roll_frwd" )
	this:addAnimation( "hero_roll_bckw" )
	this:addAnimation( "hero_roll_left" )
	this:addAnimation( "hero_roll_right" )
	this:addAnimation( "hero_idle_stand" )
	this:addAnimation( "hero_walk_frwd" )
	this:addAnimation( "hero_walk_frwd_left" )
	this:addAnimation( "hero_walk_frwd_right" )
	this:addAnimation( "hero_walk_left" )
	this:addAnimation( "hero_walk_right" )
	this:addAnimation( "hero_run_frwd" )
	this:addAnimation( "hero_run_frwd_n_left" )
	this:addAnimation( "hero_run_frwd_n_right" )
	this:addAnimation( "hero_sneak_frwd" )
	this:addAnimation( "hero_sneak_frwd_left" )
	this:addAnimation( "hero_sneak_frwd_right" )
	this:addAnimation( "hero_sneak_left" )
	this:addAnimation( "hero_sneak_right" )
	this:addAnimation( "hero_sneak_bckw" )
	this:addAnimation( "hero_sneak_bckw_left" )
	this:addAnimation( "hero_sneak_bckw_right" )
	this:addAnimation( "hero_crouch_idle", "CONSTANT" )
	this:addAnimation( "hero_crouch_frwd" )
	this:addAnimation( "hero_crouch_frwd_left" )
	this:addAnimation( "hero_crouch_frwd_right" )
	this:addAnimation( "hero_crouch_left" )
	this:addAnimation( "hero_crouch_right" )
	this:addAnimation( "hero_crouch_bckw" )
	this:addAnimation( "hero_crouch_bckw_left" )
	this:addAnimation( "hero_crouch_bckw_right" )
	this:addAnimation( "hero_crouch", "CONSTANT" ) 
	this:addAnimation( "hero_death_falldown", "CONSTANT" )
	this:addAnimation( "hero_death_falldown1", "CONSTANT" )
	this:addAnimation( "hero_death_falldown2", "CONSTANT" )
	this:addAnimation( "hero_death_falldown3", "CONSTANT" )

	-- Secondary Animations --------------------------------------------------------------------------------------------------------------------

	this:addSecondaryAnimation( "hero_idle_stand", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_look_stand", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_handgun_reload", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_rifle_reload", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_shotgun_reload", "Bip01 Spine" )

	-- Hurt anims ------------------------------------------------------------------------------------------------------------------------------

	this:addAnimation( "hero_physical_hurt_front", "CONSTANT" )
	this:addAnimation( "hero_physical_hurt_right", "CONSTANT" )
	this:addAnimation( "hero_physical_hurt_back", "CONSTANT" )
	this:addAnimation( "hero_physical_hurt_left", "CONSTANT" )
	this:addAnimation( "hero_projectile_hurt", "CONSTANT" )
	this:addAnimation( "hero_projectile_hurt_crouching", "CONSTANT" )
	this:addSecondaryAnimation( "hero_projectile_hurt_aiming_rifle", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_projectile_hurt_aiming_shotgun", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_projectile_hurt_aiming_handgun", "Bip01 Spine" )

	-- Physical combat -------------------------------------------------------------------------------------------------------------------------

	this:addAnimation( "hero_kick1", "CONSTANT" )
	this:addAnimation( "hero_rifle_knock", "CONSTANT" )	
	this:addAnimation( "hero_shotgun_knock", "CONSTANT" )	
	this:addAnimation( "hero_shotgun_knock", "CONSTANT" )	
	this:addSecondaryAnimation( "hero_rifle_knock", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_shotgun_knock", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_handgun_knock", "Bip01 Spine" )
	
	-- Stepping sound animation Listeners ------------------------------------------------------------------------------------------------------
	
	this:addAnimationListener( "hero_run_frwd", this.playRunningStepSound1, 0 )
	this:addAnimationListener( "hero_run_frwd", this.playRunningStepSound2, 0.3 )
	this:addAnimationListener( "hero_run_frwd_n_left", this.playRunningStepSound1, 0 )
	this:addAnimationListener( "hero_run_frwd_n_left", this.playRunningStepSound2, 0.3 )
	this:addAnimationListener( "hero_run_frwd_n_right", this.playRunningStepSound1, 0 )
	this:addAnimationListener( "hero_run_frwd_n_right", this.playRunningStepSound2, 0.3 )
	this:addAnimationListener( "hero_walk_frwd", this.playWalkingStepSound1, 0 )
	this:addAnimationListener( "hero_walk_frwd", this.playWalkingStepSound2, 0.41 )
	this:addAnimationListener( "hero_walk_frwd_left", this.playWalkingStepSound1, 0 )
	this:addAnimationListener( "hero_walk_frwd_left", this.playWalkingStepSound2, 0.41 )
	this:addAnimationListener( "hero_walk_frwd_right", this.playWalkingStepSound1, 0 )
	this:addAnimationListener( "hero_walk_frwd_right", this.playWalkingStepSound2, 0.41 )
	this:addAnimationListener( "hero_walk_left", this.playWalkingStepSound1, 0 )
	this:addAnimationListener( "hero_walk_left", this.playWalkingStepSound2, 0.41 )
	this:addAnimationListener( "hero_walk_right", this.playWalkingStepSound1, 0 )
	this:addAnimationListener( "hero_walk_right", this.playWalkingStepSound2, 0.41 )
	this:addAnimationListener( "hero_sneak_frwd", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_frwd", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_frwd_left", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_frwd_left", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_frwd_right", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_frwd_right", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_left", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_left", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_right", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_right", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_bckw", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_bckw", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_bckw_left", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_bckw_left", this.playSneakingStepSound2, 0.48 )
	this:addAnimationListener( "hero_sneak_bckw_right", this.playSneakingStepSound1, 0 )
	this:addAnimationListener( "hero_sneak_bckw_right", this.playSneakingStepSound2, 0.48 )

	-- Sneak/Walk/Run Movent Animation ( NOTE : Adding Movement Animation Sub Anim does not load the animation from disk, load it with addAnimation ) 

	local moving = this:createMovementAnimation( "Moving" );
	
	local sneakinglayer		= moving:addLayer( "Sneaking", "VECTOR3_LENGTH", "MOVEMENTCONTROL", 0, this:maxSneakingControl()+0.01, "ADDALLBLENDS" ) 
	local walkinglayer		= moving:addLayer( "Walking", "VECTOR3_LENGTH", "MOVEMENTCONTROL", this:minWalkingControl(), this:maxWalkingControl()+0.01, "ADDALLBLENDS" )
	local runninglayer		= moving:addLayer( "Running", "VECTOR3_LENGTH", "MOVEMENTCONTROL", this:minRunningControl(), this:maxRunningControl()+1, "ADDALLBLENDS" )
	
	-- Sneaking

	this:makeBipedMovingLayer( moving, sneakinglayer, "hero_sneak_frwd",
								"hero_sneak_frwd_left", "hero_sneak_frwd_right",
								"hero_sneak_left", "hero_sneak_right",
								"hero_sneak_bckw_left", "hero_sneak_bckw_right",
								"hero_sneak_bckw" )

	-- Walking

	this:makeBipedMovingLayer( moving, walkinglayer, "hero_walk_frwd",
								"hero_walk_frwd_left", "hero_walk_frwd_right",
								"hero_walk_left", "hero_walk_right",
								"hero_sneak_bckw_left", "hero_sneak_bckw_right",
								"hero_sneak_bckw" )

	-- Running

	this:makeBipedMovingLayer( moving, runninglayer, "hero_run_frwd",
								"hero_run_frwd_n_left", "hero_run_frwd_n_right",
								"hero_walk_left", "hero_walk_right",
								"hero_sneak_bckw_left", "hero_sneak_bckw_right",
								"hero_sneak_bckw" )

	-- Crouching movement animation

	local crouching = this:createMovementAnimation( "Crouching" )

	local crouchstilllayer	= crouching:addLayer( "Still", "VECTOR3_LENGTH", "MOVEMENT", 0, 0.11, "ADDALLBLENDS" )	
	local crouchlayer			= crouching:addLayer( "Crouching", "VECTOR3_LENGTH", "MOVEMENT", 0.1, 50, "ADDALLBLENDS" )

	this:makeBipedMovingLayer( crouching, crouchlayer, "hero_crouch_frwd", 
								"hero_crouch_frwd_left", "hero_crouch_frwd_right",
								"hero_crouch_left", "hero_crouch_right",
								"hero_crouch_bckw_left", "hero_crouch_bckw_right",
								"hero_crouch_bckw" )
								

	local crouchstill			= crouching:addSubAnim( "hero_crouch_idle", 0.25, crouchstilllayer )	
	crouching:addBlendController( crouchstill, "NONE", "NONE", "FLAT", 1, 0, 0 )
	
	-- Looking

	local looking = this:makeLookingAnimSetVector( "Looking", "hero_look_stand", "hero_look_left", "hero_look_up", "hero_look_right", "hero_look_down" )

	-- Recoil

	local shootrifle		= this:makeAimAnimSetVector( "shoot_rifle", "hero_rifle_shoot_frwd", "hero_rifle_shoot_left", "hero_rifle_shoot_up", "hero_rifle_shoot_right", "hero_rifle_shoot_down" )
	local shoothandgun		= this:makeAimAnimSetVector( "shoot_handgun", "hero_handgun_shoot_frwd", "hero_handgun_shoot_left", "hero_handgun_shoot_up", "hero_handgun_shoot_right", "hero_handgun_shoot_down" )
	local shootshotgun		= this:makeAimAnimSetVector( "shoot_shotgun", "hero_shotgun_shoot_frwd", "hero_shotgun_shoot_left", "hero_shotgun_shoot_up", "hero_shotgun_shoot_right", "hero_shotgun_shoot_down" )

	trace( "Rifle shoot anim length : "..this:getAnimLength( "hero_rifle_shoot_frwd" ) )
	trace( "Handgun shoot anim length : "..this:getAnimLength( "hero_handgun_shoot_frwd" ) )
	trace( "shotgun shoot anim length : "..this:getAnimLength( "hero_shotgun_shoot_frwd" ) )

	-- Aiming
	
	local aimrifle		= this:makeAimAnimSetVector( "aim_rifle", "hero_rifle_aim_frwd", "hero_rifle_aim_left", "hero_rifle_aim_up", "hero_rifle_aim_right", "hero_rifle_aim_down", 0.3 )  
	local aimhandgun	= this:makeAimAnimSetVector( "aim_handgun", "hero_handgun_aim_frwd", "hero_handgun_aim_left", "hero_handgun_aim_up", "hero_handgun_aim_right", "hero_handgun_aim_down", 0.3 ) 
	local aimshotgun	= this:makeAimAnimSetVector( "aim_shotgun", "hero_shotgun_aim_frwd", "hero_shotgun_aim_left", "hero_shotgun_aim_up", "hero_shotgun_aim_right", "hero_shotgun_aim_down", 0.3 ) 

	-- Physical combat

	this:setPhysicalHitRange( 0.3 )

	this:addPhysicalCombatMove( "rifle_knock", "hero_rifle_knock", "STRIKE", "NONCONTACT", 1.3, 15, -5, 0.3, 0.4, 60, 120, 1.5 )
	this:addPhysicalCombatMove( "shotgun_knock", "hero_shotgun_knock", "STRIKE", "NONCONTACT", 1.3, 15, -5, 0.3, 0.4, 60, 120, 1.5 )
	this:addPhysicalCombatMove( "handgun_knock", "hero_handgun_knock", "STRIKE", "NONCONTACT", 1.3, 15, -5, 0.3, 0.4, 60, 120, 1.5 )
	this:addPhysicalCombatMove( "kick", "hero_kick1", "STRIKE", "NONCONTACT", 1.3, 15, 0, 0.3, 0.4, 60, 120, 0.15 )

	-- preload sounds
	
	this:loadSound( this.characterSoundPath .. "die_projectileX" )
	this:loadSound( this.characterSoundPath .. "die_physicalX" )
	this:loadSound( this.characterSoundPath .. "die_explosionX" )
	this:loadSound( this.characterSoundPath .. "idleX" )
	this:loadSound( this.characterSoundPath .. "tauntX" )
	this:loadSound( this.characterSoundPath .. "surprised_canseeX" )
	this:loadSound( this.characterSoundPath .. "surprised_canhearX" )

    -- Set startup pose
	this:setAnimation( "hero_idle_stand" )
	this:setVelocity( 0, 0, 0 )
	this:setPrimaryState( "STANDING" )
end

function this.init( this )
	this.characterSoundPath = "thug1/"

	-- Initialize visuals --
	this:setName( "Thug" )
	trace( "Initializing " .. this:name() )
	
	this:setAnimationFolder( "animations" )
	
	this:setMesh( "thug1/thug1.sg", 200, 1e6 )
	this:setDynamicShadow( "thug1_shadow_volume", 10 )
	
	this:setLOD( "thug1_lod1/thug1_lod1.sg", 0, 200 )
	this:initMaleBase()

	-- add face morph animations
	this:setMorphBase( this.morphBaseMesh )
	this:addMorphAnimation( this.morphBaseMesh, "thug1_head/thug1_morph_idle.gm", "REPEAT" )	-- end behabiour: REPEAT (default), RESET, CONSTANT, OSCILLATE
	this:addMorphAnimation( this.morphBaseMesh, "thug1_head/thug1_morph_idletalk.gm", "CONSTANT" )
	this:addMorphAnimation( this.morphBaseMesh, "thug1_head/thug1_morph_die.gm", "CONSTANT" )
	this:addMorphAnimation( this.morphBaseMesh, "thug1_head/thug1_morph_physical_hurt.gm", "CONSTANT" )
	this:addMorphAnimation( this.morphBaseMesh, "thug1_head/thug1_morph_projectile_hurt.gm", "CONSTANT" )

	-- Initialize Health --
	this:setHealth( 60 )
end
