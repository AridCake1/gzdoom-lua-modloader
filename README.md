# A GZDoom WAD Loader in CLI made in Lua
This is a GZDoom CLI mod loader made entirely in Lua and a little bit of C for compiling and cross-plataform

## Compiling on Mac and Linux
I haven't included releases for these two because I don't have them to compile, if you can compile for me and send me, chat with me in my **Discord**: **aridcake** ; or **email** me at: **aridcake1y@yahoo.com**

### Windows
MinGW (I haven't tested, but probably recommended):
< gcc -o gzdoom_loader.exe gzdoom_loader.c >

I used Visual Studio, more straight forward but uses more storage space.

### MacOS
XCode or gcc
< gcc -o gzdoom_loader gzdoom_loader.c >
*Requires manual .app wrapping*

### Linux
Using gcc:
< gcc -o gzdoom_loader gzdoom_loader.c >

*optionally rename the output file:*
< mv gzdoom_loader gzdoom_loader.sh >

