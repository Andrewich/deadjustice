project(
    lua
    VERSION 4.0.1
    DESCRIPTION
        "The Lua Programming Language"
    HOMEPAGE_URL "https://www.lua.org/download.html"
    LANGUAGES C
)

add_library(lua STATIC)

include_directories(include)

target_sources(lua 
    PRIVATE
        src/lapi.c
        src/lcode.c
        src/ldebug.c
        src/ldo.c
        src/lfunc.c
        src/lgc.c
        src/llex.c
        src/lmem.c
        src/lobject.c
        src/lparser.c
        src/lstate.c
        src/lstring.c
        src/ltable.c
        src/ltests.c
        src/ltm.c
        src/lundump.c
        src/lvm.c
        src/lzio.c
        src/lib/lauxlib.c
        src/lib/lbaselib.c
        src/lib/ldblib.c
        src/lib/liolib.c
        src/lib/lmathlib.c
        src/lib/lstrlib.c)