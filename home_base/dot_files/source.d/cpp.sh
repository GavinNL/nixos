function fait() {
    if [[ ! -f ${PWD}/conanfile.py ]]; then
        echo "This should be called from the source directory"
        echo ""
        return 1
    fi
    BUILD_TYPE=Debug conan_install
    BUILD_TYPE=Release conan_install
}

function conan_install() { 
#
#  Executes the conan install command and takes into account your CC/CXX variables
#  and also sets it up for web assembly CC=$(which emcc)
#
#  Example: Execute in the source folder and it will generate a build folder 
#           named COMPILER-VERSION-BUILD_TYPE
#
#    cd SOURCE_FOLDER
#    conan_install
#    
#  Example: Execute in a build folder and build for release
#     cd SOURCE_FOLDER
#     mkdir build && cd build
#     BUILD_TYPE=Release conan_install ..
#     
#
# Example: Build for web assembly
#
#    cd SOURCE_FOLDER
#    mkdir build && cd build
#    export CC=$(which emcc)
#    export CXX=$(which em++)
#    conan_install ..
#
    # Use default C++20
    local STD=${STD:-"20"}
    local ARCH=${ARCH:-"x86_64"}
    local OS=${OS:-"Linux"}
    local CC=${CC:-"cc"}
    local CXX=${CXX:-"cpp"}
    local PATH_TO_CONAN_FILE_PY=${1}
    local OUTPUT_DIR=$PWD

    # Used for compiling WASM to non-web based binaries
    local STANDALONE_WASM=${STANDALONE_WASM:-"0"}


    if ! command -v jq &> /dev/null; then
        echo "Cannot find jq. This is required to be installed in the path"
        return 1
    fi

    local BUILD_TYPE=${BUILD_TYPE:-"Debug"}
    local PATH_TO_CMAKELISTS=$PATH_TO_CONAN_FILE_PY


    if [[ "$BUILD_TYPE" != "Debug" && "$BUILD_TYPE" != "Release" && $BUILD_TYPE" != "RelWithDebInfo" && $BUILD_TYPE" != "MinSizeRel" ]]; then
        echo "Error: BUILD_TYPE must be 'Debug' or 'Release' or 'RelWithDebInfo' or 'MinSizeRel'."
        return 1
    fi

    # if CC=gcc or /usr/bin/gcc,  get the base name
    # regardless
    local COMPILER=$(basename $(which $(realpath ${CC})))

    if [[ $COMPILER == *"emcc"* ]]; then
        # This is for WebAssembly compilations with Emscripten
        #
        # The emcc compiler is based on clang, but the version it
        # reports is not the same as the clang version.
        # So instead, we are going to look for the clang-XX binary
        # in the same folder as the emcc binary and extract
        # the version from that
        #
        # We need this version to pass into conan
        echo "EMCC Compiler found"

        local CLANG_BIN=$(ls $(dirname $(which emcc))/../bin | grep clang- | sort | head -n 1)
        local COMPILER_VERSION=${CLANG_BIN//[^0-9]/}

        local COMPILER=clang
        local BIN_NAME=emcc

        local EXTRA_CMAKE_ARGS="-D EMSCRIPTEN=1"

        ARCH=wasm
        OS=Emscripten

        # These are needed if you are going to run using wasmtime
        # rather than execute in a browser
        #local cxxflags=\"-s\",\"STANDALONE_WASM=1\",\"-s\", \"WASM_BIGINT\" 
        #local cflags=\"-s\",\"STANDALONE_WASM=1\", \"-s\", \"WASM_BIGINT\"

        local cxxflags=\"-s\",\"STANDALONE_WASM=${STANDALONE_WASM}\",\"-s\",\"WASM_BIGINT\"
        local cflags=\"-s\",\"STANDALONE_WASM=${STANDALONE_WASM}\",\"-s\",\"WASM_BIGINT\"

    else
        
        # COMPILER may be cc, which could be a symlink to clang or
        # some other compiler. Find the realpath and check if its is a clang
        # or gcc compiler
        if [[ $(realpath $(which $CC)) == *"gcc"* ]]; then
            COMPILER=gcc
        fi

        if [[ $(realpath $(which $CC)) == *"clang"* ]]; then
            COMPILER=clang
        fi

        if [[ $(realpath $(which $CC)) == *"zcc"* ]]; then
            COMPILER=clang
        fi

        local BIN_NAME=$(basename ${CC})

        local COMPILER_VERSION=$(${CC} -dumpversion | cut -d. -f1)
    fi

    local COMPILER_STD_VERSION=${STD}


    if [[ -f ${OUTPUT_DIR}/conanfile.py ]]; then
        # If the output directory contains the conanfile then we need
        # to make a new output directory so we dont populate the source dir
        # with build artifacts
        #
        # We'll also set the CMAKE_PRESET to the compiler/version/buildtype
        local CMAKE_PRESET=${CMAKE_PRESET:-"${BIN_NAME}-${COMPILER_VERSION}-${BUILD_TYPE,,}"}
    
        PATH_TO_CONAN_FILE_PY=${OUTPUT_DIR}
        OUTPUT_DIR=${OUTPUT_DIR}/build-${CMAKE_PRESET}
        echo mkdir -p ${OUTPUT_DIR}
       
    else
        local CMAKE_PRESET=$(basename $OUTPUT_DIR)
    fi

    echo ========================================================
    echo "The following environment variables were used"
    echo "If you did not set them manually, they were determined from"
    echo "your CC environment variable"
    echo ""
    echo "CC              : "${CC}
    echo "CXX             : "${CXX}
    echo "COMPILER        : "${COMPILER}
    echo "COMPILER_VERSION: "${COMPILER_VERSION}
    echo "OS              : "${OS}
    echo "ARCH            : "${ARCH}
    echo "STD             : "${COMPILER_STD_VERSION}
    echo "CMAKE_PRESET    : "${CMAKE_PRESET}
    echo "BUILD_TYPE      : "${BUILD_TYPE}
    echo "SOURCE_DIR      : "${PATH_TO_CONAN_FILE_PY}
    echo "OUTPUT_DIR      : "${OUTPUT_DIR}
    echo ""
    echo "The following conan command will be executed:"
    echo -e " \
    conan install ${PATH_TO_CONAN_FILE_PY}/conanfile.py \\
        --build=missing \\
        -s:h \""\&:build_type=$BUILD_TYPE\"" \\
        -s compiler=${COMPILER} \\
        -s compiler.version=${COMPILER_VERSION} \\
        -s compiler.cppstd=${COMPILER_STD_VERSION} ${EXTRA_CONAN_ARGS} \\
        -s arch=${ARCH} \\
        -s os=${OS} \\
        -of ${OUTPUT_DIR} \\
        -c tools.build:cxxflags='"["${cxxflags}"]"' \\
        -c tools.build:cflags='"["${cflags}"]"' \\
        -c tools.system.package_manager:mode=install \\
        -c tools.system.package_manager:sudo=True \\
        "
    echo --------------------------------------------------------

    read -p "Press Enter to continue execute the command Ctrl-C to quit"
#    return 1
    conan install ${PATH_TO_CONAN_FILE_PY}/conanfile.py \
        --build=missing \
        -s:h "&:build_type=$BUILD_TYPE" \
        -s compiler=${COMPILER} \
        -s compiler.version=${COMPILER_VERSION} \
        -s compiler.cppstd=${COMPILER_STD_VERSION} ${EXTRA_CONAN_ARGS} \
        -s arch=${ARCH} \
        -s os=${OS} \
        -of ${OUTPUT_DIR} \
        -c tools.build:cxxflags="[${cxxflags}]" \
        -c tools.build:cflags="[${cflags}]" \
        -c tools.system.package_manager:mode=install \
        -c tools.system.package_manager:sudo=True 
        
    if [ ! $? -eq 0 ]; then
        echo "Failed to execute conan!"
        echo ""
        echo ""
        echo -e " \
    conan install ${PATH_TO_CONAN_FILE_PY}/conanfile.py \\
        --build=missing \\
        -s:h \""\&:build_type=$BUILD_TYPE\"" \\
        -s compiler=${COMPILER} \\
        -s compiler.version=${COMPILER_VERSION} \\
        -s compiler.cppstd=${COMPILER_STD_VERSION} ${EXTRA_CONAN_ARGS} \\
        -s arch=${ARCH} \\
        -s os=${OS} \\
        -of ${OUTPUT_DIR} \\
        -c tools.build:cxxflags=\""[" ${cxxflags} "]"\" \\
        -c tools.build:cflags=\""[" ${cflags} "]"\" \\
        -c tools.system.package_manager:mode=install \\
        -c tools.system.package_manager:sudo=True \\
        "
        return 1
    fi
    # There is no way to set the preset name that is generated
    # from the command line. So use some bash trickery to modify the
    # output CmakePresets.json file to replace the name with the one
    # we want
    #
    # Find the name of the preset that was generated 
    local oldpreset=$(cat ${OUTPUT_DIR}/CMakePresets.json  | jq .buildPresets[0].name |  tr -d '"')

    # And replace it with a more appropriate one
    sed -i "s/${oldpreset}/${CMAKE_PRESET}/g" ${OUTPUT_DIR}/CMakePresets.json

    echo ========================================================    
    local cmake_cmd="cmake ${PATH_TO_CONAN_FILE_PY} --preset ${CMAKE_PRESET}  ${EXTRA_CMAKE_ARGS}"
    echo Execute: ${cmake_cmd}
    echo ========================================================
    echo ""
    echo ""
    read -p "Press Enter to execute the command or Ctrl-C to exit"
    ${cmake_cmd}

    echo ========================================================    
    local cmake_cmd="cmake --build ${PATH_TO_CONAN_FILE_PY} --preset ${CMAKE_PRESET}"
    echo Execute: ${cmake_cmd}
    echo ========================================================
    echo ""
    echo ""
    read -p "Press Enter to execute the command or Ctrl-C to exit"
    ${cmake_cmd}
}




