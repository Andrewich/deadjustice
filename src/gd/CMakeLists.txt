project(
    gd
    VERSION 0.65
    DESCRIPTION
        "Graphics device layer library (DirectX Graphics -wrapper)"
    LANGUAGES CXX
)

# GD DirectX 9 implementation
add_library(gd_dx9 SHARED)
add_compile_definitions(GD_DX9_EXPORTS)

include_directories(gd_dx_common ${PROJECT_SOURCE_DIR}/gd_dx9 ${DirectX9_INCLUDE_DIR})

target_sources(gd_dx9 
    PRIVATE
        gd_dx_common/DrvObject.cpp
        gd_dx_common/error.cpp
        gd_dx_common/LogFile.cpp
        gd_dx_common/operator_new.cpp
        gd_dx_common/Sort.cpp
        gd_dx_common/toSurfaceFormat.cpp
        gd_dx9/Dx9BaseTexture.cpp
        gd_dx9/Dx9CubeTexture.cpp
        gd_dx9/Dx9Effect.cpp
        gd_dx9/Dx9GraphicsDevice.cpp
        gd_dx9/Dx9GraphicsDriver.cpp
        gd_dx9/Dx9Material.cpp
        gd_dx9/Dx9Primitive.cpp
        gd_dx9/Dx9RenderingState.cpp
        gd_dx9/Dx9RenderToTexture.cpp
        gd_dx9/Dx9Texture.cpp
        gd_dx9/gd_dx9.cpp
        gd_dx9/StdAfx.cpp
        gd_dx9/toDx9.cpp
        gd_dx9/toString.cpp)

target_link_libraries(gd_dx9 ${DirectX9_LIBRARIES} lang pix math)