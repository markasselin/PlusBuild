IF(Poco_DIR)
  # Poco has been built already
  FIND_PACKAGE(Poco REQUIRED)

  MESSAGE(STATUS "Using Poco available at: ${Poco_DIR}")

  # Copy libraries to CMAKE_RUNTIME_OUTPUT_DIRECTORY
  PlusCopyLibrariesToDirectory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY} Poco)

  SET (PLUS_POCO_DIR ${Poco_DIR} CACHE INTERNAL "Path to store poco binaries")
ELSE()
  # Poco has not been built yet, so download and build it as an external project
  SetGitRepositoryTag(
    Poco
    "${GIT_PROTOCOL}://github.com/pocoproject/poco.git"
    "poco-1.10.1-release"
    )

  SET (PLUS_POCO_SRC_DIR "${CMAKE_BINARY_DIR}/poco")
  SET (PLUS_POCO_BIN_DIR "${CMAKE_BINARY_DIR}/poco-bin" CACHE INTERNAL "Path to store poco binaries")
  SET (PLUS_POCO_DIR ${PLUS_POCO_BIN_DIR}/Poco)

  ExternalProject_Add( poco
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    PREFIX "${CMAKE_BINARY_DIR}/poco-prefix"
    SOURCE_DIR "${PLUS_POCO_SRC_DIR}"
    BINARY_DIR "${PLUS_POCO_BIN_DIR}"
    #--Download step--------------
    GIT_REPOSITORY ${Poco_GIT_REPOSITORY}
    GIT_TAG ${Poco_GIT_TAG}
    #--Configure step-------------
    CMAKE_ARGS
     ${ep_common_args}
     -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
     -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
     -DBUILD_SHARED_LIBS:BOOL=${PLUSBUILD_BUILD_SHARED_LIBS}
     -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
     -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
     -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
    #--Build step-----------------
    BUILD_ALWAYS 1
    #--Install step-----------------
    INSTALL_COMMAND ""
    DEPENDS ""
    )
ENDIF()
