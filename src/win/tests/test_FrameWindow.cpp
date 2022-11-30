#include <win/FrameWindow.h>

//-----------------------------------------------------------------------------

using namespace win;

//-----------------------------------------------------------------------------

static void run( HINSTANCE inst )
{
	char							wndTitle[256]	= "Testing FrameWindow";
	FrameWindow*					wnd				= 0;
	
    // create main window
    wnd = new FrameWindow();

    wnd->create( "wc.deadjustice.catmother", wndTitle,
            640, 480, false, inst );		
    
    while ( Window::flushWindowMessages() )
    {
        
    }
    
    wnd->destroy();	
}

//-----------------------------------------------------------------------------

int WINAPI WinMain( HINSTANCE inst, HINSTANCE, LPSTR /*cmdLine*/, int /*cmdShow*/ )
{
	run( inst );

	return 0;
}
