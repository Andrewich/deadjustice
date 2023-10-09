#include <win/Window.h>

using namespace win;

int WINAPI WinMain(
	_In_ HINSTANCE hInstance,
	_In_opt_ HINSTANCE hPrevInstance,
	_In_ LPSTR     lpCmdLine,
	_In_ int       nCmdShow
) {
	Window *wnd = new Window();

	wnd->create("deadjustice_win_test", "deadjustice_win_test", WS_VISIBLE | WS_OVERLAPPEDWINDOW, 0, 0, 0, 640, 480, hInstance);

	while (Window::flushWindowMessages()) {

	}

	wnd->destroy();

	return 0;
}