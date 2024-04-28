this:include "util/cut_scene_util.lua"


function this.init( this )
-- INIT:

	-- remove thugs from CELL
	level:removeCharacter( level:getCharacter("Bill Thug") )
	level:removeCharacter( level:getCharacter("Badass Thug") )
	level:removeCharacter( level:getCharacter("Ronald McThug") )
	level:removeCharacter( level:getCharacter("Jack Thug") )
	level:removeCharacter( level:getCharacter("George Thug") )

	-- store hero position
	this.heroPosX = hero:getPosition(0)
	this.heroPosY = hero:getPosition(1)
	this.heroPosZ = hero:getPosition(2)
	this.heroCell = hero:cell()

	-- create NPCs used in this cut scene (remove them later at deinit)
	this.heroine = level:createEnemy( "heroine.lua", "Cut Scene Heroine", "beretta.lua", "PLAYER_START_POINT" )

-- TIMINGS:

	local part1End = this:framesToSeconds(276)
	local part2End = part1End + this:framesToSeconds(117) -- was 118, but scene anim range is [1,118] and 118-1=117
	local part3End = part2End + this:framesToSeconds(117)
	local part4End = part3End + this:framesToSeconds(112) 
	local part5End = part4End + this:framesToSeconds(148) -- Was 149, is 150 ? 
	local part6End = part5End + this:framesToSeconds(549)
	local totalEnd = part6End

-- PARTS:

	this:part1( 0 )			-- CUT 1: Harley enters break room and sees Ginger
	this:part2( part1End )  -- CUT 2: Harley: "I presume you already checked the area"
	this:part3( part2End )  -- CUT 3: Ginger: "Yea..."
	this:part4( part3End )  -- CUT 4: Ginger: "I checked it .. Place is heavily guarded"
	this:part5( part4End )  -- CUT 5: Ginger: "You take the back door..." Camera looks at door to inside of storage
	this:part6( part5End )  -- CUT 6: Panorama of storage, other shots of storage, and final shot showing the exit to the office

-- END:

	-- End cut scene at specified frame
	this:setEnd( totalEnd )

	-- uncomment this line to repeat cut scene until space is pressed
	-- cut scene script lua is reloaded, but anything else isn't
	-- NOTE: THIS WORKS ONLY FOR THE FIRST CUT SCENE SO USE FOR TESTING ONLY
	--level:addTimerEvent( function(this) if (this:isActiveCutScene()) then level:playCutScene("harbor_area_cut_scenes/cutscene2/p1/harbor_area_cut_scene_at_door.sg") end end, this:endTime()-0.1 )
end

-- CUT 1: Harley enters break room and sees Ginger ---------------------------------------------------------------------------------------------
function this.part1( this, startTime )

	-- camera front/back plane distances for part1
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/harbor_area_cut_scene1/p1/harbor_area_cut_scene1_p1.sg" )

	-- Animate Harley
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/harbor_area_cut_scene1/p1/harbor_area_cut_scene1_p1.sg" )

	-- Animate Ginger
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "CELL3", "Bip05", "harbor_area_cut_scenes/harbor_area_cut_scene1/p1/harbor_area_cut_scene1_p1.sg" )
	this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "harbor_area_cut_scenes/harbor_area_cut_scene1/p1/heroine_head_morph_p1.gm" )
	this:hideCharacterWeapon( this:framesToSeconds(0)+startTime, "Cut Scene Heroine" )

	-- Change to Camera01 at frame 0 of CUT 1
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL", "Camera01", this:framesToSeconds(0), "harbor_area_cut_scenes/harbor_area_cut_scene1/p1/harbor_area_cut_scene1_p1.sg" )
	
	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 0.8+startTime, 3.0+startTime, "You are already here?", 1 )
	this:dialogTextBottom( 3.0+startTime, 5+startTime, "How did you get around the guards?", 1 )	
	this:dialogTextBottom( 5.1+startTime, 8+startTime, "What guards?", 1 )
	this:dialogTextBottom( 8.1+startTime, 9+startTime, "<Sigh> ...of course", 1 )
