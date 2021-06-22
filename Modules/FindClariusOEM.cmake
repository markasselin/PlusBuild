###############################################################################
# Find Clarius OEM SDK
#
#     find_package(ClariusOEM)
#
# Variables defined by this module:
#
#  ClariusOEM_DIR                  Location of the Clarius OEM SDK
#  ClariusOEM_INCLUDE_DIR          The location(s) of Clarius OEM SDK headers
#  ClariusOEM_LIBRARY_PATH         Path to library needed to use Clarius OEM SDK
#  ClariusOEM_BINARY_PATH          Path to binary needed to use Clarius OEM SDK
#  ClariusOEM_FOUND                True if Clarius OEM SDK was found

# path hints
# since the Clarius binary is too large for PLTools, it should be extracted
# into "../clarius_oem_sdk"
IF(WIN32)
  SET(ClariusOEM_PATH_HINTS
    "../clarius_oem_sdk/"
    )
ELSE()
  MESSAGE(FATAL_ERROR "Clarius OEM SDK is currently only supported on Windows")
ENDIF()

# find path to Clarius OEM SDK dir
FIND_PATH(ClariusOEM_DIR include/oem/oem.h
  PATHS ${ClariusOEM_PATH_HINTS}
  DOC "Clarius OEM SDK dir"
  )


IF(ClariusOEM_DIR)
  
  # set path to Clarius OEM SDK include directory
  SET(ClariusOEM_INCLUDE_DIR ${ClariusOEM_DIR}/include/oem CACHE PATH "Clarius OEM SDK include directory")
  MARK_AS_ADVANCED(ClariusOEM_INCLUDE_DIR)

  # find Clarius OEM SDK library file
  FIND_LIBRARY(ClariusOEM_LIBRARY_PATH
    NAMES oem${CMAKE_STATIC_LIBRARY_SUFFIX}
    PATHS "${ClariusOEM_DIR}/lib" NO_DEFAULT_PATH
    DOC "Clarius OEM SDK library"
    )
  MARK_AS_ADVANCED(ClariusOEM_LIBRARY_PATH)

  # find Clarius OEM SDK binary file
  FIND_FILE(ClariusOEM_BINARY_PATH
    NAMES oem${CMAKE_SHARED_LIBRARY_SUFFIX}
    PATHS "${ClariusOEM_DIR}/lib" NO_DEFAULT_PATH
    DOC "Clarius OEM SDK binary"
    )
  MARK_AS_ADVANCED(ClariusOEM_BINARY_PATH)

ENDIF()


# standard find_package stuff
include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(
  ClariusOEM
  FOUND_VAR ClariusOEM_FOUND
  REQUIRED_VARS ClariusOEM_INCLUDE_DIR ClariusOEM_LIBRARY_PATH ClariusOEM_BINARY_PATH
)


# if library found create ClariusOEM target
IF(ClariusOEM_FOUND)
  ADD_LIBRARY(ClariusOEM SHARED IMPORTED)
  SET_TARGET_PROPERTIES(ClariusOEM PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${ClariusOEM_INCLUDE_DIR}
    IMPORTED_IMPLIB ${ClariusOEM_LIBRARY_PATH}
    IMPORTED_LOCATION ${ClariusOEM_BINARY_PATH}
    )
ENDIF()
