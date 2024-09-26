#ifndef _WINDOW_H
#define _WINDOW_H

#include <SDL2/SDL_events.h>
#include <SDL2/SDL_video.h>
#include <lang/Object.h>



namespace win
{

	/**
	* Simple wrapper over SDL_WINDOW flags
	* @author Maxim Egorov (abd.andrew@gmail.com)
	*/
	enum class WindowFlag {
		fullscreen = SDL_WINDOW_FULLSCREEN,
		shown = SDL_WINDOW_SHOWN,
		hidden = SDL_WINDOW_HIDDEN,
		borderless = SDL_WINDOW_BORDERLESS,
		resizable = SDL_WINDOW_RESIZABLE,
		minimized = SDL_WINDOW_MINIMIZED,
		maximized = SDL_WINDOW_MAXIMIZED,
		mouse_grabbed = SDL_WINDOW_MOUSE_GRABBED,
		keyboard_grabbed = SDL_WINDOW_KEYBOARD_GRABBED,
		popup_menu = SDL_WINDOW_POPUP_MENU,
		always_on_top = SDL_WINDOW_ALWAYS_ON_TOP
	};

	WindowFlag operator|(WindowFlag lhs, WindowFlag rhs);
	WindowFlag operator&(WindowFlag lhs, WindowFlag rhs);


	/**
	 * Simple wrapper of SDL2 window.
	 * @author Jani Kajala (jani.kajala@helsinki.fi)
	 * @author Maxim Egorov (abd.andrew@gmail.com)
	 */
	class Window :
		public lang::Object
	{
	public:
		/**
		 * Prepares for window creation.
		 * Use create() to initialize the window.
		 */
		Window();

		/** Destroys the window if not already destroyed. */
		virtual ~Window();

		/**
		 * Creates the window.
		 * @param title Title of the window to be created.
		 * @param x X-coordinate of the top-left corner.
		 * @param y Y-coordinate of the top-left corner.
		 * @param width Width of the window (in pixels).
		 * @param height Height of the window (in pixels).
		 * @param flags Style flags for the window (WindowFlag enum class variants).
		 * @exception Exception
		 *
		 */
		void create(const char* title, int x, int y, int width, int height, WindowFlag flags);

		/** Destroys the window. */
		void	destroy();

		/** Called by default handleMessage() to handle key down events. */
		virtual void handleKeyDown(int key);

		/** Called by default handleMessage() to handle key up events. */
		virtual void handleKeyUp(int key);

		/** Returns true if the window is active. */
		bool active() const;

		/**
		 * Flushes window message queue.
		 * @return false if application quit was requested.
		 */
		bool flushWindowMessages();

	protected:
		virtual void handleMessage(SDL_Event& event);

	private:
		SDL_Window* m_window;
		bool	m_active;

		Window(const Window&);
		Window& operator=(const Window&);
	};


} // win


#endif // _WINDOW_H
