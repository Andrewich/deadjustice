function this.signalHitGeometry( this, x, y, z )
	this:playSound( "weapons/generic/metal_drop_" .. this:getRandomInteger(1,3) )
	this:cell():playParticleSystemAt( "weapon_effects/bullet_hit_soft", x, y, z )

	local noiseLevel = 30
	local noiseDistance = 10
	local noise = level:createNoise( hero, noiseLevel, 0, noiseDistance, 0, 0.5 )
	noise:setPosition( this:cell(), x, y, z )
end

function this.init( this )
	this:setName( "diversion_empty_shell" )
	this:setLaunchVelocity( 6 )			-- m/s
	this:setDamage( 0 )					
	this:setAgeLimit( 15 )				-- seconds
	this:setGravity( 0.5 )				
	this:enableKeepOnCollision( 1 )		-- true
	this:enableAlignOnCollision( 1 )	-- true
	this:enableHitCharacter( nil )		-- false
	this:setSpin( this:getRandomInteger(-100,100) / 100, 1, -0.4 + this:getRandomInteger(0,100) / 200, this:getRandomInteger(0, 180) )	-- axis(X,Y,Z), deg/sec

	this:setMesh( "projectiles/m16/m16_shell.sg" )

	this:loadSound( "weapons/generic/metal_drop_X" )
end
