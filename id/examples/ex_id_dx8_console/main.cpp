#include <iostream>

#include <lang/DynamicLinkLibrary.h>
#include <lang/Exception.h>
#include <id/InputDriver.h>
#include <id/InputDevice.h>
#include <win/Window.h>

using namespace lang;
using namespace id;
using namespace win;

void run(InputDriver* inputDrv)
{
	int err = inputDrv->create();
	if (err)
		throw Exception(Format("InputDriver create failed"));


	while (Window::flushWindowMessages()) {

		inputDrv->refreshAttachedInputDevices();
		int count = inputDrv->attachedInputDevices();

		std::cout << "Count attached input devices: " << count << std::endl;

	}	
}

int main()
{
	Window* wnd = new Window();

	HINSTANCE hinst = GetModuleHandle(NULL);

	try
	{
		wnd->create("deadjustice_win_test", "deadjustice_win_test", WS_VISIBLE | WS_OVERLAPPEDWINDOW, 0, 0, 0, 640, 480, hinst);

		DynamicLinkLibrary dll("id_dx8");
		createInputDriverFunc createFunc = (createInputDriverFunc)dll.getProcAddress("createInputDriver");
		InputDriver *inputDrv = createFunc();
		run(inputDrv);
		inputDrv = 0;
	}
	catch (Throwable& e)
	{
		// show error message
		char msgText[256];
		char msgTitle[256];
		e.getMessage().format().getBytes(msgText, sizeof(msgText), "ASCII-7");
		std::cout << msgText << std::endl;
		/*sprintf(msgTitle, "%s - Error", "input test");
		e.getMessage().format().getBytes(msgText, sizeof(msgText), "ASCII-7");
		MessageBox(0, msgText, msgTitle, MB_OK | MB_ICONERROR);*/
	}
	
	wnd->destroy();

	return 0;

}
