	this:include "util/cut_scene_util.lua"


function this.init( this )
-- INIT:

	-- hide in-game NPCs from CELL (CELL2 and CELL3 are not updated anyway)
	level:getCharacter("Bill Thug"):hide()
	level:getCharacter("Badass Thug"):hide()
	level:getCharacter("Ronald McThug"):hide()
	level:getCharacter("Jack Thug"):hide()
	level:getCharacter("George Thug"):hide()

	-- load dynamic objects used in the cut scene
	this.dynamicObjectList = level:loadDynamicObjects( "harbor_area_cut_scenes/intro/meshes/harbor_area_intro_dynamic_objects.sg" )

	-- hide in-game dynamic objects in level scene
	level:getDynamicObject("DYNAMIC_harleys_van"):hide()
	level:getDynamicObject("DYNAMIC_HD_frame_VISUAL"):hide()

	-- create NPCs used in this cut scene (remove them later at deinit)
	this.enemy1 = level:createEnemy( "thug.lua", "Cut Scene Thug 1", "beretta.lua", "PLAYER_START_POINT" )
	this.enemy2 = level:createEnemy( "thug.lua", "Cut Scene Thug 2", "beretta.lua", "PLAYER_START_POINT" )

	-- enable shadows for dynamic objects (or their shadow dummies)
	-- first parameter of setDynamicShadow is the name of the shadow mesh (dummy or actual)
	--level:getDynamicObject("DYNAMIC_Harleys_van_intro_VISUAL"):setDynamicShadow( "DYNAMIC_Harleys_van_intro_VISUAL", 10 )
	--level:getDynamicObject("DYNAMIC_HD_frame_intro_VISUAL"):setDynamicShadow( "DYNAMIC_HD_frame_intro_VISUAL", 10 )

	-- disable weapon shadows (remember to enable at deinit)
	level:getCharacter("Hero"):disableDynamicShadow()
	level:getCharacter("Hero"):weapon():disableDynamicShadow()
	level:getCharacter("Cut Scene Thug 1"):disableDynamicShadow()
	level:getCharacter("Cut Scene Thug 1"):weapon():disableDynamicShadow()
	level:getCharacter("Cut Scene Thug 2"):disableDynamicShadow()
	level:getCharacter("Cut Scene Thug 2"):weapon():disableDynamicShadow()

-- TIMINGS:

	local part1End = this:framesToSeconds(370)
	local part2End = part1End + this:framesToSeconds(463)
	local part3End = part2End + this:framesToSeconds(234)
	local part4End = part3End + this:framesToSeconds(704)
	local totalEnd = part4End

-- PARTS:

	this:part1( 0 )				-- PART 1: Harley drives van and stops
	this:part2( part1End )		-- PART 2: Harley drives with bike out of the van, attacks thugs and parks motorcycle
	this:part3( part2End )		-- PART 3: Harley revs bike on place
	this:part4( part3End )		-- PART 4: Harley surges towards enemies and starts firing

-- DEBUG: view single part only, comment out previous parts

	--this:part3( 0 )
	--totalEnd = this:framesToSeconds(150)

-- END:

	-- End cut scene at specified frame
	this:setEnd( totalEnd )

	-- uncomment this line to repeat cut scene until space is pressed
	-- cut scene script lua is reloaded, but anything else isn't
	-- NOTE: THIS WORKS ONLY FOR THE FIRST CUT SCENE SO USE FOR TESTING ONLY
	--level:addTimerEvent( function(this) if (this:isActiveCutScene()) then level:playCutScene("harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg") end end, this:endTime()-0.1 )
end

-- PART 1: Harley drives van and stops -------------------------------------------------------------------------------------------------------------
function this.part1( this, startTime )

	-- camera front/back plane distances for part1
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 1, 6, "City harbor area - 3:00am", 1 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg" )

	-- Start playing "DYNAMIC_Harleys_van_intro_VISUAL" animation from scene "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg"
	-- Animation is applied to a dynamic object of the same name ("DYNAMIC_Harleys_van_intro_VISUAL").
	-- Animation playback always starts at frame 0 so start everything you need at the start of the part even
	-- if object doesn't come immediately visible.
	
	this:animateDynamicObject( this:framesToSeconds(0)+startTime, "DYNAMIC_Harleys_van_intro_VISUAL", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg" )
	
	-- Animate hero (Harley) driving the car
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip00", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg" )

	-- Animate hero (Harley) face from morpher. Morpher is head model file (gm) of the hero in animation scene.
	-- Note that character must have morph base defined in character's lua file. Morphs targets are used from the animation scene.
	-- this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Hero", "harbor_area_cut_scenes/intro/animations/hero_head.gm" )

	-- Hide weapon as hero is driving car
	this:hideCharacterWeapon( this:framesToSeconds(0)+startTime, "Hero" )

	-- Light up harley's van front lights
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_van_main_lights", "Van_mainlight_dummy01" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_van_main_lights", "Van_mainlight_dummy02" )

	-- Activate Camera01 at start of first part
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL", "Camera01", this:framesToSeconds(0), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg" )

	this:playSoundAtObject( this:framesToSeconds(0)+startTime, "intro/harley_drives_van", "DYNAMIC_Harleys_van_intro_VISUAL" )

	-- Change to Camera02 at frame 200 of first part
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(200)+startTime, "CELL", "Camera02", this:framesToSeconds(200), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg" )
	
	-- Change to Camera03 at frame 290 of first part
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(290)+startTime, "CELL", "Camera03", this:framesToSeconds(290), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p1.sg" )
end

