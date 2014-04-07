cmake_minimum_required(VERSION 2.8.3)
project(openrtm_aist)

## Find catkin macros and libraries
find_package(catkin REQUIRED mk rostest)

# Compile OpenRTM
# <devel>/lib/<package>/bin/rtcd
# <devel>/lib/libRTC...
# <src>/<package>/share
if(NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/installed)
  execute_process(
    COMMAND cmake -E chdir ${CMAKE_CURRENT_BINARY_DIR}
    make -f ${PROJECT_SOURCE_DIR}/Makefile.openrtm_aist
    INSTALL_DIR=${CATKIN_DEVEL_PREFIX}
    INSTALL_BIN_DIR=${CATKIN_DEVEL_PREFIX}/lib/${PROJECT_NAME}/bin
    INSTALL_DATA_DIR=${PROJECT_SOURCE_DIR}/share
    MK_DIR=${mk_PREFIX}/share/mk
    PATCH_DIR=${PROJECT_SOURCE_DIR}
    MD5SUM_FILE=${PROJECT_SOURCE_DIR}/OpenRTM-aist-1.1.0-RELEASE.tar.gz.md5sum
    VERBOSE=1
    RESULT_VARIABLE _make_failed)
  if (_make_failed)
    message(FATAL_ERROR "Compile openrtm_aist failed: ${_make_failed}")
  endif(_make_failed)
endif()

# ###################################
# ## catkin specific configuration ##
# ###################################

# catkin_package
catkin_package(
)

#############
## Install ##
#############

# ## Mark cpp header files for installation
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/openrtm-1.1
  DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION})
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/include/coil-1.1
  DESTINATION ${CATKIN_GLOBAL_INCLUDE_DESTINATION})
install(
  DIRECTORY ${CATKIN_DEVEL_PREFIX}/lib/openrtm-1.1
            ${CATKIN_DEVEL_PREFIX}/lib/openrtm_aist
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}
  USE_SOURCE_PERMISSIONS)
install(
  PROGRAMS ${CATKIN_DEVEL_PREFIX}/lib/libRTC-1.1.0.so
           ${CATKIN_DEVEL_PREFIX}/lib/libRTC.la
           ${CATKIN_DEVEL_PREFIX}/lib/libRTC.so
           ${CATKIN_DEVEL_PREFIX}/lib/libcoil-1.1.0.so
           ${CATKIN_DEVEL_PREFIX}/lib/libcoil.la
           ${CATKIN_DEVEL_PREFIX}/lib/libcoil.so
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION})
install(
  FILES ${CATKIN_DEVEL_PREFIX}/lib/libRTC.a
        ${CATKIN_DEVEL_PREFIX}/lib/libcoil.a
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION})
install(
  FILES ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/libcoil.pc
        ${CATKIN_DEVEL_PREFIX}/lib/pkgconfig/openrtm-aist.pc
  DESTINATION ${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/)
install(DIRECTORY test share
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}
  USE_SOURCE_PERMISSIONS)

# #debug codes
# #get_cmake_property(_variableNames VARIABLES)
# #foreach (_variableName ${_variableNames})
# #  message(STATUS "${_variableName}=${${_variableName}}")
# #endforeach()
# # CODE to fix path in rtm-config and openrtm-aist.pc
 install(CODE
  "execute_process(COMMAND echo \"fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/bin/rtm-config\")
   execute_process(COMMAND echo \"    ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND echo \"    ${openrtm_aist_SOURCE_DIR} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/bin/rtm-config)
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/bin/rtm-config)
   execute_process(COMMAND sed -i s@${openrtm_aist_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_BIN_DESTINATION}/bin/rtm-config)
   ")


install(CODE
  "execute_process(COMMAND echo \"fix \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/openrtm-aist.pc\")
   execute_process(COMMAND echo \"    ${CATKIN_DEVEL_PREFIX} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND echo \"    ${openrtm_aist_SOURCE_DIR} -> ${CMAKE_INSTALL_PREFIX}\")
   execute_process(COMMAND sed -i s@${CATKIN_DEVEL_PREFIX}@${CMAKE_INSTALL_PREFIX}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/openrtm-aist.pc)
   execute_process(COMMAND sed -i s@${openrtm_aist_SOURCE_DIR}@${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_SHARE_DESTINATION}@g \$ENV{DESTDIR}/${CMAKE_INSTALL_PREFIX}/${CATKIN_PACKAGE_LIB_DESTINATION}/pkgconfig/openrtm-aist.pc)
")

add_rostest(test/test_openrtm_aist.test)
