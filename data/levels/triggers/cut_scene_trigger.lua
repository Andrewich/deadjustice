function this.signalCharacterCollision( this, character )
	if ( not this.triggered and character == hero ) then
		hero:setHealth( 100 )
		level:playCutScene( this.cutSceneName )
		this.triggered = 1
	end
end

function this.signalProjectileCollision( this, projectile )
end

function this.init( this )
end
