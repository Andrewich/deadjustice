workspace "deadjustice"
    location "build"    
    characterset "MBCS"
    language "C++"
    targetdir "lib"
    objdir "build/%{prj.name}/%{cfg.buildcfg}"
    configurations { "Debug", "Release" }
    includedirs { "./", "config/msvc6/", "%{prj.name}/internal/" }
    libdirs { "lib" }
    vpaths { ["internal"] = { "%{prj.name}/internal/*.h", "%{prj.name}/internal/*.cpp" } }
    files { "%{prj.name}/*.h", "%{prj.name}/*.cpp", "%{prj.name}/*.inl", "%{prj.name}/internal/*.h", "%{prj.name}/internal/*.cpp" }

    filter "configurations:Debug"
        defines { "DEBUG" }
        symbols "On"
        
        filter { "Debug" }
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

-- External dependencies
project "libjpeg"
    kind "StaticLib"
    files { "external/%{prj.name}/*.c", "external/%{prj.name}/*.h" }
    removefiles { 
        "external/%{prj.name}/wrbmp.c",
        "external/%{prj.name}/wrgif.c",
        "external/%{prj.name}/wrjpgcom.c",
        "external/%{prj.name}/wrppm.c",
        "external/%{prj.name}/wrrle.c",
        "external/%{prj.name}/wrtarga.c",
        "external/%{prj.name}/rdbmp.c",
        "external/%{prj.name}/rdcolmap.c",
        "external/%{prj.name}/rdgif.c",
        "external/%{prj.name}/rdjpgcom.c",
        "external/%{prj.name}/rdppm.c",
        "external/%{prj.name}/rdrle.c",
        "external/%{prj.name}/rdswitch.c",
        "external/%{prj.name}/rdtarga.c",
        "external/%{prj.name}/transupp.c",
        "external/%{prj.name}/jpegtran.c",
        "external/%{prj.name}/jmemname.c",
        "external/%{prj.name}/jmemnobs.c",
        "external/%{prj.name}/jmemdos.c",
        "external/%{prj.name}/jmemmac.c",
        "external/%{prj.name}/ansi2knr.c",
        "external/%{prj.name}/cderror.h",
        "external/%{prj.name}/cdjpeg.c",
        "external/%{prj.name}/cdjpeg.h",
        "external/%{prj.name}/cjpeg.c",
        "external/%{prj.name}/ckconfig.c",
        "external/%{prj.name}/djpeg.c",
        "external/%{prj.name}/example.c"
    }

project "io"
    kind "StaticLib"
    dependson { "lang" }

project "win"
    kind "StaticLib"
    dependson { "lang" }

project "util"
    kind "StaticLib"
    dependson { "lang" }

project "math"
    kind "StaticLib"
    dependson { "lang" }

project "anim"
    kind "StaticLib"
    dependson { "lang", "util" }

project "bsp"
    kind "StaticLib"
    dependson { "lang", "util", "io", "math" }

project "pix"
	kind "StaticLib"
	dependson { "lang", "io", "libjpeg" }
	includedirs { "external/libjpeg", "%{prj.name}" }

project "id"
    kind "SharedLib"
    dependson { "lang" }
    filter { "system:windows" }
        targetname "%{prj.name}_dx8"
        defines "ID_DX8_EXPORTS"
        includedirs "$(DXSDK_DIR)Include"
        libdirs "$(DXSDK_DIR)Lib\\x86\\"
        links { "dinput8", "dxguid", "lang%{cfg.buildtarget.suffix}" }
        vpaths { ["id_dx8"] = { "%{prj.name}/%{prj.name}_dx8/*.h", "%{prj.name}/%{prj.name}_dx8/*.cpp" } }
        files { "%{prj.name}/%{prj.name}_dx8/*.h", "%{prj.name}/%{prj.name}_dx8/*.cpp" }
        postbuildcommands { "XCOPY \"$(TargetPath)\" ..\\DLL\\ /D /K /Y" }

project "gd"
	kind "SharedLib"
	dependson { "lang", "pix", "math" }
	filter { "system:windows" }
		targetname "%{prj.name}_dx9"
		defines "GD_DX9_EXPORTS"
		filter "action:vs*"
			pchsource "%{prj.name}/%{prj.name}_dx9/StdAfx.cpp"
			pchheader "StdAfx.h"
		includedirs { 
			"$(DXSDK_DIR)Include", 
			"%{prj.name}/%{prj.name}_dx_common",
			"%{prj.name}/%{prj.name}_dx9"
		}
		libdirs "$(DXSDK_DIR)Lib\\x86\\"
		links { 
			"d3d9", "d3dx9",
			"lang%{cfg.buildtarget.suffix}", 
			"pix%{cfg.buildtarget.suffix}", 
			"math%{cfg.buildtarget.suffix}" 
		}
		vpaths { 
			["gd_dx9"] = { "%{prj.name}/%{prj.name}_dx9/*.h", "%{prj.name}/%{prj.name}_dx9/*.cpp" },
			["gd_dx_common"] = { "%{prj.name}/%{prj.name}_dx_common/*.h", "%{prj.name}/%{prj.name}_dx_common/*.cpp" }
		}
		files { 
			"%{prj.name}/%{prj.name}_dx9/*.h", 
			"%{prj.name}/%{prj.name}_dx9/*.cpp",
			"%{prj.name}/%{prj.name}_dx_common/*.h",
			"%{prj.name}/%{prj.name}_dx_common/*.cpp"
		}
		postbuildcommands { "XCOPY \"$(TargetPath)\" ..\\DLL\\ /D /K /Y" }
    
project "sg"
    kind "StaticLib"
    dependson { "lang", "util", "io", "math", "gd", "pix", "anim" }

project "sgu"
    kind "StaticLib"
    dependson { "sg" }

project "dev"
    kind "StaticLib"
    dependson { "lang", "util" }

project "sgviewer"
    kind "WindowedApp"
    targetdir "bin"
    dependson { "sg", "sgu", "dev" }
    flags { "MFC" }
    defines "_AFXDLL"
    links {         
        "lang%{cfg.buildtarget.suffix}",
        "util%{cfg.buildtarget.suffix}",
        "libjpeg%{cfg.buildtarget.suffix}",
        "pix%{cfg.buildtarget.suffix}", 
        "math%{cfg.buildtarget.suffix}",
        "anim%{cfg.buildtarget.suffix}",
        "io%{cfg.buildtarget.suffix}",
        "sg%{cfg.buildtarget.suffix}",
        "sgu%{cfg.buildtarget.suffix}",
        "dev%{cfg.buildtarget.suffix}"
    }
    filter { "system:windows" }
        files { "%{prj.name}/*.rc" }
        postbuildcommands { 
            "XCOPY ..\\DLL\\mem%{cfg.buildtarget.suffix}.dll \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\DLL\\gd_dx9%{cfg.buildtarget.suffix}.dll \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\sgviewer\\arial.bmp \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\sgviewer\\arial.txt \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\sgviewer\\normalize.dds \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\sgviewer\\lightmap.fx \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\sgviewer\\sgviewer.prop \"$(TargetDir)\" /D /K /Y",
            "XCOPY ..\\sgviewer\\sgviewer.reg \"$(TargetDir)\" /D /K /Y"
        }
    filter "action:vs*"
        pchsource "%{prj.name}/StdAfx.cpp"
        pchheader "StdAfx.h"