-- PART 2 BEGINS ---------------------------------------------------------------------------------------
-- PART 2: Harley drives with bike out of the van and drives to crossroads

function this.part2( this, startTime )

	-- camera front/back plane distances for part2
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )

	-- Unhide weapon as hero is driving bike
	this:unhideCharacterWeapon( this:framesToSeconds(374)+startTime, "Hero" )

	-- Start playing "DYNAMIC_HD_frame_intro_VISUAL" animation from scene "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg"
	-- Animation is applied to a dynamic object of the same name ("DYNAMIC_HD_frame_intro_VISUAL").
	this:animateDynamicObject( this:framesToSeconds(0)+startTime, "DYNAMIC_HD_frame_intro_VISUAL", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )

	-- Start playing "DYNAMIC_Harleys_van_intro_VISUAL" animation from scene "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg"
	-- Animation is applied to a dynamic object of the same name ("DYNAMIC_Harleys_van_intro_VISUAL").
	-- Animation playback always starts at frame 0 so start everything you need at the start of the part even
	-- if object doesn't come immediately visible.
	this:animateDynamicObject( this:framesToSeconds(0)+startTime, "DYNAMIC_Harleys_van_intro_VISUAL", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )
	
	-- Animate hero driving the bike and doing other actions on bike
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )

	-- Animate hero (Harley) face from morpher. Morpher is head model file (gm) of the hero in animation scene.
	-- Note that character must have morph base defined in character's lua file. Morphs targets are used from the animation scene.
	-- this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Hero", "harbor_area_cut_scenes/intro/animations/hero_head.gm" )

	-- Light up Harley's bike, signal and main laps
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy01" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy02" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy03" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy04" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_main_light", "HD_mainlight_dummy" )

	-- Activate Camera04 at start (time=frame=0)
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL", "Camera04", this:framesToSeconds(0), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )

	this:playSoundAtObject( this:framesToSeconds(0)+startTime, "intro/harleygos1", "DYNAMIC_HD_frame_intro_VISUAL" )

	-- Change to Camera05 at frame 56
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(56)+startTime, "CELL", "Camera05", this:framesToSeconds(56), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )
	
	-- Change to Camera06 at frame 171
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(171)+startTime, "CELL", "Camera06", this:framesToSeconds(171), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )
	
	this:playSoundAtObject( this:framesToSeconds(171)+startTime, "intro/harleycomes1", "DYNAMIC_HD_frame_intro_VISUAL" )
	
	-- Change to Camera07 at frame 381
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(381)+startTime, "CELL", "Camera07", this:framesToSeconds(381), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p2.sg" )
end

-- PART 3 BEGINS ---------------------------------------------------------------------------------------------------------------------------------------------
function this.part3( this, startTime )

	-- camera front/back plane distances for part3
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg" )

	-- Start playing "DYNAMIC_HD_frame_intro_VISUAL" animation from scene "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg"
	-- Animation is applied to a dynamic object of the same name ("DYNAMIC_HD_frame_intro_VISUAL").
	this:animateDynamicObject( this:framesToSeconds(0)+startTime, "DYNAMIC_HD_frame_intro_VISUAL", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg" )
	
	-- Animate hero driving the bike and doing other actions on bike
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg" )

	-- Animate hero (Harley) face from morpher. Morpher is head model file (gm) of the hero in animation scene.
	-- Note that character must have morph base defined in character's lua file. Morphs targets are used from the animation scene.
	-- this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Hero", "harbor_area_cut_scenes/intro/animations/hero_head.gm" )

	-- Light up Harley's bike, signal and main laps
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy01" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy02" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy03" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy04" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_main_light", "HD_mainlight_dummy" )

	-- Start enemy animations: first thug uses Bip02 from the animation scene, second Bip03
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Thug 1", "CELL", "Bip02", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg" )
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Thug 2", "CELL", "Bip03", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg" )
	
	this:playSoundAtObject( this:framesToSeconds(0)+startTime, "intro/hd_6", "DYNAMIC_HD_frame_intro_VISUAL" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/exhaust_smoke", "Exhaust_dummy" )
	
	-- Change to Camera08 at frame 0
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL", "Camera08", this:framesToSeconds(0), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p3.sg" )
	
	-- Harley's engine starts revving...
	this:playSoundAtObject( this:framesToSeconds(154)+startTime, "intro/Harley_888_open_pipes_sm", "DYNAMIC_HD_frame_intro_VISUAL" ) --was 155
