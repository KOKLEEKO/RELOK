cmake_minimum_required(VERSION 3.16)

project(
  WordClock
  VERSION 1.2.0
  LANGUAGES CXX)

add_definitions(-DVERSION="${PROJECT_VERSION}" -DTARGET="${PROJECT_NAME}")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

if(${CMAKE_HOST_SYSTEM_PROCESSOR} STREQUAL "arm64")
  set(CMAKE_OSX_ARCHITECTURES "x86_64")
endif()

find_package(QT NAMES Qt5 Qt6)
find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Core LinguistTools Quick
                                                       Svg TextToSpeech Widgets)
set(LINK_LIBRARIES Qt::Core Qt::Quick Qt::Svg Qt::TextToSpeech Qt::Widgets)

if(ANDROID
   OR APPLE
   OR WIN32)
  find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS Purchasing)
  list(APPEND LINK_LIBRARIES Qt::Purchasing)
  if(ANDROID OR IOS)
    find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS WebView)
    list(APPEND LINK_LIBRARIES Qt::WebView)
  endif()
  if(ANDROID)
    find_package(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS AndroidExtras)
    list(APPEND LINK_LIBRARIES Qt::AndroidExtras)
  endif()
endif()

set(INCLUDE_DIRECTORIES src/base src/base/capability src/common)

set(HEADERS
    src/base/AdvertisingManagerBase.h
    src/base/AutoLockManagerBase.h
    src/base/BatteryManagerBase.h
    src/base/ClockLanguageManagerBase.h
    src/base/DeviceAccessBase.h
    src/base/EnergySavingManagerBase.h
    src/base/ManagerBase.h
    src/base/PersistenceManagerBase.h
    src/base/ReviewManagerBase.h
    src/base/ScreenBrightnessManagerBase.h
    src/base/ScreenSizeManagerBase.h
    src/base/ShareContentManagerBase.h
    src/base/SpeechManagerBase.h
    src/base/SplashScreenManagerBase.h
    src/base/TrackingManagerBase.h
    src/base/TranslationManagerBase.h
    src/common/ClockLanguageManager.h
    src/common/DeviceAccessFactory.h
    src/common/PersistenceManager.h
    src/common/TranslationManager.h)

set(SOURCES
    src/base/AdvertisingManagerBase.cpp
    src/base/AutoLockManagerBase.cpp
    src/base/BatteryManagerBase.cpp
    src/base/ClockLanguageManagerBase.cpp
    src/base/DeviceAccessBase.cpp
    src/base/EnergySavingManagerBase.cpp
    src/base/PersistenceManagerBase.cpp
    src/base/ReviewManagerBase.cpp
    src/base/ScreenBrightnessManagerBase.cpp
    src/base/ScreenSizeManagerBase.cpp
    src/base/ShareContentManagerBase.cpp
    src/base/SpeechManagerBase.cpp
    src/base/SplashScreenManagerBase.cpp
    src/base/TrackingManagerBase.cpp
    src/base/TranslationManagerBase.cpp
    src/common/ClockLanguageManager.cpp
    src/common/DeviceAccessFactory.cpp
    src/common/PersistenceManager.cpp
    src/common/TranslationManager.cpp
    src/main.cpp)

