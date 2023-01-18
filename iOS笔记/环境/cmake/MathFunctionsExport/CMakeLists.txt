cmake_minimum_required(VERSION 3.10)
project(Test)

add_library(MathFunctions mysqrt.cxx)

message("==========MathFunctions CMakeLists start==========")
message("CMAKE_INSTALL_PREFIX =${CMAKE_INSTALL_PREFIX}")
message("CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT =${CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT}")
message("CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}")


get_target_property(interface_include_dir_before_target_include_directories MathFunctions INTERFACE_INCLUDE_DIRECTORIES)
get_target_property(include_dir_before_target_include_directories MathFunctions INCLUDE_DIRECTORIES)
message("before interface_include_dir_before_target_include_directories=${interface_include_dir_before_target_include_directories}")
message("before include_dir_before_target_include_directories =${include_dir_before_target_include_directories}")


# We first state that anybody linking to MathFunctions needs to include the current source directory, while MathFunctions itself doesn't. So this can become an INTERFACE usage requirement.
# Remember INTERFACE means things that consumers require but the producer doesn't.
# Now that we've specified usage requirements for MathFunctions we can safely remove our uses of the EXTRA_INCLUDES variable from the top-level CMakeLists.txt
# 使用这个命令来改造MathFunctions目录下的CMakeLists.txt，这样就不用在上一级的目录指定包含MathFunctions的目录也能找到该目录下的头文件，这样的好处是只要在上级目录用add_subdirectories()添加对该目录的CMakeLists.txt的处理之后，不需要添加每个需要使用的文件夹，以便能找到头文件。
target_include_directories(MathFunctions INTERFACE 
$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
$<INSTALL_INTERFACE:include/mylib>  # <prefix>/include/mylib
)


get_target_property(interface_include_dir MathFunctions INTERFACE_INCLUDE_DIRECTORIES)
get_target_property(include_dir MathFunctions INCLUDE_DIRECTORIES)
message("after include_dir=${include_dir} interface_include_dir=${interface_include_dir}")
message("==========MathFunctions CMakeLists end==========")


install(TARGETS MathFunctions EXPORT TestMath DESTINATION TestCMake/MathFunctions/lib)
install(EXPORT TestMath NAMESPACE export_ DESTINATION TestCMake/MathFunctions/export)
install(FILES MathFunctions.h DESTINATION TestCMake/MathFunctions/include)