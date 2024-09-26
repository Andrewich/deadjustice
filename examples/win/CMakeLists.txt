project(
    example_simple_window
    VERSION 0.65
    DESCRIPTION
        "Example simple window app"
    LANGUAGES CXX
)

find_package(SDL2 REQUIRED CONFIG)

add_executable(simple_window WIN32)

target_sources(simple_window 
    PRIVATE
        simple_window.cpp)

target_link_libraries(simple_window lang win SDL2::SDL2main SDL2::SDL2-static)