--
-- Helper functions for dialogue text
-- Uses 'onscreen' OverlayDisplay object and onscreen.dialogFont font
--
this:include "align.lua"

function this.dialogTextBottom( this, startTime, endTime, str, rowsFromBottom )
	this:addTimerEvent( function(this)
		local w = onscreen:width()
		local h = onscreen:height()
		local dialogTextId = onscreen.dialogFont:addText( ALIGN_CENTER, h-onscreen.dialogFont:getHeight("W")*(%rowsFromBottom+1), %str )

		this:addTimerEvent( function(this)
			onscreen.dialogFont:removeText( %dialogTextId )
			end, %endTime - %startTime )

		end, startTime )
end
