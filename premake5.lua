-- Clean Function --
newaction {
    trigger     = "clean",
    description = "clean the software",
    execute     = function ()
       print("clean the build...")
       os.rmdir("./build")
       os.rmdir("./bin")
       os.rmdir("./lib")
       print("done.")
    end
 }

workspace "DeadJustice"
    configurations { "Debug", "Release" }
    platforms { "Win32" }
    language "C++"
    cppdialect "C++14"
    includedirs { "include", "src", "src/config/msvc6" }

    filter { "platforms:Win32" }
        system "Windows"
        architecture "x86"
        defines { "WIN32", "_CRT_SECURE_NO_WARNINGS" }
        characterset ("MBCS")

    filter { "configurations:Debug" }
        targetdir "lib/debug"
        targetsuffix "d"
        defines { "_DEBUG" }
        optimize "Debug"
        symbols "On"
    
    filter { "configurations:Release" }
        targetdir "lib/release"
        defines { "NDEBUG" }
        optimize "Full"
        symbols "Off"

project "lang"
    kind "StaticLib"
    location "build/lang"
    includedirs { "src/lang/internal" }
    files { "src/lang/internal/*.cpp", "src/lang/internal/*.h", "src/lang/*.cpp", "src/lang/*.h" }
    defines { "LANG_WIN32" }

project "mem"
    kind "SharedLib"
    language "C"
    location "build/mem"
    includedirs { "src/mem/internal" }
    files { "src/mem/internal/*.c", "src/mem/internal/*.h", "src/mem/*.c", "src/mem/*.h" }
    defines { "MEM_EXPORTS" }

project "io"
    kind "StaticLib"
    location "build/io"
    includedirs { "src/io/internal" }
    files { "src/io/internal/*.cpp", "src/io/internal/*.h", "src/io/*.cpp", "src/io/*.h" }
    defines { "_ALLOW_KEYWORD_MACROS" }

project "util"
    kind "StaticLib"
    location "build/util"
    includedirs { "src/util/internal" }
    files { "src/util/internal/*.cpp", "src/util/internal/*.h", "src/util/*.cpp", "src/util/*.h" }

project "win"
    kind "StaticLib"
    location "build/win"
    includedirs { "src/win/internal" }
    files { "src/win/internal/*.cpp", "src/win/internal/*.h", "src/win/*.cpp", "src/win/*.h" }

project "dev"
    kind "StaticLib"
    location "build/dev"
    includedirs { "src/dev/internal" }
    files { "src/dev/internal/*.h", "src/dev/*.cpp", "src/dev/*.h" }

project "anim"
    kind "StaticLib"
    location "build/anim"
    includedirs { "src/anim/internal" }
    files { "src/anim/internal/*.h", "src/anim/internal/*.cpp", "src/anim/*.cpp", "src/anim/*.h" }

project "bsp"
    kind "StaticLib"
    location "build/bsp"
    includedirs { "src/bsp/internal" }
    files { "src/bsp/internal/*.h", "src/bsp/*.cpp", "src/bsp/*.h" }

project "math"
    kind "StaticLib"
    location "build/math"
    includedirs { "src/math/internal" }
    files { "src/math/internal/*.h", "src/math/*.cpp", "src/math/*.h" }

project "id"
    kind "StaticLib"
    location "build/id"
    files { "src/id/*.h" }

project "id_dx8"
    kind "SharedLib"
    location "build/id_dx8"
    includedirs { "src/id/id_dx8" }
    files { "src/id/id_dx8/*.cpp", "src/id/id_dx8/*.h" }
    defines { "ID_DX8_EXPORTS" }
    libdirs { "lib/debug" }
    dependson { "mem", "lang", "util", "io" }
    links {
        "memd",        
        "dxguid",
        "dinput8"
    }

project "libjpeg"
    kind "StaticLib"
    language "C"
    location "build/libjpeg"
    includedirs { "src/external/libjpeg" }
    files { "src/external/libjpeg/*.c", "src/external/libjpeg/*.h" }

project "pix"
    kind "StaticLib"
    location "build/pix"
    includedirs { "src/pix/internal", "src/pix", "src/external/libjpeg" }
    files { "src/pix/internal/*.h", "src/pix/internal/*.cpp", "src/pix/*.cpp", "src/pix/*.h" }    

project "gd"
    kind "StaticLib"
    location "build/gd"
    files { "src/gd/*.h" }

project "gd_dx9"
    kind "SharedLib"
    location "build/gd_dx9"    
    includedirs { "$(DXSDK_DIR)Include", "src/gd/gd_dx9", "src/gd/gd_dx_common" }    
    files { "src/gd/gd_dx9/*.cpp", "src/gd/gd_dx9/*.h", "src/gd/gd_dx_common/*.cpp", "src/gd/gd_dx_common/*.h" }    
    defines { "GD_DX9_EXPORTS" }
    libdirs { "$(DXSDK_DIR)Lib/x86", "lib/debug" }        
    dependson { "mem", "math", "pix" }
    links {
        "memd",
        "mathd",
        "pixd",
        "d3dx9",
        "d3d9"
    }

project "tester"
    kind "ConsoleApp"
    location "build/tester"

    filter { "platforms:Win32" }
        debugenvs { "PATH=%PATH%;$(SolutionDir)lib/debug/" }

    targetdir "bin/debug"
    files { 
        "src/tester/*.cpp",
        "src/lang/tests/*.cpp",
        "src/io/tests/*.cpp"
        --"src/util/tests/*.cpp"
    }
    libdirs { "lib/debug" }
    dependson { "mem", "lang", "util", "io" }
    links {
        "memd",
        "langd",
        "iod",
        "utild"
    }