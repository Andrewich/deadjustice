from conan import ConanFile
import os
from conan.tools.cmake import CMakeToolchain, CMakeDeps
from conan.tools.files import replace_in_file

class DeadJusticeRecipe(ConanFile):
    settings = "os", "compiler", "build_type", "arch"

    def requirements(self):
        self.requires("sdl/2.30.7")
        self.requires("bimg/cci.20230114")
        self.requires("fmt/11.0.2")

    def generate(self):
        tc = CMakeToolchain(self)
        tc.generate()

        td = CMakeDeps(self)
        td.generate()
