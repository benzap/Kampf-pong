#makefile for Kampf game engine tests
UNAME := $(shell uname)

TAGS_EXEC = etags

CXX = g++
CXXFLAGS = --std=c++0x -static-libgcc -static-libstdc++

LDFLAGS = #-Wl,--verbose

EXEC_EXTENSION = .exe

BUILD = production

#Production Build Versus Debug Build
ifeq ($(BUILD), production)
CXXFLAGS += -O2
else ifeq ($(BUILD), debug)
CXXFLAGS += -g
else
echo "Warning: Build Parameter is incorrect, using default debug build"
CXXFLAGS += -g
endif

ifeq ($(UNAME), Linux)
EXEC_EXTENSION =
LDFLAGS += -rdynamic -DKF_LINUX
else
CXXFLAGS += -mwindows -m32 -DKF_WIN
endif

#global hpp files
GLOBAL_HPP= ../kampf/include/kampf.hpp

#get all of the .cpp files and .hpp files
HPP_FILES=$(wildcard *.hpp)
CPP_FILES=$(wildcard *.cpp)
OBJ_FILES=$(CPP_FILES:.cpp=.o)
SO_FILES = $(wildcard ../kampf/*.so)

INC_DIR= -I../ -I./ -I../kampf/include
LIB_DIR= -L../lib -L../ -L./ -LC:\MinGW\lib -L../kampf/lib

LIBS = 
ifeq ($(UNAME), Linux)
LIBS += -lkampf -lSDL2main -lSDL2 -lluajit-5.1 -lSDL2_ttf -lSDL2_image
else
LIBS += -lkampf -lmingw32 -lSDL2main -lSDL2 -llua51 -lSDL2_ttf -lSDL2_image
endif

EXECUTABLE_NAME = pong

#redefine our suffixes
.SUFFIXES:
.SUFFIXES: .cpp .c .hpp .h

.PHONY: all clean exec
exec: $(OBJ_FILES) $(SO_FILES)
	cp -f *.dll ../bin
	cp -f ../kampf/scripts/*.lua ../scripts/engine/
#	cp -f *.so ../bin
	cp -f $(EXECUTABLE_NAME)$(EXEC_EXTENSION) ../bin
	cp -f $(EXECUTABLE_NAME).lua ../bin

all: clean exec

%.o: %.cpp $(GLOBAL_HPP) $(SO_FILES)
	$(CXX) $(CXXFLAGS) $(INC_DIR) -o $@ -c $< $(LIBS) $(LIB_DIR)
	$(CXX) $(CXXFLAGS) $(LDFLAGS) $(LD_SHARED) -o $* $@ $(LIBS) $(LIB_DIR)

clean:
	rm -f *.o
	rm -f *.exe

tags:
	$(TAGS_EXEC) $(CPP_FILES) $(HPP_FILES)
