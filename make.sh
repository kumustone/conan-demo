# Get the absolute path of the current script directory
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

# Get the directory name and replace spaces with underscores
project_name=$(basename -- "$script_dir" | tr ' ' '_')

# 以当前目录名作为项目名
# Output the value of project_name
echo "ProjectName: $project_name"

function exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [[ $exit_code -ne 0 ]]; then
        echo >&2 "${last_command} command failed with exit code ${exit_code}."
        exit $exit_code
    fi
}

# Define a function to get the version of cmake
get_cmake_version() {
    # Call the cmake --version command and get the first line of output
    local output=$(cmake --version | head -n 1)
    # Use the sed command to replace the part before version, keeping only the numbers and dots
    local version=$(echo "$output" | sed 's/.*version //')
    # Return the version number
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
    echo "  -c    clean build directory"
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