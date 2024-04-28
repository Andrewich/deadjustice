this:include "align.lua"
this:include "help_text.lua"
this:include "boolean.lua"
this:include "triggers/tutorial_mouse.lua"
this:include "triggers/tutorial_ps2.lua"


-- seconds before task command is changed to acceptance message, must be >0
this.acceptTime = 0.5

-- seconds between tasks
this.taskSwitchTime = 1	

-- see additional tutorial task specific settings in start of task functions


function this.startTexts( this )
	local nextRowY = nil
	local startTime = this.startTime

	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "WELCOME TO DEAD JUSTICE PLAYABLE PROTOTYPE DEMO", 0.75 )
		
	nextRowY = this:addCenteredHelpText( 6+startTime, 10+startTime, "A SHORT INTERACTIVE TUTORIAL IS ABOUT TO START", 0.75 )

	nextRowY = this:addCenteredHelpText( 12+startTime, 17+startTime, "IF YOU WANT TO SKIP TUTORIAL, WALK AHEAD THRU", 0.75 )
	nextRowY = this:addCenteredHelpText( 12+startTime, 17+startTime, "THE HOLE IN THE FENCE TO GET INTO ACTION", nextRowY )

	nextRowY = this:addCenteredHelpText( 18+startTime, 22+startTime, "OK, LET'S GET STARTED!", 0.75 )

	this.startTime = this.startTime + 23
end

function this.endTexts( this )
	local nextRowY = nil
	local startTime = this.startTime

	nextRowY = this:addCenteredHelpText( 0+startTime, 5+startTime, "IN ORDER TO SURVIVE ", 0.75 )

	nextRowY = this:addCenteredHelpText( 6+startTime, 11+startTime, "MOVE IN DARKNESS TO REMAIN UNSEEN", 0.75 )

	nextRowY = this:addCenteredHelpText( 12+startTime, 17+startTime, "SLOWER MOVEMENT AND SOFT SURFACES MAKE LESS NOISE", 0.75 )

	nextRowY = this:addCenteredHelpText( 18+startTime, 23+startTime, "GOOD LUCK!", 0.75 )

	this.startTime = this.startTime + 24
end


function this.signalCharacterCollision( this, character )
	if ( character == hero and not this.collided ) then
		this.collided = 1

		this.startTime = 0
		this:startTexts()

		if ( controller:hasJoystickControls() ) then
			this:ps2_task1()
			this:ps2_task2()
			this:ps2_task2b()
			this:ps2_task3()
			this:ps2_task4()
			this:ps2_task5()
			this:ps2_task6()
			this:ps2_task7()
			this:ps2_task8()
			this:ps2_task9()
			this:ps2_task10()
			this:ps2_task11()
			this:ps2_task12()
			this:ps2_task13()
			this:ps2_task14()
			this:ps2_task15()
			this:ps2_task16()
		else
			this:mouse_task1()
			this:mouse_task2()
			this:mouse_task3()
			this:mouse_task4()
			this:mouse_task5()
			this:mouse_task6()
			this:mouse_task7()
			this:mouse_task8()
			this:mouse_task9()
			this:mouse_task10()
			this:mouse_task11()
			this:mouse_task12()
			this:mouse_task13()
			this:mouse_task14()
			this:mouse_task15()
			this:mouse_task16()
		end

		this:endTexts()
	end
end

function this.signalProjectileCollision( this, projectile )
end

function this.init( this )
	this.collided = nil
end
