this:include( "util/enemy.lua" )
this:include( "util/breakable_object.lua" )
this:include( "util/level_util.lua" )
this:include( "boolean.lua" )


function this.init ( this )
	level = this

	-- collision material types used in this level, 
	-- the first one is default if TYPE= tag is missing from a material
	this.collisionMaterialTypes = 
	{ 
		-- 1. softest
		{typeName="SOFT", runningNoiseLevel=0.3, walkingNoiseLevel=0.2, sneakingNoiseLevel=0.1, movementNoiseDistance=10},
		-- 2.
		{typeName="SAND", runningNoiseLevel=0.5, walkingNoiseLevel=0.4, sneakingNoiseLevel=0.3, movementNoiseDistance=10},
		-- 3.
		{typeName="STONE", runningNoiseLevel=0.7, walkingNoiseLevel=0.6, sneakingNoiseLevel=0.5, movementNoiseDistance=10},
		-- 4.
		{typeName="WOOD", runningNoiseLevel=0.9, walkingNoiseLevel=0.8, sneakingNoiseLevel=0.7, movementNoiseDistance=10},		
		-- 5. hardest
		{typeName="METAL", runningNoiseLevel=1.1, walkingNoiseLevel=1.0, sneakingNoiseLevel=0.9, movementNoiseDistance=10},
	}

	trace( "Importing harbor area" )
	this:importGeometry( "harbor_area/harbor_area.sg", this.collisionMaterialTypes )

--  Intialize sounds
	
	this:loadSound( "environment/ambient_1" )

--  Insert sounds to environment

	local thecell = this:getCell( "CELL" )
	thecell:playSound( "environment/ambient_1", "G1" )

