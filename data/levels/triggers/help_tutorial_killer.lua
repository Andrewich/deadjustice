function this.signalCharacterCollision( this, character )
	if ( character == hero and not this.triggered and this.target ) then
		onscreen.helpFont:removeTexts()
		level:removeTrigger( this.target )
		this.target = nil
		this.triggered = 1
	end
end

function this.signalProjectileCollision( this, projectile )
end

function this.init( this )
end
