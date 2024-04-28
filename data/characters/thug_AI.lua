this:include( "boolean.lua" )


-- Helper functions

function this.isCloseTo( this, x, y, z, maxdistance )
	if ( this:getDistanceTo( x, y, z ) < maxdistance ) then
		return true
	else
		return false
	end
end

function this.testPercentAgainstRandom( this, percent )
	local rnd = this:getRandomInteger(1, 100)
	if ( ( percent * 100 ) >= rnd ) then
		return true
	else
		return false
	end
end

function findSequence( sequences, time )
	local i = 1
	while ( i <= sequences.n ) do
		if ( sequences[i].start <= time and time <= sequences[i].finish ) then
			return sequences[i].sequence
		end
		i = i + 1
	end 

	return nil
end

function applyHeadTurningSequence( this, sequence, lastsequence, dt )
	if ( (sequence ~= lastsequence ) or not this.sequenceTime ) then
		-- Init time when entered a new sequence
		this.sequenceTime = 0
	end

	-- Get look from sequence
	local lastTime = sequence.views[ sequence.views.n ].time
	local time = this.sequenceTime
	if ( sequence.endBehaviour == "REPEAT" ) then
		time = math.mod( this.sequenceTime, lastTime )
	end
	local activeView = sequence.views[1] 
	local i = 2
	while ( i <= sequence.views.n ) do
		if ( sequence.views[i].time < time ) then
			activeView = sequence.views[i]
		end
		i = i + 1
	end
	--trace( this.character:name().." seqtime "..time..", view "..activeView.xAngle..", "..activeView.yAngle )
	this.controller:lookToAngle( activeView.xAngle, activeView.yAngle, activeView.angleSpeed )

	this.sequenceTime = this.sequenceTime + dt			
end

function applyFightSequence( this, sequence, lastsequence, enemy, dt )
	if ( not this.fightSequenceTime ) then
		-- Init time if its' not initialized
		this.fightSequenceTime = 0
	end

	local time = this.fightSequenceTime
	local lastTime = 0
	local event = nil
	local i = 1
	while ( i <= sequence.events.n and not event ) do
		if ( sequence.events[i].timeStart <= time and time < sequence.events[i].timeEnd ) then
			event = sequence.events[i]
			if ( sequence.events[i].timeEnd > lastTime ) then
				lastTime = sequence.events[i].timeEnd
			end
		end
		i = i + 1
	end

	local finished = nil
	if ( time >= lastTime ) then
		finished = 1
	end

	this.fightSequenceTime = this.fightSequenceTime + dt

	if ( not event ) then
		-- return without doing anything ( this is legal )
		return finished
	end

