# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.22

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/iagou/Desktop/TCC_LEB

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/iagou/Desktop/TCC_LEB/build

# Include any dependencies generated for this target.
include CMakeFiles/terrain.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/terrain.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/terrain.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/terrain.dir/flags.make

CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o: ../submodules/imgui/imgui.cpp
CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o -MF CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o.d -o CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o -c /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui.cpp

CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui.cpp > CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.i

CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui.cpp -o CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.s

CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o: ../submodules/imgui/imgui_demo.cpp
CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o -MF CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o.d -o CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o -c /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_demo.cpp

CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_demo.cpp > CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.i

CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_demo.cpp -o CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.s

CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o: ../submodules/imgui/imgui_draw.cpp
CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o -MF CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o.d -o CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o -c /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_draw.cpp

CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_draw.cpp > CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.i

CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_draw.cpp -o CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.s

CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o: ../submodules/imgui/imgui_widgets.cpp
CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building CXX object CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o -MF CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o.d -o CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o -c /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_widgets.cpp

CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_widgets.cpp > CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.i

CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/submodules/imgui/imgui_widgets.cpp -o CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.s

CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o: ../terrain/OpenSimplexNoise.cpp
CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o -MF CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o.d -o CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o -c /home/iagou/Desktop/TCC_LEB/terrain/OpenSimplexNoise.cpp

CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/terrain/OpenSimplexNoise.cpp > CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.i

CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/terrain/OpenSimplexNoise.cpp -o CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.s

CMakeFiles/terrain.dir/terrain/erosion.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/terrain/erosion.cpp.o: ../terrain/erosion.cpp
CMakeFiles/terrain.dir/terrain/erosion.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/terrain.dir/terrain/erosion.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/terrain/erosion.cpp.o -MF CMakeFiles/terrain.dir/terrain/erosion.cpp.o.d -o CMakeFiles/terrain.dir/terrain/erosion.cpp.o -c /home/iagou/Desktop/TCC_LEB/terrain/erosion.cpp

CMakeFiles/terrain.dir/terrain/erosion.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/terrain/erosion.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/terrain/erosion.cpp > CMakeFiles/terrain.dir/terrain/erosion.cpp.i

CMakeFiles/terrain.dir/terrain/erosion.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/terrain/erosion.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/terrain/erosion.cpp -o CMakeFiles/terrain.dir/terrain/erosion.cpp.s

CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o: ../terrain/imgui_impl.cpp
CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o -MF CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o.d -o CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o -c /home/iagou/Desktop/TCC_LEB/terrain/imgui_impl.cpp

CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/terrain/imgui_impl.cpp > CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.i

CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/terrain/imgui_impl.cpp -o CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.s

CMakeFiles/terrain.dir/terrain/terrain.cpp.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/terrain/terrain.cpp.o: ../terrain/terrain.cpp
CMakeFiles/terrain.dir/terrain/terrain.cpp.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object CMakeFiles/terrain.dir/terrain/terrain.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/terrain.dir/terrain/terrain.cpp.o -MF CMakeFiles/terrain.dir/terrain/terrain.cpp.o.d -o CMakeFiles/terrain.dir/terrain/terrain.cpp.o -c /home/iagou/Desktop/TCC_LEB/terrain/terrain.cpp

CMakeFiles/terrain.dir/terrain/terrain.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/terrain.dir/terrain/terrain.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/iagou/Desktop/TCC_LEB/terrain/terrain.cpp > CMakeFiles/terrain.dir/terrain/terrain.cpp.i

CMakeFiles/terrain.dir/terrain/terrain.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/terrain.dir/terrain/terrain.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/iagou/Desktop/TCC_LEB/terrain/terrain.cpp -o CMakeFiles/terrain.dir/terrain/terrain.cpp.s

CMakeFiles/terrain.dir/terrain/glad/glad.c.o: CMakeFiles/terrain.dir/flags.make
CMakeFiles/terrain.dir/terrain/glad/glad.c.o: ../terrain/glad/glad.c
CMakeFiles/terrain.dir/terrain/glad/glad.c.o: CMakeFiles/terrain.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Building C object CMakeFiles/terrain.dir/terrain/glad/glad.c.o"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -MD -MT CMakeFiles/terrain.dir/terrain/glad/glad.c.o -MF CMakeFiles/terrain.dir/terrain/glad/glad.c.o.d -o CMakeFiles/terrain.dir/terrain/glad/glad.c.o -c /home/iagou/Desktop/TCC_LEB/terrain/glad/glad.c

CMakeFiles/terrain.dir/terrain/glad/glad.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/terrain.dir/terrain/glad/glad.c.i"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/iagou/Desktop/TCC_LEB/terrain/glad/glad.c > CMakeFiles/terrain.dir/terrain/glad/glad.c.i

CMakeFiles/terrain.dir/terrain/glad/glad.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/terrain.dir/terrain/glad/glad.c.s"
	/usr/bin/cc $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/iagou/Desktop/TCC_LEB/terrain/glad/glad.c -o CMakeFiles/terrain.dir/terrain/glad/glad.c.s

# Object files for target terrain
terrain_OBJECTS = \
"CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o" \
"CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o" \
"CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o" \
"CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o" \
"CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o" \
"CMakeFiles/terrain.dir/terrain/erosion.cpp.o" \
"CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o" \
"CMakeFiles/terrain.dir/terrain/terrain.cpp.o" \
"CMakeFiles/terrain.dir/terrain/glad/glad.c.o"

# External object files for target terrain
terrain_EXTERNAL_OBJECTS =

terrain: CMakeFiles/terrain.dir/submodules/imgui/imgui.cpp.o
terrain: CMakeFiles/terrain.dir/submodules/imgui/imgui_demo.cpp.o
terrain: CMakeFiles/terrain.dir/submodules/imgui/imgui_draw.cpp.o
terrain: CMakeFiles/terrain.dir/submodules/imgui/imgui_widgets.cpp.o
terrain: CMakeFiles/terrain.dir/terrain/OpenSimplexNoise.cpp.o
terrain: CMakeFiles/terrain.dir/terrain/erosion.cpp.o
terrain: CMakeFiles/terrain.dir/terrain/imgui_impl.cpp.o
terrain: CMakeFiles/terrain.dir/terrain/terrain.cpp.o
terrain: CMakeFiles/terrain.dir/terrain/glad/glad.c.o
terrain: CMakeFiles/terrain.dir/build.make
terrain: submodules/glfw/src/libglfw3.a
terrain: /usr/lib/x86_64-linux-gnu/librt.a
terrain: /usr/lib/x86_64-linux-gnu/libm.so
terrain: CMakeFiles/terrain.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/iagou/Desktop/TCC_LEB/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_10) "Linking CXX executable terrain"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/terrain.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/terrain.dir/build: terrain
.PHONY : CMakeFiles/terrain.dir/build

CMakeFiles/terrain.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/terrain.dir/cmake_clean.cmake
.PHONY : CMakeFiles/terrain.dir/clean

CMakeFiles/terrain.dir/depend:
	cd /home/iagou/Desktop/TCC_LEB/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/iagou/Desktop/TCC_LEB /home/iagou/Desktop/TCC_LEB /home/iagou/Desktop/TCC_LEB/build /home/iagou/Desktop/TCC_LEB/build /home/iagou/Desktop/TCC_LEB/build/CMakeFiles/terrain.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/terrain.dir/depend

