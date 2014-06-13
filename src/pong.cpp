#include <iostream>
#include <cassert>

#include "kampf.hpp"

int main(int argc, char *argv[]) {
    auto kampf = Kampf(enumInitType::Basic); 
    auto lua = kampf.getLua();
    
    //include scripts folder from kampf
    //lua->addPath("../kampf/scripts/?.lua");
    lua->loadScript("pong.lua");

    return 0;
}
