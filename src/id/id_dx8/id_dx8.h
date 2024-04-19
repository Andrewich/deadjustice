// The following ifdef block is the standard way of creating macros which make exporting 
// from a DLL simpler. All files within this DLL are compiled with the ID_DX8_EXPORTS
// symbol defined on the command line. this symbol should not be defined on any project
// that uses this DLL. This way any other project whose source files include this file see 
// ID_DX8_API functions as being imported from a DLL, wheras this DLL sees symbols
// defined with this macro as being exported.

#ifdef ID_DX8_EXPORTS
#define ID_DX8_API extern "C" __declspec(dllexport)
#else
#define ID_DX8_API extern "C" __declspec(dllimport)
#endif


namespace id {
	class InputDriver;}


ID_DX8_API	id::InputDriver*	createInputDriver();
