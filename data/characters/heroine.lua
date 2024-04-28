this:include "player_base.lua"

-- name of base object to morph in character mesh

this.morphBaseMesh = "heroine_head"

-- make sure animations used here are added in init() with addMorphAnimation()

--this.morphDefault			= "heroine_head/heroine_morph_idle.gm"
--this.morphAiming			= "heroine_head/heroine_morph_aim.gm"
--this.morphShooting			= "heroine_head/heroine_morph_shoot.gm"
--this.morphDying				= "heroine_head/heroine_morph_die.gm"				-- played when character death animation starts
--this.morphProjectileHurting	= "heroine_head/heroine_morph_projectile_hurt.gm"	-- played when character gets hurt by bullet
--this.morphPhysicalHurting	= "heroine_head/heroine_morph_physical_hurt.gm"		-- played when character gets hurt by close combat attack


-- Initialization

function this.init( this )
	this.characterSoundPath = "hero/"

	this:setName( "Heroine" )
	trace( "Initializing " .. this:name() )

	this:setMesh( "heroine/heroine.sg", 0, 1e6 )
	this:setDynamicShadow( "heroine_shadow_volume", 10 )
	this:initBase()

-- add face morph animations

	this:setMorphBase( this.morphBaseMesh )
	--this:addMorphAnimation( this.morphBaseMesh, "heroine_head/heroine_morph_aim.gm", "REPEAT" )	-- end behabiour: REPEAT (default), RESET, CONSTANT, OSCILLATE
	--this:addMorphAnimation( this.morphBaseMesh, "heroine_head/heroine_morph_idle.gm", "REPEAT" )
	--this:addMorphAnimation( this.morphBaseMesh, "heroine_head/heroine_morph_shoot.gm", "REPEAT" )
	
	--this:addMorphAnimation( this.morphBaseMesh, "heroine_head/heroine_morph_die.gm", "CONSTANT" )
	--this:addMorphAnimation( this.morphBaseMesh, "heroine_head/heroine_morph_physical_hurt.gm", "CONSTANT" )
	--this:addMorphAnimation( this.morphBaseMesh, "heroine_head/heroine_morph_projectile_hurt.gm", "CONSTANT" )




end