end

-- CUT 2: Harley: "I presume you already checked the area" -------------------------------------------------------------------------------------
function this.part2( this, startTime )

	-- camera front/back plane distances for part2
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/harbor_area_cut_scene1/p2/harbor_area_cut_scene1_p2.sg" )

	-- Animate Harley
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/harbor_area_cut_scene1/p2/harbor_area_cut_scene1_p2.sg" )
	this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Hero", "harbor_area_cut_scenes/harbor_area_cut_scene1/p2/hero_head_morph_p2.gm" )

	-- Animate Ginger
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "CELL3", "Bip05", "harbor_area_cut_scenes/harbor_area_cut_scene1/p2/harbor_area_cut_scene1_p2.sg" )
	this:hideCharacterWeapon( this:framesToSeconds(0)+startTime, "Cut Scene Heroine" )

	-- Change to Camera02 at frame 0 of CUT 2
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL3", "Camera02", this:framesToSeconds(0), "harbor_area_cut_scenes/harbor_area_cut_scene1/p2/harbor_area_cut_scene1_p2.sg" )
	
	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 0+startTime, 2+startTime , "...and... ", 1 )
	this:dialogTextBottom( 2.1+startTime, 4+startTime, "I presume you already checked the area?", 1 )
end

-- CUT 3: Ginger: "Yea..." --------------------------------------------------------------------------------------------------------------------
function this.part3( this, startTime )

	-- camera front/back plane distances for part3
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/harbor_area_cut_scene1/p3/harbor_area_cut_scene1_p3.sg" )

	-- Animate Harley
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/harbor_area_cut_scene1/p3/harbor_area_cut_scene1_p3.sg" )

	-- Animate Ginger
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "CELL3", "Bip05", "harbor_area_cut_scenes/harbor_area_cut_scene1/p3/harbor_area_cut_scene1_p3.sg" )
	this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "harbor_area_cut_scenes/harbor_area_cut_scene1/p3/heroine_head_morph_p3.gm" )
	this:hideCharacterWeapon( this:framesToSeconds(0)+startTime, "Cut Scene Heroine" )

	-- Change to Camera03 at frame 0 of CUT 3
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL3", "Camera03", this:framesToSeconds(0), "harbor_area_cut_scenes/harbor_area_cut_scene1/p3/harbor_area_cut_scene1_p3.sg" )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 0.3+startTime, 3+startTime, "Yea... I did...", 1 )
end

-- CUT 4: Ginger: "I checked it .. Place is heavily guarded" ----------------------------------------------------------------------------------

function this.part4( this, startTime )

	-- camera front/back plane distances for part4
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/harbor_area_cut_scene1/p4/harbor_area_cut_scene1_p4.sg" )

	-- Animate Harley
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Hero", "CELL", "Bip01", "harbor_area_cut_scenes/harbor_area_cut_scene1/p4/harbor_area_cut_scene1_p4.sg" )

	-- Animate Ginger
	this:animateCharacter( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "CELL3", "Bip05", "harbor_area_cut_scenes/harbor_area_cut_scene1/p4/harbor_area_cut_scene1_p4.sg" )
	this:animateCharacterFace( this:framesToSeconds(0)+startTime, "Cut Scene Heroine", "harbor_area_cut_scenes/harbor_area_cut_scene1/p4/heroine_head_morph_p4.gm" )
	this:hideCharacterWeapon( this:framesToSeconds(0)+startTime, "Cut Scene Heroine" )

	-- Change to Camera04 at frame 0 of CUT 4
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL3", "Camera04", this:framesToSeconds(0), "harbor_area_cut_scenes/harbor_area_cut_scene1/p4/harbor_area_cut_scene1_p4.sg" )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 0.2+startTime, 3+startTime, "This place seems to be heavily guarded -", 1 )
end

-- CUT 5: Ginger: "You take the back door..." Camera looks at door to inside of storage -------------------------------------------------------

