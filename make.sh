# 获取当前脚本所在目录的绝对路径
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# 获取目录名并替换空格为下划线
project_name=$(basename -- "$script_dir" | tr ' ' '_')

# 输出 project_name 的值
echo "ProjectName: $project_name"

function exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [[ $exit_code -ne 0 ]]; then
        echo >&2 "${last_command} command failed with exit code ${exit_code}."
        exit $exit_code
    fi
}

# 定义一个函数，用于获取 cmake 的版本号
get_cmake_version() {
    # 调用 cmake --version 命令，并获取第一行的输出
    local output=$(cmake --version | head -n 1)
    # 使用 sed 命令，替换掉 version 前面的部分，只保留数字和点
    local version=$(echo "$output" | sed 's/.*version //')
    # 返回版本号
    echo "$version"
}


function do_cmake() {
    echo "do_cmake pwd : " $(pwd)
    echo "\n\n=================== Conan Install  ==================="
    if [ -d "build" ]; then
        rm -rf "build"
    fi
    
    # Create the build directory
    mkdir build

    # Run conan install with the build directory as the output folder
    conan install . -b=missing
    exit_on_error $? "conan install error!"

    echo "\n\n=================== CMake ==================="

    local cmake_version=$(get_cmake_version)

    if [ "${cmake_version//./}" -ge  3230 ]; then 
        cmake --preset conan-release 
    else 
        cmake -B build -DCMAKE_TOOLCHAIN_FILE=build/conan_toolchain.cmake -DCMAKE_POLICY_DEFAULT_CMP0091=NEW  
    fi

    exit_on_error $? "cmake error!"
}

function do_make() {
    echo "\n\n=================== Make  ==================="
    
    make -C build/Release -j8

    exit_on_error $? "make error! "

    echo "Make finish, success!"
}

function do_run() {
    echo "\n\n=================== Run  ==================="
    ./build/Release/${project_name}
}

function do_clean() {
    rm -rf build
    rm -f CMakeUserPresets.json
    echo "Clean Finish !!!"
}

usage() {

    echo "Usage: $0 [options]"
    echo "Default: Make and run"
    echo "Options:"
    echo "  -a    cmake conan, make and run"
    echo "  -b    cmake conan and make"
}


while getopts "abc" opt; do
    case $opt in 
        a)
            do_cmake && do_make && do_run
            exit 0
            ;;
        b)
            do_cmake && do_make
            exit 0
            ;;
        c)
            do_clean
            exit 0
            ;;
        *)
            usage
            exit 1 
            ;;
    esac
done

if [ $OPTIND -eq 1 ]; then
    do_make && do_run
    exit 0
fi

