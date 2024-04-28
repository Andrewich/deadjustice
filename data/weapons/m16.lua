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
	this:playSound( "weapons/m16/m16_fire_1" )
	-- play nozzle flame particles
--	this:playParticleSystem( "weapon_effects/m16_exitflame", "Dummy_flame" )
	this:playTextureAnimation( "m16_flame_seq" )
	this:playParticleSystem( "weapon_effects/m16_smoke", "Dummy_flame" )
	-- add noise: <weapon owner>, <noise level>, <fade out distance start>, <fade out distance end>, <fade out time start>, <fade out time end>
	level:createNoise( this:owner(), 100, 0, 30, 0, 0.5 )
	this.ricochetCount = this.ricochetCount + 1
	this.bloodCount = this.bloodCount + 1
end

function this.signalEmpty( this, character )
	-- play sound
	this:playSound( "weapons/m16/m16_click" )
end

function this.signalLooseClip( this )
	
	local endSoundTime1 = 0.2
	local endSoundTime2 = 2.7
	local endSoundTime3 = 3.35

	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			-- play clip unlocked sound
			character:playSound("weapons/m16/m16_unlock_clip") 
		end
		end, endSoundTime1, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )		
		
	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			-- play insert new clip sound
			character:playSound("weapons/m16/m16_insert_new_clip") 
		end
		end, endSoundTime2, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )		

	this:owner():addSecondaryStateListener( "CHANGING_CLIP", function(character) 
		if ( character:isReloading() and not character:isDead() ) then
			-- play pull slide back sound
			character:playSound("weapons/m16/m16_pull_reload") 
		end
		end, endSoundTime3, this:owner().STATE_ENTRY+this:owner().STATE_REMOVE )		
end

function this.init( this )

	this:setMesh( "m16/m16.sg" )
	this:setDynamicShadow( "m16_shadow_volume", 10 )

	this:setName( "m16" )						-- String
	this:setBullet( "m16_shot.lua" )			-- Projectile Script name
	this:setFireMode( "AUTO" )
	this:setEmptyShell( "m16_shell.lua" )		-- Empty Shell script name
	this:setFireRate( 2 / 0.2666666507720947 )	-- Firings / sec (NOTE : Doubled rate)
	this:setShellEjectDelay( 0.05 )				-- Delay from fire till shell eject (sec)
	this:setShellsPerClip( 25 )					-- Launches / clip
	this:setShellsRemaining( 25 )				-- Launches 
	this:setShotsPerLaunch( 1 )					-- bullets / shot
	this:setSpreadConeAngle( 1 )				-- Amount of spread
	this:setRecoilErrorPerShot( 0.75 )			-- degrees / shot
	this:setRecoilErrorCorrectionPerSec( 5 )	-- degrees / sec
	this:setRecoilErrorMax( 7 )					-- degrees
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
	this:addTextureAnimation( "m16_flame_seq", "m16_flame", "m16/m16_flame_f{0,00}.dds", 0, 3, 30, "CONSTANT" )

	this:loadSound( "weapons/m16/m16_fire_X" )
	this:loadSound( "weapons/m16/m16_click" )
	this:loadSound( "weapons/m16/m16_insert_new_clip" )
	this:loadSound( "weapons/m16/m16_unlock_clip" )
	this:loadSound( "weapons/m16/m16_pull_reload" )
	
	this:loadSound( "weapons/generic/ricochet_soft" )
	this:loadSound( "weapons/generic/ricochet_sand" )
	this:loadSound( "weapons/generic/ricochet_stone" )
	this:loadSound( "weapons/generic/ricochet_wood" )
	this:loadSound( "weapons/generic/ricochet_metal" )
end
