// Made entirely by ChatGPT, I have no idea on how to code in C

#include <stdio.h>
#include <stdlib.h>

int main() {
    // Path to the Lua script
    const char *lua_script_path = "main.lua"; // Change this to your Lua file's name/path

    // Build the command to run the Lua script
    char command[256];
    snprintf(command, sizeof(command), "lua %s", lua_script_path);

    // Execute the command
    int result = system(command);

    // Check if the command was successful
    if (result == -1) {
        perror("Error executing Lua script");
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}
