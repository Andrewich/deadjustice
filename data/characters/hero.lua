this:include "player_base.lua"

-- death sound

function this.playDeathSound( this )
	this:playSound( this.characterSoundPath .. "die" .. this:getRandomInteger(1,2) )
end

-- signals

-- called when health changes but character does not die
function this.signalHealthChanged( this, health, oldhealth )
	if ( oldhealth > 15 and health <= 15 ) then

		-- display comment when health drops below 15%
		onscreen.dialogFont:removeTexts()
		onscreen:dialogTextBottom( 0, 4, "I won't make it...", 1 )

	elseif ( oldhealth > 50 and health <= 50 ) then

		-- display comment when health drops below 50%
		onscreen.dialogFont:removeTexts()
		onscreen:dialogTextBottom( 0, 4, "This is too much...", 1 )

	end
end

function this.signalTaunt( this, timeSinceLast )
end

-- hero face animations

-- name of base object to morph in character mesh
this.morphBaseMesh	= "hero_head"

-- make sure animations used here are added in init() with addMorphAnimation()

this.morphDefault			= "hero_head/hero_morph_idle.gm"
this.morphAiming			= "hero_head/hero_morph_aim.gm"
this.morphShooting			= "hero_head/hero_morph_shoot.gm"
this.morphDying				= "hero_head/hero_morph_die.gm"				-- played when character death animation starts
this.morphProjectileHurting	= "hero_head/hero_morph_projectile_hurt.gm"	-- played when character gets hurt by bullet
this.morphPhysicalHurting	= "hero_head/hero_morph_physical_hurt.gm"		-- played when character gets hurt by close combat attack

-- state listeners

function this.standing( this )
	-- Idle animation is blended with 1/4 sec delay as primary anim. (disabling anything previously running)
	this:blendAnimation( "hero_idle_stand", 0.25 )
	this:morph( this.morphDefault, 0.2 )
end

function this.toCrouch( this )
	-- To-Crouch animation is blended with 1/10 sec delay at 30fps as primary anim
	this:blendAnimation( "hero_crouch", 0.1, 30 )
end

function this.unCrouch( this )
	-- To-Crouch animation is blended with 1/10sec delay and played backwards (-30fps) starting at frame 15
	this:blendAnimation( "hero_crouch", 0.1, -30, 15/30 )
end

function this.moveCrouched( this )
	-- Crouching movement animation is activated as primary anim set. (anim set contains blend delays respectively for each anim, dont specify blend delay here )
	this:activateMovementAnimation( "Crouching" )
end

