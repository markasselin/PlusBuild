IF(Eigen_DIR)
  # Eigen has been built already
  FIND_PACKAGE(eigen REQUIRED)

  MESSAGE(STATUS "Using eigen available at: ${Eigen_DIR}")

  # Copy libraries to CMAKE_RUNTIME_OUTPUT_DIRECTORY
  PlusCopyLibrariesToDirectory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY} Eigen)

  SET (PLUS_EIGEN_DIR ${Eigen_DIR} CACHE INTERNAL "Path to store eigen binaries")
ELSE()
  # Eigen has not been built yet, so download and build it as an external project
  SetGitRepositoryTag(
    Eigen
    "${GIT_PROTOCOL}://gitlab.com/libeigen/eigen.git"
    "master"
    )

  SET (PLUS_EIGEN_SRC_DIR "${CMAKE_BINARY_DIR}/eigen")
  SET (PLUS_EIGEN_BIN_DIR "${CMAKE_BINARY_DIR}/eigen-bin" CACHE INTERNAL "Path to store poco binaries")
  SET (PLUS_EIGEN_INSTALL_DIR "${CMAKE_BINARY_DIR}/eigen-int" CACHE INTERNAL "Path to install poco")
  SET (PLUS_EIGEN_DIR ${PLUS_EIGEN_INSTALL_DIR}/share/eigen3/cmake)

  ExternalProject_Add( eigen
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    PREFIX "${CMAKE_BINARY_DIR}/eigen-prefix"
    SOURCE_DIR "${PLUS_EIGEN_SRC_DIR}"
    BINARY_DIR "${PLUS_EIGEN_BIN_DIR}"
    INSTALL_DIR "${PLUS_EIGEN_INSTALL_DIR}"
    #--Download step--------------
    GIT_REPOSITORY ${Eigen_GIT_REPOSITORY}
    GIT_TAG ${Eigen_GIT_TAG}
    #--Configure step-------------
    CMAKE_ARGS
      ${ep_common_args}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DBUILD_SHARED_LIBS:BOOL=${PLUSBUILD_BUILD_SHARED_LIBS}
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
      -DCMAKE_INSTALL_PREFIX:PATH=${PLUS_EIGEN_INSTALL_DIR}
      -DBUILD_TESTING:BOOL=OFF
    #--Build step-----------------
    BUILD_ALWAYS 1
    DEPENDS ""
    )
ENDIF()