file(GLOB RESOURCES res/*.qrc)

file(
  GLOB
  DISTFILES
  .github/PULL_REQUEST_TEMPLATE
  .github/workflows/*
  LICENSE
  README.md
  fastlane/*
  src/README.md)

if(APPLE)
  # https://github.com/OlivierLDff/QtIosCMake/blob/master/AddQtIosApp.cmake
  enable_language(OBJCXX)
  list(APPEND LINK_LIBRARIES "-framework AppKit" "-framework Foundation"
       "-framework StoreKit")
  list(APPEND DISTFILES Gemfile)

  if(IOS)

    list(APPEND INCLUDE_DIRECTORIES src/ios)

    set(OBJECTIVE_HEADERS
        src/ios/AutoLockManager.h
        src/ios/DeviceAccess.h
        src/ios/ReviewManager.h
        src/ios/ScreenBrightnessManager.h
        src/ios/ScreenSizeManager.h
        src/ios/ShareContentManager.h
        src/ios/SpeechManager.h)
    set(OBJECTIVE_SOURCES
        src/ios/AutoLockManager.mm
        src/ios/DeviceAccess.mm
        src/ios/ReviewManager.mm
        src/ios/ScreenBrightnessManager.mm
        src/ios/ScreenSizeManager.mm
        src/ios/ShareContentManager.mm
        src/ios/SpeechManager.mm)

    list(
      APPEND
      HEADERS
      ${OBJECTIVE_HEADERS}
      src/default/AutoLockManager.h
      src/default/BatteryManager.h
      src/default/EnergySavingManager.h
      src/default/ShareContentManager.h
      src/default/SpeechManager.h)
    list(
      APPEND
      SOURCES
      ${OBJECTIVE_SOURCES}
      src/default/AutoLockManager.cpp
      src/default/BatteryManager.cpp
      src/default/EnergySavingManager.cpp
      src/default/ShareContentManager.cpp
      src/default/SpeechManager.cpp)

  elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")

    list(APPEND INCLUDE_DIRECTORIES src/macx)

    set(OBJECTIVE_HEADERS src/macx/DeviceAccess.h src/macx/ReviewManager.h
                          src/macx/ShareContentManager.h)
    set(OBJECTIVE_SOURCES src/macx/DeviceAccess.mm src/macx/ReviewManager.mm
                          src/macx/ShareContentManager.mm)

    list(APPEND HEADERS ${OBJECTIVE_HEADERS} src/default/ShareContentManager.h
         src/default/SpeechManager.h)
    list(APPEND SOURCES ${OBJECTIVE_SOURCES}
         src/default/ShareContentManager.cpp src/default/SpeechManager.cpp)

    # https://doc.qt.io/qt-5/appicon.html#setting-the-application-icon-on-macos
  endif()
elseif(ANDROID)
  # https://github.com/LaurentGomila/qt-android-cmake/blob/master/AddQtAndroidApk.cmake
  list(APPEND INCLUDE_DIRECTORIES src/android)

  list(
    APPEND
    HEADERS
    src/android/AutoLockManager.h
    src/android/DeviceAccess.h
    src/android/ReviewManager.h
    src/android/ScreenBrightnessManager.h
    src/android/ScreenSizeManager.h
    src/android/ShareContentManager.h
    src/android/SpeechManager.h
    src/android/SplashScreenManager.h
    src/default/AutoLockManager.h
    src/default/BatteryManager.h
    src/default/EnergySavingManager.h
    src/default/ShareContentManager.h
    src/default/SpeechManager.h)
  list(
    APPEND
    SOURCES
    src/android/AutoLockManager.cpp
    src/android/DeviceAccess.cpp
    src/android/ReviewManager.cpp
    src/android/ScreenBrightnessManager.cpp
    src/android/ScreenSizeManager.cpp
    src/android/ShareContentManager.cpp
    src/android/SpeechManager.cpp
    src/android/SplashScreenManager.cpp
    src/default/AutoLockManager.cpp
    src/default/BatteryManager.cpp
    src/default/EnergySavingManager.cpp
    src/default/ShareContentManager.cpp
    src/default/SpeechManager.cpp)

  list(
    APPEND
    DISTFILES
    android/AndroidManifest.xml
    android/build.gradle
    android/gradle.properties
    android/gradle/wrapper/gradle-wrapper.jar
    android/gradle/wrapper/gradle-wrapper.properties
    android/gradlew
    android/gradlew.bat
    android/res/values/libs.xml
    android/res/xml/paths.xml
    android/src/io/kokleeko/wordclock/DeviceAccess.java
    android/src/io/kokleeko/wordclock/MyActivity.java)

elseif(CMAKE_SYSTEM_NAME STREQUAL "Emscripten")

  list(APPEND INCLUDE_DIRECTORIES src/wasm)

  list(
    APPEND
    HEADERS
    src/default/AutoLockManager.h
    src/default/BatteryManager.h
    src/default/EnergySavingManager.h
    src/default/ShareContentManager.h
    src/wasm/AutoLockManager.h
    src/wasm/DeviceAccess.h
    src/wasm/ScreenSizeManager.h
    src/wasm/SpeechManager.h)
  list(
    APPEND
    SOURCES
    src/default/AutoLockManager.cpp
    src/default/BatteryManager.cpp
    src/default/EnergySavingManager.cpp
    src/default/ShareContentManager.cpp
    src/wasm/AutoLockManager.cpp
    src/wasm/DeviceAccess.cpp
    src/wasm/ScreenSizeManager.cpp
    src/wasm/SpeechManager.cpp)

else()

  list(APPEND INCLUDE_DIRECTORIES src/default)

  list(APPEND HEADERS src/default/DeviceAccess.h src/default/SpeechManager.h)
  list(APPEND SOURCES src/default/DeviceAccess.cpp
       src/default/SpeechManager.cpp)

endif()

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
  qt_add_executable(${PROJECT_NAME} MANUAL_FINALIZATION ${HEADERS} ${SOURCES}
                    ${RESOURCES} ${DISTFILES})
  if(ANDROID)
    set_property(
      TARGET ${PROJECT_NAME}
      APPEND
      PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
               ${CMAKE_CURRENT_SOURCE_DIR}/android)
  endif()
else()
  if(ANDROID)
    add_library(${PROJECT_NAME} SHARED ${HEADERS} ${SOURCES} ${RESOURCES})
    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
  else()
    add_executable(${PROJECT_NAME} ${HEADERS} ${SOURCES} ${RESOURCES}
                                   ${DISTFILES})
  endif()
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE ${LINK_LIBRARIES})

target_include_directories(${PROJECT_NAME} PRIVATE ${INCLUDE_DIRECTORIES})

set_source_files_properties(${OBJCXX_SOURCES} PROPERTIES LANGUAGE OBJCXX)

if(${QT_VERSION} VERSION_LESS 6.1.0 AND APPLE)
  set(BUNDLE_ID_OPTION MACOSX_BUNDLE_GUI_IDENTIFIER io.kokleeko.${PROJECT_NAME})
endif()
set_target_properties(
  ${PROJECT_NAME}
  PROPERTIES ${BUNDLE_ID_OPTION} MACOSX_BUNDLE_BUNDLE_VERSION
             ${PROJECT_VERSION} MACOSX_BUNDLE_SHORT_VERSION_STRING
             ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR} MACOSX_BUNDLE
             TRUE WIN32_EXECUTABLE
             TRUE)

include(GNUInstallDirs)
install(
  TARGETS ${PROJECT_NAME}
  BUNDLE DESTINATION .
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR})

if(QT_VERSION_MAJOR EQUAL 6)
  qt_import_qml_plugins(${PROJECT_NAME})
  qt_finalize_executable(${PROJECT_NAME})
endif()
