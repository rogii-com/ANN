import os
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout
from conan.tools.files import copy, collect_libs

class annRecipe(ConanFile):
    name = "ann"
    version = "1.1.2"
    package_type = "shared-library"

    settings = "os", "compiler", "build_type", "arch"
    no_copy_source = True

    def layout(self):
        cmake_layout(self)

    def generate(self):
        tc = CMakeToolchain(self)
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

        local_include_folder = os.path.join(self.source_folder, "include")
        copy(self, "*.h", local_include_folder, os.path.join(self.package_folder, "include"), keep_path=True)

    def package_info(self):
        self.cpp_info.set_property("cmake_file_name", "ANN")
        self.cpp_info.set_property("cmake_target_name", "ANN::library")

        self.cpp_info.libs = collect_libs(self)
