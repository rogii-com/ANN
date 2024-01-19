from conan import ConanFile
from conan.tools.cmake import CMakeToolchain, CMake, cmake_layout
from conan.tools.files import copy, collect_libs
from conan.tools.scm import Git
from pathlib import Path
import os, sys


class PkgConanRecipe(ConanFile):
    name = "ann"
    #version = "1.1.2"
    package_version= "1.1.2"

    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False], "fPIC": [True, False]}
    default_options = {"shared": True, "fPIC": True}

    # exports_sources = "include/*"
    no_copy_source = True
    required_conan_version = ">=2.0"

    def config_options(self):
        if self.settings.os == "Windows":
            del self.options.fPIC

    def layout(self):
        cmake_layout(self)

    def generate(self):
        tc = CMakeToolchain(self)
        tc.generate()

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def _split_debug_info(self):
        if self.settings.compiler == "gcc":
            script_path=f"{self.recipe_folder}/rogii/utils/split_debug_info.sh"
            self.run(f"chmod u+x {script_path}")
            for path in Path(self.package_folder).rglob('*.so'):
                self.run(f"bash -c '{script_path} {path.absolute()}'")

    def package(self):
        cmake = CMake(self)
        cmake.install()

        local_include_folder = os.path.join(self.source_folder, self.cpp.source.includedirs[0])
        local_lib_folder = os.path.join(self.build_folder, self.cpp.build.libdirs[0])
        copy(self, "*.h", local_include_folder, os.path.join(self.package_folder, "include/ANN"), keep_path=False)
        self._split_debug_info()

    # def validate(self):
    #     if self.settings.compiler.version != "12":
    #         raise ConanInvalidConfiguration("Compiler not supported")

    def set_version(self):
        #git = Git(self)
        #self.version = "%s-%s_%s" % (self.package_version, git.run("rev-parse --abbrev-ref HEAD"), git.run("rev-parse --short HEAD"))
        self.version = "%s-%s_%s" % (self.package_version, os.environ['BRANCH'],os.environ['BUILD_NUMBER'])

    def package_info(self):
        self.cpp_info.libs = ["ANN"]
        self.cpp_info.includedirs = ["include"]
        self.cpp_info.libdirs = ["bin", "lib"]

        # self.cpp_info.set_property("cmake_file_name", "ANN")
        # self.cpp_info.set_property("cmake_target_name", "ANN::ANN")
        # self.cpp_info.names["cmake_find_package"] = "ANN"
        # self.cpp_info.names["cmake_find_package_multi"] = "ANN"

        #self.cpp_info.libs = ["ANNd"]
        #self.cpp_info.libs=collect_libs(self)
        #print(collect_libs(self))
        #self.info.clear()  # header-only