-- Create flares ----------------------------------------------------------------------------------------------------------------------

	-- Use level:createFlareSet( <image name>, <diameter in world space>, <fade time>, <max flare count>, <cell name> ) 
	-- function to create flare container. Flare container holds a single image and 
	-- container can only be in a single room. Flare container has function addFlare 
	-- which accepts game object and flare parent object name as parameters.
	-- See below for usage examples.

	-- time to fade flare in after it becomes visible
	local flareFadeTime = 0.2

	-- Street lamps

	local firstFlare = 0
	local lastFlare = 115
	local flareDiameter = 7
	local cellName = "CELL"
	local flareSet = this:createFlareSet( "generic_effects/flare_lightpost.dds", flareDiameter, flareFadeTime, (lastFlare-firstFlare+1), cellName )
	while ( firstFlare <= lastFlare ) do
		flareSet:addFlare( this:getCell(cellName), string.format("Dummy_lightpost_flare%02i",firstFlare) )
		firstFlare = firstFlare + 1
	end

	-- Storage lamps

	local firstFlare = 0
	local lastFlare = 38
	local flareDiameter = 7
	local cellName = "CELL2";
	local flareSet = this:createFlareSet( "generic_effects/flare_lightpost.dds", flareDiameter, flareFadeTime, (lastFlare-firstFlare+1), cellName )
	while ( firstFlare <= lastFlare ) do
		flareSet:addFlare( this:getCell(cellName), string.format("Dummy_storage_flare%02i",firstFlare) )
		firstFlare = firstFlare + 1
	end

	-- Break room flares
	
	local flareDiameter = 2
	local cellName = "CELL3"
	local maxFlares = 5
	local flareSet = this:createFlareSet( "generic_effects/flare_lightpost.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_storage_flare39" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_storage_flare40" )
	
	-- Sign LIQUOR flars
	
	local flareDiameter = 3
	local cellName = "CELL"
	local maxFlares = 2
	local flareSet = this:createFlareSet( "generic_effects/flare_liquor.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_liquor_flare_01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_liquor_flare_02" )
	
	-- Sign Tom's liquor and deli flares
	
	local flareDiameter = 3
	local cellName = "CELL"
	local maxFlares = 2
	local flareSet = this:createFlareSet( "generic_effects/flare_deli.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_deli_flare01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_deli_flare02" )
	
	-- Sign PIZZA flares
	
	local flareDiameter = 2
	local cellName = "CELL"
	local maxFlares = 2
	local flareSet = this:createFlareSet( "generic_effects/flare_gunshop.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_pizza_flare01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_pizza_flare02" )
	
	-- Sign Gun Shop flares
	
	local flareDiameter = 8
	local cellName = "CELL"
	local maxFlares = 8
	local flareSet = this:createFlareSet( "generic_effects/flare_gunshop.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_gunshop_flare01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_gunshop_flare02" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_gunshop_flare03" )

	-- Sign Don's pizza flares
	
	local flareDiameter = 4
	local cellName = "CELL"
	local maxFlares = 3
	local flareSet = this:createFlareSet( "generic_effects/flare_dons.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_dons_flare01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_dons_flare02" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_dons_flare03" )
	
	-- Sign Bailbonds
	
	local flareDiameter = 2
	local cellName = "CELL"
	local maxFlares = 1
	local flareSet = this:createFlareSet( "generic_effects/flare_bailbond.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_bailbond_flare01" )

	-- Sign We buy cars
	
	local flareDiameter = 3
	local cellName = "CELL"
	local maxFlares = 2
	local flareSet = this:createFlareSet( "generic_effects/flare_gunshop.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_webuycars_flare01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_webuycars_flare02" )

	-- Sign EBM
	
	local flareDiameter = 2
	local cellName = "CELL"
	local maxFlares = 2
	local flareSet = this:createFlareSet( "generic_effects/flare_bailbond.dds", flareDiameter, flareFadeTime, maxFlares, cellName )
	flareSet:addFlare( this:getCell(cellName), "Dummy_ebm_flare01" )
	flareSet:addFlare( this:getCell(cellName), "Dummy_ebm_flare02" )


-- Create particle systems ----------------------------------------------------------------------------------------------------------------------

	-- Break room cigarette smoke
	
	this:getCell("CELL3"):playParticleSystem( "Generic_effects/tobacco_smoke", "Dummy_tobacco" )

	-- Barrel on Fire

	this:getCell("CELL"):playParticleSystem( "Generic_effects/flame_sequence", "Dummy_barrel_fire" )
	this:getCell("CELL"):playParticleSystem( "Generic_effects/flame_glow_sequence", "Dummy_barrel_fire" )

	-- Moon glow

	this:getCell("CELL"):playParticleSystem( "Generic_effects/flare_moon", "Dummy_moon" )

-- Head turning sequences

	local headTurningLeftRight = this:createHeadTurningSequence()
	-- addView( <time>, <horzAngle>, <vertAngle>, <angleSpeed> )
	headTurningLeftRight:addView( 0, -60, 0, 30 )
	headTurningLeftRight:addView( 3, 60, 0, 30 )
	headTurningLeftRight:addView( 6, 0, 0, 30 )
	-- take 10-15 second break before repeating the cycle
	-- REPEAT end behaviour doesn't use last key value, only time matters 
	headTurningLeftRight:addView( 6+this:getRandomInteger(10,15), 0, 0, 0 )
	headTurningLeftRight:setEndBehaviour( "REPEAT" )

	local headTurningLeftRightFast = this:createHeadTurningSequence()
	headTurningLeftRightFast:addView( 0, -60, 0, 40 )
	headTurningLeftRightFast:addView( 3, 60, 0, 40 )
	headTurningLeftRightFast:addView( 6, 0, 0, 40 )
	-- take 2-3 second break before repeating the cycle
	headTurningLeftRight:addView( 6+this:getRandomInteger(2,3), 0, 0, 0 )
	headTurningLeftRightFast:setEndBehaviour( "REPEAT" )

-- Fight sequences
	
	-- Parameters of all "add" functions start with "Start Time" & "End Time", the rest are specific
	-- See deadjustice.txt "Fight Sequences" for function specific documentation. 
	-- Use Move & turn functions to set destination points, you don't need to wait until they are complete.
	-- REMEMBER : time span of an event must be more than or equal to state's update interval
	-- TODO : Code should check intervals and print warnings if too frequent 

	local shortAttackBurst1 = this:createFightSequence()
	shortAttackBurst1:addFaceEnemy(0, 0.5)					-- look at enemy 
	shortAttackBurst1:addShootOnce(0.5, 1)					-- Shoot (shoot takes abt 0.25 secs to start, hold this state until ready to shoot)

	local shortAttackBurst2 = this:createFightSequence()
	shortAttackBurst2:addFaceEnemy(0, 0.4)					-- Look at enemy
	shortAttackBurst2:addShootOnce(0.4, 0.7)				-- Shoot
	shortAttackBurst2:addMoveCloser(1.1, 1.2, 3, 2)			-- Set movement target 3 meters closer to enemy
	shortAttackBurst2:addShootOnce(1.0, 1.3)				-- Shoot at 1 secs
	shortAttackBurst2:addFaceEnemy(1.3, 2.0)				-- Look at enemy
	shortAttackBurst2:addShootOnce(2.0, 2.3)				-- Shoot at 2 secs

	local shortAttackLeftStrafe = this:createFightSequence()
	shortAttackLeftStrafe:addFaceEnemy( 0.0, 0.4 )
	shortAttackLeftStrafe:addCrouch( 0.4, 0.5, false )
	shortAttackLeftStrafe:addMove( 0.5, 0.6, -3.5, 0, 0 )
	shortAttackLeftStrafe:addShootOnce( 0.6, 1.1 )
	shortAttackLeftStrafe:addFaceEnemy( 1, 1.4 )
	shortAttackLeftStrafe:addShootOnce( 1.4, 1.7 )
	shortAttackLeftStrafe:addFaceEnemy( 1.75, 2.25 )
	shortAttackLeftStrafe:addShootOnce( 2.5, 2.8 )

	local shortAttackRightStrafe = this:createFightSequence()
	shortAttackRightStrafe:addFaceEnemy( 0.0, 0.5 )
	shortAttackRightStrafe:addShoot( 0.5, 0.6, true)
	shortAttackRightStrafe:addCrouch( 0.6, 0.7, false )
	shortAttackRightStrafe:addMove( 0.7, 0.8, 3.5, 0, 0 )
	shortAttackRightStrafe:addFaceEnemy( 1, 2 )
	shortAttackRightStrafe:addShoot( 2.5, 2.6, false )

	local evadeBackLeft = this:createFightSequence()
	evadeBackLeft:addMove( 0.0, 0.1, -5, 0, -6 )
	evadeBackLeft:addTurnToMove( 0.2, 2.5 )
	evadeBackLeft:addFaceEnemy( 2.5, 3.0 )

	local billsHideOut1 = this:createFightSequence()
	billsHideOut1:addShoot(0, 0.1, false )
	billsHideOut1:addMoveAbsoluteIfNotHeroClose( 0.1, 0.2, 45, 0, 151, 15 )
	billsHideOut1:addTurnToMove( 0.1, 6 )
	billsHideOut1:addFaceEnemy( 6.1, 6.4)

	local billsHideOut2 = this:createFightSequence()
	billsHideOut2:addShoot(0, 0.1, false )
	billsHideOut2:addMoveAbsoluteIfNotHeroClose( 0.1, 0.2, 28, 0, 152, 10 )
	billsHideOut2:addTurnToMove( 0.2, 6 )
	billsHideOut2:addFaceEnemy( 6, 6.2)

	local shoot3secs = this:createFightSequence()
	shoot3secs:addFaceEnemy(0, 0.8)
	shoot3secs:addShoot(0.8, 0.9, true)
	shoot3secs:addShoot(3.8, 3.9, false)

	local shootOnce = this:createFightSequence()
	shootOnce:addFaceEnemy(0, 1)
	shootOnce:addShootOnce(1, 1)

	local wait2secs = this:createFightSequence()
	wait2secs:addWait(0, 2)

	local crouch = this:createFightSequence()
	crouch:addCrouch(0, 0.1, true)

	local uncrouch = this:createFightSequence()
	uncrouch:addCrouch(0, 0.1, false)

	local baddiesHideOut1 = this:createFightSequence()
	baddiesHideOut1:addShoot(0, 0.1, false )
	baddiesHideOut1:addMoveAbsoluteIfNotHeroClose(0.1, 0.3, 56, 0, 149, 20 )
	baddiesHideOut1:addCrouch(0.3, 0.4, false )
	baddiesHideOut1:addTurnToMove(0.4, 4)
	baddiesHideOut1:addFaceEnemy(6.1, 6.5)

	local baddiesHideOut2 = this:createFightSequence()
	baddiesHideOut2:addCrouch(0.0, 0.1, false )
	baddiesHideOut2:addMoveAbsoluteIfNotHeroClose(0.1, 0.2, 53, 0, 158, 20 )
	baddiesHideOut2:addTurnToMove(0.2, 3)
	baddiesHideOut2:addFaceEnemy(7.1, 7.5)

	local doorGuardSeq = this:createFightSequence()
	doorGuardSeq:addFaceEnemy(0, 0.1)
	doorGuardSeq:addShootOnce(0.1, 0.4)
	doorGuardSeq:addMoveAbsolute(0.4, 2.2, 96.5, 0, 174 )
	doorGuardSeq:addFaceEnemy(2.2, 2.5)
	doorGuardSeq:addMoveAbsolute(2.5, 3.5, 98.5, 0, 171.5 )
	doorGuardSeq:addShoot(3.5, 6.5, true)

	local doorGuardEvade = this:createFightSequence()
	doorGuardEvade:addMoveAbsolute(0.1, 1.5, 97.5, 0, 174 )	

	local sniperAttack = this:createFightSequence()
	sniperAttack:addFaceEnemy(0, 0.4)
	sniperAttack:addCrouch(0.4, 0.5, false)
	sniperAttack:addWait(0.5, 0.6)
	sniperAttack:addShootOnce(0.6, 1.2)

	local sniperCrouch = this:createFightSequence()
	sniperCrouch:addFaceEnemy(0, 0.5)
	sniperCrouch:addShootOnce(0.5, 0.8)
	sniperCrouch:addCrouch(0.8, 0.9, true)
	sniperCrouch:addWait(0.9, 3.0)

	local runAwayBoy1 = this:createFightSequence()
	runAwayBoy1:addMoveAbsolute(0, 0.1, 94, 0, 178)
	runAwayBoy1:addTurnToMove(0.1, 2.0)
	runAwayBoy1:addMoveAbsolute(2.0, 5, 98, 0, 281)
	--runAwayBoy1:addTurnToMove(5, 50)
	runAwayBoy1:addFaceEnemy(5, 5.2)

	local runAwayBoy2 = this:createFightSequence()
	runAwayBoy2:addMoveAbsolute(0, 0.1, 110, 0, 284)
	runAwayBoy2:addTurnToMove(0.2, 50)

	local shootAndBackUp = this:createFightSequence()
	shootAndBackUp:addFaceEnemy(0, 0.5)
	shootAndBackUp:addShoot(0.5, 0.6, true)
	shootAndBackUp:addMoveFurther(0.6, 1.5, 10, 20)
	shootAndBackUp:addShoot(1.5, 1.6, false)

    local defenderAttack = this:createFightSequence()
    defenderAttack:addMoveCloser(0.1, 1.0, 4, 2)
	defenderAttack:addFaceEnemy(1.0, 1.3)
	defenderAttack:addShoot( 1.3, 2.5, false )

	local evade = this:createFightSequence()
	evade:addEvade(0, 0.1, 3)
	evade:addFaceEnemy(0.2, 1.8)

	local evadeRun = this:createFightSequence()
	evadeRun:addEvade(0, 0.1, 20)
	evadeRun:addTurnToMove(0.1, 1.5)
	evadeRun:addFaceEnemy(4, 5)

	local wait1sec = this:createFightSequence()
	wait1sec:addWait(0, 1)

	local shoot = this:createFightSequence()
	shoot:addShootAuto(0, 1.5, 1.4)

-- Create Enemies -------------------------------------------------------------------------------------------------------

-- Thug walking around the sand pile ------------------------------------------------------------------------------------
	thug8 = this:createEnemy( "thug.lua", "Bill Thug", "beretta.lua", "PATH_Line08" )
	thug8:getComputerControl().stupidity = 0.5
	thug8:getComputerControl().aggressiveness = 0.8
	thug8:getComputerControl().healthLowThreshold = 45
	thug8:getComputerControl().chicken = 0.5
	thug8:getComputerControl():setShootDelay( 0.5 )
-- Bill Thug hears the player if player walks or runs behind Bill (Bill is walking mainly on STONE)
	-- Hearing and vision tresholds ------------------------------------------------
	thug8:getComputerControl().hearingLimit = 0.25
	thug8:getComputerControl().visionLimit = 0.15
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug8:addPatrolState( "PATH_Line08", headTurningLeftRightFast )
	-- Define idling + idle mumbling -----------------------------------------------
	-- playRandomIdleSounds: min interval, max interval (20-25 secs),
	-- calls character:playIdleSound to play actual sound effect
	patrolState:playRandomIdleSounds( 20, 25 )
	local alertState = thug8:addAlertState( 1.0, headTurningLeftRightFast )
	alertState.evadeEnabled = true
	alertState.enemyCloseThreshold = 20
	local fightState = thug8:addFightState()
	fightState:addAttackSequence( shortAttackBurst1 )
	fightState:addAttackSequence( shortAttackBurst2 )
	fightState:addAttackSequence( shoot3secs )
	fightState:addAttackSequence( shortAttackLeftStrafe )
	fightState:addEvadeSequence( evadeBackLeft )
	fightState:addEvadeSequence( billsHideOut1 )
	--fightState:addRetreatSequence( billsHideOut2 )
	
-- Thug guarding the Fence near storage entrance -------------------------------------------------------------------------
	thug10 = this:createEnemy( "thug.lua", "Badass Thug", "beretta.lua", "thug_Dummy01" )
	thug10:getComputerControl().stupidity = 0.2
	thug10:getComputerControl().aggressiveness = 0.8
	thug10:getComputerControl().healthLowThreshold = 30
	thug10:getComputerControl().chicken = 0.75
	thug10:getComputerControl():setShootDelay( 0.3 )
	-- Hearing and vision tresholds ------------------------------------------------
	thug10:getComputerControl().hearingLimit = 0.25
	thug10:getComputerControl().visionLimit = 0.15
	-- Define idling + idle mumbling -----------------------------------------------
	local idleState = thug10:addIdleState( "hero_idle_stand" )
	idleState:playRandomIdleSounds( 60, 65 )
	-- Define fighting behavior ----------------------------------------------------
	local alertState = thug10:addAlertState( 1.0 )
	local fightState = thug10:addFightState()
	fightState:addAttackSequence( shoot3secs )
	fightState:addAttackSequence( wait1sec )
	fightState:addEvadeSequence( crouch )
	fightState:addEvadeSequence( uncrouch )
	fightState:addEvadeSequence( baddiesHideOut1 )
	fightState:addEvadeSequence( evade )
	fightState:addRetreatSequence( baddiesHideOut2 )

-- Idling Thug -------------------------------------------------------------------------------------------------------------
	thug11 = this:createEnemy( "thug.lua", "Ronald McThug", "beretta.lua", "thug_Dummy02" )
	thug11:getComputerControl().stupidity = 0.5
	thug11:getComputerControl().aggressiveness = 0.8
	thug11:getComputerControl().chicken = 0
	thug11:getComputerControl():setShootDelay( 0.3 )
	-- Hearing and vision tresholds ------------------------------------------------
	thug11:getComputerControl().hearingLimit = 0.45
	thug11:getComputerControl().visionLimit = 0.15
	-- Define idling + idle mumbling -----------------------------------------------
	local idleState = thug11:addIdleState( "hero_idle_turn" )
	idleState:playRandomIdleSounds( 40, 45 )
	-- Define fighting behavior ----------------------------------------------------
	local alertState = thug11:addAlertState( 1.0, headTurningLeftRightFast )
	local fightState = thug11:addFightState()
	alertState.evadeEnabled = true
	alertState.enemyCloseThreshold = 40
	fightState:addAttackSequence( shortAttackBurst2 )
	fightState:addAttackSequence( shoot3secs )
	fightState:addEvadeSequence( evadeRun )

-- Door guard thug (hiding in corner) --------------------------------------------------------------------------------------
	thug12 = this:createEnemy( "thug.lua", "George Thug", "shotgun.lua", "thug_Dummy03" )
	thug12:getComputerControl().stupidity = 0.2
	thug12:getComputerControl().aggressiveness = 0.8
	thug12:getComputerControl().healthLowThreshold = 33
	thug12:getComputerControl().chicken = 0.2
	thug12:getComputerControl():setShootDelay( 0.2 )
	-- Hearing and vision tresholds ------------------------------------------------
	thug12:getComputerControl().hearingLimit = 0.45
	thug12:getComputerControl().visionLimit = 0.05
	-- Define idling + idle mumbling -----------------------------------------------
	local idleState = thug12:addIdleState( "hero_idle_stand" )
	idleState:playRandomIdleSounds( 120, 125 )
	-- Define fighting behavior ----------------------------------------------------
	local alertState = thug12:addAlertState( 1.0, headTurningLeftRightFast )
	alertState.evadeEnabled = false
	alertState.enemyCloseThreshold = 20
	local fightState = thug12:addFightState()
	fightState:addAttackSequence( doorGuardSeq )
	fightState:addAttackSequence( shoot3secs )
	fightState:addEvadeSequence( crouch )
	fightState:addEvadeSequence( evade )

-- Thug on the roof --------------------------------------------------------------------------------------------------------
	thug9 = this:createEnemy( "thug.lua", "Jack Thug", "m16.lua", "thug_Dummy04" )
	-- Disable Jack Thug's shadow volume -----------------------------------------------------------------------------------
	thug9:disableDynamicShadow()
	thug9:weapon():disableDynamicShadow()
	thug9:getComputerControl().visionFarAttenStart = 40
	thug9:getComputerControl().visionFarAttenEnd = 55
	thug9:getComputerControl().stupidity = 0.2
	thug9:getComputerControl().aggressiveness = 0.5
	thug9:getComputerControl().healthLowThreshold = 0
	thug9:getComputerControl().chicken = 0
	thug9:getComputerControl():setShootDelay( 0.2 )
	thug9:getComputerControl():setAimInaccuracy( 2 ) -- some error would be nice since he's shooting quite often
	-- Hearing and vision tresholds ------------------------------------------------
	thug9:getComputerControl().hearingLimit = 0.45
	thug9:getComputerControl().visionLimit = 0.15
	-- Define fighting behavior ----------------------------------------------------
	local idleState = thug9:addIdleState( "hero_idle_stand" )
	idleState:playRandomIdleSounds( 80, 85 )
	local alertState = thug9:addAlertState( 1.0)
	alertState.turningAroundEnabled = false
	local fightState = thug9:addFightState()	
	alertState.evadeEnabled = false
	alertState.enemyCloseThreshold = 0
	fightState:addAttackSequence( sniperAttack )
	fightState:addAttackSequence( sniperCrouch )
	fightState:addEvadeSequence( wait1sec )
	fightState:addEvadeSequence( crouch )

-- Thug next to the door, near 1st forklifter, walking small ring ----------------------------------------------------------
-- 1st patrol guard
	thug3 = this:createEnemy( "thug.lua", "Tim Thug", "shotgun.lua", "PATH_Line03" )
	thug3:getComputerControl().stupidity = 0.3
	thug3:getComputerControl().aggressiveness = 0.7
	thug3:getComputerControl().healthLowThreshold = 15
	thug3:getComputerControl().chicken = 0.1
	thug3:getComputerControl():setShootDelay( 0.3 )
-- Tim Thug hears the player if player walks or runs behind Tim (Tim is walking mainly on concrete (STONE) )
	-- Hearing and vision tresholds ------------------------------------------------
	thug3:getComputerControl().hearingLimit = 0.45
	thug3:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug3:addPatrolState( "PATH_Line03", headTurningLeftRight )
	patrolState:playRandomIdleSounds( 40, 45 )
	local alertState = thug3:addAlertState( 1.0, headTurningLeftRightFast )
	--alertState.evadeEnabled = true
	local fightState = thug3:addFightState()
	fightState:addAttackSequence( shortAttackLeftStrafe )
	fightState:addAttackSequence( wait1sec )
	fightState:addAttackSequence( defenderAttack )
	fightState:addAttackSequence( shoot3secs )
	fightState:addEvadeSequence( evadeRun )

-- 3rd patrol guard, patrolling in SE corner of storage building ---------------------------------------------------------
	thug6 = this:createEnemy( "thug.lua", "Bert 'Patrol Man' Thug", "beretta.lua", "PATH_Line06" )
	thug6:getComputerControl().stupidity = 0.25
	thug6:getComputerControl().aggressiveness = 0.5
	thug6:getComputerControl().healthLowThreshold = 15
	thug6:getComputerControl().chicken = 0.2
	thug6:getComputerControl():setShootDelay( 0.3 )
-- Bert 'Patrol Man' Thug hears the player if player walks or runs behind Bert (Bert is walking mainly on concrete (STONE) )
	-- Hearing and vision tresholds ------------------------------------------------
	thug6:getComputerControl().hearingLimit = 0.58
	thug6:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug6:addPatrolState( "PATH_Line06", headTurningLeftRight )
	patrolState:playRandomIdleSounds( 70, 75 )
	local alertState = thug6:addAlertState( 1.0 )
	local fightState = thug6:addFightState()
	fightState:addAttackSequence( shootAndBackUp )
	fightState:addAttackSequence( crouch )
	fightState:addAttackSequence( uncrouch )
	fightState:addAttackSequence( shootOnce )
	fightState:addEvadeSequence( evade )
	local retreat = this:createFightSequence()
	retreat:addMoveAbsolute(0, 15, 137, 0, 182)
	fightState:addRetreatSequence( retreat )

-- Another runaway boy ( just to act as bait for the exit guard's M16 ) -------------------------------------------------
	thug4 = this:createEnemy( "thug.lua", "Sam Thug", "shotgun.lua", "PATH_Line04" )
	thug4:getComputerControl().stupidity = 0.4
	thug4:getComputerControl().aggressiveness = 0.7
	thug4:getComputerControl().healthLowThreshold = 30
	thug4:getComputerControl().chicken = 0.2
	thug4:getComputerControl():setShootDelay( 0.3 )
	-- Hearing and vision tresholds ------------------------------------------------
	thug4:getComputerControl().hearingLimit = 0.58
	thug4:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug4:addPatrolState( "PATH_Line04", headTurningLeftRight )
	patrolState:playRandomIdleSounds( 20, 25 )
	local alertState = thug4:addAlertState( 1.0 )
	local fightState = thug4:addFightState()
	fightState:addAttackSequence( shootOnce )
	fightState:addAttackSequence( shortAttackLeftStrafe )
	fightState:addAttackSequence( wait1sec )
	fightState:addAttackSequence( shortAttackRightStrafe )
	fightState:addAttackSequence( shoot )
	fightState:addEvadeSequence( evade )
	fightState:addEvadeSequence( evadeRun )
	fightState:addRetreatSequence( runAwayBoy2 )

-- 2nd patrol guard --------------------------------------------------------------------------------------------------------
	thug5 = this:createEnemy( "thug.lua", "Shooter Thug", "shotgun.lua", "PATH_Line05" )
	thug5:getComputerControl().stupidity = 0.5
	thug5:getComputerControl().aggressiveness = 1.0
	thug5:getComputerControl().healthLowThreshold = 10
	thug5:getComputerControl().chicken = 0.0
	thug5:getComputerControl():setShootDelay( 0.3 )
-- Shooter Thug hears the player if player walks or runs behind Shooter thug (...is walking mainly on concrete (STONE) ) -----------
	-- Hearing and vision tresholds ------------------------------------------------
	thug5:getComputerControl().hearingLimit = 0.58
	thug5:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug5:addPatrolState( "PATH_Line05", headTurningLeftRight )
	local alertState = thug5:addAlertState( 1.0 )
	local fightState = thug5:addFightState()
	fightState:addAttackSequence( shortAttackLeftStrafe )
	fightState:addAttackSequence( wait1sec )
	fightState:addAttackSequence( shortAttackRightStrafe )
	fightState:addEvadeSequence( evade )
	fightState:addEvadeSequence( evadeRun )
	
-- 5th patrol guard in the storage building, near the end, patrolling the end area ----------------------------------------

	thug2 = this:createEnemy( "thug.lua", "Joe Thug", "shotgun.lua", "PATH_Line02" )
	thug2:getComputerControl().stupidity = 0.5
	thug2:getComputerControl().aggressiveness = 1.0
	thug2:getComputerControl().healthLowThreshold = 0
	thug2:getComputerControl().chicken = 0.0
	thug2:getComputerControl():setShootDelay( 0.3 )
-- Joe Thug Thug hears the player if player walks or runs behind Joe (Joe is walking mainly on concrete (STONE) )
	-- Hearing and vision tresholds ------------------------------------------------
	thug2:getComputerControl().hearingLimit = 0.58
	thug2:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug2:addPatrolState( "PATH_Line02", headTurningLeftRight )
	patrolState:playRandomIdleSounds( 40, 45 )
	local alertState = thug2:addAlertState( 1.0 )
	local fightState = thug2:addFightState()
	fightState:addAttackSequence( shortAttackBurst2 )

-- 4th patrol guard, patrolling in E side aisle of storage ---------------------------------------------------------------------
	thug7 = this:createEnemy( "thug.lua", "Hart 'Highway Patrol' Thug", "beretta.lua", "PATH_Line07" )
	thug7:getComputerControl().stupidity = 0.5
	thug7:getComputerControl().aggressiveness = 1.0
	thug7:getComputerControl().healthLowThreshold = 10
	thug7:getComputerControl().chicken = 0.0
	thug7:getComputerControl():setShootDelay( 0.3 )
-- Hart 'Highway Patrol' Thug hears the player if player even sneaks too close to Hart - Hart cannot be taken by surprise (Hart is walking STONE)
	-- Hearing and vision tresholds ------------------------------------------------
	thug7:getComputerControl().hearingLimit = 0.45
	thug7:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug7:addPatrolState( "PATH_Line07", headTurningLeftRight )
	patrolState:playRandomIdleSounds( 30, 35 )
	local alertState = thug7:addAlertState( 1.0 )
	local fightState = thug7:addFightState()

-- This thug guards the exit platform, equiped with m16 ------------------------------------------------------------------------

	thug1 = this:createEnemy( "thug.lua", "Exit Guard Thug", "m16.lua", "PATH_Line01" )
	thug1:getComputerControl().stupidity = 0.5
	thug1:getComputerControl().aggressiveness = 1.0
	thug1:getComputerControl().healthLowThreshold = 10
	thug1:getComputerControl().chicken = 0.0
	thug1:getComputerControl():setShootDelay( 0.1 )
	thug1:getComputerControl():setAimInaccuracy( 10 ) -- some error would be nice since he's shooting quite often
	thug1:setAimingTimeAfterShooting( 10 )
	-- Hearing and vision tresholds ------------------------------------------------
	thug1:getComputerControl().hearingLimit = 0.45
	thug1:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug1:addPatrolState( "PATH_Line01", headTurningLeftRight )
	local alertState = thug1:addAlertState( )
	local fightState = thug1:addFightState()
	fightState:addAttackSequence( shoot3secs )
	fightState:addAttackSequence( wait1sec )
	fightState:addEvadeSequence( evade )

-- This thug guards the W side of the storage area, equiped with m16 -----------------------------------------------------------
	
	thug13 = this:createEnemy( "thug.lua", "Backup thug", "m16.lua", "PATH_Line10" )
	thug13:getComputerControl().stupidity = 0.5
	thug13:getComputerControl().aggressiveness = 1.0
	thug13:getComputerControl().healthLowThreshold = 10
	thug13:getComputerControl().chicken = 0.0
	thug13:getComputerControl():setShootDelay( 0.01 )
	thug13:getComputerControl():setAimInaccuracy( 10 ) -- some error would be nice since he's shooting quite often
	-- Hearing and vision tresholds ------------------------------------------------
	thug13:getComputerControl().hearingLimit = 0.45
	thug13:getComputerControl().visionLimit = 0.05
	-- Define fighting behavior ----------------------------------------------------
	local patrolState = thug13:addPatrolState( "PATH_Line10", headTurningLeftRight )
	patrolState:playRandomIdleSounds( 40, 45 )
	local alertState = thug13:addAlertState( )
	local fightState = thug13:addFightState()
	fightState:addAttackSequence( shoot3secs )		
	fightState:addAttackSequence( wait1sec )
	fightState:addEvadeSequence( evade )
	

-- Hero

	hero = this:createCharacter( "hero.lua" )
	this:setCharacterTransformToPathStart( hero, "PLAYER_START_POINT" )
	--this:setCharacterTransformToPathStart( hero, "DEBUG_START_POINT_1" )
	
	local defaultGun = this:createWeapon( "m16.lua" )
	hero:addWeaponToInventory( defaultGun )								-- add active weapon first!
	hero:addWeaponToInventory( this:createWeapon( "beretta.lua" ) )		-- weapon cycle will follow 
	hero:addWeaponToInventory( this:createWeapon( "shotgun.lua" ) )		-- this order
	hero:setWeapon( defaultGun )

	this:setMainCharacter( hero )
	
-- Breakable objects

-- create exploding barrels -----------------------------------------------------------------------------

    -- Loop through existing dynamic objects in scene by name
    -- and initialize breakable object scripting to each one.
	-- Different versions (unbroken/broken) of each object must
	-- be in the same place in the scene. Broken version can be parented
	-- to the unbroken version.

	local firstBarrel = 1	-- DYNAMIC_barrel_explosive_F<frame>_001 is the first one
	local lastBarrel = 4	-- DYNAMIC_barrel_explosive_F<frame>_004 is the last one
	while ( firstBarrel <= lastBarrel ) do

		local health = 60			-- how much damage dynamic object can get before exploding
		local damage = 150			-- how much damage explosion would cause to object at zero distance
		local damageRadius = 10		-- maximum range explosion causes any damage (linear fade out)
		local hideDelay = 0.2		-- delay before the mesh is changed to broken one
		local noiseLevel = 100		-- noise level so AI can hear explosions
		local noiseDistance = 40	-- distance how far the noise affects (linear fade out)
		
        -- naming convention for dynamic objects:
        -- object 1, frame 0: DYNAMIC_barrel_explosive_F0_001
        -- object 1, frame 1: DYNAMIC_barrel_explosive_F1_001
        -- object 2, frame 0: DYNAMIC_barrel_explosive_F0_002
        -- object 2, frame 1: DYNAMIC_barrel_explosive_F1_002
		local objects =
		{
			-- DYNAMIC_barrel_explosive_F0_001, ...
			{name=string.format("DYNAMIC_barrel_explosive_F0_%03i",firstBarrel)},
			{name=string.format("DYNAMIC_barrel_explosive_F1_%03i",firstBarrel)}
		}

        -- played particle effects and their time from dynamic object 'death'
        -- (0.1 means that particle effect is played 0.1 seconds after dynamic object 'health' runs out)
		local particleEffects =
		{
			{name="generic_effects/barrel_explosion", time=0.1},
			{name="generic_effects/barrel_explosion_sparks", time=0.1},
			{name="generic_effects/smoke_puff_dark", time=0.2},
			{name="generic_effects/smoke_puff_light", time=2.0}
		}

        -- same settings for sounds as for particle objects
		local soundEffects =
		{
			{name="environment/barrel_explosion", time=0.05}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstBarrel = firstBarrel + 1
	end
-- create destructible crate wooden -----------------------------------------------------------------------------

	local firstCrate = 1
	local lastCrate = 9
	while ( firstCrate <= lastCrate ) do

		local health = 60
		local damage = 100
		local damageRadius = 10
		local hideDelay = 0.2
		local noiseLevel = 100
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_crate_wooden_F0_001, ...
			{name=string.format("DYNAMIC_crate_wooden_F0_%03i",firstCrate)},
			{name=string.format("DYNAMIC_crate_wooden_F1_%03i",firstCrate)}
		}

		local particleEffects =
		{
			{name="generic_effects/electric_box_explosion", time=0.1},
			{name="generic_effects/electric_box_explosion_sparks", time=0.1},
			{name="generic_effects/smoke_puff_dark", time=0.2},
		}

		local soundEffects =
		{
			{name="environment/explosion", time=0.05}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstCrate = firstCrate + 1
	end
-- create exploding fire extinguisher -----------------------------------------------------------------------------

	local firstExtinguisher = 1
	local lastExtinguisher = 6
	while ( firstExtinguisher <= lastExtinguisher ) do

		local health = 60
		local damage = 100
		local damageRadius = 10
		local hideDelay = 0.2
		local noiseLevel = 100
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_fire_extinguisher_F0_001, ...
			{name=string.format("DYNAMIC_fire_extinguisher_F0_%03i",firstExtinguisher)},
			{name=string.format("DYNAMIC_fire_extinguisher_F1_%03i",firstExtinguisher)}
		}

		local particleEffects =
		{
			{name="generic_effects/fire_extinguisher_puff", time=0.1}
		}

		local soundEffects =
		{
			{name="environment/fire_extinguisher_explosion", time=0.05},
			{name="environment/fire_extinguisher_leaking", time=0.2}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstExtinguisher = firstExtinguisher + 1
	end
-- create exploding Electricbox -----------------------------------------------------------------------------

	local firstElectricbox = 1
	local lastElectricbox = 2
	while ( firstElectricbox <= lastElectricbox ) do

		local health = 20
		local damage = 0
		local damageRadius = 1
		local hideDelay = 0.2
		local noiseLevel = 100
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_crate_wooden_F0_001, ...
			{name=string.format("DYNAMIC_electric_box_F0_%03i",firstElectricbox)},
			{name=string.format("DYNAMIC_electric_box_F1_%03i",firstElectricbox)}
		}

		local particleEffects =
		{
			{name="generic_effects/electric_box_explosion", time=0.1},
			{name="generic_effects/electric_box_explosion_sparks", time=0.1},
			{name="generic_effects/electric_box_sparks", time=0.15}
		}

		local soundEffects =
		{
			{name="weapons/generic/ricochet_metal", time=0.05},
			{name="environment/electric_box_sparking", time=0.1}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstElectricbox = firstElectricbox + 1
	end
-- create exploding Forklifter gas -----------------------------------------------------------------------------

	local firstForkgas = 1
	local lastForkgas = 2
	while ( firstForkgas <= lastForkgas ) do

		local health = 60
		local damage = 100
		local damageRadius = 10
		local hideDelay = 0.2
		local noiseLevel = 100
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_crate_wooden_F0_001, ...
			{name=string.format("DYNAMIC_forklifter_gas_F0_%03i",firstForkgas)},
			{name=string.format("DYNAMIC_forklifter_gas_F1_%03i",firstForkgas)}
		}

		local particleEffects =
		{
			{name="generic_effects/barrel_explosion", time=0.1},
			{name="generic_effects/barrel_explosion_sparks", time=0.1},
			{name="generic_effects/smoke_puff_dark", time=0.2},
			{name="generic_effects/smoke_puff_light", time=2.0}
		}

		local soundEffects =
		{
			{name="environment/barrel_explosion", time=0.05}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstForkgas = firstForkgas + 1
	end
-- create destructible sign dead end -----------------------------------------------------------------------------

	local firstDeadend = 1
	local lastDeadend = 1
	while ( firstDeadend <= lastDeadend ) do

		local health = 10
		local damage = 0
		local damageRadius = 1
		local hideDelay = 0.2
		local noiseLevel = 20
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_sign_dead_end_F0_001, ...
			{name=string.format("DYNAMIC_sign_dead_end_F0_%03i",firstDeadend)},
			{name=string.format("DYNAMIC_sign_dead_end_F1_%03i",firstDeadend)}
		}

		local particleEffects =
		{
			{name="generic_effects/electric_box_explosion_sparks", time=0.1}
		}

		local soundEffects =
		{
			{name="weapons/generic/ricochet_metal", time=0.05}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstDeadend = firstDeadend + 1
	end
-- create destructible sign EXIT -----------------------------------------------------------------------------

	local firstIllusign = 1
	local lastIllusign = 2
	while ( firstIllusign <= lastIllusign ) do

		local health = 10
		local damage = 0
		local damageRadius = 1
		local hideDelay = 0.2
		local noiseLevel = 20
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_crate_wooden_F0_001, ...
			{name=string.format("DYNAMIC_signl_exitglow_illu_F0_%03i",firstIllusign)},
			{name=string.format("DYNAMIC_signl_exitglow_illu_F1_%03i",firstIllusign)}
		}

		local particleEffects =
		{
			{name="generic_effects/electric_box_explosion_sparks", time=0.1}
		}

		local soundEffects =
		{
			{name="environment/glass_breaks", time=0.05}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstIllusign = firstIllusign + 1
	end
-- create exploding transformer -----------------------------------------------------------------------------

	local firstTransformer = 1
	local lastTransformer = 1
	while ( firstTransformer <= lastTransformer ) do

		local health = 50
		local damage = 0
		local damageRadius = 1
		local hideDelay = 0.2
		local noiseLevel = 20
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_crate_wooden_F0_001, ...
			{name=string.format("DYNAMIC_transformer_F0_%03i",firstTransformer)},
			{name=string.format("DYNAMIC_transformer_F1_%03i",firstTransformer)}
		}

		local particleEffects =
		{
			{name="generic_effects/electric_box_explosion", time=0.1},
			{name="generic_effects/electric_box_explosion_sparks", time=0.1},
			{name="generic_effects/electric_box_sparks", time=0.15}
		}

		local soundEffects =
		{
			{name="environment/explosion", time=0.05},
			{name="environment/electric_box_sparking", time=0.1}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstTransformer = firstTransformer + 1
	end
-- create exploding welding gas -----------------------------------------------------------------------------

	local firstWeldinggas = 1
	local lastWeldinggas = 2
	while ( firstWeldinggas <= lastWeldinggas ) do

		local health = 60
		local damage = 150
		local damageRadius = 10
		local hideDelay = 0.2
		local noiseLevel = 100
		local noiseDistance = 40
		
		local objects =
		{
			-- DYNAMIC_crate_wooden_F0_001, ...
			{name=string.format("DYNAMIC_welding_gas_F0_%03i",firstWeldinggas)},
			{name=string.format("DYNAMIC_welding_gas_F1_%03i",firstWeldinggas)}
		}

		local particleEffects =
		{
			{name="generic_effects/barrel_explosion", time=0.1},
			{name="generic_effects/barrel_explosion_sparks", time=0.1},
			{name="generic_effects/smoke_puff_dark", time=0.2},
			{name="generic_effects/smoke_puff_light", time=2.0}
		}

		local soundEffects =
		{
			{name="environment/barrel_explosion", time=0.05}
		}

		this:createBreakableObject( objects, health, damage, damageRadius, particleEffects, soundEffects, hideDelay, noiseLevel, noiseDistance )
		
		firstWeldinggas = firstWeldinggas + 1
	end

	-- Stencil shadow color r,g,b,a
	-- this:setShadowColor( 0, 0, 0, 80 )
	this:setShadowColor( 0, 0, 0, 70 )

	-- Set backgrounds for each cell which needs background
	this:setBackgroundToCells( "BACKGROUND_sky_dome", {"CELL"} )

-- Pre-load some projectiles of weapons into cache avoid real-time resource allocation
	this:loadProjectiles( "shotgun_shot.lua", 50 )
	this:loadProjectiles( "shotgun_shell.lua", 30 )
	this:loadProjectiles( "m16_shot.lua", 30 )
	this:loadProjectiles( "m16_shell.lua", 30 )
	this:loadProjectiles( "beretta_shot.lua", 15 )
	this:loadProjectiles( "beretta_shell.lua", 30 )

-- Triggers ----------------------------------------------------------------------------------------------------

	-- cut scene 1 trigger
	local cutSceneTrigger1 = this:createCutSceneTrigger( "TRIGGER_Dummy01", "harbor_area_cut_scenes/harbor_area_cut_scene_1.lua" )

	-- end trigger
	local endTrigger = this:createBoxTrigger( "triggers/end_trigger.lua", "TRIGGER_Dummy02" )

	-- tutorial trigger
	local tutorialTrigger = this:createBoxTrigger( "triggers/help_at_start.lua", "PLAYER_START_POINT" )

	-- tutorial killer trigger
	local tutorialKillerTrigger = this:createBoxTrigger( "triggers/help_tutorial_killer.lua", "TRIGGER_Dummy03" )
	tutorialKillerTrigger.target = tutorialTrigger

	-- movement barrier trigger
	local movementBarrierTrigger = this:createBoxTrigger( "triggers/movement_barrier_trigger.lua", "TRIGGER_Dummy04" )

-- Start intro cut scene
	--this:playCutScene( "harbor_area_cut_scenes/harbor_area_intro.lua" )
	--this:playCutScene( "harbor_area_cut_scenes/harbor_area_cut_scene_1.lua" )
end
