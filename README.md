# C++ Project Template

A production-ready C++ starter template with modern tooling, designed for rapid project bootstrapping.

**Created as Week 01 of 52 Weeks of C++ Projects.**

---

## Features

| Feature | Description |
|---------|-------------|
| **CMake 3.21+** | Modern build system with proper target-based configuration |
| **C++20** | Latest language standard enabled |
| **vcpkg** | Dependency management via manifest mode |
| **GoogleTest** | Unit testing framework integrated |
| **Compiler Warnings** | Strict warnings enabled (Wall, Wextra, Werror, etc.) |
| **Sanitizers** | AddressSanitizer & UndefinedBehaviorSanitizer support |
| **GitHub Actions CI** | Automated builds on Linux, macOS, and Windows |
| **clang-format** | Consistent code formatting |
| **clang-tidy** | Static analysis |

---

## Prerequisites

### 1. CMake (3.21 or higher)

```bash
# macOS
brew install cmake

# Ubuntu/Debian
sudo apt install cmake

# Windows
# Download from https://cmake.org/download/
```

Verify installation:
```bash
cmake --version
```

### 2. vcpkg

```bash
# Clone vcpkg
git clone https://github.com/microsoft/vcpkg.git ~/vcpkg

# Bootstrap
cd ~/vcpkg
./bootstrap-vcpkg.sh      # macOS/Linux
# or
.\bootstrap-vcpkg.bat     # Windows

# Add to shell profile (~/.zshrc or ~/.bashrc)
export VCPKG_ROOT="$HOME/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"
```

Restart your terminal or run `source ~/.zshrc`.

### 3. A C++ Compiler

- **macOS:** Xcode Command Line Tools (`xcode-select --install`)
- **Linux:** GCC (`sudo apt install build-essential`) or Clang
- **Windows:** Visual Studio 2019+ with C++ workload, or MinGW

---

## Quick Start

### Using This Template

1. **On GitHub:** Click "Use this template" → "Create a new repository"
2. **Or clone directly:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/Cpp-Template.git MyNewProject
   cd MyNewProject
   rm -rf .git
   git init
   ```

### Building the Project

```bash
# Configure (first time downloads dependencies via vcpkg)
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake

# Build
cmake --build build

# Run the executable
./build/MyProject

# Run tests
ctest --test-dir build --output-on-failure
```

### Build Options

| Option | Default | Description |
|--------|---------|-------------|
| `ENABLE_TESTING` | `ON` | Enable unit tests |
| `ENABLE_SANITIZERS` | `OFF` | Enable ASan/UBSan |

```bash
# Example: Build with sanitizers enabled
cmake -B build -S . \
  -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
  -DENABLE_SANITIZERS=ON

# Example: Build without tests
cmake -B build -S . \
  -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake \
  -DENABLE_TESTING=OFF
