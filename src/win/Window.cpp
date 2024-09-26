#include <type_traits>
#include <SDL2/SDL.h>
#include "StdAfx.h"
#include "Window.h"
#include <lang/Exception.h>

//-----------------------------------------------------------------------------

using namespace lang;

//-----------------------------------------------------------------------------

namespace win
{

	WindowFlag operator|(WindowFlag lhs, WindowFlag rhs) {
		return static_cast<WindowFlag>(
			static_cast<std::underlying_type_t<WindowFlag>>(lhs) |
			static_cast<std::underlying_type_t<WindowFlag>>(rhs)
			);
	}

	WindowFlag operator&(WindowFlag lhs, WindowFlag rhs) {
		return static_cast<WindowFlag>(
			static_cast<std::underlying_type_t<WindowFlag>>(lhs) &
			static_cast<std::underlying_type_t<WindowFlag>>(rhs)
			);
	}

	Window::Window() :
		m_window(nullptr), m_active(false)
	{
	}

	Window::~Window()
	{
		destroy();
	}

	void Window::create(const char* title, int x, int y, int width, int height, WindowFlag flags) {
		const Uint32 subsystem_mask = SDL_INIT_VIDEO | SDL_INIT_EVENTS;
		if (SDL_WasInit(subsystem_mask) != subsystem_mask) {
			throw Exception(Format("SDL2 subsystems VIDEO and EVENTS are not initialized."));
		}

		const Uint32 window_flags = static_cast<std::underlying_type_t<WindowFlag>>(flags);
		m_window = SDL_CreateWindow(title, SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, width, height, window_flags);
		if (!m_window) {
			throw Exception(Format("Failed to create a window."));
		}
	}

	void Window::destroy()
	{
		if (m_window != nullptr) {
			SDL_DestroyWindow(m_window);
			m_window = nullptr;
		}
	}

	bool Window::flushWindowMessages()
	{
		SDL_Event event;

		SDL_PollEvent(&event);

		handleMessage(event);

		return event.type != SDL_QUIT;
	}

	void Window::handleMessage(SDL_Event& event)
	{
		switch (event.type)
		{
		case SDL_KEYDOWN:
			handleKeyDown(event.key.keysym.sym);
			break;

		case SDL_KEYUP:
			handleKeyUp(event.key.keysym.sym);
			break;

		case SDL_WINDOWEVENT:
		{
			switch (event.window.event)
			{
			case SDL_WINDOWEVENT_FOCUS_GAINED:
			{
				m_active = true;
				if (m_window != nullptr) {
					SDL_LogDebug(SDL_LOG_CATEGORY_APPLICATION, "Window \"%s\" %s\n", SDL_GetWindowTitle(m_window), "activated");
				}
			}
			break;

			case SDL_WINDOWEVENT_FOCUS_LOST:
			{
				m_active = false;
				if (m_window != nullptr) {
					SDL_LogDebug(SDL_LOG_CATEGORY_APPLICATION, "Window \"%s\" %s\n", SDL_GetWindowTitle(m_window), "deactivated");
				}
			}
			break;

			case SDL_WINDOWEVENT_CLOSE:
				break;
			}
		}
		break;
		}
	}

	void Window::handleKeyDown(int)
	{
	}

	void Window::handleKeyUp(int)
	{
	}

	bool Window::active() const
	{
		return m_active;
	}


} // win
