#include <iostream>
#include <fmt/core.h>

int main() {
    std::cout << "Hello from Template!\n";
    fmt::print("fmt version: {}\n", FMT_VERSION);
    return 0;
}