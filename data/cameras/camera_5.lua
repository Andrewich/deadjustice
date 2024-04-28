this:include "camera_base.lua"


function this.init( this )
	this:setName( "survival horror" )

	this:setFront( 0.01 )
	this:setBack( 200 )
	this:setBoundSphere( 0.1 )
	this:setHorizontalFov( 80 )

	this:setMoveTarget( 0.5, 1.2, 1.8 )
	this:setLookTarget( 0, 0.92, 0 )

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

	this:setPitchAmountDown( -40 )
	this:setPitchAmountUp( -40 )
end
