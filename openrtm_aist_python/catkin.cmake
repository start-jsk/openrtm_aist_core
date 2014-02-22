cmake_minimum_required(VERSION 2.8.3)
project(openrtm_aist_python)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED COMPONENTS mk rostest)

# Build openrtm_aist_python
# <devel>/lib/<package>/bin
# <devel>/lib/python2.7/dist-packages
# <src>/<package>/share
if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/installed)
  execute_process(
    COMMAND cmake -E chdir ${CMAKE_CURRENT_BINARY_DIR}
    make -f ${PROJECT_SOURCE_DIR}/Makefile.openrtm_aist_python
    INSTALL_DIR=${CATKIN_DEVEL_PREFIX}
    INSTALL_SCRIPTS_DIR=${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}
    MK_DIR=${mk_PREFIX}/share/mk
    MD5SUM_FILE=${PROJECT_SOURCE_DIR}/OpenRTM-aist-Python-1.1.0-RC1.tar.gz.md5sum
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "Build of OpenRTM Python failed")
  endif(_make_failed)
endif()

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if you package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need
catkin_package(
#  INCLUDE_DIRS include
#  LIBRARIES openrtm_aist_python
#  CATKIN_DEPENDS python-omniorb
#  DEPENDS system_lib
)

#############
## Install ##
#############

# all install targets should use catkin DESTINATION variables
# See http://ros.org/doc/api/catkin/html/adv_user_guide/variables.html

install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/${CATKIN_GLOBAL_PYTHON_DESTINATION}/OpenRTM_aist/
  DESTINATION ${CATKIN_GLOBAL_PYTHON_DESTINATION}/OpenRTM_aist)
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
  USE_SOURCE_PERMISSIONS)
install(
  DIRECTORY test
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS)

#############
## Testing ##
#############

## Add gtest based cpp test target and link libraries
# catkin_add_gtest(${PROJECT_NAME}-test test/test_openrtm_aist_python.cpp)
# if(TARGET ${PROJECT_NAME}-test)
#   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
# endif()

## Add folders to be run by python nosetests
# catkin_add_nosetests(test)

add_rostest(test/test_openrtm_aist_python.test)
