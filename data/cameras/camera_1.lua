this:include "camera_base.lua"


-- Camera settings defined and their usage, see also camera_base.lua

function this.init( this )
	this:setName( "default camera (PC)" )

	-- front/back plane distances
	this:setFront( 0.01 )
	this:setBack( 200 )

	-- vertical field of view in degrees
	this:setHorizontalFov( 80 )

	-- camera movement target in hero character space
	this:setMoveTarget( 0, 1.5, -2 )

	-- camera look-at target in hero character space
	this:setLookTarget( 0, 1.45, 0 )
	
	-- sets how many previous values to average
	-- when computing final used values
	this:setAverageCount( 1 )
	
	-- end-of-movement adjustment to 
	-- shift hero head away from screen center
	this:setPostPitchMove( 0, 0.5, 0 )

	-- move/look target spring strength & damping constants (x,y,z)
	this:setMoveSpring( 400, 400, 200 )
	this:setLookSpring( 400, 400, 200 )
	this:setMoveDamping( 30, 60, 15 )
	this:setLookDamping( 15, 40, 15 )

	-- crosshair movement limits
	this:setCrosshairLimitLeft( 0.75 )		-- Percent of half screen width
	this:setCrosshairLimitRight( 0.75 )		-- Percent of half screen height
	this:setCrosshairLimitUp( 0.75 )		-- Percent of half screen width
	this:setCrosshairLimitDown( 0.3 )		-- Percent of half screen height
	this:setCrosshairOffset( 0, 0 )		-- Percent of half screen width & height

	-- camera turning strength
	this:setTurnStrengthLeft( 1.25 )		-- Percent of character rotation speed
	this:setTurnStrengthRight( 1.25 )		-- Percent of character rotation speed

	-- thresholds for defining when turning starts
	this:setTurnThresholdLeft( 0.15 )		-- Percent of half screen width
	this:setTurnThresholdRight( 0.15 )		-- Percent of half screen width
	this:setPitchThresholdUp( 0.2 )			-- Percent of half screen height
	this:setPitchThresholdDown( 0.2 )		-- Percent of half screen height

	-- how much camera can look up/down
	this:setPitchAmountDown( 35 )			-- Maximum pitch amount in degrees
	this:setPitchAmountUp( 45 )				-- Maximum pitch amount in degrees

	-- set camera offsets based on hero character state, used for peeking and crouching:
	-- addTargetStateOffset( <primary state>, <secondary state>, <move offset x,y,z>, <look offset x,y,z>, <blend time> )
	-- for list of character states see addStateListener calls in hero.lua
	local crouchY = -0.5
	local crouchTime = 0.3
	local peekX = 1
	local peekTime = 0.5
	this:addTargetStateOffset( "CROUCHED", "UNKNOWN", 0,crouchY,0, 0,crouchY,0, crouchTime )
	this:addTargetStateOffset( "PEEKING_LEFT", "UNKNOWN", -peekX,0,0, -peekX,0,0, peekTime )
	this:addTargetStateOffset( "PEEKING_RIGHT", "UNKNOWN", peekX,0,0, peekX,0,0, peekTime )
	this:addTargetStateOffset( "DEAD", "UNKNOWN", 0,crouchY,0, 0,crouchY,0, crouchTime )

	-- settings that should not be used currently:
	-- this:getCameraAnimationLength
	-- this:getCameraAnimationStart
	-- this:playCameraAnimation
	-- this:setBoundSphere
	-- this:setBlendTime
	-- this:setTimeScale
	-- this:setWorldSpaceControl
	-- this:setMinPortalVisibleSize
	-- this:stopCameraAnimation
end