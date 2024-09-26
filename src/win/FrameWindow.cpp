#include <SDL2/SDL.h>
#include "StdAfx.h"
#include "FrameWindow.h"
#include "config.h"

//-----------------------------------------------------------------------------

namespace win
{


FrameWindow::FrameWindow()
{
}

FrameWindow::~FrameWindow()
{
}

void FrameWindow::create(const char* title, int width, int height, bool popup)
{
	// create main window
	WindowFlag flags = WindowFlag::shown;
	if ( popup )
	{
		flags = flags | WindowFlag::popup_menu;
		flags = flags | WindowFlag::always_on_top;
	}

	Window::create(title, 0, 0, width, height, flags);

	if (popup) {
		SDL_ShowCursor(SDL_DISABLE);
	}
}


} // win
