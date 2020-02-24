IF(Franka_DIR)
  # libfranka has been built already
  FIND_PACKAGE(libfranka REQUIRED)

  MESSAGE(STATUS "Using libfranka available at: ${Franka_DIR}")

  # Copy libraries to CMAKE_RUNTIME_OUTPUT_DIRECTORY
  PlusCopyLibrariesToDirectory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY} libfranka)

  SET (PLUS_FRANKA_DIR ${Franka_DIR} CACHE INTERNAL "Path to store libfranka binaries")
ELSE()
  # libfranka has not been built yet, so download and build it as an external project
  SetGitRepositoryTag(
    Franka
    "${GIT_PROTOCOL}://github.com/frankaemika/libfranka.git"
    "develop"
    )

  SET (PLUS_LIBFRANKA_SRC_DIR "${CMAKE_BINARY_DIR}/libfranka")
  SET (PLUS_LIBFRANKA_BIN_DIR "${CMAKE_BINARY_DIR}/libfranka-bin" CACHE INTERNAL "Path to store libfranka binaries")
  SET (PLUS_LIBFRANKA_DIR ${PLUS_LIBFRANKA_BIN_DIR})

  ExternalProject_Add( franka
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    PREFIX "${CMAKE_BINARY_DIR}/libfranka-prefix"
    SOURCE_DIR "${PLUS_LIBFRANKA_SRC_DIR}"
    BINARY_DIR "${PLUS_LIBFRANKA_BIN_DIR}"
    #--Download step--------------
    GIT_REPOSITORY ${Franka_GIT_REPOSITORY}
    GIT_TAG ${Franka_GIT_TAG}
    #--Configure step-------------
    CMAKE_ARGS
      ${ep_common_args}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DBUILD_SHARED_LIBS:BOOL=${PLUSBUILD_BUILD_SHARED_LIBS}
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
      -DBUILD_TESTS:BOOL=OFF
      -DBUILD_EXAMPLES:BOOL=OFF
      -DPoco_DIR:PATH=${PLUS_POCO_DIR}
      -DEigen3_DIR:PATH=${PLUS_EIGEN_DIR}
    #--Build step-----------------
    BUILD_ALWAYS 1
    #--Install step-----------------
    INSTALL_COMMAND ""
    DEPENDS eigen poco
    )
ENDIF()
