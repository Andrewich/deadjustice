--
-- character_sounds.lua contains all material specific movement step sounds
-- and other sound playback calls.
--
-- The file is currently common for hero and thug but character specific 
-- characterSoundPath is used to sepearate sounds from each other.
-- Functions can also be overriden later if needed.
--

-- ---------------------- SURPRISE sound when visually sighted -------------------------------------------
function this.playSurprisedCanSeeSound( this )
	this:playSound( this.characterSoundPath .. "surprised_cansee" .. this:getRandomInteger(1,10) )
end

-- ---------------------- SURPRISE sound when heard noise ------------------------------------------------
function this.playSurprisedCanHearSound( this )
	this:playSound( this.characterSoundPath .. "surprised_canhear" .. this:getRandomInteger(1,12) )
end

function this.playBulletHitSound( this )
	this:playSound( this.characterSoundPath .. "hit" .. this:getRandomInteger(1,4) )
end

function this.playPhysicalAttackHitSound( this )
	this:playSound( this.characterSoundPath .. "hit" .. this:getRandomInteger(1,4) )
end


-- --------------------- SNEAKING sound on different surfaces ----------------------------------------------
-- --------------------- DEFAULT sound is STONE ------------------------------------------------------------


function this.playSneakingStepSound1( this )

	-- play SNEAKING foot step sound for first shoe
	
	local mtl = this:groundMaterial().typeName
	if ( mtl == "SOFT" ) then

		-- change 'footstep1' according to which sound to use when walking on STONE material
		-- (for example to "footstep1_stone" and then add footstep1_stone to sounds/hero/)
		
		this:playSound( this.characterSoundPath .. "sneaking_soft1" )

	elseif ( mtl == "SAND" ) then
		this:playSound( this.characterSoundPath .. "sneaking_sand1" )
	elseif ( mtl == "WOOD" ) then
		this:playSound( this.characterSoundPath .. "sneaking_wood1" )
	elseif ( mtl == "METAL" ) then
		this:playSound( this.characterSoundPath .. "sneaking_metal1" )
	else
		-- this last one is default if material is something else
		this:playSound( this.characterSoundPath .. "sneaking_stone1" )
	end
end

function this.playSneakingStepSound2( this )

	-- play SNEAKING foot step sound for the other shoe
	
	local mtl = this:groundMaterial().typeName
	if ( mtl == "SOFT" ) then
		this:playSound( this.characterSoundPath .. "sneaking_soft2" )
	elseif ( mtl == "SAND" ) then
		this:playSound( this.characterSoundPath .. "sneaking_sand2" )
	elseif ( mtl == "WOOD" ) then
		this:playSound( this.characterSoundPath .. "sneaking_wood2" )
	elseif ( mtl == "METAL" ) then
		this:playSound( this.characterSoundPath .. "sneaking_metal2" )
	else
		-- this last one is default if material is something else
		this:playSound( this.characterSoundPath .. "sneaking_stone2" )
	end
end

-- --------------------- WALKING sound on different surfaces ----------------------------------------------
-- --------------------- DEFAULT sound is STONE ------------------------------------------------------------

function this.playWalkingStepSound1( this )

	-- play WALKING foot step sound for first shoe

	local mtl = this:groundMaterial().typeName
	if ( mtl == "SOFT" ) then

		-- change 'footstep1' according to which sound to use when walking on STONE material
		-- (for example to "footstep1_stone" and then add footstep1_stone to sounds/hero/)
		
		this:playSound( this.characterSoundPath .. "walking_soft1" )

	elseif ( mtl == "SAND" ) then
		this:playSound( this.characterSoundPath .. "walking_sand1" )
	elseif ( mtl == "WOOD" ) then
		this:playSound( this.characterSoundPath .. "walking_wood1" )
	elseif ( mtl == "METAL" ) then
		this:playSound( this.characterSoundPath .. "walking_metal1" )
	else
		-- this last one is STONE and also default if material is something else
		this:playSound( this.characterSoundPath .. "walking_stone1" )
	end
end

function this.playWalkingStepSound2( this )

	-- play WALKING foot step sound for the other shoe

	local mtl = this:groundMaterial().typeName
	if ( mtl == "SOFT" ) then
		this:playSound( this.characterSoundPath .. "walking_soft2" )
	elseif ( mtl == "SAND" ) then
		this:playSound( this.characterSoundPath .. "walking_sand2" )
	elseif ( mtl == "WOOD" ) then
		this:playSound( this.characterSoundPath .. "walking_wood2" )
	elseif ( mtl == "METAL" ) then
		this:playSound( this.characterSoundPath .. "walking_metal2" )
	else
		-- this last one is STONE and also default if material is something else
		this:playSound( this.characterSoundPath .. "walking_stone2" )
	end
end

-- --------------------- RUNNING sound on different surfaces ----------------------------------------------
-- --------------------- DEFAULT sound is STONE ------------------------------------------------------------

function this.playRunningStepSound1( this )

	-- play RUNNING foot step sound for first shoe

	local mtl = this:groundMaterial().typeName
	if ( mtl == "SOFT" ) then

		-- change 'footstep1' according to which sound to use when walking on STONE material
		-- (for example to "footstep1_stone" and then add footstep1_stone to sounds/hero/)
		
		this:playSound( this.characterSoundPath .. "running_soft1" )

	elseif ( mtl == "SAND" ) then
		this:playSound( this.characterSoundPath .. "running_sand1" )
	elseif ( mtl == "WOOD" ) then
		this:playSound( this.characterSoundPath .. "running_wood1" )
	elseif ( mtl == "METAL" ) then
		this:playSound( this.characterSoundPath .. "running_metal1" )
	else
		-- this last one is STONE and also default if material is something else
		this:playSound( this.characterSoundPath .. "running_stone1" )
	end
end

function this.playRunningStepSound2( this )
	
	-- play RUNNING foot step sound for the other shoe
	
	local mtl = this:groundMaterial().typeName
	if ( mtl == "SOFT" ) then
		this:playSound( this.characterSoundPath .. "running_soft2" )
	elseif ( mtl == "SAND" ) then
		this:playSound( this.characterSoundPath .. "running_sand2" )
	elseif ( mtl == "WOOD" ) then
		this:playSound( this.characterSoundPath .. "running_wood2" )
	elseif ( mtl == "METAL" ) then
		this:playSound( this.characterSoundPath .. "running_metal2" )
	else
		-- this last one is STONE and also default if material is something else
		this:playSound( this.characterSoundPath .. "running_stone2" )
	end
end

