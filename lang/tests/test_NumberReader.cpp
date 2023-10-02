#include <lang/NumberReader.h>
#include <math.h>
#include <ctype.h>
#include <stdio.h>

int main(int argc, char* argv[])
{
	// 1.23 -1.23 1. 1.e+002 .2e-10 123 3e3 -123
	if (argc > 1)
	{
		int k;

		printf("NumberReader<double>:\n");
		for (k = 1; k < argc; ++k)
		{
			lang::NumberReader<float> rd;
			const char* str = argv[k];
			for (int i = 0; str[i] && rd.put(str[i]); ++i);
			if (rd.valid())
				printf("value %s = %g\n", str, (double)rd.value());
			else
				printf("invalid double value (%s)\n", str);
		}

		printf("NumberReader<int>:\n");
		for (k = 1; k < argc; ++k)
		{
			lang::NumberReader<int> rd;
			const char* str = argv[k];
			for (int i = 0; str[i] && rd.put(str[i]); ++i);
			if (rd.valid())
				printf("value %s = %i\n", str, rd.value());
			else
				printf("invalid int value (%s)\n", str);
		}

		printf("NumberReader<unsigned>:\n");
		for (k = 1; k < argc; ++k)
		{
			lang::NumberReader<unsigned> rd;
			const char* str = argv[k];
			for (int i = 0; str[i] && rd.put(str[i]); ++i);
			if (rd.valid())
				printf("value %s = %u\n", str, rd.value());
			else
				printf("invalid unsigned int value (%s)\n", str);
		}
	}
	getchar();
	return 0;
}