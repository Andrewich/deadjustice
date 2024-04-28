function this.signalSkipCutScene( this, cutscene )
	-- cut scene can be skipped after 0.5 seconds
	if ( cutscene:time() > 0.5 ) then

		-- cut scene is still played for 1 second before being skipped
		local skipDelay = 1

		onscreen:addCenteredHelpText( 0, skipDelay, "SKIPPING CUT SCENE", 0.5 )
		this:addTimerEvent( function(this) this:skipCutScene() end, skipDelay )
	end
end

function this.createCutSceneTrigger( this, dummyName, cutSceneName )
	local boxtrigger = this:createBoxTrigger( "triggers/cut_scene_trigger.lua", dummyName )	
	boxtrigger.cutSceneName = cutSceneName
end