--	trace( this.character:name().." fightseqtime "..time..", type "..event.type )
			
	if ( event.type == "WAIT" ) then
		this.controller:standHere()
	elseif ( event.type == "SHOOT" ) then
		if ( this.character:canSee( hero ) ) then 
			this.controller:fire( event.parameter )
		end
	elseif ( event.type == "SHOOTONCE" ) then
		if ( this.character:canSee( hero ) ) then 
			this.controller:fireOnce()
		end
	elseif ( event.type == "SHOOTAUTO" ) then
		if ( ( this.fightSequenceTime - event.timeStart ) < event.parameter ) then
			if ( this.character:canSee( hero ) ) then 
				this.controller:fire( true )
			end
		else
			this.controller:fire( false )
		end
	elseif ( event.type == "SHOOTBLIND" ) then
		if ( ( this.fightSequenceTime - event.timeStart ) < event.parameter ) then
			this.controller:fire( true )
		else
			this.controller:fire( false )
		end
	elseif ( event.type == "CROUCH" ) then
		this.controller:crouch( event.parameter )
	elseif ( event.type == "MOVEABSOLUTE" ) then
		this.controller:goTo( event.parameter.x, event.parameter.y, event.parameter.z )
	elseif ( event.type == "MOVEABSOLUTE_NOTHEROCLOSE" ) then
		if ( this.character:getDistanceTo( hero ) > event.parameter.threshold ) then
			this.controller:goTo( event.parameter.x, event.parameter.y, event.parameter.z )
		else
			finished = true
		end
	elseif ( event.type == "MOVE" ) then
		local r_x = event.parameter.x * this.character:getRight(0)
		local r_y = event.parameter.x * this.character:getRight(1) 
		local r_z = event.parameter.x * this.character:getRight(2)
		local u_x = event.parameter.y * this.character:getUp(0)
		local u_y = event.parameter.y * this.character:getUp(1)
		local u_z = event.parameter.y * this.character:getUp(2)
		local f_x = event.parameter.z * this.character:getForward(0)
		local f_y = event.parameter.z * this.character:getForward(1)
		local f_z = event.parameter.z * this.character:getForward(2)
		if ( this.character:canMove( r_x + u_x + f_x, r_y + u_y + f_y, r_z + u_z + f_z ) ) then
			this.controller:goToOffset( r_x + u_x + f_x, r_y + u_y + f_y, r_z + u_z + f_z )
		else
			finished = true
		end
	elseif ( event.type == "MOVECLOSER" ) then
		local ofsX = enemy:getPosition(0) - this.character:getPosition(0)	
		local ofsY = enemy:getPosition(1) - this.character:getPosition(1)	
		local ofsZ = enemy:getPosition(2) - this.character:getPosition(2)
		local limit = event.parameter.limit
		local length = math.sqrt( math.abs(ofsX) + math.abs(ofsY) + math.abs(ofsZ) )
		
		if ( length > limit ) then
			local amount = event.parameter.amount
			if ( amount > ( length - limit ) ) then
				amount = length - limit
			end
			local scale = amount / length
			if ( this.character:canMove( ofsX * scale, ofsY * scale, ofsZ * scale ) ) then 
				this.controller:goToOffset( ofsX * scale, ofsY * scale, ofsZ * scale )
			else 
				finished = true
			end
		else
			finished = true
		end
	elseif ( event.type == "MOVEFURTHER" ) then
		local ofsX = enemy:getPosition(0) - this.character:getPosition(0)	
		local ofsY = enemy:getPosition(1) - this.character:getPosition(1)	
		local ofsZ = enemy:getPosition(2) - this.character:getPosition(2)
		local limit = event.parameter.limit
		local length = math.sqrt( math.abs(ofsX) + math.abs(ofsY) + math.abs(ofsZ) )
		
		if ( length < limit ) then
			local amount = event.parameter.amount
			if ( ( amount + length ) > limit ) then
				amount = limit - length
			end
			local scale = amount / length
			if ( this.character:canMove( -ofsX * scale, -ofsY * scale, -ofsZ * scale ) ) then 
				this.controller:goToOffset( -ofsX * scale, -ofsY * scale, -ofsZ * scale )
			else
				finished = true 
			end
		else
			finished = true
		end		
	elseif ( event.type == "EVADE" ) then
		local evadeLength = this.character:getRandomInteger( -10, 10 )
		if ( this.character:canMove( this.character:getRight(0) * evadeLength * event.parameter / 10,
									this.character:getRight(1) * evadeLength * event.parameter / 10,
									this.character:getRight(2) * evadeLength * event.parameter / 10 ) ) then 
			this.controller:goToOffset( this.character:getRight(0) * evadeLength * event.parameter / 10,
										this.character:getRight(1) * evadeLength * event.parameter / 10,
										this.character:getRight(2) * evadeLength * event.parameter / 10 )
		else
			finished = true
		end
	elseif ( event.type == "FACEENEMY" ) then
		this.controller:turnTo( hero:getPosition(0), hero:getPosition(1), hero:getPosition(2) )
	elseif ( event.type == "TURNTOMOVE" ) then
		this.controller:turnToMovement()
	end

	return finished
end