end

-- PART 4 BEGINS ---------------------------------------------------------------------------------------------------------------------------------------------
-- HARLEY STARTS TO FIRE, CHASE VIEW OF HARLEY RIDING BIKE -----------------------------------------------------------------------------------------------

function this.part4( this, startTime )

	-- camera front/back plane distances for part4
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )

	-- Start playing "DYNAMIC_HD_frame_intro_VISUAL" animation from scene "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg"
	-- Animation is applied to a dynamic object of the same name ("DYNAMIC_HD_frame_intro_VISUAL").
	this:animateDynamicObject( this:framesToSeconds(0)+startTime, "DYNAMIC_HD_frame_intro_VISUAL", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	-- Harley's engine starts revving...
	this:playSoundAtObject( this:framesToSeconds(0)+startTime, "intro/Harley_888_open_pipes_sm", "DYNAMIC_HD_frame_intro_VISUAL" )
	
	-- Animate hero driving the bike and doing other actions on bike
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )

	-- Animate hero (Harley) face from morpher. Morpher is head model file (gm) of the hero in animation scene.
	-- Note that character must have morph base defined in character's lua file. Morphs targets are used from the animation scene.
	-- this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Hero", "harbor_area_cut_scenes/intro/animations/hero_head.gm" )

	-- Light up Harley's bike, signal and main laps
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy01" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy02" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy03" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_signal", "HD_signal_dummy04" )
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/flare_motorcycle_main_light", "HD_mainlight_dummy" )

	-- Eject exhaust from pipe...
	this:playParticleSystemAtObject( this:framesToSeconds(0)+startTime, "generic_effects/exhaust_smoke", "Exhaust_dummy" )

	-- Start enemy animations: first thug uses Bip02 from the animation scene, second Bip03
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Thug 1", "CELL", "Bip02", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Thug 2", "CELL", "Bip03", "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	-- Thugs react to approaching Harley -------------------------------------------------------------------------------------------------------------------------------
	-- Change to Camera09 at frame 0
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL", "Camera09", this:framesToSeconds(0), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	this:playSoundAtObject( this:framesToSeconds(25)+startTime, "thug1/surprised_canhear5", "Dummy_bullet_hit_01" )
	
	-- Change to Camera10 at frame 65
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(65)+startTime, "CELL", "Camera10", this:framesToSeconds(65), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(68)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(72)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(76)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(80)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(84)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(88)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(92)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(96)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(100)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(104)+startTime, "Hero" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(115)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(120)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(124)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(128)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(132)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(136)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(140)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(144)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(148)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(152)+startTime, "Hero" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(158)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(162)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(166)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(170)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(174)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(180)+startTime, "Hero" )
	
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(69)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_01" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(73)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_02" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(81)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_03" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(85)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_04" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(89)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_05" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(93)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_06" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(96)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_07" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(100)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_08" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(105)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_09" )
	                                                                 
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(115)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_01" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(120)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_02" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(124)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_03" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(128)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_04" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(132)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_05" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(136)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_06" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(140)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_07" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(144)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_08" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(148)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_09" )
	                                                            
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(158)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_03" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(162)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_04" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(166)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_05" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(170)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_06" )
	                                                              
	---- THUGS OPENS FIRE TOWARD HARLEY FRONT CORNER VIEW ----------------------------------------------------------------------------------------------------
	
	-- Change to Camera11 at frame 185
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(185)+startTime, "CELL", "Camera11", this:framesToSeconds(185), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(185)+startTime, "Cut Scene Thug 1" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(188)+startTime, "Cut Scene Thug 2" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(195)+startTime, "Cut Scene Thug 1" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(210)+startTime, "Cut Scene Thug 2" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(210)+startTime, "Cut Scene Thug 1" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(225)+startTime, "Cut Scene Thug 2" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(220)+startTime, "Cut Scene Thug 1" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(238)+startTime, "Cut Scene Thug 2" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(235)+startTime, "Cut Scene Thug 1" )
	
	---- HARLEY OPENS FIRE TOWARD ENEMIES, FRONT CORNER RAIL VIEW --------------------------------------------------------------------------------------------	
	
	-- Change to Camera12 at frame 241
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(241)+startTime, "CELL", "Camera12", this:framesToSeconds(241), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	-- Hero fires weapon five (5) times towards thugs (visuals only, i.e. sounds, particles and shells, but no bullets)
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(241)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(245)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(251)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(256)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(261)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(267)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(271)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(276)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(281)+startTime, "Hero" )
	
	-- FIRST THUG GETS GUNNED DOWN ----------------------------------------------------------------------------------------------------------------------------
	
	-- Change to Camera13 at frame 287
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(287)+startTime, "CELL", "Camera13", this:framesToSeconds(287), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	-- Harley fires weapon seven (7) times off-screen
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(268)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(273)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(278)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(283)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(288)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(293)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(298)+startTime, "Hero" )

	-- Bullets hit cars, making sparks fly off the metal
	
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(270)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_01" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(275)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_02" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(280)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_03" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(285)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_04" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(290)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_05" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(295)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_06" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(300)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_07" )
	
	-- Thug 1 gets hit by bullets, falls down with blood splats
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(289)+startTime, "generic_effects/blood_splat", "thug1/hit1", "Dummy_bullet_hit_01" )
	this:playParticleSystemAtObject( this:framesToSeconds(289)+startTime, "generic_effects/blood_splat_m16", "Dummy_bullet_hit_01" )
	this:playParticleSystemAtObject( this:framesToSeconds(290)+startTime, "generic_effects/blood_splat_m16_2", "Dummy_bullet_hit_01" )
	
	-- Change to Camera14 at frame 325
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(325)+startTime, "CELL", "Camera14", this:framesToSeconds(325), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(326)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(330)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(334)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(338)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(342)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(346)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(350)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(354)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(358)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(363)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(367)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(370)+startTime, "Hero" )
	
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(327)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_01" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(331)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_02" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(335)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_03" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(338)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_04" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(343)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_05" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(347)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_06" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(351)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_07" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(355)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_08" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(358)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_09" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(364)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_07" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(368)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_06" )
	
	-- SECOND THUG GETS GUNNED DOWN ---------------------------------------------------------------------------------------------------------------------------
	
	-- Change to Camera15 at frame 374
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(374)+startTime, "CELL", "Camera15", this:framesToSeconds(374), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
	
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(375)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(379)+startTime, "Hero" )
	this:fireCharacterWeaponWithoutBullet( this:framesToSeconds(384)+startTime, "Hero" )
	
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(376)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_09" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(380)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_08" )
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(385)+startTime, "weapon_effects/bullet_hit_metal", "weapons/generic/ricochet_metal", "Dummy_bullet_hit_metal_07" )
	
	this:playParticleSystemAndSoundAtObject( this:framesToSeconds(380)+startTime, "generic_effects/blood_splat", "thug1/hit2", "Dummy_bullet_hit_02" )
	this:playParticleSystemAtObject( this:framesToSeconds(380)+startTime, "generic_effects/blood_splat_m16", "Dummy_bullet_hit_02" )
	this:playParticleSystemAtObject( this:framesToSeconds(382)+startTime, "generic_effects/blood_splat_m16_2", "Dummy_bullet_hit_02" )

	-- Change to Camera16 at frame 413
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(413)+startTime, "CELL", "Camera16", this:framesToSeconds(413), "harbor_area_cut_scenes/intro/animations/harbor_area_intro_p4.sg" )
end

