#pragma once

#include <stdint.h>
#include <stdlib.h>

#define DEFINE_DEFAULT_ISR(name) \
    __attribute__((interrupt)) \
    __attribute__((weak)) \
    __attribute__((noreturn)) \
    void name() { \
        while (1); \
    }
