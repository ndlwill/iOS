# https://cmake.org/cmake/help/latest/guide/tutorial/index.html

cmake_minimum_required(VERSION 3.10)

project(TestExec)

message("==========Debug Start==========")
message("MACOSX_DEPLOYMENT_TARGET =${MACOSX_DEPLOYMENT_TARGET}")
message("==========Debug End==========")

message("==========TestExec CMakeLists start==========")
# The CMake variable CMAKE_INSTALL_PREFIX is used to determine the root of where the files will be installed.
message("CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}")

message(">>> PROJECT_NAME=${PROJECT_NAME} CMAKE_PROJECT_NAME=${CMAKE_PROJECT_NAME}")

message(">>> PROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR} PROJECT_BINARY_DIR=${PROJECT_BINARY_DIR}")
message(">>> <PROJECT_NAME>_SOURCE_DIR=${${PROJECT_NAME}_SOURCE_DIR}")

message(">>> CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}")
message(">>> CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}")


# ===Specify the C++ Standard===
# Make sure to add the CMAKE_CXX_STANDARD declarations above the call to add_executable.
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

option(USE_MYMATH "Use provided math implementation" ON)

# ===Adding a Configured Header File===
set(VERSION_MAJOR 1)
set(VERSION_MINOR 0)
configure_file(config.h.in config.h)


# To make use of the new library we will add an add_subdirectory() call in the top-level CMakeLists.txt file so that the library will get built.
#add_subdirectory(MathFunctions)
if(USE_MYMATH)
  add_subdirectory(MathFunctions)

  # ===This is a classic approach when dealing with many optional components===
  # Note the use of the variable EXTRA_LIBS to collect up any optional libraries to later be linked into the executable.
  list(APPEND EXTRA_LIBS MathFunctions)
  # The variable EXTRA_INCLUDES is used similarly for optional header files. Step2
  #list(APPEND EXTRA_INCLUDES "${PROJECT_SOURCE_DIR}/MathFunctions")
  # Step3 注释上面的
endif()

message("PROJECT_NAME=${PROJECT_NAME}")
add_executable(${PROJECT_NAME} main.cpp)


get_target_property(include_dir_before_target_include_directories ${PROJECT_NAME} INCLUDE_DIRECTORIES)
message("before include_dir_before_target_include_directories=${include_dir_before_target_include_directories}")
get_target_property(interface_include_dir_before_target_include_directories ${PROJECT_NAME} INTERFACE_INCLUDE_DIRECTORIES)
message("before interface_include_dir_before_target_include_directories=${interface_include_dir_before_target_include_directories}")


# We add the new library(MathFunctions) to the executable
#target_link_libraries(${PROJECT_NAME} PUBLIC MathFunctions)
target_link_libraries(${PROJECT_NAME} PUBLIC ${EXTRA_LIBS}) # Step2


# Specifies include directories to use when compiling a given target. The named <target> must have been created by a command such as add_executable() or add_library() and must not be an ALIAS target.
# Since the configured file will be written into the binary tree, we must add that directory to the list of paths to search for include files. 
# 头文件搜索路径
target_include_directories(${PROJECT_NAME} PUBLIC 
"${PROJECT_BINARY_DIR}"
# "${PROJECT_SOURCE_DIR}/MathFunctions" # add MathFunctions as an include directory so that the mysqrt.h header file can be found.
#${EXTRA_INCLUDES} # Step2
# Step3 注释上面的
)

get_target_property(interface_include_dir ${PROJECT_NAME} INTERFACE_INCLUDE_DIRECTORIES)
get_target_property(include_dir ${PROJECT_NAME} INCLUDE_DIRECTORIES)
message("after include_dir=${include_dir} interface_include_dir=${interface_include_dir}")
message("==========TestExec CMakeLists end==========")

# Installing and Testing (Step 4)
install(TARGETS ${PROJECT_NAME} DESTINATION bin)
install(FILES "${PROJECT_BINARY_DIR}/config.h" DESTINATION include)
# Then run the install step by using the install option of the cmake command (introduced in 3.15, older versions of CMake must use make install) from the command line. 

# ===Build and Test===
# mkdir build && cd build
# cmake ..
# cmake --build .
# ./TestExec
# ./TestExec 111

# Step2
# cmake .. -DUSE_MYMATH=OFF

# Step4
# cmake ..
# cmake --build . # 能生成可执行文件
# cmake --install . # 安装到/usr/local
#-- Installing: /usr/local/bin/TestExec
#-- Installing: /usr/local/include/config.h
#-- Installing: /usr/local/lib/libMathFunctions.a
#-- Installing: /usr/local/include/MathFunctions.h
# Then run the install step by using the install option of the cmake command (introduced in 3.15, older versions of CMake must use make install) from the command line.
# cmake --install . --prefix "/Users/youdone-ndl/cmake_installdir"

# ===Project Commands===
# enable_testing, add_test, set_tests_properties

# ===Testing===
enable_testing()

add_test(NAME Runs COMMAND TestExec 100)

add_test(NAME Usage COMMAND TestExec)
set_tests_properties(Usage PROPERTIES PASS_REGULAR_EXPRESSION "Usage:.*number")

function(do_test target arg result)
  add_test(NAME Comp${arg} COMMAND ${target} ${arg})
  set_tests_properties(Comp${arg} PROPERTIES PASS_REGULAR_EXPRESSION ${result})
endfunction(do_test)

do_test(TestExec 4 "4 is 2")
do_test(TestExec 0.0001 "0.0001 is 0.01")

# ctest -N
# ctest -VV