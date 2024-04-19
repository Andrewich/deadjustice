project(
    mem
    VERSION 0.65
    DESCRIPTION
        "Memory allocation support library"
    LANGUAGES C
)

add_library(mem INTERFACE)

add_compile_definitions(MEM_EXPORTS)

include_directories(internal ${PROJECT_SOURCE_DIR})