function this.rollForward( this )
	-- Roll Forward animation is blended with n sec delay *SS*
	local animName = "hero_roll_frwd"
	local stateEnd = this:getAnimLength(animName) - 0.55
	this:setSecondaryState( "IDLING" )
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.15 )
	--this:blendAnimation( animName, 0.25 )
	this:addPrimaryStateListener( "ROLLING_FORWARD", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
	this:addPrimaryStateListener( "ROLLING_FORWARD", function( this ) this:setSecondaryState( "LOOKING" ) end, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.rollBackward( this )
	local animName = "hero_roll_bckw"
	local stateEnd = this:getAnimLength(animName) - 0.65
	this:setSecondaryState( "IDLING" )
	this:clearSecondaryAnimations()
	--this:blendAnimation( animName, 0.25, -40, this:getAnimLength(animName)-0.25 )
	this:blendAnimation( animName, 0.25, -40, this:getAnimLength(animName)-0.25 )
	this:addPrimaryStateListener( "ROLLING_BACKWARD", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
	this:addPrimaryStateListener( "ROLLING_BACKWARD", function( this ) this:setSecondaryState( "LOOKING" ) end, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.rollLeft( this )
	local animName = "hero_roll_left"
	local stateEnd = this:getAnimLength(animName) - 0.2
	this:setSecondaryState( "IDLING" )
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.1 )
	this:addPrimaryStateListener( "ROLLING_LEFT", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
	this:addPrimaryStateListener( "ROLLING_LEFT", function( this ) this:setSecondaryState( "LOOKING" ) end, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.rollRight( this )
	local animName = "hero_roll_right"
	local stateEnd = this:getAnimLength(animName) - 0.2
	this:setSecondaryState( "IDLING" )
	this:clearSecondaryAnimations()
	this:blendAnimation( animName, 0.1 )
	this:addPrimaryStateListener( "ROLLING_RIGHT", this.endMark, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
	this:addPrimaryStateListener( "ROLLING_RIGHT", function( this ) this:setSecondaryState( "LOOKING" ) end, stateEnd, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.peekLeft( this )
	-- Peek Left animation is blended with 1/4 sec delay and played at 60fps
	this:blendAnimation( "hero_peek_left", 0.15, 60 )
end

function this.unpeekLeft( this )
	-- Peek Left animation is blended with 1/4 sec delay and played backwards at -60fps starting at frame 30
	this:blendAnimation( "hero_peek_back_left", 0.15, -60, 30/30 )
	this:addPrimaryStateListener( "UNPEEKING_LEFT", this.endMark, this:getAnimLength("hero_peek_back_left")-0.3, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.peekRight( this )
	-- Peek Right animation is blended with 1/4 sec delay and played at 60fps
	this:blendAnimation( "hero_peek_right", 0.15, 60 )
end

function this.unpeekRight( this )
	-- Peek Right animation is blended with 1/4 sec delay and played backwards at -60fps starting at frame 30
	this:blendAnimation( "hero_peek_back_right", 0.15, -60, 30/30 )
	this:addPrimaryStateListener( "UNPEEKING_RIGHT", this.endMark, this:getAnimLength("hero_peek_back_right")-0.3, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.die( this )
	this:clearSecondaryAnimations()
	-- Falling animation is blended with 1/2 sec delay
	this:blendAnimation( "hero_death_falldown", 0.5 )
	this:morph( this.morphDying, 0.2 )

	if ( this == hero ) then
		onscreen:addCenteredHelpText( 0, 1e6, "PRESS F11 TO RESTART DEAD JUSTICE DEMO", 0.75 ) 
	end
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
		trace( "anim " .. animName .. " length is " .. animEnd*30 .. " frames" )
		this:addSecondaryStateListener( "CHANGING_CLIP", this.changeClipRefill, animEnd-1.1, this.STATE_ENTRY+this.STATE_REMOVE )
		this:blendSecondaryAnimation( animName, 0.25 )

		this:weapon():signalLooseClip()
	end
end

function this.changeClipRefill( this )
	-- Load character's weapon with new clip
	this:weapon():reload()
end

function this.nextWeapon( this )
	this:looking()
	this:addSecondaryStateListener( "CYCLING_WEAPON", function(this) this:cycleWeapon() end, 0.5, this.STATE_ENTRY+this.STATE_REMOVE )
end

function this.throwAnEmptyShell( this )
	local animName = "hero_throw_shell"
	local animEnd = this:getAnimLength( animName ) + this.throwReleaseTime
	this:addSecondaryStateListener( "THROWING_EMPTY_SHELL", this.endMark, animEnd, this.STATE_ENTRY+this.STATE_REMOVE )
	this:blendSecondaryAnimation( animName, 0.25 )
	this:addSecondaryStateListener( "THROWING_EMPTY_SHELL", function(this) this:throwProjectile( "diversion_empty_shell.lua" ) end, this.throwReleaseTime, this.STATE_ENTRY+this.STATE_REMOVE )
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
	this:addPrimaryStateListener( "PEEKING_LEFT", this.peekLeft, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "UNPEEKING_LEFT", this.unpeekLeft, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "PEEKING_RIGHT", this.peekRight, 0, this.STATE_ENTRY )
	this:addPrimaryStateListener( "UNPEEKING_RIGHT", this.unpeekRight, 0, this.STATE_ENTRY )
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
	this:addSecondaryStateListener( "CYCLING_WEAPON", this.nextWeapon, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "THROWING_EMPTY_SHELL", this.throwAnEmptyShell, 0, this.STATE_ENTRY )
	this:addSecondaryStateListener( "DEAD", this.dieSecondary, 0, this.STATE_ENTRY )

	-- addAnimation(name): data/characters/animations/<name>.sg
	
	-- Load Primary Animations ----------------------------------------------------------------------------------------------------------------

	this:addAnimation( "hero_roll_frwd", "CONSTANT", "CONSTANT" )
	this:addAnimation( "hero_roll_bckw", "CONSTANT", "CONSTANT" )
	this:addAnimation( "hero_roll_left", "CONSTANT", "CONSTANT" )
	this:addAnimation( "hero_roll_right", "CONSTANT", "CONSTANT" )
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
	this:addAnimation( "hero_crouch", "CONSTANT", "CONSTANT" ) 
	this:addAnimation( "hero_death_falldown", "CONSTANT" )
	this:addAnimation( "hero_peek_left", "CONSTANT" )
	this:addAnimation( "hero_peek_right", "CONSTANT" )
	this:addAnimation( "hero_peek_back_left", "CONSTANT", "CONSTANT" )
	this:addAnimation( "hero_peek_back_right", "CONSTANT", "CONSTANT" )
	this:addAnimation( "hero_throw_shell", "CONSTANT" )

	-- Secondary Animations --------------------------------------------------------------------------------------------------------------------

	this:addSecondaryAnimation( "hero_idle_stand", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_look_stand", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_handgun_reload", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_rifle_reload", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_shotgun_reload", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_throw_shell", "Bip01 Spine" )

	-- Load Idle Animations --------------------------------------------------------------------------------------------------------------------

	this:addAnimation( "hero_idle_stand" )
	this:addAnimation( "hero_idle_turn" )

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
	this:addAnimation( "hero_handgun_knock", "CONSTANT" )	
	this:addSecondaryAnimation( "hero_rifle_knock", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_shotgun_knock", "Bip01 Spine" )
	this:addSecondaryAnimation( "hero_handgun_knock", "Bip01 Spine" )


	-- Movement sound animation Listeners ------------------------------------------------------------------------------------------------------

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

-- DOC
--
-- In addition to normal animation playback, the character has a primary and secondary "Movement Animation" which make it possible
-- to do seamless blending of walking directions or aiming directions, for example.
-- Movement animations use parameters of the character's control attributes to set weights of animations in respect to eachother, normalizing
-- the total weight to 1.
-- Secondary movement animation behaves only a little bit differently, it does not normalize a total weight below 1, so you can still blend in the
-- secondary masked animation on top of the primary. 
--
	-- Sneak/Walk/Run Movent Animation ( NOTE : Adding Movement Animation Sub Anim does not load the animation from disk, load it with addAnimation )
	
-- DOC 
--
-- createMovementAnimations makes a new movementanimation, use the returned table to refer to it
-- Movement animations consists of sets of animations on multiple layers, with one layer being in use at a time
--
	local moving = this:createMovementAnimation( "Moving" );
	
	-- Layers

-- DOC 
--
-- addLayer adds a new layer to movementanimation. 
-- Layers are used to switch between sets of animations, like sneak/walk/run sets in this case
-- layers are switched on and off depending on the value of control 
--
-- Params : name, control attribute, control source, low limit of control, high limit of control, blend behavior
-- blend behavior is "NORMAL" / "ADDALLBLENDS", use ADDALLBLENDS for continous blending, "NORMAL" for faded time-depending blends
-- Returns : Layer index     
--
-- Control types are: 
--		NONE : Doesn't care about the value of control, always valid in any case
--		VECTOR3_LENGTH : Measures the length of control's vector (or just the value if its' a float) 
--		VECTOR3_DIRECTIONXZ : Absolute direction in world coordinates on XZ-plane
--		VECTOR3_DIRECTIONYZ : Absolute direction in world coordinates on YZ-plane
--		VECTOR3_DIRECTIONXZX : Like both above, but the highest angle is used
--
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
	
	-- WAS Secondary Animations --------------------------------------------------------------------------------------------------------------------

	-- Looking (aim vector)

	local looking = this:makeLookingAnimSetVector( "Looking", "hero_look_stand", "hero_look_left", "hero_look_up", "hero_look_right", "hero_look_down" )
	
	-- Looking (crosshair screen space)

	--local looking = this:makeLookingAnimSetCrosshair( "Looking", "hero_look_stand", "hero_look_left", "hero_look_up", "hero_look_right", "hero_look_down" )
	
	-- Recoil (aim vector)

	local shootrifle		= this:makeAimAnimSetVector( "shoot_rifle", "hero_rifle_shoot_frwd", "hero_rifle_shoot_left", "hero_rifle_shoot_up", "hero_rifle_shoot_right", "hero_rifle_shoot_down" )
	local shoothandgun		= this:makeAimAnimSetVector( "shoot_handgun", "hero_handgun_shoot_frwd", "hero_handgun_shoot_left", "hero_handgun_shoot_up", "hero_handgun_shoot_right", "hero_handgun_shoot_down" )
	local shootshotgun		= this:makeAimAnimSetVector( "shoot_shotgun", "hero_shotgun_shoot_frwd", "hero_shotgun_shoot_left", "hero_shotgun_shoot_up", "hero_shotgun_shoot_right", "hero_shotgun_shoot_down" )

	-- Recoil (crosshair screen space)

	--local shootrifle	= this:makeAimAnimSetCrosshair( "shoot_rifle", "hero_rifle_shoot_frwd", "hero_rifle_shoot_left", "hero_rifle_shoot_up", "hero_rifle_shoot_right", "hero_rifle_shoot_down" )
	--local shoothandgun	= this:makeAimAnimSetCrosshair( "shoot_handgun", "hero_handgun_shoot_frwd", "hero_handgun_shoot_left", "hero_handgun_shoot_up", "hero_handgun_shoot_right", "hero_handgun_shoot_down" )
	--local shootshotgun	= this:makeAimAnimSetCrosshair( "shoot_shotgun", "hero_shotgun_shoot_frwd", "hero_shotgun_shoot_left", "hero_shotgun_shoot_up", "hero_shotgun_shoot_right", "hero_shotgun_shoot_down" )

	-- Aiming (aim vector)
	
	local aimrifle		= this:makeAimAnimSetVector( "aim_rifle", "hero_rifle_aim_frwd", "hero_rifle_aim_left", "hero_rifle_aim_up", "hero_rifle_aim_right", "hero_rifle_aim_down", 0.3 )  
	local aimhandgun	= this:makeAimAnimSetVector( "aim_handgun", "hero_handgun_aim_frwd", "hero_handgun_aim_left", "hero_handgun_aim_up", "hero_handgun_aim_right", "hero_handgun_aim_down", 0.3 ) 
	local aimshotgun	= this:makeAimAnimSetVector( "aim_shotgun", "hero_shotgun_aim_frwd", "hero_shotgun_aim_left", "hero_shotgun_aim_up", "hero_shotgun_aim_right", "hero_shotgun_aim_down", 0.3 ) 

	-- Aiming (crosshair screen space)
	
	--local aimrifle		= this:makeAimAnimSetCrosshair( "aim_rifle", "hero_rifle_aim_frwd", "hero_rifle_aim_left", "hero_rifle_aim_up", "hero_rifle_aim_right", "hero_rifle_aim_down", 0.3 )  
	--local aimhandgun	= this:makeAimAnimSetCrosshair( "aim_handgun", "hero_handgun_aim_frwd", "hero_handgun_aim_left", "hero_handgun_aim_up", "hero_handgun_aim_right", "hero_handgun_aim_down", 0.3 ) 
	--local aimshotgun	= this:makeAimAnimSetCrosshair( "aim_shotgun", "hero_shotgun_aim_frwd", "hero_shotgun_aim_left", "hero_shotgun_aim_up", "hero_shotgun_aim_right", "hero_shotgun_aim_down", 0.3 ) 

	-- DEBUG: print aim/shoot anim lengths

	trace( "Rifle shoot anim length : "..this:getAnimLength( "hero_rifle_shoot_frwd" ) )
	trace( "Handgun shoot anim length : "..this:getAnimLength( "hero_handgun_shoot_frwd" ) )
	trace( "Shotgun shoot anim length : "..this:getAnimLength( "hero_shotgun_shoot_frwd" ) )
	trace( "Rifle aim anim length : "..this:getAnimLength( "hero_rifle_aim_frwd" ) )
	trace( "Handgun aim anim length : "..this:getAnimLength( "hero_handgun_aim_frwd" ) )
	trace( "Shotgun aim anim length : "..this:getAnimLength( "hero_shotgun_aim_frwd" ) )

	-- Physical combat

	-- Hit range cylinder describes contact distance of physical hits,
	-- i.e. if enemy physical attack is further away than 0.3m from capsule center axis
	-- then no harm is done to character
	this:setPhysicalHitRange( 0.3 )

	-- addPhysicalCombatMove parameters:
	--  1) name of the combat movement
	--  2) name of animation used in movement
	--  3) hit type: only STRIKE for now
	--  4) contact type: only NONCONTACT for now
	--  5) hit position height where the damage is caused to target
	--  6) amount of damage
	--  7) direction of damage/force (angle in degrees, forward=0, angle increases counter-clockwise)
	--  8) Time when opponent starts receiving damage
	--  9) Time when opponent ends receiving damage
	-- 10) Start angle (degrees) of attack sector (0=right, 90=forward, 180=left, 270=behind)
	-- 11) End angle (degrees) of attack sector (0=right, 90=forward, 180=left, 270=behind)
	-- 12) Reach distance for this attack
	this:addPhysicalCombatMove( "rifle_knock", "hero_rifle_knock", "STRIKE", "NONCONTACT", 1.3, 15, -5, 0.3, 0.4, 60, 120, 1.5 )
	this:addPhysicalCombatMove( "shotgun_knock", "hero_shotgun_knock", "STRIKE", "NONCONTACT", 1.3, 15, -5, 0.3, 0.4, 60, 120, 1.5 )
	this:addPhysicalCombatMove( "handgun_knock", "hero_handgun_knock", "STRIKE", "NONCONTACT", 1.3, 15, -5, 0.3, 0.4, 60, 120, 1.5 )
	this:addPhysicalCombatMove( "kick", "hero_kick1", "STRIKE", "NONCONTACT", 1.3, 15, 0, 0.3, 0.4, 60, 120, 0.15 )
	--this:addPhysicalCombatCombo( "rifle_knock", "kick" )
	--this:addPhysicalCombatCombo( "shotgun_knock", "kick" )
	--this:addPhysicalCombatCombo( "handgun_knock", "kick" )

