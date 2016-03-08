cmake_minimum_required(VERSION 3.0.0)

project(JF-Cut)

if(NOT CMAKE_BUILD_TYPE) 
    set(CMAKE_BUILD_TYPE Release)
endif(NOT CMAKE_BUILD_TYPE)

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

find_package(Qt5 COMPONENTS Core Gui
			OpenGL Xml Declarative
			Widgets 
			REQUIRED
			)
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

add_definitions(-DUNICODE
				-DQT_LARGEFILE_SUPPORT
				-D__CL_ENABLE_EXCEPTIONS
				-D__CL_ENABLE_DEBUG_
				-DQT_CORE_LIB
				-DQT_GUI_LIB
				-DQT_DLL
				-DQT_XML_LIB
				-DNOMINMAX
				-DUNIX
				)

SET(CMAKE_INCLUDE_CURRENT_DIR ON)
INCLUDE_DIRECTORIES(${CMAKE_CURRENT_BINARY_DIR})

file(REMOVE_RECURSE ${CMAKE_CURRENT_BINARY_DIR}/cl)

set(SOURCE
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/bench/mfi.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCMain.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCSetting.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QSetting.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.cpp
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
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/call_stack.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/call_stack_msvc.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/call_stack_gcc.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCSetting.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QError.h
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/StackWalker.hpp
  ${CMAKE_CURRENT_SOURCE_DIR}/3rdParty/stacktrace/StackWalker.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QSetting.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QStructure.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.h
  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.h
  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QTransferFunction1D.h
  ${CMAKE_CURRENT_SOURCE_DIR}/templates/QCommon.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QIO.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityCL.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityConsole.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityData.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityGL.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityMath.h
  ${CMAKE_CURRENT_SOURCE_DIR}/utilities/QUtilityUI.h
 )
 
 set(OPENCL_GRAPHCUT_FILES
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

set(OPENCL_INFRASTRUCTURES_FILES
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/Infrastructures/initialization.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/Infrastructures/integration.cl
  ${CMAKE_CURRENT_SOURCE_DIR}/cl/Infrastructures/reduce.cl 
)

QT5_WRAP_CPP(QGCPanel_hdr_moc ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCPanel.h )
qt5_wrap_ui(QGCPanel_ui_moc  ${CMAKE_CURRENT_SOURCE_DIR}/ui/Graph_Cut/QGCPanel.ui)

QT5_WRAP_CPP(QGCVisualizer_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCVisualizer.h)
qt5_wrap_ui(QGCVisualizer_ui_moc  ${CMAKE_CURRENT_SOURCE_DIR}/ui/Graph_Cut/QGCVisualizer.ui)

QT5_WRAP_CPP(QGCWidget_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/Graph_Cut/QGCWidget.h )
QT5_WRAP_CPP(QTransferFunction1D_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QTransferFunction1D.h )
QT5_WRAP_CPP(QProfile_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QProfile.h )
QT5_WRAP_CPP(QHoverPoints_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/infrastructures/QHoverPoints.h )
QT5_WRAP_CPP(QCommon_hdr_moc  ${CMAKE_CURRENT_SOURCE_DIR}/templates/QCommon.h )

LIST(APPEND SOURCE ${QGCPanel_hdr_moc} ${QCommon_hdr_moc}
	${QGCVisualizer_ui_moc} ${QGCPanel_ui_moc}
	${QGCVisualizer_hdr_moc} ${QGCPanel_hdr_moc}
	${QGCWidget_hdr_moc}  ${QTransferFunction1D_hdr_moc}
	${QProfile_hdr_moc} ${QHoverPoints_hdr_moc}
	${QCommon_hdr_moc}
	)

include_directories(${Boost_INCLUDE_DIR}
                    ${OpenCL_INCLUDE_DIRS}
                    ${CLOGS_INCLUDE}
                    ${OPENGL_INCLUDE_DIRS} 
                    ${GLUT_INCLUDE_DIRS}
                    $(GLEW_INCLUDE_DIRS)
                    )

add_executable(test_build
				${SOURCE} ${HEADERS} ${OPENCL_GRAPHCUT_FILES}
				${OPENCL_INFRASTRUCTURES_FILES}
				)
target_link_libraries(test_build
  Qt5::Widgets  Qt5::Xml Qt5::Core Qt5::Gui	Qt5::OpenGL
  Qt5::Xml Qt5::Declarative
  ${GLM_INCLUDE_DIR} ${Boost_LIBRARIES}  ${OpenCL_LIBRARIES}
  ${CLOGS_LIB}/libclogs.so ${OPENGL_LIBRARIES} ${GLUT_LIBRARY}
  ${GLEW_LIBRARIES} dl 
  )
  
set(build_GraphCut_dir ${CMAKE_CURRENT_BINARY_DIR}/cl/GraphCut)
file(MAKE_DIRECTORY ${build_GraphCut_dir})
file(COPY ${OPENCL_GRAPHCUT_FILES} DESTINATION ${build_GraphCut_dir})
  
set(build_Infrastructures_dir ${CMAKE_CURRENT_BINARY_DIR}/cl/Infrastructures)
file(MAKE_DIRECTORY ${build_Infrastructures_dir})
file(COPY ${OPENCL_INFRASTRUCTURES_FILES} DESTINATION ${build_Infrastructures_dir})
