import os
from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake
from conan.tools.files import copy

class annRecipe(ConanFile):
    name = "ann"
    version = "1.1.2"
    package_type = "shared-library"

    settings = "os", "compiler", "build_type", "arch"
    no_copy_source = True

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

        bt = self.settings.get_safe("build_type")
        self.cpp_info.libs = ["ANNd" if bt == "Debug" else "ANN"]
