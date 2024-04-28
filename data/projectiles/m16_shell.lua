function this.signalHitGeometry( this, x, y, z )
	this:playSound( "weapons/generic/metal_drop_" .. this:getRandomInteger(1,3) )
end

function this.init( this )
	this:setName( "m16_shell" )
	this:setLaunchVelocity( 1.5 )		-- m/s
	this:setDamage( 0 )					
	this:setAgeLimit( 15 )				-- seconds
	this:setGravity( 1 )				
	this:enableKeepOnCollision( 1 )		-- true
	this:enableAlignOnCollision( 1 )	-- true
	this:enableHitCharacter( nil )		-- false
	this:setSpin( this:getRandomInteger(-100,100) / 100, 1, -0.4 + this:getRandomInteger(0,100) / 200, this:getRandomInteger(0, 1080*3) )	-- axis(X,Y,Z), deg/sec

	this:setMesh( "projectiles/m16/m16_shell.sg" )

	this:loadSound( "weapons/generic/metal_drop_X" )
end