function this.deinit( this )
	-- do cut scene specific cleanup in here

	-- enable weapon shadows (remember to enable at deinit)
	level:getCharacter("Hero"):weapon():enableDynamicShadow()
	level:getCharacter("Cut Scene Thug 1"):weapon():enableDynamicShadow()
	level:getCharacter("Cut Scene Thug 2"):weapon():enableDynamicShadow()

	-- remove any dialogue texts
	onscreen.dialogFont:removeTexts()

	-- remove enemies
	level:removeCharacter( this.enemy1 )
	level:removeCharacter( this.enemy2 )

	-- stop camera animations
	camera:stopAnimation()

	-- remove added dynamic objects used in this cut scene
	level:removeDynamicObjects( this.dynamicObjectList )

	-- unhide in-game dynamic objects
	level:getDynamicObject("DYNAMIC_harleys_van"):unhide()
	level:getDynamicObject("DYNAMIC_HD_frame_VISUAL"):unhide()

	-- reset hero state
	hero:weapon():unhide()
	hero:stopWorldSpaceAnimation()
	level:setCharacterTransformToPathStart( hero, "PLAYER_START_POINT" )
	hero:enableDynamicShadow()

	-- unhide in-game NPCs from CELL
	level:getCharacter("Bill Thug"):unhide()
	level:getCharacter("Badass Thug"):unhide()
	level:getCharacter("Ronald McThug"):unhide()
	level:getCharacter("Jack Thug"):unhide()
	level:getCharacter("George Thug"):unhide()
end
