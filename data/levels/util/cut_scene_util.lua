this:include "dialog_text.lua"


-- cut scene helper functions

-- Returns frame (in 30 fps) as seconds
function this.framesToSeconds( this, frame )
	return frame/30
end


-- cut scene commands

function this.setEnd( this, time )
	if ( this.deinit ) then
		this:addTimerEvent( this.deinit, time )
	end
	this:setEndTime( time )
end

function this.setCamera( this, time, cellName, cameraName, animTime, sceneName )
	trace( "Camera " .. cameraName .. " of scene " .. sceneName .. " starts at frame " .. time*30 )
	this:addTimerEvent( function(this) 
		camera:setPosition( level:getCell(%cellName), camera:getPosition(0), camera:getPosition(1), camera:getPosition(2) )
		camera:playAnimation( %cameraName, %sceneName, %animTime )
		end, time )
end

function this.setCameraFrontAndBackPlaneDistances( this, time, front, back )
	this:addTimerEvent( function(this) 
		this:setCutSceneCameraFrontAndBackPlanes(%front,%back)
		end, time )
end

function this.animateDynamicObject( this, time, dynamicObjectName, sceneName )
	local dynamicObject = level:getDynamicObject( dynamicObjectName )
	local startTime = 0
	local endBehaviour = "CONSTANT"
	this:addTimerEvent( function(this) %dynamicObject:playWorldSpaceAnimation(%sceneName,%endBehaviour,%startTime) end, time )
end

function this.animateCharacter( this, time, characterName, cellName, bipedName, sceneName )
	local character = level:getCharacter( characterName )
	local startTime = 0
	local endBehaviour = "CONSTANT"
	this:addTimerEvent( function(this) 
		%character:setPosition( level:getCell(%cellName), 0, 0, 0 )
		%character:playWorldSpaceAnimation(%sceneName,%bipedName,%endBehaviour,%startTime) 
		end, time )
end

function this.animateCharacterFace( this, time, characterName, modelName )
	local character = level:getCharacter( characterName )
	local startTime = 0
	local endBehaviour = "CONSTANT"
	this:addTimerEvent( function(this) %character:playMorphAnimationOnce(%character.morphBaseMesh,%modelName,%endBehaviour) end, time )
end

function this.hideCharacterWeapon( this, time, characterName )
	local character = level:getCharacter( characterName )
	local weapon = character:weapon()
	if ( weapon ) then
		this:addTimerEvent( function(this) %weapon:hide() end, time )
	end
end

function this.unhideCharacterWeapon( this, time, characterName )
	local character = level:getCharacter( characterName )
	local weapon = character:weapon()
	if ( weapon ) then
		this:addTimerEvent( function(this) %weapon:unhide() end, time )
	end
end

function this.enableCharacterShadow( this, time, objName )
	local obj = level:getCharacter( objName )
	this:addTimerEvent( function(this) %obj:enableDynamicShadow() end, time )
end

function this.disableCharacterShadow( this, time, objName )
	local obj = level:getCharacter( objName )
	this:addTimerEvent( function(this) %obj:disableDynamicShadow() end, time )
end

function this.enableCharacterWeaponShadow( this, time, objName )
	local obj = level:getCharacter( objName )
	this:addTimerEvent( function(this) %obj:weapon():enableDynamicShadow() end, time )
end

function this.disableCharacterWeaponShadow( this, time, objName )
	local obj = level:getCharacter( objName )
	this:addTimerEvent( function(this) %obj:weapon():disableDynamicShadow() end, time )
end

function this.fireCharacterWeaponWithoutBullet( this, time, characterName )
	local character = level:getCharacter( characterName )
	local weapon = character:weapon()
	if ( weapon ) then
		this:addTimerEvent( function(this) %weapon:fireWithoutBullet(%character) end, time )
	end
end

function this.playParticleSystemAndSoundAtObject( this, time, particleName, soundName, objectName )
	this:addTimerEvent( function(this) 
		this:playObjectParticleSystem(%particleName,%objectName) 
		this:playObjectSound(%soundName,%objectName)
		end, time )
end

function this.playParticleSystemAtObject( this, time, particleName, objectName )
	this:addTimerEvent( function(this) 
		this:playObjectParticleSystem(%particleName,%objectName) 
		end, time )
end

function this.playSoundAtObject( this, time, soundName, objectName )
	this:addTimerEvent( function(this) 
		this:playObjectSound(%soundName,%objectName)
		end, time )
end

function this.animateScene( this, time, sceneName )
	trace( "Cut scene animation " .. sceneName .. " starts at frame " .. time*30 )
	this:addTimerEvent( function(this) 
		this:playScene( %sceneName )
		end, time )
end
