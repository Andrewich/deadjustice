-- tutorial task: move hero
function this.ps2_task1( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE LEFT ANALOG JOYSTICK TO MOVE HARLEY AROUND", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "OK", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		-- note that there is only one movement state WALKING, for all styles (sneak/run/walk)
		return hero:isSneaking() or hero:isWalking() or hero:isRunning()
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: sneaking
function this.ps2_task2( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 6
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "BY PUSHING STICK FURTHER TO ANY DIRECTION", 0.75 ) 
	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "CAN SNEAK, WALK AND RUN", nextRowY ) 

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "TRY TO WALK FORWARD", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:isWalking() and hero:primaryState() == "WALKING"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

function this.ps2_task2b( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NEXT TRY TO SNEAK LEFT OR RIGHT", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:isSneaking() and hero:primaryState() == "STRAFING"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: running
function this.ps2_task3( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NOW TRY TO RUN FORWARD", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "VERY GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:isRunning() and hero:primaryState() == "WALKING"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: turning
function this.ps2_task4( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE RIGHT ANALOG JOYSTICK TO MOVE THE CROSSHAIR", 0.75 ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "MOVE CROSSHAIR OFF-CENTER TO TURN HARLEY", nextRowY ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "RETURN CROSSHAIR TO CENTER TO STOP TURNING", nextRowY ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this.heroTurned = false
	this:addTimerWaitCondition( function(this) 
		if ( this.heroTurned ) then
			return not hero:userControl():isTurning()
		else
			this.heroTurned = hero:userControl():isTurning()
			return false
		end
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: roll forward
function this.ps2_task5( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 4
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	nextRowY = this:addCenteredHelpText( 0+startTime, 3+startTime, "L2 EXECUTES ROLL MANOUVER", 0.75 ) 

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NOW TRY TO ROLL FORWARD", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this.heroTurned = false
	this:addTimerWaitCondition( function(this) 
		return hero:primaryState() == "ROLLING_FORWARD"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: roll sideways and backwards
function this.ps2_task6( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE L2 COMBINED WITH MOVEMENT DIRECTION STICK", 0.75 ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "TO PERFORM ROLL SIDEWAYS AND BACKWARDS", nextRowY ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NOW TRY TO ROLL SIDEWAYS AND THEN BACKWARDS", nextRowY ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "OK, VERY GOOD!", 0.75 ) 

	this.heroRolledSide = false
	this.heroRolledBack = false
	this:addTimerWaitCondition( function(this) 
		if ( hero:primaryState() == "ROLLING_LEFT" or hero:primaryState() == "ROLLING_RIGHT" ) then
			this.heroRolledSide = true
		end
		if ( hero:primaryState() == "ROLLING_BACKWARD" ) then
			this.heroRolledBack = true
		end
		return this.heroRolledSide and this.heroRolledBack
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: crouch
function this.ps2_task7( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 5

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE L1 TO CROUCH DOWN", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "NOW, RELEASE L1 TO GET UP", 0.75 ) 
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "REMEMBER THAT YOU CAN ALSO ROLL FROM CROUCHED STANCE", nextRowY ) 

	this:addTimerWaitCondition( function(this) 
		return hero:isCrouched()
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: firing weapon
function this.ps2_task8( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 3

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NOW LET'S TRY WEAPONS", 0.75 ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "CLICK R2 TO RAISE WEAPON UP AND CLICK AGAIN TO FIRE", nextRowY ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "OK, NEXT WE TRY WITH DIFFERENT WEAPON", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:secondaryState() == "ATTACKING"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: changing weapon
function this.ps2_task9( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE CIRCLE BUTTON TO CHANGE WEAPON", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:secondaryState() == "CYCLING_WEAPON"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: firing a few shots
function this.ps2_task10( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 4

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NOW FIRE A FEW SHOTS", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD! NOTE THAT DIFFERENT WEAPONS HAVE VARYING ACCURACY", 0.75 ) 
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "AND FIRING RATE", nextRowY ) 

	this.heroFiring = false
	this.heroFireCount = 0
	this:addTimerWaitCondition( function(this) 
		if ( hero:secondaryState() == "ATTACKING" ) then
			this.heroFiring = true
		elseif ( this.heroFiring ) then
			this.heroFireCount = this.heroFireCount + 1
			this.heroFiring = false
		end
		return this.heroFireCount > 3
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: reload weapon
function this.ps2_task11( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 4

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE TRIANGE BUTTON TO RELOAD YOUR WEAPON", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:secondaryState() == "CHANGING_CLIP"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: throw decoy shell
function this.ps2_task12( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 11
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 5

	-- pre-task briefing
	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "YOU CAN ALSO CANCEL RELOADING BY ROLLING IF", 0.75 ) 
	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "YOU ARE IN REALLY TIGHT SITUATION", nextRowY ) 
	nextRowY = this:addCenteredHelpText( 6+startTime, 10+startTime, "NEXT WE TRY A FEW MORE ADVANCED TECHNIQUES", 0.75 ) 

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE R1 TO THROW A DECOY SHELL TO DISTRACT ENEMIES", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD! REMEMBER THAT YOU CAN USE AIM TO CONTROL", nextRowY ) 
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "WHERE YOU THROW THE SHELL", nextRowY ) 

	this:addTimerWaitCondition( function(this) 
		return hero:secondaryState() == "THROWING_EMPTY_SHELL"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: peek
function this.ps2_task13( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 6
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 3

	-- pre-task briefing
	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "SOMETIMES IT'S WISE TAKE CAUTION IN COMBAT", 0.75 ) 
	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "YOU CAN PEEK AROUND A CORNER AND FIRE SHOTS", nextRowY ) 

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "PRESS AND HOLD DPAD RIGHT OR LEFT TO PEEK AROUND A CORNER", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD! RELEASE DPAD TO RETURN FROM PEEK", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:primaryState() == "PEEKING_LEFT" or hero:primaryState() == "PEEKING_RIGHT"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: firing when peeking
function this.ps2_task14( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 3

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "NOW TRY FIRING WHEN YOU PEEK", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "VERY GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return (hero:primaryState() == "PEEKING_LEFT" or hero:primaryState() == "PEEKING_RIGHT") and hero:secondaryState() == "ATTACKING"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: kick
function this.ps2_task15( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 2

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "IF YOU GET INTO CLOSE COMBAT SITUATION", 0.75 ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "YOU CAN KICK AND PUNCH YOUR ENEMIES", nextRowY ) 
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE X BUTTON TO KICK ENEMIES", nextRowY ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD!", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:primaryState() == "PHYSICAL_KICK"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end

-- tutorial task: punch
function this.ps2_task16( this )
	local nextRowY
	local startTime = this.startTime

	-- seconds reserved for pre-task briefing
	local infoTime = 0
	-- seconds elapsed before task can be completed, must be >0
	local taskTime = 0.2
	-- seconds how long acceptance message is on screen
	local okTime = 3

	-- pre-task briefing
	-- (none)

	-- calculate needed combinations of the values
	local commandStartTime = startTime + infoTime
	local commandEndTime = startTime + infoTime + taskTime + this.acceptTime
	local acceptStartTime = commandEndTime
	local acceptEndTime = commandEndTime + okTime

	-- addCenteredHelpText: adds text to center of screen (horizontal),
	-- parameters: time start, time end, text string, relative vertical position [0,1]
	-- function returns Y-coordinate of next row, so multiple rows can be added to same relative location
	nextRowY = this:addCenteredHelpText( commandStartTime, commandEndTime, "USE SQUARE BUTTON TO PUNCH", 0.75 ) 

	-- acceptance text for this task
	nextRowY = this:addCenteredHelpText( acceptStartTime, acceptEndTime, "GOOD! NOTE THAT YOU CAN ALSO PUNCH WHILE MOVING", 0.75 ) 

	this:addTimerWaitCondition( function(this) 
		return hero:secondaryState() == "PHYSICAL_STRIKE"
		end, commandEndTime-this.acceptTime )

	-- calculate when next task can start
	this.startTime = acceptEndTime + this.taskSwitchTime
end
