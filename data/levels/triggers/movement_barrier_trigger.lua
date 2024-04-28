this:include "align.lua"


function this.signalCharacterCollision( this, character )
	if ( character == hero and not this.collided ) then
		onscreen:dialogTextBottom( 0, 8, "I still have some unfinished business here...", 1 )
		this.collided = 1
	end
end

function this.signalProjectileCollision( this, projectile )
end

function this.init( this )
	this.collided = nil
end
