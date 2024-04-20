project(
    script
    VERSION 0.65
    DESCRIPTION
        "Scripting support (Lua wrapper)"
    LANGUAGES CXX
)

add_library(script STATIC)

include_directories(internal ${CMAKE_SOURCE_DIR}/external/lua/include)

target_sources(script 
    PRIVATE
        internal/lua_ex.cpp
        RestoreStack.cpp
        Scriptable.cpp
        Table.cpp
        VM.cpp)
