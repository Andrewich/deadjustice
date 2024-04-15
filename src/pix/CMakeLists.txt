project(
    pix
    VERSION 0.65
    DESCRIPTION
        "Low level pixel processing library, supports pixel format conversions etc."
    LANGUAGES CXX
)

add_library(pix STATIC)

include_directories(internal ${PROJECT_SOURCE_DIR})

target_sources(pix 
    PRIVATE
        internal/loadBMP.cpp
        internal/loadDDS.cpp
        internal/loadJPEG.cpp
        internal/loadTGA.cpp
        Color.cpp
        Colorf.cpp
        Image.cpp
        Surface.cpp
        SurfaceFormat.cpp
        SurfaceUtil.cpp)
