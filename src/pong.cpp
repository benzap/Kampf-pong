#include <iostream>
#include <cassert>

#include "kampf.hpp"

int main(int argc, char *argv[]) {
    auto kampf = Kampf(enumInitType::Basic); 
    auto lua = kampf.getLua();
    lua->loadScript("pong.lua");

    return 0;
}
