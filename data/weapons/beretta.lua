--- Helpers --------------------------------------------------------------

function this.triggerRicochet( this )
	return 1
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
	this:playSound( "weapons/beretta/beretta_fire_1" )
	-- play nozzle flame particles
--	this:playParticleSystem( "weapon_effects/beretta_exitflame", "Dummy_flame" )
	this:playTextureAnimation( "beretta_flame_seq" )
	this:playParticleSystem( "weapon_effects/beretta_smoke", "Dummy_flame" )
	-- add noise: <weapon owner>, <noise level>, <fade out distance start>, <fade out distance end>, <fade out time start>, <fade out time end>
	level:createNoise( this:owner(), 100, 0, 30, 0, 0.5 )
	this.ricochetCount = this.ricochetCount + 1
	this.bloodCount = this.bloodCount + 1
end

function this.signalEmpty( this, character )
	-- play sound
	this:playSound( "weapons/beretta/beretta_click" )
end

function this.signalLooseClip( this )
	
	local endSoundTime1 = 1.7
	local endSoundTime2 = 2.18
	local endSoundTime3 = 3.16

	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			-- play clip unlocked sound
			character:playSound("weapons/beretta/beretta_unlock_clip") 
		end
		end, endSoundTime1, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )		
		
	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			-- play insert new clip sound
			character:playSound("weapons/beretta/beretta_insert_new_clip") 
		end
		end, endSoundTime2, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )		

	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			-- play pull slide back sound
			character:playSound("weapons/beretta/beretta_pull_back_slide") 
		end
		end, endSoundTime3, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )		

end

function this.init( this )
	this:setMesh( "beretta/beretta.sg" )
	this:setDynamicShadow( "beretta_shadow_volume", 10 )

	this:setName( "beretta" )					-- String
	this:setFireMode( "SINGLE" )
	this:setBullet( "beretta_shot.lua" )		-- Script name
	this:setEmptyShell( "beretta_shell.lua" )	-- Empty Shell script name
	--this:setFireRate( 1 / 0.2999999821186066 )-- Max firings / sec
	this:setFireRate( 5 )						-- Max firings / sec
	this:setShellEjectDelay( 0.05 )				-- Delay from fire till shell eject (sec)
	this:setShellsPerClip( 12 )					-- Launches / clip
	this:setShellsRemaining( 12 )				-- Launches 
	this:setShotsPerLaunch( 1 )					-- bullets / shot
	this:setSpreadConeAngle( 0  )				-- Amount of spread
	this:setRecoilErrorPerShot( 3 )				-- degrees / shot
	this:setRecoilErrorCorrectionPerSec( 7.5 )	-- degrees / sec
	this:setRecoilErrorMax( 10 )				-- degrees
	this:setRecoilErrorMin( 0 )					-- degrees
	
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
	this:addTextureAnimation( "beretta_flame_seq", "beretta_flame", "beretta/beretta_flame_f{0,00}.dds", 0, 5, 60, "CONSTANT" )

	this:loadSound( "weapons/beretta/beretta_fire_X" )
	this:loadSound( "weapons/beretta/beretta_click" )
	this:loadSound( "weapons/beretta/beretta_unlock_clip" )
	this:loadSound( "weapons/beretta/beretta_insert_new_clip" )
	this:loadSound( "weapons/beretta/beretta_pull_back_slide" )
	
	this:loadSound( "weapons/generic/ricochet_soft" )
	this:loadSound( "weapons/generic/ricochet_sand" )
	this:loadSound( "weapons/generic/ricochet_stone" )
	this:loadSound( "weapons/generic/ricochet_wood" )
	this:loadSound( "weapons/generic/ricochet_metal" )
end
