#include "System.h"

#ifdef WIN32
   #define WIN32_LEAN_AND_MEAN
   #include <windows.h>
   #pragma warning( disable : 4201 )
   #include <mmsystem.h>
   #pragma comment( lib, "winmm" )
#endif

#include <time.h>
#include "config.h"

//-----------------------------------------------------------------------------

namespace lang
{


long System::currentTimeMillis()
{
#ifdef WIN32

   LARGE_INTEGER freq;
   if ( QueryPerformanceFrequency(&freq) )
   {
      LARGE_INTEGER counter;
      QueryPerformanceCounter( &counter );
      if ( freq.QuadPart >= 1000 )
      {
         // resolution is more than 1ms
         __int64 msDiv = __int64(freq.QuadPart) / __int64(1000);
         __int64 c = __int64(counter.QuadPart) / msDiv;
         return (long)c;
      }
   }

   return timeGetTime();

#else

   timespec time;
   clock_gettime(CLOCK_MONOTONIC, &time);
   double t = (1000000000*time.tv_sec+time.tv_nsec)/1000000;
   return (long)t;

#endif
}


} // lang
