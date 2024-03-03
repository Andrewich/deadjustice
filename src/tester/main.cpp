#include <iostream>
#include <functional>
#include <filesystem>

int test() {
    return 5;
}

void call(std::function<int()> testFunc) {
    std::cout << "Test: " << testFunc() << std::endl;
}


using namespace std::filesystem;

int main() {
    call(test);

    path current = "./";
    if (exists(current))
        std::cout << "Directory " << current << " exists!" << std::endl;
    
    return 0;
}