#include <bx/error.h>
#include <bx/file.h>
#include <bx/readerwriter.h>
#include <fmt/format.h>
#include <iostream>

int main() {
  const char *filePath = "screenshot.jpg";

  bx::Error err;
  bx::FileReader reader;
  if (!bx::open(&reader, "screenshot.jpg", &err)) {
    std::cerr << fmt::format("Failed to open input file {}.", filePath)
              << std::endl;
    return bx::kExitFailure;
  }

  uint32_t fileSize = (uint32_t)bx::getSize(&reader);
  if (fileSize == 0) {
    std::cerr << fmt::format("Failed to read input file {}.", filePath)
              << std::endl;
    return bx::kExitFailure;
  }

  std::cout << fmt::format("File: {}, Size: {}", filePath, fileSize)
            << std::endl;


  return 0;
}