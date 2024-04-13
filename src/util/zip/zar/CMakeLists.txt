project(
    zar
    VERSION 0.65
    DESCRIPTION
        ""
    LANGUAGES CXX
)

add_executable(zar)

include_directories(${CMAKE_SOURCE_DIR}/external/zlib)

target_sources(zar PRIVATE zar.cpp)

target_link_libraries(zlib)