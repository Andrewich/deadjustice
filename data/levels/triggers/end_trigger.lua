function this.signalCharacterCollision( this, character )
	if ( character == hero and not this.triggered ) then
		level:endLevel()
		this.triggered = 1
	end
end

function this.signalProjectileCollision( this, projectile )
end

function this.init( this )
end
