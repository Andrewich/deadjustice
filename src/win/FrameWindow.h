#ifndef _WIN_FRAMEWINDOW_H
#define _WIN_FRAMEWINDOW_H


#include <win/Window.h>


namespace win
{


/** 
 * Base class for application main window. 
 * @author Jani Kajala (jani.kajala@helsinki.fi)
 * @author Maxim Egorov (abd.andrew@gmail.com)
 */
class FrameWindow :
	public win::Window
{
public:
	///
	FrameWindow();

	///
	~FrameWindow();

	/** 
	 * Creates the main window.
	 * @param title Title of the window to be created.
	 * @param width Width (in pixels) of the window to be created.
	 * @param height Height (in pixels) of the window to be created.
	 * @param popup If true then create borderless topmost popup window.
	 * @exception Exception
	 */
	void create(const char* title, int width, int height, bool popup);

private:
	FrameWindow( const FrameWindow& );
	FrameWindow& operator=( const FrameWindow& );
};


} // win


#endif // _WIN_FRAMEWINDOW_H
