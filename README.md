# conan-demo

## English

This project demonstrates how to use Conan to compile and run code.

### Prerequisites

- [Conan](https://conan.io/)
- [CMake](https://cmake.org/)
- A C++ compiler (e.g., GCC, Clang)

### Setup

#### Installing Conan

1. Install Conan using pip:
    ```sh
    pip install conan
    ```

2. Verify the installation:
    ```sh
    conan --version
    ```

#### Configuring Conan

1. Create a default profile:
    ```sh
    conan profile new default --detect
    conan profile update settings.compiler.libcxx=libstdc++11 default
    ```

### Basic Principles of Conan

Conan is a package manager for C++ that helps you manage dependencies and build configurations. It allows you to:

- Define dependencies in a `conanfile.txt` or `conanfile.py`.
- Install dependencies and generate build files using generators like `CMakeDeps` and `CMakeToolchain`.
- Integrate with build systems like CMake to manage the build process.

### Integrating Conan with CMake

1. Define dependencies in `conanfile.txt`:
    ```plaintext
    [requires]
    redis-plus-plus/1.3.13

    [generators]
    CMakeDeps
    CMakeToolchain

    [layout]
    cmake_layout
    ```

2. Use the generated files in `CMakeLists.txt`:
    ```cmake
    cmake_minimum_required(VERSION 3.20)
    project(conan-demo)

    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    conan_basic_setup()

    find_package(redis++ REQUIRED)

    add_executable(${PROJECT_NAME} main.cpp)
    target_link_libraries(${PROJECT_NAME} redis++::redis++_static)
    ```

### Project Structure

- `main.cpp`: The main source file that demonstrates using the `redis++` library.
- `conanfile.txt`: Conan configuration file specifying dependencies and generators.
- `CMakeLists.txt`: CMake configuration file for building the project.
- `make.sh`: Shell script to automate the build and run process.

### Usage

- To build and run the project:
    ```sh
    ./make.sh -a
    ```

- To clean the build directory:
    ```sh
    ./make.sh -c
    ```

## 中文

这个工程演示了如何使用 Conan 来编译和运行代码。

### 前提条件

- [Conan](https://conan.io/)
- [CMake](https://cmake.org/)
- 一个 C++ 编译器（例如，GCC，Clang）

### 设置

#### 安装 Conan

1. 使用 pip 安装 Conan：
    ```sh
    pip install conan
    ```

2. 验证安装：
    ```sh
    conan --version
    ```

#### 配置 Conan

1. 创建默认配置文件：
    ```sh
    conan profile new default --detect
    conan profile update settings.compiler.libcxx=libstdc++11 default
    ```

### Conan 的基本原理

Conan 是一个 C++ 的包管理器，帮助你管理依赖项和构建配置。它允许你：

- 在 `conanfile.txt` 或 `conanfile.py` 中定义依赖项。
- 使用 `CMakeDeps` 和 `CMakeToolchain` 等生成器安装依赖项并生成构建文件。
- 与 CMake 等构建系统集成以管理构建过程。

### 与 CMake 集成

1. 在 `conanfile.txt` 中定义依赖项：
    ```plaintext
    [requires]
    redis-plus-plus/1.3.13

    [generators]
    CMakeDeps
    CMakeToolchain

    [layout]
    cmake_layout
    ```

2. 在 `CMakeLists.txt` 中使用生成的文件：
    ```cmake
    cmake_minimum_required(VERSION 3.20)
    project(conan-demo)

    include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
    conan_basic_setup()

    find_package(redis++ REQUIRED)

    add_executable(${PROJECT_NAME} main.cpp)
    target_link_libraries(${PROJECT_NAME} redis++::redis++_static)
    ```

### 项目结构

- `main.cpp`：演示使用 `redis++` 库的主源文件。
- `conanfile.txt`：指定依赖项和生成器的 Conan 配置文件。
- `CMakeLists.txt`：用于构建项目的 CMake 配置文件。
- `make.sh`：自动化构建和运行过程的 Shell 脚本。

### 用法

- 构建并运行项目：
    ```sh
    ./make.sh -a
    ```

- 清理构建目录：
    ```sh
    ./make.sh -c
    ```