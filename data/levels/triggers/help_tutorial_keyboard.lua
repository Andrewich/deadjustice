this:include "align.lua"
this:include "help_text.lua"


function this.signalCharacterCollision( this, character )
	if ( character == hero and not this.collided ) then
		local nextRowY = nil
		
		-- addCenteredHelpText: adds text to center of screen (horizontal),
		-- parameters: time start, time end, text string, relative vertical position [0,1]
		-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
		nextRowY = this:addCenteredHelpText( 0, 5, "USE W,A,S,D KEYS TO MOVE HARLEY AROUND", 0.75 ) 
		nextRowY = this:addCenteredHelpText( 0, 5, "USE MOUSE TO MOVE CROSSHAIR", nextRowY ) 
		
		nextRowY = this:addCenteredHelpText( 6, 11, "MOVE CROSSHAIR OFF-CENTER TO TURN HARLEY", 0.75 ) 
		nextRowY = this:addCenteredHelpText( 11, 16, "RETURN CROSSHAIR TO CENTER TO STOP TURNING", nextRowY ) 
		
		nextRowY = this:addCenteredHelpText( 17, 22, "X KEY EXECUTES ROLL MANOUVER", 0.75 )
		nextRowY = this:addCenteredHelpText( 17, 22, "USE X KEY COMBINED WITH MOVEMENT DIRECTIONS", nextRowY )
		nextRowY = this:addCenteredHelpText( 17, 22, "TO PERFORM ROLL SIDEWAYS AND BACKWARDS ", nextRowY )
		
		nextRowY = this:addCenteredHelpText( 23, 28, "USE C KEY TO CROUCH DOWN", 0.75 )
		
		nextRowY = this:addCenteredHelpText( 29, 34, "USE LEFT MOUSE BUTTON TO FIRE WEAPON", 0.75 )
		
		nextRowY = this:addCenteredHelpText( 35, 40, "USE Z KEY TO THROW A DECOY SHELL TO DISTRACT ENEMIES", 0.75 )
		
		nextRowY = this:addCenteredHelpText( 41, 46, "PRESS AND HOLD Q OR E KEY TO PEEK AROUND A CORNER", 0.75 )
		nextRowY = this:addCenteredHelpText( 41, 46, "RELEASE Q OR E KEY TO RETURN FROM PEEK", nextRowY )
		nextRowY = this:addCenteredHelpText( 47, 52, "USE LEFT MOUSE BUTTON TO PUNCH ENEMIES", 0.75 ) 
		NextRowY = this:addCenteredHelpText( 47, 52, "USE LEFT CTRL KEY TO KICK ENEMIES", nextRowY )
		
		NextRowY = this:addCenteredHelpText( 53, 63, "USE R KEY TO RELOAD YOUR WEAPON", 0.75 )
		
		nextRowY = this:addCenteredHelpText( 64, 69, "USE TAB KEY TO CHANGE WEAPON", 0.75 )

		nextRowY = this:addCenteredHelpText( 70, 75, "IN ORDER TO SURVIVE ", 0.75 )
		nextRowY = this:addCenteredHelpText( 76, 81, "USE DARKNESS TO REMAIN UNSEEN", 0.75 )
		nextRowY = this:addCenteredHelpText( 82, 87, "SLOWER MOVEMENT AND SOFT SURFACES MAKE LESS NOISE", 0.75 )
		nextRowY = this:addCenteredHelpText( 88, 93, "GOOD LUCK!", 0.75 )

		-- addCenteredHelpText: adds text to relative position of screen. 
		-- parameters: time start, time end, text string, relative horizontal position [0,1], relative vertical position [0,1]
		-- supports ALIGN_LEFT, ALIGN_RIGHT, ALIGN_CENTER, ALIGN_TOP, ALIGN_BOTTOM symbolic constants
		-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
		
		---nextRowY = this:addHelpText( 12, 32, "USE SH", ALIGN_CENTER, ALIGN_BOTTOM )
		this.collided = 1
	end
end

function this.signalProjectileCollision( this, projectile )
end

function this.init( this )
	this.collided = nil
end
