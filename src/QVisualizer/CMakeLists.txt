cmake_minimum_required(VERSION 3.0.0)

project(JF-Cut)


include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
#elseif(COMPILER_SUPPORTS_CXX0X)
#	set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
        message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()


set(FIND_GLM ./FindGLM.cmake)

# Find the QtWidgets library
find_package(OpenCL REQUIRED)
find_package(OpenGL REQUIRED)
#find_package(GLM REQUIRED)
#include_directories(${GLM_INCLUDE_DIRS})
#link_directories(${GLM_LIBRARY_DIRS})
#add_definitions(${GLM_DEFINITIONS})

find_package(Qt5 COMPONENTS OpenGL Xml Gui Declarative Widgets  REQUIRED)
find_package(GLEW REQUIRED )
find_package(Boost COMPONENTS system)

#FIND_PATH(GLM_INCLUDE_DIR /usr/include)

# Interoperation with clogs
option(CLOGS " use clogs algorithms " OFF)
if (CLOGS)
  find_path(CLOGS_INCLUDE clogs/clogs.h)
  find_library(CLOGS_LIB clogs)
  include_directories(${CLOGS_INCLUDE})
  add_definitions(-DHAVE_CLOGS)
endif()

#set(CMAKE_AUTOMOC ON)
#SET(CMAKE_AUTOUIC ON)

SET(CMAKE_INCLUDE_CURRENT_DIR ON)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})

set(SOURCE
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bench/mfi.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/call_stack_gcc.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/StackWalker.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCMain.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCSetting.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QSetting.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QTransferFunction1D.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/templates/QCommon.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QIO.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityCL.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityConsole.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityData.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityGL.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityMath.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityUI.cpp

)
set(HEADERS
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bench/mfi.h
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/cl/cl_stacktrace.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/call_stack_msvc.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/call_stack.h # this is a new addition
  
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/StackWalker.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCSetting.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QError.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QSetting.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QStructure.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QTransferFunction1D.h
  ${CMAKE_CURRENT_SOURCE_DIR}/templates/QCommon.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QIO.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityCL.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityConsole.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityData.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityGL.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityMath.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityUI.h
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_bfs_block.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_compute_capacity.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_compute_cut.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_compute_excessflow.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_compute_flow.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_compute_tag.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_count_block.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_global_relabel.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_histogram.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_kmeans.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_push_relabel.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_push_relabel_fast.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_render_ray_casting.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_render_ray_casting_feature.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/GraphCut/graphcut_render_ray_casting_preint.cl
)

Set (UI_FILES
	${CMAKE_CURRENT_SOURCE_DIR}/ui/Graph_Cut/QGCPanel.ui
	${CMAKE_CURRENT_SOURCE_DIR}/ui/Graph_Cut/QGCVisualizer.ui
	)


QT5_WRAP_CPP(QGCPanel_hdr_moc ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.h )
qt5_wrap_ui(QGCPanel_ui_moc  ${CMAKE_CURRENT_SOURCE_DIR}/ui/Graph_Cut/QGCPanel.ui)

QT5_WRAP_CPP(QGCVisualizer_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.h )
qt5_wrap_ui(QGCVisualizer_ui_moc  ${CMAKE_CURRENT_SOURCE_DIR}/ui/Graph_Cut/QGCVisualizer.ui)

#QT5_WRAP_CPP(QGCSetting_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCSetting.h )
QT5_WRAP_CPP(QGCWidget_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.h )
QT5_WRAP_CPP(QTransferFunction1D_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QTransferFunction1D.h )
QT5_WRAP_CPP(QProfile_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.h )
QT5_WRAP_CPP(QHoverPoints_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.h )

QT5_WRAP_CPP(QCommon_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/templates/QCommon.h )


add_library(QGCPanel
			${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.cpp
			${QGCPanel_ui_moc})
target_link_libraries(QGCPanel Qt5::Widgets Qt5::OpenGL ${QGCPanel_hdr_moc})

add_library(QGCVisualizer
			${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.cpp
			${QGCVisualizer_ui_moc} )
target_link_libraries(QGCVisualizer  Qt5::Widgets Qt5::OpenGL ${QGCVisualizer_hdr_moc})

add_library(QGCSetting ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCSetting.cpp)
target_link_libraries(QGCSetting  Qt5::Widgets ${QGCSetting_hdr_moc})

add_library(QGCWidget ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.cpp)
target_link_libraries(QGCWidget Qt5::Widgets ${QGCWidget_hdr_moc})

add_library(QTransferFunction1D ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QTransferFunction1D.cpp)
target_link_libraries(QTransferFunction1D  Qt5::Widgets ${QTransferFunction1D_hdr_moc})

add_library(QProfile ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.cpp)
target_link_libraries(QProfile  Qt5::Widgets ${QProfile_hdr_moc})

add_library(QHoverPoints ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.cpp)
target_link_libraries(QHoverPoints  Qt5::Widgets ${QHoverPoints_hdr_moc})

add_library(QCommon ${CMAKE_CURRENT_SOURCE_DIR}/templates/QCommon.cpp)
target_link_libraries(QCommon Qt5::Gui Qt5::Widgets ${QCommon_hdr_moc} ${OpenCL_LIBRARIES})

include_directories(${Boost_INCLUDE_DIR} ${OpenCL_INCLUDE_DIRS} ${CLOGS_INCLUDE})
add_executable(test_build ${SOURCE} ${HEADERS}
				${QGCVisualizer_ui_moc}
				${QGCPanel_ui_moc})
target_link_libraries(test_build
  Qt5::Widgets Qt5::Gui Qt5::Xml 
  GLM_INCLUDE_DIR ${Boost_LIBRARIES}  ${OpenCL_LIBRARIES}
  ${QGCVisualizer} ${QGCPanel} ${QGCSetting} ${QGCWidget}
  ${QTransferFunction1D}  ${QProfile} ${QHoverPoints}  ${QCommon}
  ${CLOGS_LIB}
  )
