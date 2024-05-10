# -DAPPLE_PLATFORM=iOS -DCMAKE_TOOLCHAIN_FILE=Apple.cmake

message ("==========Apple.cmake==========")

cmake_minimum_required(VERSION 3.21.0)

set(UNIX True)
set(APPLE True)

if(DEFINED ENV{_APPLE_TOOLCHAIN_HAS_RUN})
  message ("==========Apple.cmake return==========")
  return()
endif()
set(ENV{_APPLE_TOOLCHAIN_HAS_RUN} true)
message ("==========Apple.cmake start==========")