#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Constants
#define MAX_PATH_LEN 256
#define MAX_CMD_LEN 1024

// Function prototypes
void set_paths(char *gzdoom_path, char *wads_path, int *use_subfolders);
void detect_os(char *os);
void run_gzdoom(const char *gzdoom_path, const char *wads_path, int use_subfolders, const char *os);
void build_command(char *command, const char *gzdoom_path, const char *wads_path, int use_subfolders, const char *os);

int main() {
    char gzdoom_path[MAX_PATH_LEN] = "/path/to/gzdoom";
    char wads_path[MAX_PATH_LEN] = "/path/to/wads";
    char os[32];
    int use_subfolders = 0;
    
    // Detect the OS
    detect_os(os);
    
    // Set file locations
    set_paths(gzdoom_path, wads_path, &use_subfolders);
    
    // Run GZDoom
    run_gzdoom(gzdoom_path, wads_path, use_subfolders, os);
    
    return 0;
}

// Function to detect the operating system
void detect_os(char *os) {
#ifdef _WIN32
    strcpy(os, "windows");
#elif __APPLE__
    strcpy(os, "macos");
#elif __linux__
    strcpy(os, "linux");
#else
    strcpy(os, "unknown");
#endif
    printf("Operating system detected: %s\n", os);
}

// Function to set GZDoom path, WADs path, and subfolder options
void set_paths(char *gzdoom_path, char *wads_path, int *use_subfolders) {
    printf("Please set GZDoom path (max 255 characters): ");
    scanf("%255s", gzdoom_path);
    
    printf("Please set WADs folder path (max 255 characters): ");
    scanf("%255s", wads_path);
    
    printf("Use subfolders for WADs/PK3s? (1 for yes, 0 for no): ");
    scanf("%d", use_subfolders);
}

// Function to execute GZDoom with WADs and PK3s
void run_gzdoom(const char *gzdoom_path, const char *wads_path, int use_subfolders, const char *os) {
    char command[MAX_CMD_LEN];
    
    // Build the command to run GZDoom
    build_command(command, gzdoom_path, wads_path, use_subfolders, os);
    
    printf("Executing: %s\n", command);
    
    // Run the command silently based on the operating system
    if (strcmp(os, "windows") == 0) {
        system(command);  // On Windows, run normally (you can improve it with a silent method)
    } else if (strcmp(os, "macos") == 0) {
        system(command);  // On macOS, run in the background
    } else if (strcmp(os, "linux") == 0) {
        system(command);  // On Linux, run in the background
    } else {
        printf("Unsupported OS: %s\n", os);
    }
}

// Function to build the GZDoom command based on OS and user inputs
void build_command(char *command, const char *gzdoom_path, const char *wads_path, int use_subfolders, const char *os) {
    if (strcmp(os, "windows") == 0) {
        snprintf(command, MAX_CMD_LEN, "\"%s\" -file \"%s\"", gzdoom_path, wads_path);
    } else if (strcmp(os, "macos") == 0 || strcmp(os, "linux") == 0) {
        snprintf(command, MAX_CMD_LEN, "%s -file %s", gzdoom_path, wads_path);
    }
    
    // If subfolders are used, add recursive search for WADs and PK3s
    if (use_subfolders) {
        strcat(command, " -searchdir");
    }
}