```

---

## Project Structure

```
MyProject/
├── CMakeLists.txt              # Root CMake configuration
├── vcpkg.json                  # Dependency manifest
├── cmake/
│   └── CompilerWarnings.cmake  # Compiler warning flags
├── src/
│   ├── CMakeLists.txt          # Build rules for main executable
│   └── main.cpp                # Application entry point
├── tests/
│   ├── CMakeLists.txt          # Build rules for tests
│   └── test_main.cpp           # Unit tests
├── .github/
│   └── workflows/
│       └── ci.yml              # GitHub Actions CI configuration
├── .clang-format               # Code formatting rules
├── .clang-tidy                 # Static analysis rules
├── .gitignore                  # Git ignore rules
└── README.md                   # This file
```

---

## Understanding the Components

### CMake

CMake is a **build system generator**. It doesn't compile code directly—it generates platform-specific build files (Makefiles, Ninja, Visual Studio solutions).

**Key files:**
- `CMakeLists.txt` — Describes your project, dependencies, and build rules
- `build/` — Generated directory containing build artifacts (never commit this)

**Key commands:**
```bash
cmake -B build -S .           # Configure (generate build files)
cmake --build build           # Build (compile your code)
cmake --build build --clean-first  # Clean and rebuild
```

**Key CMake concepts:**
- `project()` — Declares project name and version
- `add_executable()` — Creates an executable target
- `add_library()` — Creates a library target
- `target_link_libraries()` — Links dependencies to a target
- `find_package()` — Finds installed libraries

### vcpkg

vcpkg is a **C++ package manager**. It downloads, builds, and manages library dependencies.

**Manifest mode** (`vcpkg.json`):
```json
{
  "name": "myproject",
  "version-string": "1.0.0",
  "builtin-baseline": "c82f74667287d3dc386bce81e44964370c91a289",
  "dependencies": [
    "fmt",
    "gtest"
  ]
}
```

When you run CMake with the vcpkg toolchain, it automatically installs dependencies listed in `vcpkg.json`.

**What is `builtin-baseline`?**

The `builtin-baseline` is a **Git commit hash** from the [vcpkg repository](https://github.com/microsoft/vcpkg). It's NOT a secret or token — it's public information that pins your dependencies to a specific snapshot of the vcpkg package registry.

**Why it matters:**
- Without it: `fmt` might be v10.2 today, v11.0 next month (potentially breaking your code)
- With it: You always get the same package versions = reproducible builds

**Is it safe to commit?** Yes! It's meant to be committed. Anyone can see vcpkg commits at https://github.com/microsoft/vcpkg/commits/master

**How to update it:**
```bash
# Get the latest vcpkg commit hash
cd ~/vcpkg
git pull
git log -1 --format="%H"
# Copy the hash and update vcpkg.json and ci.yml
```

**Adding a new dependency:**
1. Add it to `vcpkg.json`
2. Add `find_package(LibName CONFIG REQUIRED)` to CMakeLists.txt
3. Add `target_link_libraries(... LibName::LibName)` to link it
4. Re-run cmake configure

**Useful commands:**
```bash
vcpkg search <library>        # Search for packages
vcpkg list                    # List installed packages (classic mode)
```

### GoogleTest

GoogleTest is a **unit testing framework**. Tests verify your code works correctly.

**Basic test structure:**
```cpp
#include <gtest/gtest.h>

TEST(TestSuiteName, TestName) {
    // Arrange - set up test data
    int a = 2, b = 3;
    
    // Act - call the function
    int result = add(a, b);
    
    // Assert - verify the result
    EXPECT_EQ(result, 5);
}
```

**Key macros:**
| Macro | Description |
|-------|-------------|
| `EXPECT_EQ(a, b)` | Check equality (continues on failure) |
| `EXPECT_NE(a, b)` | Check inequality |
| `EXPECT_TRUE(x)` | Check true |
| `EXPECT_FALSE(x)` | Check false |
| `ASSERT_EQ(a, b)` | Check equality (stops on failure) |

**Running tests:**
```bash
ctest --test-dir build --output-on-failure
# or run directly for more details:
./build/unit_tests
./build/unit_tests --gtest_filter="MathTest.*"  # Run specific tests
```

### Compiler Warnings

Strict compiler warnings catch bugs at compile time. This template enables:

| Flag | What it catches |
|------|-----------------|
| `-Wall` | Common warnings |
| `-Wextra` | Extra warnings |
| `-Werror` | Treat warnings as errors |
| `-Wshadow` | Variable shadowing |
| `-Wconversion` | Lossy type conversions |

### Sanitizers

Sanitizers are runtime tools that detect bugs:

- **AddressSanitizer (ASan):** Buffer overflows, use-after-free, memory leaks
- **UndefinedBehaviorSanitizer (UBSan):** Signed overflow, null dereference, etc.

Enable with `-DENABLE_SANITIZERS=ON`. Note: Sanitizers slow down execution significantly—use only for debugging.

### GitHub Actions CI

Continuous Integration automatically builds and tests your code on every push/PR.

**What happens:**
1. You push to `main` or open a PR
2. GitHub spins up VMs (Ubuntu, macOS, Windows)
3. Each VM builds your project in Debug and Release modes
4. Tests run automatically
5. Results appear in the Actions tab

**6 total builds:** 3 OS × 2 build types

---

## Common Tasks

### Rename the Project

1. Update `project(MyProject ...)` in root `CMakeLists.txt`
2. Update `"name"` in `vcpkg.json`
3. Update this README

### Add a New Source File

1. Create the file in `src/` (e.g., `src/utils.cpp`)
2. Add it to `add_executable()` in `src/CMakeLists.txt`:
   ```cmake
   add_executable(${PROJECT_NAME} main.cpp utils.cpp)
   ```

### Add a New Dependency

1. Find the package name: `vcpkg search <name>`
2. Add to `vcpkg.json`:
   ```json
   "dependencies": [
     "fmt",
     "gtest",
     "spdlog"
   ]
   ```
3. Add to `CMakeLists.txt`:
   ```cmake
   find_package(spdlog CONFIG REQUIRED)
   ```
4. Link to your target in `src/CMakeLists.txt`:
   ```cmake
   target_link_libraries(${PROJECT_NAME} PRIVATE fmt::fmt spdlog::spdlog)
   ```
5. Re-run cmake configure

### Add a New Test File

1. Create the file in `tests/` (e.g., `tests/test_utils.cpp`)
2. Add it to `add_executable()` in `tests/CMakeLists.txt`:
   ```cmake
   add_executable(unit_tests test_main.cpp test_utils.cpp)
   ```

### Format Code

```bash
# Format a single file
clang-format -i src/main.cpp

