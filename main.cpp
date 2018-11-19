#include <sys/types.h>
#include <dirent.h>
#include <string>
#include <vector>
#include <iostream>
#include <windows.h>

#include "cmake-build-debug/parser.hpp"

void read_directory(const std::string& name, std::vector<std::string>& v)
{
    DIR* dirp = opendir(name.c_str());
    struct dirent * dp;
    while ((dp = readdir(dirp)) != NULL) {
        v.push_back(dp->d_name);
    }
    closedir(dirp);
}

int main(int argc, char ** argv)
{
    char buffer[MAX_PATH];
    GetCurrentDirectory(MAX_PATH, buffer);
    std::cout << buffer << std::endl;

    std::string path = "\\tests";
    std::vector<std::string> vec;
    read_directory(buffer + path, vec);
    for (auto& a : vec) {
        std::cout << a;
    }
    main2(argc, argv);
   return 0;
}