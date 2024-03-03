#ifndef TESTER_TEST_H_
#define TESTER_TEST_H_

#include <functional>

/** Registers a test function. Function prototype is 'int f()'. */
#define TEST_REG( FUNC ) static ::tester::Test s_testReg( FUNC, __FILE__ )


namespace tester
{


/*
 * Registers named test function. 
 * Use by creating a static object to each test cpp file.
 * Test library runs the registered tests from main().
 * @author Jani Kajala (jani.kajala@helsinki.fi)
 * @author Egorov Maxim (abd.andrew@gmail.com)
 */
class Test {
public:
	/**
	 * Test function prototype.
	 */
	using TestFunc = std::function<int()>;	

	/**
	 * Registers named test function.
	 */
	Test( TestFunc func, const char* filename );

	/** Returns number of registered tests. */
	static int			tests();

	/** Returns ith registered test function. */
	static TestFunc		getTestFunc( int i );

	/** Returns ith registered test function filename. */
	static const char*	getTestName( int i );

	/** Returns ith registered test function path. */
	static const char*	getTestPath( int i );

	/** Swaps two tests. */
	static void			swapTests( int i, int j );
};


} // namespace tester


#endif // TESTER_TEST_H_
