# NanoVG Makefile (Linux)
#
# Usage:
#   make            Build release version
#   make debug      Build debug version
#   make web        Build WebGL version (requires Emscripten)
#   make run        Build and run release version
#   make clean      Remove build artifacts

CC := cc
AR := ar

# Release build settings
RELEASE_DIR := build/release
RELEASE_FLAGS := -O2 -DNDEBUG

# Debug build settings
DEBUG_DIR := build/debug
DEBUG_FLAGS := -O0 -g -DDEBUG

# Web build settings
WEB_DIR := build/web
WEB_FLAGS := -O2 -DNDEBUG

# Common settings
CFLAGS := -std=c11 -Wall -Wextra
CPPFLAGS := -Isrc -Iexample -Isokol -D_POSIX_C_SOURCE=200809L -DSOKOL_GLCORE
LDLIBS := -lglfw -lGL -ldl -lpthread -lm

# Sources
LIB_SRC := src/nanovg.c
EXAMPLE_SRC := example/example.c example/demo.c example/perf.c

# Release objects and targets
RELEASE_LIB_OBJ := $(RELEASE_DIR)/obj/src/nanovg.o
RELEASE_EXAMPLE_OBJ := $(patsubst %.c,$(RELEASE_DIR)/obj/%.o,$(EXAMPLE_SRC))
RELEASE_LIB := $(RELEASE_DIR)/libnanovg.a
RELEASE_BIN := $(RELEASE_DIR)/example

# Debug objects and targets
DEBUG_LIB_OBJ := $(DEBUG_DIR)/obj/src/nanovg.o
DEBUG_EXAMPLE_OBJ := $(patsubst %.c,$(DEBUG_DIR)/obj/%.o,$(EXAMPLE_SRC))
DEBUG_LIB := $(DEBUG_DIR)/libnanovg.a
DEBUG_BIN := $(DEBUG_DIR)/example

# Web targets
WEB_OUT := $(WEB_DIR)/index.html

.PHONY: all release debug web run run-debug clean

all: release

release: $(RELEASE_BIN)

debug: $(DEBUG_BIN)

web: $(WEB_OUT)

run: release
	@./$(RELEASE_BIN)

run-debug: debug
	@./$(DEBUG_BIN)

clean:
	rm -rf build

# Release build rules
$(RELEASE_LIB): $(RELEASE_LIB_OBJ)
	@mkdir -p $(dir $@)
	$(AR) rcs $@ $^

$(RELEASE_BIN): $(RELEASE_EXAMPLE_OBJ) $(RELEASE_LIB)
	@mkdir -p $(dir $@)
	$(CC) -s $^ $(LDLIBS) -o $@

$(RELEASE_DIR)/obj/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(RELEASE_FLAGS) -c $< -o $@

# Debug build rules
$(DEBUG_LIB): $(DEBUG_LIB_OBJ)
	@mkdir -p $(dir $@)
	$(AR) rcs $@ $^

$(DEBUG_BIN): $(DEBUG_EXAMPLE_OBJ) $(DEBUG_LIB)
	@mkdir -p $(dir $@)
	$(CC) $^ $(LDLIBS) -o $@

$(DEBUG_DIR)/obj/%.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) $(DEBUG_FLAGS) -c $< -o $@

# Web build rules
$(WEB_OUT): example/example_web.c example/demo.c example/perf.c src/nanovg.c
	@mkdir -p $(WEB_DIR)
	emcc $^ $(WEB_FLAGS) \
		-Isrc -Iexample -Isokol \
		-DSOKOL_GLES3 \
		-sUSE_WEBGL2=1 \
		-sALLOW_MEMORY_GROWTH=1 \
		--preload-file example/Roboto-Regular.ttf \
		--preload-file example/Roboto-Bold.ttf \
		--preload-file example/entypo.ttf \
		--preload-file example/NotoEmoji-Regular.ttf \
		--preload-file example/images \
		--shell-file example/shell.html \
		-o $@
