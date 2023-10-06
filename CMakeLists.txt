cmake_minimum_required(VERSION 3.5)
PROJECT(ZED_Apps)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
SET(CMAKE_BUILD_TYPE "Release")

option(LINK_SHARED_ZED "Link with the ZED SDK shared executable" ON)

if (NOT LINK_SHARED_ZED AND MSVC)
    message(FATAL_ERROR "LINK_SHARED_ZED OFF : ZED SDK static libraries not available on Windows")
endif()

find_package(ZED 3 REQUIRED)
find_package(CUDA ${ZED_CUDA_VERSION} REQUIRED)
find_package(OpenCV REQUIRED)
find_package(GLUT REQUIRED)
find_package(GLEW REQUIRED)
SET(OpenGL_GL_PREFERENCE GLVND)
find_package(OpenGL REQUIRED)

include_directories(${OpenCV_INCLUDE_DIRS})
include_directories(${ZED_INCLUDE_DIRS})
include_directories(${GLEW_INCLUDE_DIRS})
include_directories(${GLUT_INCLUDE_DIR})
include_directories(${CUDA_INCLUDE_DIRS})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/include/SHARED)

link_directories(${ZED_LIBRARY_DIR})
link_directories(${GLEW_LIBRARY_DIRS})
link_directories(${GLUT_LIBRARY_DIRS})
link_directories(${OpenGL_LIBRARY_DIRS})
link_directories(${CUDA_LIBRARY_DIRS})
link_directories(${OpenCV_LIBRARY_DIRS})

# Common files
FILE(GLOB_RECURSE COMMON_HDR_FILES include/SHARED/*.h*)
FILE(GLOB_RECURSE COMMON_SRC_FILES src/SHARED/*.c*)

# BodyTracking 
FILE(GLOB_RECURSE BODYTRACKING_SRC_FILES src/BodyTracking/*.c*)
FILE(GLOB_RECURSE BODYTRACKING_HDR_FILES include/BodyTracking/*.h*)
add_executable(BodyTracking ${COMMON_HDR_FILES} ${BODYTRACKING_HDR_FILES} ${BODYTRACKING_SRC_FILES} ${COMMON_SRC_FILES})

# ImageViewer
FILE(GLOB_RECURSE IMAGEVIEWER_SRC_FILES src/ImageViewer/*.c*)
FILE(GLOB_RECURSE IMAGEVIEWER_HDR_FILES include/ImageViewer/*.h*)
add_executable(ImageViewer ${COMMON_HDR_FILES} ${IMAGEVIEWER_HDR_FILES} ${IMAGEVIEWER_SRC_FILES} ${COMMON_SRC_FILES})

if (LINK_SHARED_ZED)
    SET(ZED_LIBS ${ZED_LIBRARIES} ${CUDA_CUDA_LIBRARY} ${CUDA_CUDART_LIBRARY} ${CUDA_DEP_LIBRARIES_ZED})
else()
    SET(ZED_LIBS ${ZED_STATIC_LIBRARIES} ${CUDA_CUDA_LIBRARY} ${CUDA_LIBRARY})
endif()

target_link_libraries(BodyTracking
                    ${ZED_LIBS}
                    ${OPENGL_LIBRARIES}
                    ${GLUT_LIBRARY}
                    ${OpenCV_LIBRARIES}
                    ${GLEW_LIBRARIES}
)

target_link_libraries(ImageViewer
                    ${ZED_LIBS}
                    ${OPENGL_LIBRARIES}
                    ${GLUT_LIBRARY}
                    ${OpenCV_LIBRARIES}
                    ${GLEW_LIBRARIES}
)

if(INSTALL_SAMPLES)
    LIST(APPEND SAMPLE_LIST ${PROJECT_NAME})
    SET(SAMPLE_LIST "${SAMPLE_LIST}" PARENT_SCOPE)
endif()