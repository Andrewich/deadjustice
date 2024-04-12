project(
    example_simple_window
    VERSION 0.65
    DESCRIPTION
        "Example simple window app"
    LANGUAGES CXX
)

add_executable(simple_window WIN32)

target_sources(simple_window PRIVATE simple_window.cpp)

target_link_libraries(simple_window $<TARGET_FILE:lang> $<TARGET_FILE:win>)