-- Turns towards absolute position, moves forward while turning if too steep turn
function this.turnMoving( this, x, y, z )
	local maxAngleToCorrectDirection = 25
	local cc = this:getComputerControl()
	cc:turnTo( x, y, z )
	if ( math.abs(this:getAngleTo(x,y,z)) < maxAngleToCorrectDirection ) then
		cc:goTo( x, y, z )
	else
		local farEnough = 10
		cc:goTo( this:getPosition(0)+this:getForward(0)*farEnough, 
			this:getPosition(1)+this:getForward(1)*farEnough,
			this:getPosition(2)+this:getForward(2)*farEnough )
	end
end

function this.playRandomIdleSound( this, idleSounds, dt )
	if ( idleSounds ) then
		if ( not idleSounds.timer ) then
			idleSounds.timer = (idleSounds.soundMaxDelay-idleSounds.soundMinDelay)*this:random() + idleSounds.soundMinDelay
		end

		idleSounds.timer = idleSounds.timer - dt
		if ( idleSounds.timer < 0 ) then
			this:playIdleSound()
			idleSounds.timer = nil
		end
	end
end

-- State creators

function this.addIdleState( this, idleAnimName )
	local machine = this:getComputerControl():getStateMachine()
	local state = {}
	state.name = "idle"
	state.updateInterval = 0.1
	state.idleAnimName = idleAnimName
	state.randomSounds = { n=0 }

	state.enterCondition = function( this ) return true end
	
	state.enter = function ( this ) 
		--trace( this.character:name() .. " idling in animation " .. this.idleAnimName )
		this.character:clearSecondaryAnimations()
		this.character:blendAnimation( this.idleAnimName, 0.25 ) 
		end

	state.update = function( this ) 
		this.character:playRandomIdleSound( this.idleSounds, this.updateInterval )
		end

	state.exitCondition = function(this) return false end
	state.exit = nil

	state.playRandomIdleSounds = function( this, minDelay, maxDelay, sounds )
		this.idleSounds = {soundMinDelay=minDelay, soundMaxDelay=maxDelay}
		end 

	state.machine = machine
	state.character = this
	state.controller = this:getComputerControl()
	machine:addState( state )
	return state
end

function this.addPatrolState( this, pathName, headTurningSequence )
	local machine = this:getComputerControl():getStateMachine()
	local state = {}
	state.name = "patrol"
	state.updateInterval = 0.1
	state.headTurningSequences = { n=0 }
	state.randomSounds = { n=0 }

	state.enterCondition = function( this ) return true end

	state.enter = function( this )
		this.sequence = nil
		this.lastSequence = nil
		end

	state.update = function( this )
		-- Get path knot 
		local x = this.path:getPointPosition(this.pathPos,0)
		local y = this.path:getPointPosition(this.pathPos,1)
		local z = this.path:getPointPosition(this.pathPos,2)
		local looped = nil
		while ( this.character:isCloseTo(x, y, z, 1) ) do
			this.pathPos = this.pathPos + 1
			if ( this.pathPos > this.path:points() ) then
				this.pathPos = 1
				if ( looped ) then
					break
				end
				looped = 1
			end
			x = this.path:getPointPosition(this.pathPos,0)
			y = this.path:getPointPosition(this.pathPos,1)
			z = this.path:getPointPosition(this.pathPos,2)
		end

		-- Go to path knot
		this.controller:setMovingWalking()
		this.character:turnMoving( x, y, z )

		-- Pre-set aim 10 meters forward
		local aimDist = 10
		this.character:aimAt( this.character:getPosition(0) + this.character:getForward(0) * aimDist,
			this.character:getPosition(1) + this.character:getForward(1) * aimDist + 1.7,
			this.character:getPosition(2) + this.character:getForward(2) * aimDist )

		-- Look sequence
		this.sequence = findSequence( this.headTurningSequences, this.pathPos / this.path:points() )
		if ( not this.sequence and not this.machine.patrolLookToPosition ) then
			this.controller:lookToAngle( 0, 0, 45 )
		elseif ( this.machine.patrolLookToPosition ) then
			this.controller:lookToAngle( -this.character:getSignedAngleTo( this.machine.patrolLookToPosition.x, this.machine.patrolLookToPosition.y, this.machine.patrolLookToPosition.z ), 0, 45 )
		else 
			applyHeadTurningSequence( this, this.sequence, this.lastSequence, this.updateInterval )
		end
		this.lastSequence = this.sequence

		this.character:playRandomIdleSound( this.idleSounds, this.updateInterval )

		end

	state.exitCondition = function(this) return false end
	state.exit = nil

	state.addHeadTurningSequence = function(this, _start, _finish, _sequence )
		this.headTurningSequences.n = this.headTurningSequences.n + 1
		this.headTurningSequences[ this.headTurningSequences.n ] = { start = _start, finish = _finish, sequence = _sequence }
		end	

	if ( headTurningSequence ) then
		state:addHeadTurningSequence( 0, 1, headTurningSequence )
	end

	state.playRandomIdleSounds = function( this, minDelay, maxDelay, sounds )
		this.idleSounds = {soundMinDelay=minDelay, soundMaxDelay=maxDelay}
		end 

	state.path = level:getPath( pathName )
	state.pathPos = state.path:getClosestPointIndex( this:getPosition(0), this:getPosition(1), this:getPosition(2) )

	state.machine = machine
	state.machine.patrolLookToPosition = nil
	state.character = this
	state.controller = this:getComputerControl()
	machine:addState( state )
	return state
