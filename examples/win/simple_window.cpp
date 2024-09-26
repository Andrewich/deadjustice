#include <SDL2/SDL.h>

#include <win/Window.h>

using namespace win;

int main(int argc, char* argv[])
{
	if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
		return 1;
	}

	SDL_LogSetAllPriority(SDL_LOG_PRIORITY_DEBUG);

	Window wnd;
	wnd.create("simple_window", 0, 0, 640, 480, WindowFlag::shown);

	while (wnd.flushWindowMessages()) {

	}

	SDL_Quit();

	return 0;
}