# Format all source files
find src tests -name "*.cpp" -o -name "*.hpp" | xargs clang-format -i
```

### Run Static Analysis

```bash
clang-tidy src/main.cpp -p build
```

### Clean Build

```bash
rm -rf build
cmake -B build -S . -DCMAKE_TOOLCHAIN_FILE=$VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake
cmake --build build
```

---

## When to Use This Template

Use this template when starting:

- Console applications
- CLI tools
- Algorithm practice projects
- Library development
- Learning projects
- Competitive programming (with modifications)
- Interview prep projects

You may need to modify for:

- GUI applications (add Qt, SDL, or other GUI framework)
- Game development (add game engine or graphics libraries)
- Embedded systems (different toolchain)

---

## Troubleshooting

### CMake can't find vcpkg

Make sure `$VCPKG_ROOT` is set:
```bash
echo $VCPKG_ROOT
# Should print: /Users/yourname/vcpkg (or similar)
```

If empty, add to `~/.zshrc` or `~/.bashrc`:
```bash
export VCPKG_ROOT="$HOME/vcpkg"
export PATH="$VCPKG_ROOT:$PATH"
```

### "No tests were found"

Make sure:
1. `tests/CMakeLists.txt` has `gtest_discover_tests(unit_tests)`
2. Your test file has at least one `TEST()` macro
3. You rebuilt after adding tests

### Sanitizer errors on macOS with Apple Silicon

Some sanitizer features may have issues on M1/M2. Try building without sanitizers:
```bash
cmake -B build -S . -DENABLE_SANITIZERS=OFF ...
```

### vcpkg takes forever

First build downloads and compiles dependencies from source. Subsequent builds use cached binaries. This is normal—grab a coffee.

---

## Resources

- [CMake Documentation](https://cmake.org/documentation/)
- [vcpkg Documentation](https://vcpkg.io/en/docs/README.html)
- [GoogleTest Primer](https://google.github.io/googletest/primer.html)
- [clang-format Documentation](https://clang.llvm.org/docs/ClangFormat.html)
- [clang-tidy Checks](https://clang.llvm.org/extra/clang-tidy/checks/list.html)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## License

This template is provided as-is for educational purposes. Use it however you like for your projects.

---

*Created during 52 Weeks of C++ — Week 01*
