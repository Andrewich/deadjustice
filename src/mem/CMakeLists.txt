project(
    mem
    VERSION 0.65
    DESCRIPTION
        "Memory allocation support library"
    LANGUAGES C
)

add_library(mem SHARED)

add_compile_definitions(MEM_EXPORTS)

include_directories(internal)

target_sources(mem 
    PRIVATE internal/error.c internal/testAndSet.c internal/Vector.c Group.c raw.c)