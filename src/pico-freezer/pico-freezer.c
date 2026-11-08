#include <stdio.h>
#include "pico/stdlib.h"
#include "pico/multicore.h"
#include "hardware/clocks.h"
#include "hardware/vreg.h"

static uint8_t freezer_rom_data[3 * 8 * 1024];
static uint8_t freezer_ram_data[32 * 1024];

#define ST_DISABLED 0
#define ST_INTERMEDIATE 1
#define ST_ENABLED 2
#define ST_TEMP_DISABLED 3

typedef struct
{
    uint32_t state;
    uint8_t *freezer_rom;
    uint8_t *freezer_ram;
} vars_t;

vars_t freezer_vars;

extern void freezer_function();

void init_all_gpios_as_input()
{
    // Mask for pins 0 to 29 (bits 0 to 29 are set to 1)
    uint32_t gpio_mask = 0x3FFFFFFF;

    // Initialize all GPIOs included in the mask at once
    gpio_init_mask(gpio_mask);

    // Set direction of all GPIOs to input simultaneously (0 = Input, 1 = Output)
    gpio_set_dir_all_bits(0x00000000);
}

int main()
{
    uint8_t c;
    uint32_t freq;

    vreg_set_voltage(VREG_VOLTAGE_1_20);
    sleep_ms(10);

    if (!set_sys_clock_khz(250000, true))
    {
        while (1)
        {
            tight_loop_contents();
        }
    };

    stdio_init_all();
    init_all_gpios_as_input();

    freezer_vars.state = ST_DISABLED;
    freezer_vars.freezer_rom = freezer_rom_data;
    freezer_vars.freezer_ram = freezer_ram_data;

    multicore_launch_core1(freezer_function);

    sleep_ms(1000);

    freq = clock_get_hz(clk_sys);

    printf("PICO - Freezer \n");
    printf("SYSCLK: %d\n", freq);
    printf(">");

    while (true)
    {
        c = getchar();
        printf("%c", c);
    }
}
