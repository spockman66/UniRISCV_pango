#include "printf.h"
#include "uart_lite.h"

//-----------------------------------------------------------------
// main
//-----------------------------------------------------------------
int main(int argc, char *argv[])
{
    // Setup serial port
    uartlite_init(CONFIG_UARTLITE_BASE, 0);

    // Register serial driver with printf
    printf_register(uartlite_putc);

    while (1)
    {
        printf("Hello RISC-V!\n");
        printf("Pango PGL22G\n\n");
    }
    return 0;
}
