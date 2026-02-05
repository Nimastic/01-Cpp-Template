#include <gtest/gtest.h>

// A simple function to test (normally you'd import from your lib)
int add(int a, int b) {
    return a + b;
}

TEST(MathTest, Addition) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
    EXPECT_EQ(add(0, 0), 0);
}

TEST(MathTest, AdditionEdgeCases) {
    EXPECT_EQ(add(-5, -5), -10);
    EXPECT_EQ(add(1000000, 1000000), 2000000);
}

TEST(StringTest, BasicString) {
    std::string hello = "Hello";
    EXPECT_EQ(hello.length(), 5);
    EXPECT_TRUE(hello.find("ell") != std::string::npos);
}