function this.part5( this, startTime )

	-- camera front/back plane distances for part5
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/harbor_area_cut_scene1/p5/harbor_area_cut_scene1_p5.sg" )

	-- Change to Camera05 at frame 0 of CUT 5
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL3", "Camera05", this:framesToSeconds(0), "harbor_area_cut_scenes/harbor_area_cut_scene1/p5/harbor_area_cut_scene1_p5.sg" )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 0+startTime, 2.4+startTime, "You take the back door...", 1 )
	this:dialogTextBottom( 2.5+startTime, 5+startTime, "I will go around the building", 1 )
end

-- CUT 6: Panorama of storage -----------------------------------------------------------------------------------------------------------------

function this.part6( this, startTime )

	-- camera front/back plane distances for part6
	this:setCameraFrontAndBackPlaneDistances( startTime, 0.1, 200 )

	-- start scene playback
	this:animateScene( startTime, "harbor_area_cut_scenes/harbor_area_cut_scene1/p6/harbor_area_cut_scene1_p6.sg" )

	-- Change to Camera06 at frame 0 of CUT 6
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(0)+startTime, "CELL2", "Camera06", this:framesToSeconds(0), "harbor_area_cut_scenes/harbor_area_cut_scene1/p6/harbor_area_cut_scene1_p6.sg" )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 0.2+startTime, 3.0+startTime, "It's relatively dark in there", 1 )
	this:dialogTextBottom( 3.1+startTime, 5.8+startTime, "If you don't make too much noise...", 1 )
	this:dialogTextBottom( 5.9+startTime, 8+startTime, "...You should be able to sneak by the guards", 1 )

-- CUT 7: Camera films 1st aisle view of storage, guards walking ------------------------------------------------------------------------------

	-- Change to Camera07 at frame 250 of CUT 7
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(250)+startTime, "CELL2", "Camera07", this:framesToSeconds(250), "harbor_area_cut_scenes/harbor_area_cut_scene1/p6/harbor_area_cut_scene1_p6.sg" )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 8.1+startTime, 9.8+startTime, "Many of them are quite heavily armed", 1 )
	this:dialogTextBottom( 9.9+startTime, 10.9+startTime, "...So watch out...", 1 )

-- CUT 8:  Right side aisle view of storage, guards walking -----------------------------------------------------------------------------------

	-- Change to Camera08 at frame 332 of CUT 8
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(332)+startTime, "CELL2", "Camera08", this:framesToSeconds(332), "harbor_area_cut_scenes/harbor_area_cut_scene1/p6/harbor_area_cut_scene1_p6.sg" )
	
	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 11+startTime, 13.9+startTime, "There are less guards on right side of the storage", 1 )

-- CUT 9:  Panorama showing the exit to office ------------------------------------------------------------------------------------------------

	-- Change to Camera09 at frame 421 of CUT 8
	-- (first parameter is cut scene time, third parameter is start time in camera animation)
	this:setCamera( this:framesToSeconds(421)+startTime, "CELL2", "Camera09", this:framesToSeconds(421), "harbor_area_cut_scenes/harbor_area_cut_scene1/p6/harbor_area_cut_scene1_p6.sg" )

	-- bottom dialog text: start time, end time, text string, rows from bottom
	this:dialogTextBottom( 14.0+startTime, 17.1+startTime, "The office is in right end of the storage", 1 )
	this:dialogTextBottom( 17.2+startTime, 19.1+startTime, "...I see you there!", 1 )
end

	

-- -------------------------------------------------------------------------------------------------------------------------------------------

function this.deinit( this )
	-- do cut scene specific cleanup in here

	-- remove any dialogue texts
	onscreen.dialogFont:removeTexts()

	-- remove characters used in this cut scene
	level:removeCharacter( this.heroine )

	-- stop camera animations
	camera:stopAnimation()

	-- reset hero state
	hero:stopWorldSpaceAnimation()
	hero:setPosition( this.heroCell, this.heroPosX, this.heroPosY, this.heroPosZ )
end