end

function this.addAlertState( this, playSurprisedSoundProb, headTurningSequence )
	local machine = this:getComputerControl():getStateMachine()
	local state = {}
	state.name = "alert"
	state.updateInterval = 0.5
	state.evadeDelay = 1.5
	state.evadeEnabled = false
	state.alertLength = 20
	state.headTurningSequences = { n=0 }
	state.sequenceTime = 0
	state.hasSeenPlayer = nil
	state.enemyCloseThreshold = 15
	state.timeSinceLastNoise = 0
	state.noiseFrequencyLimit = 1
	state.noiseCountLimit = 3
	state.noiseCount = 0
	state.turningAroundEnabled = true
	state.turningAroundDelay = 10
	state.turningAroundTime = 2.5

	state.enterCondition = function(this) 
		return (this.machine.lastKnownEnemyPosition or this.character:canSee(hero)) and not hero:isDead()
		end

	state.enter = function(this)
		this.evadeTimer = this.evadeDelay
		this.lastSequence = nil
		this.sequence = nil

		-- play surprised sound with probability of <playSurprisedSoundProb>
		if ( not this.hasSeenPlayer and %playSurprisedSoundProb and this.character:random() < %playSurprisedSoundProb ) then
			if ( this.character:canSee( hero ) ) then 
				this.character:playSurprisedCanSeeSound()
			else
				this.character:playSurprisedCanHearSound()
			end
		end

		this.alertTimer = 0
		this.character:setPrimaryState( "STANDING" )
		this.hasSeenPlayer = 1
		this.noiseHasRevealedPlayer = nil
		this.noiseCount = 0
		this.turningAroundTimer = 0
		end

	state.update = function(this)
		--trace( "AI is alert" )
		this.controller:setMovingSneaking()
		this.controller:fire( false )
		this.controller:crouch( false )

		-- Set enemy position if enemy visible
		if ( this.character:canSee( hero ) or this.noiseHasRevealedPlayer ) then 
			this.machine.lastKnownEnemyPosition = {	x = hero:getPosition(0), y = hero:getPosition(1), z = hero:getPosition(2) }
			this.machine.patrolLookToPosition = this.machine.lastKnownEnemyPosition
		end

		-- Turn to last known enemy position
		if ( this.machine.lastKnownEnemyPosition ) then
			this.controller:turnTo( this.machine.lastKnownEnemyPosition.x, this.machine.lastKnownEnemyPosition.y, this.machine.lastKnownEnemyPosition.z )
		end

		-- Random evade
		if ( this.evadeEnabled ) then
			this.evadeTimer = this.evadeTimer - this.updateInterval
			if ( this.evadeTimer < 0 ) then
				if ( this.character:random() > 0.85 ) then
					local evadeLength = this.character:getRandomInteger( -3, 3 )
					this.controller:goToOffset( this.character:getRight(0) * evadeLength,
												this.character:getRight(1) * evadeLength,
												this.character:getRight(2) * evadeLength )
				else
					this.controller:standHere()
				end
				this.evadeTimer = this.evadeDelay
			else
				this.controller:stop()
			end
		end

		-- Preset aim 10 meters forward
		local aimDist = 10
		this.character:aimAt( this.character:getPosition(0) + this.character:getForward(0) * aimDist,
			this.character:getPosition(1) + this.character:getForward(1) * aimDist + 1.7,
			this.character:getPosition(2) + this.character:getForward(2) * aimDist )

		-- Looking sequence
		this.sequence = findSequence( this.headTurningSequences, 0 )
		if ( not this.sequence ) then
			this.controller:lookToAngle( 0, 0, 45 )
		else
			applyHeadTurningSequence( this, this.sequence, this.lastSequence, this.updateInterval )
		end
		this.lastSequence = this.sequence

		-- Turning around to get a better look
		if ( this.turningAroundEnabled and this.turningAroundTimer >= this.turningAroundDelay ) then
			this.character:turnMoving( this.character:getPosition(0) - this.character:getForward(0) * 10 + this.character:getRight(0) * 0.1, 
										this.character:getPosition(1) - this.character:getForward(1) * 10 + this.character:getRight(1) * 0.1,
										this.character:getPosition(2) - this.character:getForward(2) * 10 + this.character:getRight(2) * 0.1 )

			if ( this.turningAroundTimer > this.turningAroundDelay + this.turningAroundTime ) then
				this.turningAroundTimer = 0;
			end

			if ( not this.noiseHasRevealedPlayer ) then
				this.machine.lastKnownEnemyPosition = nil
			end
		end

		-- Timers
		this.alertTimer = this.alertTimer + this.updateInterval
		this.timeSinceLastNoise = this.timeSinceLastNoise + this.updateInterval
		this.turningAroundTimer = this.turningAroundTimer + this.updateInterval
		
		end

	state.exitCondition = function( this )
		local enemyClose = nil
		if ( this.machine.lastKnownEnemyPosition ) then
			enemyClose = this.enemyCloseThreshold > this.character:getDistanceTo( hero )
		end
		return (this.alertTimer > this.alertLength) and ( (not enemyClose) or hero:isDead() )
		end

	state.exit = function( this )
		this.machine.lastKnownEnemyPosition = nil
		this.noiseHasRevealedPlayer = nil
		end

	state.addHeadTurningSequence = function(this, _sequence )
			this.headTurningSequences.n = this.headTurningSequences.n + 1
			this.headTurningSequences[ this.headTurningSequences.n ] = { start = 0, finish = 1, sequence = _sequence }
		end	

	if ( headTurningSequence ) then
		state:addHeadTurningSequence( headTurningSequence )
	end

	state.signalHearNoise = function(this, noise)		
		if ( noise:getSource():name() == hero:name() ) then 
			--trace ( "AI " .. this.character:name() .. " signals on heard hero-made noise in alert state" )
			this.machine.lastKnownEnemyPosition = {	x = noise:getPosition(0), 
				y = noise:getPosition(1),
				z = noise:getPosition(2) }
		end
		if ( this.timeSinceLastNoise < this.noiseFrequencyLimit ) then
			this.noiseCount = this.noiseCount + 1
		else
			this.noiseCount = 0
		end

		this.timeSinceLastNoise = 0

		if ( this.noiseCount >= this.noiseCountLimit ) then
			this.noiseHasRevealedPlayer = true
		end
		
		end

	state.signalReceiveProjectile = function(this, bullet)
		--trace ( "AI signals on received projectile in alert state" )
		if ( bullet:getWeapon() == hero:weapon() ) then 
			this.machine.lastKnownEnemyPosition = {	x = this.character:getPosition(0) - bullet:getVelocity(0), 
				y = this.character:getPosition(1) - bullet:getVelocity(1),
				z = this.character:getPosition(2) - bullet:getVelocity(2) }
		end
		end

	state.machine = machine
	state.character = this
	state.controller = this:getComputerControl()
	machine:addState( state )
	return state
