--
-- Helper functions for tutorial / help text
-- Uses 'onscreen' OverlayDisplay object and onscreen.helpFont font
--
this:include "align.lua"

function this.addHelpText( this, startTime, endTime, str, x, y )
	local ofsx = onscreen:width() * x
	local ofsy = onscreen:height() * y
	if ( x == ALIGN_CENTER or x == ALIGN_LEFT or x == ALIGN_RIGHT ) then 
		ofsx = x
	end
	if ( y == ALIGN_CENTER or y == ALIGN_TOP or y == ALIGN_BOTTOM ) then 
		ofsy = y
	end
	this:addTimerEvent( function( this ) 
		local ID = onscreen.helpFont:addText( %ofsx, %ofsy, %str )
		this:addTimerEvent( function(this)
			onscreen.helpFont:removeText( %ID )
			end, %endTime - %startTime )
		end, startTime )
	return (onscreen:height() * y + onscreen.helpFont:getHeight("W")) / onscreen:height()
end

function this.addCenteredHelpText( this, startTime, endTime, str, y )
	this:addTimerEvent( function( this ) 
		local ID = onscreen.helpFont:addText( ALIGN_CENTER, onscreen:height() * %y, %str )
		this:addTimerEvent( function(this)
			onscreen.helpFont:removeText( %ID )
			end, %endTime - %startTime )
		end, startTime )
	return (onscreen:height() * y + onscreen.helpFont:getHeight("W")) / onscreen:height()
end

function this.addLeftAlignHelpText( this, startTime, endTime, str, y )
	this:addTimerEvent( function( this ) 
		local ID = onscreen.helpFont:addText( 0, onscreen:height() * %y, %str )
		this:addTimerEvent( function(this)
			onscreen.helpFont:removeText( %ID )
			end, %endTime - %startTime )
		end, startTime )
	return (onscreen:height() * y + onscreen.helpFont:getHeight("W")) / onscreen:height()
end

function this.addRightAlignHelpText( this, startTime, endTime, str, y )
	this:addTimerEvent( function( this ) 
		local ID = onscreen.helpFont:addText( ALIGN_RIGHT, onscreen:height() * %y, %str )
		this:addTimerEvent( function(this)
			onscreen.helpFont:removeText( %ID )
			end, %endTime - %startTime )
		end, startTime )
	return (onscreen:height() * y + onscreen.helpFont:getHeight("W")) / onscreen:height()
end

function this.addTopAlignHelpText( this, startTime, endTime, str, y )
	this:addTimerEvent( function( this ) 
		local ID = onscreen.helpFont:addText( onscreen:width() * %x, 0, %str )
		this:addTimerEvent( function(this)
			onscreen.helpFont:removeText( %ID )
			end, %endTime - %startTime )
		end, startTime )
	return (onscreen:height() * y + onscreen.helpFont:getHeight("W")) / onscreen:height()
end

function this.addBottomAlignHelpText( this, startTime, endTime, str, y )
	this:addTimerEvent( function( this ) 
		local ID = onscreen.helpFont:addText( onscreen:width() * %x, ALIGN_BOTTOM, %str )
		this:addTimerEvent( function(this)
			onscreen.helpFont:removeText( %ID )
			end, %endTime - %startTime )
		end, startTime )
	return (onscreen:height() * y + onscreen.helpFont:getHeight("W")) / onscreen:height()
end
