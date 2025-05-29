set(${PROJECT_NAME}_COMPAT_VERSION ${${PROJECT_NAME}_VERSION_MAJOR}.${${PROJECT_NAME}_VERSION_MINOR}.0)

set(ITENSOR_PLATFORM lapack)
configure_file(config.h.in config.h @ONLY)

add_library(ITensor SHARED)
set_target_properties(ITensor PROPERTIES OUTPUT_NAME itensor)
if(APPLE)
  set_target_properties(ITensor PROPERTIES LINK_FLAGS
    "-Wl,-compatibility_version,${${PROJECT_NAME}_COMPAT_VERSION} -Wl,-current_version,${${PROJECT_NAME}_VERSION}")
endif()
target_compile_features(ITensor PUBLIC cxx_std_17)
target_sources(ITensor PRIVATE
  util/args.cc util/input.cc util/cputime.cc
  tensor/lapack_wrap.cc tensor/vec.cc tensor/mat.cc tensor/gemm.cc tensor/algs.cc tensor/contract.cc
  itdata/dense.cc itdata/combiner.cc itdata/diag.cc itdata/qdense.cc itdata/qcombiner.cc itdata/qdiag.cc itdata/scalar.cc
  qn.cc tagset.cc index.cc indexset.cc itensor.cc spectrum.cc decomp.cc hermitian.cc svd.cc global.cc
  mps/mps.cc mps/mpsalgs.cc mps/mpo.cc mps/mpoalgs.cc mps/autompo.cc)
target_include_directories(ITensor PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}> $<BUILD_INTERFACE:${PROJECT_BINARY_DIR}> $<INSTALL_INTERFACE:include>)
target_link_libraries(ITensor PUBLIC LAPACK::LAPACK BLAS::BLAS)
if(OpenMP_CXX_FOUND)
  target_compile_definitions(ITensor PUBLIC ITENSOR_USE_OMP)
  target_link_libraries(ITensor PUBLIC OpenMP::OpenMP_CXX)
endif()
add_library(ITensor::ITensor ALIAS ITensor)

install(TARGETS ITensor
  EXPORT itensor-targets
  ARCHIVE LIBRARY)
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/config.h
  DESTINATION include/itensor)
install(DIRECTORY ${PROJECT_SOURCE_DIR}/itensor
  DESTINATION include
  FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp")
install(EXPORT itensor-targets
  NAMESPACE ITensor::
  DESTINATION lib/cmake/itensor)
install(EXPORT itensor-targets
    FILE itensor-config.cmake
    DESTINATION share/cmake/foo/
    EXPORT_LINK_INTERFACE_LIBRARIES)
