# C++ Template Flashcard

Quick reference for everything in this template.

---

## CMake Commands

| Command | What it does |
|---------|--------------|
| `cmake -B build -S .` | Configure (generate build files) |
| `cmake --build build` | Build (compile) |
| `cmake --build build --clean-first` | Clean rebuild |
| `ctest --test-dir build --output-on-failure` | Run tests |

**With vcpkg:**
```bash
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
```

---

## CMake Concepts

| Concept | Meaning |
|---------|---------|
| `cmake_minimum_required()` | Minimum CMake version needed |
| `project()` | Project name, version, language |
| `set(CMAKE_CXX_STANDARD 20)` | Use C++20 |
| `add_executable()` | Create an executable |
| `add_library()` | Create a library |
| `target_link_libraries()` | Link dependencies |
| `find_package()` | Find installed libraries |
| `add_subdirectory()` | Process another CMakeLists.txt |
| `option()` | User-configurable boolean |

---

## vcpkg

**What:** C++ package manager (like npm/pip for C++)

**Manifest file:** `vcpkg.json`
```json
{
  "name": "myproject",
  "version-string": "1.0.0",
  "builtin-baseline": "<commit-hash>",
  "dependencies": ["fmt", "gtest"]
}
```

**Add a dependency:**
1. Add to `vcpkg.json`
2. Add `find_package(LibName CONFIG REQUIRED)` to CMakeLists.txt
3. Add `target_link_libraries(... LibName::LibName)`
4. Re-run cmake

**builtin-baseline:** Git commit hash from vcpkg repo. NOT a secret. Ensures reproducible builds.

---

## GoogleTest

**Test structure:**
```cpp
TEST(SuiteName, TestName) {
    EXPECT_EQ(actual, expected);
}
```

| Macro | Behavior |
|-------|----------|
| `EXPECT_EQ(a, b)` | a == b (continues on fail) |
| `EXPECT_NE(a, b)` | a != b |
| `EXPECT_TRUE(x)` | x is true |
| `EXPECT_FALSE(x)` | x is false |
| `ASSERT_EQ(a, b)` | a == b (STOPS on fail) |

**Run tests:**
```bash
ctest --test-dir build --output-on-failure
./build/unit_tests --gtest_filter="MathTest.*"
```

---

## Compiler Warnings

| Flag | Catches |
|------|---------|
| `-Wall` | Common warnings |
| `-Wextra` | Extra warnings |
| `-Werror` | Warnings = errors |
| `-Wshadow` | Variable shadowing |
| `-Wconversion` | Lossy type conversions |
| `-Wpedantic` | Strict ISO compliance |

---

## Sanitizers

| Sanitizer | Catches |
|-----------|---------|
| **ASan** (Address) | Buffer overflow, use-after-free, memory leaks |
| **UBSan** (Undefined Behavior) | Signed overflow, null deref, etc. |

**Enable:** `-DENABLE_SANITIZERS=ON`

**Note:** Slows down execution. Debug only.

---

## GitHub Actions CI

**Triggers:**
- Push to `main`
- Pull request to `main`

**Matrix:** 3 OS × 2 build types = 6 builds

**View results:** GitHub repo → Actions tab

---

## Project Structure

```
├── CMakeLists.txt          # Root config
├── vcpkg.json              # Dependencies
├── cmake/
│   └── CompilerWarnings.cmake
├── src/
│   ├── CMakeLists.txt
│   └── main.cpp
├── tests/
│   ├── CMakeLists.txt
│   └── test_main.cpp
├── .github/workflows/ci.yml
├── .clang-format
├── .clang-tidy
└── .gitignore
```

---

## Common Tasks Cheatsheet

**Rename project:**
1. `CMakeLists.txt` → `project(NewName ...)`
2. `vcpkg.json` → `"name": "newname"`

**Add source file:**
```cmake
# src/CMakeLists.txt
add_executable(${PROJECT_NAME} main.cpp newfile.cpp)
```

**Add test file:**
```cmake
# tests/CMakeLists.txt
add_executable(unit_tests test_main.cpp test_new.cpp)
```

**Format code:**
```bash
clang-format -i src/main.cpp
```

**Static analysis:**
```bash
clang-tidy src/main.cpp -p build
```

**Update vcpkg baseline:**
```bash
cd ~/vcpkg && git pull && git log -1 --format="%H"
# Update vcpkg.json and ci.yml with new hash
```

---

## Key Files Quick Reference

| File | Purpose |
|------|---------|
| `CMakeLists.txt` | Build configuration |
| `vcpkg.json` | Dependencies |
| `cmake/CompilerWarnings.cmake` | Warning flags function |
| `src/CMakeLists.txt` | Build rules for app |
| `tests/CMakeLists.txt` | Build rules for tests |
| `.github/workflows/ci.yml` | CI configuration |
| `.clang-format` | Code style rules |
| `.clang-tidy` | Static analysis rules |
| `build/` | Generated (never commit) |
| `compile_commands.json` | For IDE/tooling |

---

## Remember

- `build/` is generated — delete it to start fresh
- vcpkg baseline is NOT a secret
- `EXPECT_*` continues, `ASSERT_*` stops
- First vcpkg build is slow (compiles from source)
- CI runs on push to main and on PRs

---

*Week 01 of 52 — C++ Template Complete*
