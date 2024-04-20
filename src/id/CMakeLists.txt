project(
    id
    VERSION 0.65
    DESCRIPTION
        "Input device library (DirectInput -wrapper)"
    LANGUAGES CXX
)

# ID DirectInput implementation
add_library(id_dx8 SHARED)
add_compile_definitions(ID_DX8_EXPORTS)

include_directories(${PROJECT_SOURCE_DIR}/id_dx8 ${DirectX9_INCLUDE_DIR})

target_sources(id_dx8 
    PRIVATE
        id_dx8/DrvObject.cpp
        id_dx8/Dx8InputDevice.cpp
        id_dx8/Dx8InputDriver.cpp
        id_dx8/error.cpp
        id_dx8/id_dx8.cpp
        id_dx8/operator_new.cpp
        id_dx8/StdAfx.cpp
        id_dx8/toString.cpp)

target_link_libraries(id_dx8 ${DInput_LIBRARIES})
