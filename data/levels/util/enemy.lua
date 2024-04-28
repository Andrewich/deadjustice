-- helpers

function this.setCharacterTransformToPathStart( this, character, pathname )
	local path = this:getPath(pathname)

	character:setPosition( path.startPointCell, path:getPointPosition(1,0), path:getPointPosition(1,1), path:getPointPosition(1,2) )
	character:setPrimaryState( "STANDING" )
	
	character:lookAt( character:getPosition(0) + path.startPointDirection0 * 5,
		character:getPosition(1) + path.startPointDirection1 * 5, 
		character:getPosition(2) + path.startPointDirection2 * 5 )
	
	character:aimAt( character:getPosition(0) + character:getForward(0) * 5,
		character:getPosition(1) + character:getForward(1) * 5, 
		character:getPosition(2) + character:getForward(2) * 5 )

	character:getComputerControl():standHere()
end


-- user interface

function this.createEnemy( this, characterScript, characterName, weaponName, pathOrDummyObjectName )
	local character = this:createCharacter( characterScript )
	character:setName( characterName )
	character:setWeapon( this:createWeapon(weaponName) )
	this:setCharacterTransformToPathStart( character, pathOrDummyObjectName )
	return character
end

function this.createHeadTurningSequence( this )
	local sequence = { views = { n=0 } }
	
	sequence.addView = function( this, _time, _xangle, _yangle, _anglespeed )
		this.views.n = this.views.n + 1
		this.views[ this.views.n ] = { time = _time, xAngle = _xangle, yAngle = _yangle, angleSpeed = _anglespeed } 
	end
	
	sequence.setEndBehaviour = function( this, _behaviour )
		this.endBehaviour = _behaviour
	end

	return sequence
end

function this.createFightSequence( this )
	local sequence = { events = { n=0 } }

	sequence.addEvent = function( this, _timeStart, _timeEnd, _type, _params )
		if ( _timeStart > _timeEnd ) then		
			trace( "Fight sequence event ({2}) start time ({0}) must be less than end time ({1})", _timeStart, _timeEnd, _params);
			return 
		end
		this.events.n = this.events.n + 1
		this.events[ this.events.n ] = { timeStart = _timeStart, timeEnd = _timeEnd, type = _type, parameter = _params }
	end

	sequence.addWait = function( this, timeStart, timeEnd )
		this:addEvent( timeStart, timeEnd, "WAIT" )
	end

	sequence.addShoot = function( this, timeStart, timeEnd, state )
		this:addEvent( timeStart, timeEnd, "SHOOT", state )
	end

	sequence.addShootOnce = function( this, timeStart, timeEnd )
		this:addEvent( timeStart, timeEnd, "SHOOTONCE" )
	end

	sequence.addShootAuto = function( this, timeStart, timeEnd, duration )
		this:addEvent( timeStart, timeEnd, "SHOOTAUTO", duration )
	end

	sequence.addShootBlind = function( this, timeStart, timeEnd, duration )
		this:addEvent( timeStart, timeEnd, "SHOOTBLIND", duration )
	end

	sequence.addCrouch = function( this, timeStart, timeEnd, state )
		this:addEvent( timeStart, timeEnd, "CROUCH", state )
	end

	sequence.addMove = function( this, timeStart, timeEnd, _x, _y, _z )
		this:addEvent( timeStart, timeEnd, "MOVE", { x = _x, y = _y, z = _z } )
	end

	sequence.addMoveAbsolute = function( this, timeStart, timeEnd, _x, _y, _z )
		this:addEvent( timeStart, timeEnd, "MOVEABSOLUTE", { x = _x, y = _y, z = _z } )
	end

	sequence.addMoveAbsoluteIfNotHeroClose = function( this, timeStart, timeEnd, _x, _y, _z, _threshold )
		this:addEvent( timeStart, timeEnd, "MOVEABSOLUTE_NOTHEROCLOSE", { x = _x, y = _y, z = _z, threshold = _threshold } )
	end

	sequence.addMoveCloser = function( this, timeStart, timeEnd, _amount, _limit )
		this:addEvent( timeStart, timeEnd, "MOVECLOSER", { amount = _amount, limit = _limit } )
	end

	sequence.addMoveFurther = function( this, timeStart, timeEnd, _amount, _limit )
		this:addEvent( timeStart, timeEnd, "MOVEFURTHER", { amount = _amount, limit = _limit } )
	end
	
	sequence.addEvade = function( this, timeStart, timeEnd, amount )
		this:addEvent( timeStart, timeEnd, "EVADE", amount )
	end

	sequence.addFaceEnemy = function( this, timeStart, timeEnd )
		this:addEvent( timeStart, timeEnd, "FACEENEMY" )
	end

	sequence.addTurnToMove = function( this, timeStart, timeEnd )
		this:addEvent( timeStart, timeEnd, "TURNTOMOVE" )
	end

	return sequence
end
