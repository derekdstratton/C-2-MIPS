CXX = g++
CXX_FLAGS = -c -std=c++11
OBJ_FILES = driver.o SymbolTable.o

all:$(OBJ_FILES)
	$(CXX) $(OBJ_FILES) -o driver

driver.o: driver.cpp
	$(CXX) $(CXX_FLAGS) driver.cpp

SymbolTable.o: SymbolTable.cpp
	$(CXX) $(CXX_FLAGS) SymbolTable.cpp

clean:
	rm *.o driver 
