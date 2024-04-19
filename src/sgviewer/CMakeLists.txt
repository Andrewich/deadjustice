project(
    sgviewer
    VERSION 0.65
    DESCRIPTION
        "Scene (.sg) file viewer. See sgviewer/docs/sgviewer.txt for usage."
    LANGUAGES CXX
)

add_compile_definitions(_AFXDLL _WIN32_WINNT=0x0601)
set(CMAKE_MFC_FLAG 2)

add_executable(sgviewer WIN32)

target_sources(sgviewer 
    PRIVATE 
        createCube.cpp
        MainFrm.cpp
        printMemoryState.cpp
        sgviewer.cpp
        sgviewerDoc.cpp
        sgviewerView.cpp
        StdAfx.cpp
        sgviewer.rc)

target_link_libraries(sgviewer lang win util io math anim dev libjpeg pix gd_dx9 sg sgu)

add_custom_command(TARGET sgviewer POST_BUILD
        COMMAND 
        ${CMAKE_COMMAND} -E copy_if_different
            $<TARGET_FILE:gd_dx9> 
            "${PROJECT_SOURCE_DIR}/sgviewer.prop"
            "${PROJECT_SOURCE_DIR}/arial.txt"
            "${PROJECT_SOURCE_DIR}/arial.bmp"
            "${PROJECT_SOURCE_DIR}/normalize.dds"
            $<TARGET_FILE_DIR:sgviewer>)
