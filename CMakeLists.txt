cmake_minimum_required(VERSION 3.15)
project(ITensor VERSION 3.2.0 LANGUAGES CXX)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()
enable_testing()

option(ITENSOR_USE_OPENMP "itensor use openmp (this could compete with blas/lapack multithreading)" OFF)

find_package(LAPACK REQUIRED)
if(ITENSOR_USE_OPENMP)
  find_package(OpenMP REQUIRED)
endif()

add_subdirectory(itensor)
if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
  add_subdirectory(sample)
endif()
install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/tutorial
  DESTINATION share/itensor
  FILES_MATCHING PATTERN "*.txt" PATTERN "*.cc" PATTERN "*.h" PATTERN "inputfile_*")
