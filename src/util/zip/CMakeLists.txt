project(
    util_zip
    VERSION 0.65
    DESCRIPTION
        "Zlib wrapper library"
    LANGUAGES CXX
)

add_library(util_zip STATIC)

include_directories(internal ${CMAKE_SOURCE_DIR}/external/zlib)

target_sources(util_zip 
    PRIVATE
        internal/MemoryInputStream.cpp
        ZipFile.cpp)

if(MSVC)
    add_custom_command(TARGET util_zip POST_BUILD
        COMMAND LIB.exe "$<TARGET_FILE:util_zip>" "$<TARGET_FILE:zlib>")
endif()

#add_subdirectory(zar)