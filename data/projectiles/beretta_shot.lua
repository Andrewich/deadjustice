function this.signalHitGeometry( this, x, y, z, mtl )
	if ( mtl.typeName == "SOFT" ) then
		this:cell():playSoundAt( "weapons/generic/ricochet_soft", x, y, z )
		this:cell():playParticleSystemAt( "weapon_effects/bullet_hit_soft", x, y, z )
	elseif ( mtl.typeName == "SAND" ) then
		this:cell():playSoundAt( "weapons/generic/ricochet_sand", x, y, z )
		this:cell():playParticleSystemAt( "weapon_effects/bullet_hit_sand", x, y, z )
	elseif ( mtl.typeName == "WOOD" ) then
		this:cell():playSoundAt( "weapons/generic/ricochet_wood", x, y, z )
		this:cell():playParticleSystemAt( "weapon_effects/bullet_hit_wood", x, y, z )
	elseif ( mtl.typeName == "METAL" ) then
		this:cell():playSoundAt( "weapons/generic/ricochet_metal", x, y, z )
		this:cell():playParticleSystemAt( "weapon_effects/bullet_hit_metal", x, y, z )
	else
	-- If not any of above, play STONE hit particle effect and sound
		this:cell():playSoundAt( "weapons/generic/ricochet_stone", x, y, z )
		this:cell():playParticleSystemAt( "weapon_effects/bullet_hit_stone", x, y, z )
	end
	
	local noiseLevel = 100
	local noiseDistance = 15
	local noise = level:createNoise( this:getWeapon():owner(), noiseLevel, 0, noiseDistance, 0, 0.1 )
	noise:setPosition( this:cell(), x, y, z )
end

function this.init( this )
	this:setName( "beretta_shot" )
	this:setLaunchVelocity( 100 )				-- m/s
	this:setDamage( 15 )
	this:setAgeLimit( 8 )						-- seconds
	this:setDamageAttenuationStartRange( 40 )	-- meters, range when damage attenuation starts
	this:setMaxRange( 80 )						-- meters, range when damage is 0 and projectile is removed
end
