this:include "camera_base.lua"


function this.init( this )
	this:setName( "front tele" )

	this:setFront( 0.01 )
	this:setBack( 200 )
	this:setBoundSphere( 0.1 )
	this:setBlendTime( 1 )

	this:setMoveTarget( 0, 1.6, 1.4 )
	this:setMoveSpring( 400, 150, 200 )
	this:setMoveDamping( 30, 30, 15 )
	
	this:setLookTarget( 0, 1.6, -1 )
	this:setLookSpring( 400, 150, 200 )
	this:setLookDamping( 15, 10, 15 )

	this:setCrosshairLimitLeft( 0.95 )		-- Percent of half screen width
	this:setCrosshairLimitRight( 0.95 )		-- Percent of half screen height
	this:setCrosshairLimitUp( 0.95 )		-- Percent of half screen width
	this:setCrosshairLimitDown( 0.95 )		-- Percent of half screen height

	this:setTurnStrengthLeft( 1.25 )		-- Percent of rotation speed
	this:setTurnStrengthRight( 1.25 )		-- Percent of rotation speed

	this:setTurnThresholdLeft( 0.2 )		-- Percent of half screen width
	this:setTurnThresholdRight( 0.2 )		-- Percent of half screen width
	this:setPitchThresholdUp( 0.2 )			-- Percent of half screen height
	this:setPitchThresholdDown( 0.2 )		-- Percent of half screen height

	this:setPitchAmountDown( 40 )			-- Degrees
	this:setPitchAmountUp( 30 )			-- Degrees
end
