function(set_project_warnings target)
    set(MSVC_WARNINGS /W4 /WX /permissive-)
    set(CLANG_WARNINGS
        -Wall -Wextra -Wpedantic -Werror
        -Wshadow -Wconversion -Wsign-conversion
        -Wnull-dereference -Wdouble-promotion
        -Wformat=2 -Wimplicit-fallthrough
    )
    set(GCC_WARNINGS ${CLANG_WARNINGS} -Wmisleading-indentation -Wduplicated-cond)

    if(MSVC)
        target_compile_options(${target} PRIVATE ${MSVC_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_compile_options(${target} PRIVATE ${CLANG_WARNINGS})
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
        target_compile_options(${target} PRIVATE ${GCC_WARNINGS})
    endif()
endfunction()