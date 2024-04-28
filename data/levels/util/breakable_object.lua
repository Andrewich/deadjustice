--
-- Creates breakable object (sequence of dynamic objects)
--
-- Parameters:
-- objects Table of object tables. Object table entries: name. Example: {{name="o1"}, {name="o2"}}
-- health Amount of damage the breakable object can get before 'dying'.
-- damage Amount of damage the breakable object causes at pivot point when dying.
-- damageRadius Radius of the caused damage. Fades out to zero at outer range.
-- particles Table of particle tables. Particle table entries: name, time. Time is delay (seconds) before playing effect.
-- sounds Table of sound tables. Sound table entries: name, time. Time is delay (seconds) before playing effect.
-- hideDelay Delay (seconds) before object is changed to next one.
-- noiseLevel Noise level at the pivot point (so AI can hear explosion).
-- noiseDistance Fade out distance of noise (so AI can hear explosion).
--
function this.createBreakableObject( this, objects, health, damage, damageRadius, particles, sounds, hideDelay, noiseLevel, noiseDistance )
	local i = 1
	while ( objects[i] ) do
		local dynobj = this:getDynamicObject( objects[i].name )
		dynobj:hide()
		if ( objects[i+1] ) then
			dynobj.next = this:getDynamicObject( objects[i+1].name )
		end
		i = i + 1
	end

	local dynobj = this:getDynamicObject( objects[1].name )
	dynobj:unhide()
	dynobj.health = health
	dynobj.damage = damage
	dynobj.damageRadius = damageRadius
	dynobj.particles = particles
	dynobj.sounds = sounds
	dynobj.hideDelay = hideDelay
	dynobj.noiseLevel = noiseLevel
	dynobj.noiseDistance = noiseDistance

	dynobj.receiveDamage = function( this, damage )
		local oldhealth = this.health
		this.health = this.health - damage
		if ( oldhealth >= 0 and this.health < 0 and this.next ) then
			-- play particle systems
			local i = 1
			while ( this.particles[i] ) do
				local particleName = this.particles[i].name
				this:addTimerEvent( function(this)
					local cell = this:cell()
					cell:playParticleSystemAt( %particleName, this:getPosition(0), this:getPosition(1), this:getPosition(2) )
					end, this.particles[i].time )
				i = i + 1
			end

			-- play sounds
			local i = 1
			while ( this.sounds[i] ) do
				local soundName = this.sounds[i].name
				this:addTimerEvent( function(this)
					local cell = this:cell()
					cell:playSoundAt( %soundName, this:getPosition(0), this:getPosition(1), this:getPosition(2) )
					end, this.sounds[i].time )
				i = i + 1
			end

			-- hide this, unhide next,
			-- signal explosion and noise
			this:addTimerEvent( function(this)
				level:signalExplosion( this, this.damage, 0, this.damageRadius )
				level:createNoise( this, this.noiseLevel, 0, this.noiseDistance, 0, 0.1 )
				local next = this.next
				next:unhide()
				this:hide()
				end, this.hideDelay )
		end
		end

	dynobj.signalProjectileCollision = function( this, projectile )
		--trace( "projectile " .. projectile:name() .. " collided dynamic object " .. this:name() )
		this:receiveDamage( projectile:damage() )
		end

	dynobj.signalReceiveExplosion = function( this, damage )
		this:receiveDamage( damage )
		end
end
