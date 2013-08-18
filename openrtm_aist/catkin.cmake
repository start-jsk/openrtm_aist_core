cmake_minimum_required(VERSION 2.8.3)
project(openrtm_aist)

## Find catkin macros and libraries
## if COMPONENTS list like find_package(catkin REQUIRED COMPONENTS xyz)
## is used, also find other catkin packages
find_package(catkin REQUIRED)

# Build OpenRTM
execute_process(COMMAND cmake -E chdir ${PROJECT_SOURCE_DIR} make -f Makefile.openrtm_aist
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Build of openrtm_aist failed")
endif(_make_failed)
execute_process(COMMAND cmake -E copy_directory ${PROJECT_SOURCE_DIR}/bin ${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/bin # force copy under devel for catkin_package
                RESULT_VARIABLE _make_failed)
if (_make_failed)
  message(FATAL_ERROR "Post build of openrtm_aist failed")
endif(_make_failed)

## System dependencies are found with CMake's conventions
# find_package(Boost REQUIRED COMPONENTS system)


## Uncomment this if the package has a setup.py. This macro ensures
## modules and global scripts declared therein get installed
## See http://ros.org/doc/api/catkin/html/user_guide/setup_dot_py.html
# catkin_python_setup()

#######################################
## Declare ROS messages and services ##
#######################################

## Generate messages in the 'msg' folder
# add_message_files(
#   FILES
#   Message1.msg
#   Message2.msg
# )

## Generate services in the 'srv' folder
# add_service_files(
#   FILES
#   Service1.srv
#   Service2.srv
# )

## Generate added messages and services with any dependencies listed here
# generate_messages(
#   DEPENDENCIES
#   std_msgs  # Or other packages containing msgs
# )

###################################
## catkin specific configuration ##
###################################
## The catkin_package macro generates cmake config files for your package
## Declare things to be passed to dependent projects
## INCLUDE_DIRS: uncomment this if you package contains header files
## LIBRARIES: libraries you create in this project that dependent projects also need
## CATKIN_DEPENDS: catkin_packages dependent projects also need
## DEPENDS: system dependencies of this project that dependent projects also need

# fake add_library for catkin_package
add_library(RTC  SHARED)
add_library(coil SHARED)
set_target_properties(RTC  PROPERTIES LINKER_LANGUAGE C)
set_target_properties(coil PROPERTIES LINKER_LANGUAGE C)
add_custom_command(OUTPUT lib/libRTC.so
  COMMAND cmake -E copy ${PROJECT_SOURCE_DIR}/lib/libRTC.so  ${CATKIN_DEVEL_PREFIX}/lib/libRTC.so)
add_custom_target(copy_openrtm_aist_RTC ALL DEPENDS lib/libRTC.so)
add_custom_command(OUTPUT lib/libcoil.so
  COMMAND cmake -E copy ${PROJECT_SOURCE_DIR}/lib/libcoil.so  ${CATKIN_DEVEL_PREFIX}/lib/libcoil.so)
add_custom_target(copy_openrtm_aist_coil ALL DEPENDS lib/libcoil.so)
#add_library(RTC  SHARED IMPORTED)
#add_library(coil SHARED IMPORTED)
#set_target_properties(RTC  PROPERTIES IMPORTED_IMPLIB ${PROJECT_SOURCE_DIR}/lib/libRTC.so )
#set_target_properties(coil PROPERTIES IMPORTED_IMPLIB ${PROJECT_SOURCE_DIR}/lib/libcoil.so)

find_package(PkgConfig REQUIRED)
pkg_check_modules(omniorb REQUIRED omniORB4)
pkg_check_modules(omnidynamic REQUIRED omniDynamic4)
# copy from rtm-config --cflags and rtm-config --libs
catkin_package(
  DEPENDS omniorb omnidynamic
  INCLUDE_DIRS include include/coil-1.1 include/openrtm-1.1 include/openrtm-1.1/rtm/idl
  LIBRARIES RTC coil
)

###########
## Build ##
###########

## Specify additional locations of header files
## Your package locations should be listed before other locations
# include_directories(include)
include_directories(
  ${catkin_INCLUDE_DIRS}
)

## Declare a cpp library
# add_library(openrtm_tools
#   src/${PROJECT_NAME}/openrtm_tools.cpp
# )

## Declare a cpp executable
# add_executable(openrtm_tools_node src/openrtm_tools_node.cpp)

## Add cmake target dependencies of the executable/library
## as an example, message headers may need to be generated before nodes
# add_dependencies(openrtm_tools_node openrtm_tools_generate_messages_cpp)

## Specify libraries to link a library or executable target against
# target_link_libraries(openrtm_tools_node
#   ${catkin_LIBRARIES}
# )

#############
## Install ##
#############

# all install targets should use catkin DESTINATION variables
# See http://ros.org/doc/api/catkin/html/adv_user_guide/variables.html

## Mark executable scripts (Python etc.) for installation
## in contrast to setup.py, you can choose the destination
# install(PROGRAMS
#   scripts/my_python_script
#   DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark executables and/or libraries for installation
# install(TARGETS openrtm_tools openrtm_tools_node
#   ARCHIVE DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   LIBRARY DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
#   RUNTIME DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}
# )

## Mark cpp header files for installation
install(DIRECTORY include
  DESTINATION ${CATKIN_PACKAGE_INCLUDE_DESTINATION}
)

# bin goes lib/openrtm_aist so that it can be invoked from rosrun
install(DIRECTORY bin
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}/${PROJECT_NAME}
  USE_SOURCE_PERMISSIONS  # set executable
)

#debug codes
get_cmake_property(_variableNames VARIABLES)
foreach (_variableName ${_variableNames})
  message(STATUS "${_variableName}=${${_variableName}}")
endforeach()
# CODE to fix path in rtm-config
install(CODE
 "execute_process(COMMAND echo \"post process...\")
  execute_process(COMMAND echo \" fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/${PROJECT_NAME}/bin/rtm-config\")
  execute_process(COMMAND echo \" sed s@${openrtm_aist_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME}@g\")
  execute_process(COMMAND sed -i s@${openrtm_aist_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/${PROJECT_NAME}/bin/rtm-config) # basic
  execute_process(COMMAND sed -i s@exec_prefix=@exec_prefix=\"${CMAKE_INSTALL_PREFIX}\"\\ \\\#@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/${PROJECT_NAME}/bin/rtm-config) # for -cflags
  ")


install(DIRECTORY etc
  DESTINATION ${CATKIN_PACKAGE_ETC_DESTINATION}
)

install(DIRECTORY lib/ # lib will create devel/lib/lib/*, so lib/ is important
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  USE_SOURCE_PERMISSIONS  # set executable
)
# remove catkin generate openrtm_aist.pc
install(CODE
  "execute_process(COMMAND echo \"use openrtm-asit.pc provided by OpenRTM, openrtm_aist.pc is provided catkin.pc and do not use this\")
   #execute_process(COMMAND cmake -E remove -f $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/openrtm_aist.pc)
   #execute_process(COMMAND cmake -E create_symlink openrtm-aist.pc $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/openrtm_aist.pc)
   execute_process(COMMAND sed -i s@${openrtm_aist_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/include/${PROJECT_NAME}@g $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/openrtm-aist.pc) # basic
   execute_process(COMMAND sed -i s@exec_prefix=@exec_prefix=${CMAKE_INSTALL_PREFIX}\\ \\\#@g $ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/lib/pkgconfig/openrtm-aist.pc) # for -cflags
")

install(DIRECTORY share
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
)

## Mark other files for installation (e.g. launch and bag files, etc.)
# install(FILES
#   # myfile1
#   # myfile2
#   DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
# )

#############
## Testing ##
#############

## Add gtest based cpp test target and link libraries
# catkin_add_gtest(${PROJECT_NAME}-test test/test_openrtm_tools.cpp)
# if(TARGET ${PROJECT_NAME}-test)
#   target_link_libraries(${PROJECT_NAME}-test ${PROJECT_NAME})
# endif()

## Add folders to be run by python nosetests
# catkin_add_nosetests(test)

