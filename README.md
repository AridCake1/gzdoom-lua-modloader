# A GZDoom WAD Loader in CLI made in Lua
This is a GZDoom CLI mod loader made entirely in Lua and a little bit of C for compiling and cross-plataform

## What I plan on adding:

1. Gameplay statistics (Time, Kills, etc.)

2. Screenshots

3. Other Source ports support built-in

4. Freedoom Downloader built-in

5. .zip mod loading support

**(SUGGEST MORE BY SENDING ME EMAIL)**


## Compiling on Mac and Linux
I haven't included releases for these two because I don't have them to compile, if you can compile for me and send me, chat with me in my **Discord**: **aridcake** ; or **email** me at: **aridcake1y@yahoo.com**

## If you have the knowledge and time:

### Windows
MinGW (Recommended):
< gcc -o gzdoom_loader.exe gzdoom_loader.c >

You can also use Visual Studio, although it requires more storage

### MacOS
XCode or gcc (can be either)
< gcc -o gzdoom_loader gzdoom_loader.c >
*Requires manual .app wrapping*

### Linux
Using gcc:
< gcc -o gzdoom_loader gzdoom_loader.c >

*optionally rename the output file:*
< mv gzdoom_loader gzdoom_loader.sh >

