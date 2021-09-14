#include <iostream>
#include "config.h"
#ifdef USE_MYMATH
    #include "MathFunctions.h"
#endif

int main(int argc, char** argv)
{
    if (argc < 2) {
    std::cout << argv[0] << " Version " << VERSION_MAJOR << "."
              << VERSION_MINOR << std::endl;
    std::cout << "Usage: " << argv[0] << " number" << std::endl;
    return 1;
    }

    const double inputValue = std::stod(argv[1]);
    std::cout << inputValue << std::endl;
#ifdef USE_MYMATH
    const double outputValue = mysqrt(inputValue);
#else
    const double outputValue = sqrt(inputValue);
#endif
    std::cout << inputValue << " is " << outputValue << std::endl;

    std::cout << "hello, world!" << std::endl;
    return 0;
}