end

function this.addFightState( this )
	local machine = this:getComputerControl():getStateMachine()
	local state = {}
	state.name = "fight"
	state.updateInterval = 0.1
	state.attackSequences = { n=0 }
	state.evadeSequences = { n=0 }
	state.retreatSequences = { n=0 }
	state.evadeDelay = 1.5
	state.lastPhysical = "KICK"

	state.enterCondition = function( this )
		return this.character:canSee(hero) and not hero:isDead() or this.character:isHurting()
		end

	state.enter = function(this)
		this.evadeTimer = this.evadeDelay
		this.controller:setFireTarget( hero )
		trace( this.character:name().." entered fight state, "..this.attackSequences.n.." attacks "..this.evadeSequences.n.." evades "..this.retreatSequences.n.." retreats" )
		if ( this.character:testPercentAgainstRandom( this.controller.aggressiveness ) ) then
		-- Aggressive behaviour
			this:selectSequence( this.attackSequences )						
			trace( this.character:name().." initialized aggressive behaviour" )
		else
		-- Evasive behaviour
			this:selectSequence( this.evadeSequences )						
			trace( this.character:name().." initialized evasive behaviour" )
		end
		this.lastSequence = nil
		this.seqFinished = nil
		this.isRetreating = nil
		this.physicalAttackTimer = 0
		end

	state.update = function(this) 
		--trace( "AI is in fight state" )

		this.physicalAttackTimer = this.physicalAttackTimer + this.updateInterval

		if ( this.character:getDistanceTo( hero ) > 1 ) then
			this.controller:setMovingRunning()
			local target = this.controller:getFireTarget()
			this.character:aimAt( hero )
			this.machine.lastKnownEnemyPosition = {	x = hero:getPosition(0), y = hero:getPosition(1), z = hero:getPosition(2) }

			if ( not this.currentSequence ) then 
				this.controller:fire( false )
				this.character:turnMoving( this.machine.lastKnownEnemyPosition.x, this.machine.lastKnownEnemyPosition.y, this.machine.lastKnownEnemyPosition.z )
				this.controller:fire( true )

				this.evadeTimer = this.evadeTimer - this.updateInterval
				if ( this.evadeTimer < 0 ) then
					if ( this.character:random() > 0.67 ) then
						local evadeLength = this.character:getRandomInteger( -10, 10 )
						if ( math.abs(evadeLength) > 3 ) then
							this.controller:goToOffset( this.character:getRight(0) * evadeLength,
														this.character:getRight(1) * evadeLength,
														this.character:getRight(2) * evadeLength )
						end
					end
					this.evadeTimer = this.evadeDelay
				end
			else
				-- Select new sequence if seq finished
				if ( this.seqFinished ) then
					if ( this.character:testPercentAgainstRandom( this.controller.aggressiveness ) ) then
						-- Aggressive behaviour
						this:selectSequence( this.attackSequences )						
						trace( this.character:name().." updated to aggressive behaviour" )
					else
						-- Evasive behaviour
						this:selectSequence( this.evadeSequences )						
						trace( this.character:name().." updated to evasied behaviour" )
					end
				end
				-- Apply non-finished seq
				if ( not this.seqFinished ) then
					this.seqFinished = applyFightSequence( this, this.currentSequence, this.lastSequence, hero, this.updateInterval )		
					this.lastSequence = this.currentSequence
				end
			end
		else
		 -- Go to close combat
			this.controller:turnTo( hero )
			if ( this.physicalAttackTimer >= this.controller.physicalAttackDelay ) then
				if ( this.lastPhysical == "KICK" ) then 
					this.controller:physicalAttackStrike()
					this.lastPhysical = "STRIKE"
				else
					this.controller:physicalAttackKick()
					this.lastPhysical = "KICK"
				end
				this.physicalAttackTimer = 0
			end
		end
		end

	state.exitCondition = function(this) 
		return hero:isDead() or (this.seqFinished and not this.character:canSee(hero) ) and not this.character:isHurting()
		end

	state.exit = function(this)
		this.controller:fire(false)
		this.controller:setFireTarget( nil )
		trace( this.character:name().." exited fight state" )
		end

	state.addAttackSequence = function( this, sequence )
		if ( not sequence ) then
			trace( "ERROR! NIL attack sequence assigned for "..this.character:name() )
		else
			if ( sequence.n == 0 ) then
				trace( "ERROR! Attack sequence for "..this.character:name().." did not contain any events" )
			end
			this.attackSequences.n = this.attackSequences.n + 1
			this.attackSequences[ this.attackSequences.n ] = sequence
		end
		end

	state.addEvadeSequence = function( this, sequence )
		if ( not sequence ) then
			trace( "ERROR! NIL evade sequence assigned for "..this.character:name() )
		else
			if ( sequence.n == 0 ) then
				trace( "ERROR! Evade sequence for "..this.character:name().." did not contain any events" )
			end
			this.evadeSequences.n = this.evadeSequences.n + 1
			this.evadeSequences[ this.evadeSequences.n ] = sequence
		end
		end

	state.addRetreatSequence = function( this, sequence )
		if ( not sequence ) then
			trace( "ERROR! NIL retreat sequence assigned for "..this.character:name() )
		else
			if ( sequence.n == 0 ) then
				trace( "ERROR! Retreat sequence for "..this.character:name().." did not contain any events" )
			end
			this.retreatSequences.n = this.retreatSequences.n + 1
			this.retreatSequences[ this.retreatSequences.n ] = sequence
		end
		end
	
	-- fight sequence should not be set with other than this function
	state.selectSequence = function( this, sequences )
		if ( sequences.n > 0 ) then
			this.currentSequence = sequences[ this.character:getRandomInteger(1, sequences.n) ]				
		else
			this.currentSequence = nil
		end
		this.seqFinished = false
		this.fightSequenceTime = 0
		end

	state.signalReceiveProjectile = function(this, bullet)
		if ( bullet:getWeapon() == hero:weapon() ) then 
			this.machine.lastKnownEnemyPosition = {	x = this.character:getPosition(0) - bullet:getVelocity(0), 
				y = this.character:getPosition(1) - bullet:getVelocity(1),
				z = this.character:getPosition(2) - bullet:getVelocity(2) }
		end	
		if ( not this.isRetreating ) then
			if ( this.character:testPercentAgainstRandom( this.controller.stupidity ) ) then 
				-- Character is too stupid to react
				trace( this.character:name().. " was too stupid to react" )
			else
				-- Reaction to event 
				if ( this.character:testPercentAgainstRandom( this.controller.aggressiveness ) ) then
					-- Aggressive behaviour
					this:selectSequence( this.attackSequences )						
					trace( this.character:name().." selected aggressive behaviour" )
				else
					-- Evasive behaviour
					this:selectSequence( this.evadeSequences )						
					trace( this.character:name().." selected evasive behaviour" )
				end

				-- Check health low
				if ( this.character:getHealth() <= this.controller.healthLowThreshold ) then
					if ( this.character:testPercentAgainstRandom( this.controller.chicken ) ) then
						-- Retreat behaviour
						this:selectSequence( this.retreatSequences )						
						trace( this.character:name().." selected retreat behaviour" )
						this.isRetreating = true
					else
						-- Aggressive behaviour
						this:selectSequence( this.attackSequences )						
						trace( this.character:name().." selected aggressive behaviour" )
					end
				end
			end	
		end
		end

	state.signalHearNoise = function(this, noise)
		--trace ( "AI " .. this.character:name() .. " signals on heard noise in alert state" )
		if ( noise:getSource():name() == hero:name() ) then 
			this.machine.lastKnownEnemyPosition = {	x = noise:getPosition(0), 
				y = noise:getPosition(1),
				z = noise:getPosition(2) }
		end
		end

	state.machine = machine
	state.character = this
	state.controller = this:getComputerControl()
	machine:addState( state )
	return state
end
