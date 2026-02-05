add_executable(unit_tests test_main.cpp)  # Changed from "tests" to "unit_tests"
target_link_libraries(unit_tests PRIVATE GTest::gtest GTest::gtest_main)
set_project_warnings(unit_tests)

include(GoogleTest)
gtest_discover_tests(unit_tests)