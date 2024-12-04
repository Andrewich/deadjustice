project(
    example_pix
    VERSION 0.65
    DESCRIPTION
        "Example pix using app"
    LANGUAGES CXX
)

find_package(bimg REQUIRED)
find_package(fmt)

add_executable(pix_example)

target_sources(pix_example 
    PRIVATE
        main.cpp)

target_link_libraries(pix_example bimg::bimg fmt::fmt)

add_custom_command(TARGET pix_example POST_BUILD
        COMMAND 
        ${CMAKE_COMMAND} -E copy
            "${CMAKE_SOURCE_DIR}/data/screenshot.jpg"
            $<TARGET_FILE_DIR:pix_example>)