-- Preload sounds ----------------------------------------------------------------------------------------------------------
	this:loadSound( this.characterSoundPath .. "dieX" )

    -- Set startup pose
	this:setAnimation( "hero_idle_stand" )
	this:setVelocity( 0, 0, 0 )
	this:setPrimaryState( "STANDING" )
end

function this.init( this )
	this.characterSoundPath = "hero/"

	this:setName( "Hero" )
	trace( "Initializing " .. this:name() )

	this:setAnimationFolder( "animations" )
	this:setMesh( "hero/hero.sg", 0, 1e6 )
	this:setDynamicShadow( "hero_shadow_volume", 10 )
	this:initMaleBase()

	-- smoothed input
	this.inputTurnSpeed = 360  -- max direction change, degrees / sec
	this.inputControlSpeed = 4 -- max control vector [0,1] length change, 1 / sec

	-- add face morph animations
	this:setMorphBase( this.morphBaseMesh )
	this:addMorphAnimation( this.morphBaseMesh, "hero_head/hero_morph_aim.gm", "REPEAT" )	-- end behabiour: REPEAT (default), RESET, CONSTANT, OSCILLATE
	this:addMorphAnimation( this.morphBaseMesh, "hero_head/hero_morph_idle.gm", "REPEAT" )
	this:addMorphAnimation( this.morphBaseMesh, "hero_head/hero_morph_shoot.gm", "REPEAT" )
	
	this:addMorphAnimation( this.morphBaseMesh, "hero_head/hero_morph_die.gm", "CONSTANT" )
	this:addMorphAnimation( this.morphBaseMesh, "hero_head/hero_morph_physical_hurt.gm", "CONSTANT" )
	this:addMorphAnimation( this.morphBaseMesh, "hero_head/hero_morph_projectile_hurt.gm", "CONSTANT" )

	-- Projectile does not cause hurt state transition.
	this.projectileHurts = nil

	-- default is 100, add extra zeros to be able to get more damage
	this:setHealth( 100 )
end
