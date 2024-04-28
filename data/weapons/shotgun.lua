--- Helpers --------------------------------------------------------------

function this.triggerRicochet( this )
	local canPlaySound = nil
	if ( this.ricochetCount > 0 ) then
		canPlaySound = 1
		this.ricochetCount = this.ricochetCount - 1
	end
	return canPlaySound
end

function this.triggerBlood( this )
	local canPlaySound = nil
	if ( this.bloodCount > 0 ) then
		canPlaySound = 1
		this.bloodCount = this.bloodCount - 1
	end
	return canPlaySound
end

--- Actions --------------------------------------------------------------

function this.signalFire( this, character )
	-- play sound
	this:playSound( "weapons/shotgun/shotgun_fire_1" )
	-- play nozzle particles
--	this:playParticleSystem( "weapon_effects/shotgun_exitflame", "Dummy_flame" )
	this:playTextureAnimation( "shotgun_flame_seq" )
	this:playParticleSystem( "weapon_effects/shotgun_smoke", "Dummy_flame" )
	-- add noise: <weapon owner>, <noise level>, <fade out distance start>, <fade out distance end>, <fade out time start>, <fade out time end>
	level:createNoise( this:owner(), 100, 0, 30, 0, 0.5 )
	-- play unlock clip sound
	
	-- play shotgun pump push after shot
	local endSoundTime1 = 0.5
	this:addTimerEvent( function(this) this:playSound( "weapons/shotgun/shotgun_push_pump" ) end, endSoundTime1 )
	this.ricochetCount = this.ricochetCount + 1
	this.bloodCount = this.bloodCount + 1
end

function this.signalEmpty( this, character )
	-- play sound
	this:playSound( "weapons/shotgun/shotgun_click" )
end

function this.signalLooseClip( this )

	-- play sequence of sounds:
	-- <timeStart>, <timeStart+timeInterval>, ...
	local timeStart = 1
	local timeEnd = 4
	local timeInterval = 0.4
	local endSoundTime = 4.6
	
	while ( timeStart < timeEnd ) do
		this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
			local weapon = character:weapon()
			if ( character:isReloading() and not character:isDead() ) then
				character:playSound("weapons/shotgun/shotgun_insert_shell")
				if ( weapon:getShellsRemaining() < weapon:getShellsPerClip() ) then
					weapon:setShellsRemaining( character:weapon():getShellsRemaining() + 1 )
				end
			end
			end, timeStart, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )
		timeStart = timeStart + timeInterval
	end

	-- play end sound
	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			character:playSound( "weapons/shotgun/shotgun_push_pump" ) 
		end
		end, endSoundTime, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )
end

function this.init( this )
	this:setMesh( "shotgun/shotgun.sg" )
	this:setDynamicShadow( "shotgun_shadow_volume", 10 )

	this:setName( "shotgun" )					-- String
	this:setFireMode( "SINGLE" )				-- SINGLE or AUTO
	this:setBullet( "shotgun_shot.lua" )			-- Script name
	this:setEmptyShell( "shotgun_shell.lua" )	
	--this:setFireRate( 1 / 0.7333332896232605 )	-- Firings / sec
	this:setFireRate( 1.5 )
	this:setShellEjectDelay( 0.2 )
	this:setShellsPerClip( 10 )					-- Launches / clip
	this:setShellsRemaining( 10 )				-- Launches 
	this:setShotsPerLaunch( 15 )				-- bullets / shot
	this:setSpreadConeAngle( 6.5  )				-- Amount of spread
	this:setRecoilErrorPerShot( 10 )			-- degrees / shot
	this:setRecoilErrorCorrectionPerSec( 6 )	-- degrees / sec
	this:setRecoilErrorMax( 12 )				-- degrees
	this:setRecoilErrorMin( 2 )					-- degrees
	
	this.ricochetCount = 0
	this.bloodCount = 0

	-- addTextureAnimation: 
	-- animation name, target material name, image file name format string, 
	-- first image index, last image index (inclusive), playback frame rate and 
	-- end behaviour type (REPEAT, CONSTANT, OSCILLATE)
	-- NOTE: exit flame target material should be exported with 
	--   1) ADDITIVE transparency set 
	--   2) black frame set as texture
	--   3) 2-sided check box checked
	this:addTextureAnimation( "shotgun_flame_seq", "shotgun_flame", "shotgun/shotgun_flame_f{0,00}.dds", 0, 3, 30, "CONSTANT" )

	this:loadSound( "weapons/shotgun/shotgun_fire_X" )
	this:loadSound( "weapons/shotgun/shotgun_click" )
	this:loadSound( "weapons/shotgun/shotgun_insert_shell" )
	this:loadSound( "weapons/shotgun/shotgun_push_pump" )
	
	this:loadSound( "weapons/generic/ricochet_soft" )
	this:loadSound( "weapons/generic/ricochet_sand" )
	this:loadSound( "weapons/generic/ricochet_stone" )
	this:loadSound( "weapons/generic/ricochet_wood" )
	this:loadSound( "weapons/generic/ricochet_metal" )
end
