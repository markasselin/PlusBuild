IF(IGSIO_DIR)
  # IGSIO has been built already
  FIND_PACKAGE(IGSIO REQUIRED NO_MODULE)
  MESSAGE(STATUS "Using IGSIO available at: ${IGSIO_DIR}")

  # Copy libraries to CMAKE_RUNTIME_OUTPUT_DIRECTORY
  PlusCopyLibrariesToDirectory(${CMAKE_RUNTIME_OUTPUT_DIRECTORY} ${IGSIO_LIBRARIES})

  SET (PLUS_IGSIO_DIR "${IGSIO_DIR}" CACHE INTERNAL "Path to store IGSIO binaries")
ELSE()

  SetGitRepositoryTag(
    IGSIO
    "${GIT_PROTOCOL}://github.com/IGSIO/IGSIO.git"
    "master"
    )

  SET(PLUS_IGSIO_SRC_DIR ${CMAKE_BINARY_DIR}/Deps/IGSIO CACHE INTERNAL "Path to store IGSIO contents.")
  SET(PLUS_IGSIO_PREFIX_DIR ${CMAKE_BINARY_DIR}/Deps/IGSIO-prefix CACHE INTERNAL "Path to store IGSIO prefix data.")
  SET(PLUS_IGSIO_DIR ${CMAKE_BINARY_DIR}/Deps/IGSIO-bin CACHE INTERNAL "Path to store IGSIO binaries")

  SET(IGSIO_DEPENDENCIES vtk)
  SET(IGSIO_BUILD_OPTIONS
       -DVTK_DIR:PATH=${PLUS_VTK_DIR}
     )

  IF (PLUS_USE_VTKVIDEOIO)
    LIST(APPEND IGSIO_BUILD_OPTIONS
      -DBUILD_VTKVIDEOIO:BOOL=ON  
    )
    IF (PLUS_USE_VTKVIDEOIO_MKV)
      LIST(APPEND IGSIO_BUILD_OPTIONS
          -DVTKVIDEOIO_ENABLE_MKV:BOOL=${PLUS_USE_VTKVIDEOIO_MKV}
          -Dlibwebm_DIR:PATH=${PLUS_libwebm_DIR}
          )
      LIST(APPEND IGSIO_DEPENDENCIES libwebm)
    ENDIF()
  ENDIF()

  ExternalProject_Add( IGSIO
    PREFIX ${PLUS_IGSIO_PREFIX_DIR}
    "${PLUSBUILD_EXTERNAL_PROJECT_CUSTOM_COMMANDS}"
    SOURCE_DIR ${PLUS_IGSIO_SRC_DIR}
    BINARY_DIR ${PLUS_IGSIO_DIR}
    #--Download step--------------
    GIT_REPOSITORY ${IGSIO_GIT_REPOSITORY}
    GIT_TAG ${IGSIO_GIT_TAG}
    #--Configure step-------------
    CMAKE_ARGS
      ${ep_common_args}
      -DEXECUTABLE_OUTPUT_PATH:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_RUNTIME_OUTPUT_DIRECTORY:PATH=${CMAKE_RUNTIME_OUTPUT_DIRECTORY}
      -DCMAKE_LIBRARY_OUTPUT_DIRECTORY:PATH=${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
      -DCMAKE_ARCHIVE_OUTPUT_DIRECTORY:PATH=${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
      -DCMAKE_CXX_FLAGS:STRING=${ep_common_cxx_flags}
      -DCMAKE_C_FLAGS:STRING=${ep_common_c_flags}
      -DBUILD_SHARED_LIBS:BOOL=${PLUSBUILD_BUILD_SHARED_LIBS}
      ${IGSIO_BUILD_OPTIONS}
    #--Build step-----------------
    BUILD_ALWAYS 1
    #--Install step-----------------
    INSTALL_COMMAND ""
    DEPENDS ${IGSIO_DEPENDENCIES}
    )
ENDIF()