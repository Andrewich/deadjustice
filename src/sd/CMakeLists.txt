project(
    sd
    VERSION 0.65
    DESCRIPTION
        "Sound device layer library (DSound wrapper)"
    LANGUAGES CXX
)

# SD DirectSound implementation
add_library(sd_dx8 SHARED)
add_compile_definitions(SD_DX8_EXPORTS)

include_directories(${PROJECT_SOURCE_DIR} sd_dx8 ${DirectX9_INCLUDE_DIR})

target_sources(sd_dx8 
    PRIVATE
    sd_dx8/DrvObject.cpp
    sd_dx8/Dx8SoundBuffer.cpp
    sd_dx8/Dx8SoundDevice.cpp
    sd_dx8/Dx8SoundDriver.cpp
    sd_dx8/error.cpp
    sd_dx8/operator_new.cpp
    sd_dx8/sd_dx8.cpp
    sd_dx8/StdAfx.cpp
    sd_dx8/toDx8.cpp
    sd_dx8/toString.cpp)

target_link_libraries(sd_dx8 ${DSound_LIBRARIES} math)
