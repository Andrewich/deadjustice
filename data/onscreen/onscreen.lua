this:include "align.lua"
this:include "help_text.lua"
this:include "dialog_text.lua"

-- crosshair

this.targetingCrosshair = nil
this.targetBitmap = nil
this.targetHalfWidth = 0
this.targetHalfHeight = 0

function this.signalRefresh( this, dt )
	local screenhalf_x = this:width() / 2
	local screenhalf_y = this:height() / 2

	if ( level and not level:isActiveCutScene() ) then
		this.targetBitmap:setSpritePosition( this.targetingCrosshair, screenhalf_x + this:crosshairPos(1) * screenhalf_x - this.targetHalfWidth, 
			screenhalf_y + this:crosshairPos(2) * screenhalf_y - this.targetHalfHeight )
	else
		this.targetBitmap:setSpritePosition( this.targetingCrosshair, -1e6, -1e6 )
	end

	this.time = this.time + dt
end


function this.init( this )
	onscreen = this

	-- crosshair
	this.targetBitmap = this:createBitmap( "target.tga" )
	this.targetHalfWidth = this.targetBitmap:width() / 2
	this.targetHalfHeight = this.targetBitmap:height() / 2
	this.targetingCrosshair = this.targetBitmap:addSprite( this:width() / 2 - this.targetHalfWidth, this:height() / 2 - this.targetHalfHeight ) 
	this.crosshairEnabled = 1

	-- this font is used in cut scene dialogues
	this.dialogFont = this:createFont( "font_dialog" )

	-- this font is used in help / tutorial
	this.helpFont = this:createFont( "font_arial" )

	-- Initialization of internal time
	this.time = 0
end
