workspace "deadjustice"
    location "build"    
    characterset "MBCS"
    language "C++"
    targetdir "lib"
    objdir "build/%{prj.name}/%{cfg.buildcfg}"
    configurations { "Debug", "Release" }
    includedirs { "./", "config/msvc6/", "%{prj.name}/internal/" }
    vpaths { ["internal"] = { "%{prj.name}/internal/*.h", "%{prj.name}/internal/*.cpp" } }
    files { "%{prj.name}/*.h", "%{prj.name}/*.cpp", "%{prj.name}/*.inl", "%{prj.name}/internal/*.h", "%{prj.name}/internal/*.cpp" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        
        filter { "Debug", "kind:SharedLib or StaticLib" }
            targetsuffix "d"

    filter "configurations:Release"
        defines { "NDEBUG" }
        optimize "On"    

    filter "system:windows"
        defines "WIN32"

    filter "action:vs*"
        defines "_CRT_SECURE_NO_WARNINGS"

project "mem"
    kind "SharedLib"
    files { "%{prj.name}/*.c", "%{prj.name}/internal/*.c" }
    defines { "MEM_EXPORTS" }
    filter { "system:windows" }
        postbuildcommands { "XCOPY \"$(TargetPath)\" ..\\DLL\\ /D /K /Y" }

project "lang"
    kind "StaticLib"
    dependson { "mem" }
    defines { "LANG_WIN32" }
    filter { "system:windows" }
        postbuildcommands { "LIB $(TargetPath) ../lib/mem%{cfg.buildtarget.suffix}.lib" }

project "io"
    kind "StaticLib"
    targetdir "lib"
