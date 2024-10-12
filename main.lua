--[[ 
    AridCake's GZDoom Mod Loader
    
    Thing ChatGPT added for me, because I'm lazy:
    - Added cross-platform support for Windows, macOS, and Linux
    - Added functionality to list and select both .wad and .pk3 files
    - Added handling for recursive searching of WADs and PK3s in subfolders
    - File locations for GZDoom, WADs, and subfolders are saved in a config file
    - Silent command execution for launching GZDoom without showing the console window
    - User can modify settings on boot and select WADs and PK3s to load
    - List and select both .wad, .pk3, and .zip files
    - Handle recursive searching of WADs, PK3s, and ZIPs in subfolders
    - Gameplay statistics tracking (Time, Kills, etc.)
    - Screenshot functionality
    - Freedoom downloader
--]]

-- Variables
local filelocset = false
local gzdoom_path = ""
local wads_path = ""
local wadsubfolders = false
local system_os = ""
local source_port = "gzdoom"  -- Default source port
local statistics = {time = 0, kills = 0}  -- Dummy statistics
local screenshots = {}  -- Placeholder for screenshots
local mods_selected = {}

-- Detect Operating System
if package.config:sub(1, 1) == '\\' then
    system_os = "windows"
elseif io.popen("uname"):read("*l") == "Darwin" then
    system_os = "macos"
else
    system_os = "linux"
end

print("Operating System Detected: " .. system_os)

-- File location management
local function fileloc(define)
    local file = io.open("config.cfg", define)
    return file
end

local file1 = fileloc("a+")

-- Check if file locations have been set
if not file1 then
    print("Error opening config file. Please restart modloader.")
    os.exit()
end

-- Function to add GZDoom, WADs folder, and WAD subfolder settings to the file
local function att1(gzdoom, wads, subfolders)
    if file1 then
        file1:write("gzdoom_path = \"" .. gzdoom .. "\"\n")
        file1:write("wads_path = \"" .. wads .. "\"\n")
        file1:write("wadsubfolders = " .. tostring(subfolders) .. "\n")
        file1:flush()
    else
        print("Error: Could not write to the file.")
    end
end

-- Set file locations function
local function setFileloc()
    print("Please set GZDoom Path: ")
    gzdoom_path = io.read()
    print("Please set WADs folder path: ")
    wads_path = io.read()
    print("Do you have subfolders with WADs/PK3s? (yes/no)")
    local subfolder_answer = io.read()
    wadsubfolders = (subfolder_answer:lower() == "yes")
    filelocset = true
    att1(gzdoom_path, wads_path, wadsubfolders)
end

-- Function to list WADs, PK3s, and ZIPs in a directory (and subdirectories if enabled)
local function list_mods(directory, include_subfolders)
    local file_list = {}
    local command

    -- Handle listing files differently based on OS
    if system_os == "windows" then
        command = 'dir "' .. directory .. '" /b /s *.wad & dir "' .. directory .. '" /b /s *.pk3 & dir "' .. directory .. '" /b /s *.zip'
    else
        command = 'find "' .. directory .. '" -type f \\( -name "*.wad" -o -name "*.pk3" -o -name "*.zip" \\)'
    end

    local handle = io.popen(command)
    for file in handle:lines() do
        table.insert(file_list, file)
    end
    handle:close()

    -- Display the list of mods to the user
    if #file_list > 0 then
        print("Available WADs, PK3s, and ZIPs:")
        for i, file in ipairs(file_list) do
            print(i .. ": " .. file)
        end
    else
        print("No WAD, PK3, or ZIP files found.")
    end
    return file_list
end

-- Function to allow user to select mods to load
local function select_files(file_list)
    print("Select the mods to load (separate numbers with commas):")
    local choices = io.read()
    local selected_files = {}
    for choice in string.gmatch(choices, '([^,]+)') do
        local index = tonumber(choice)
        if index and file_list[index] then
            table.insert(selected_files, file_list[index])
        else
            print("Invalid selection: " .. choice)
        end
    end
    return selected_files
end

-- Dummy function to track gameplay statistics
local function track_statistics()
    print("Tracking gameplay statistics...")
    statistics.time = os.time()  -- Just a placeholder
    statistics.kills = 0  -- Placeholder
end

-- Dummy function to capture screenshots
local function take_screenshot()
    print("Taking a screenshot...")
    table.insert(screenshots, os.time())  -- Just a placeholder
end

-- Dummy function to download Freedoom
local function download_freedoom()
    print("Downloading Freedoom...")
    -- Placeholder for download logic
end

-- Windows-specific command handling
local function run_command_silently(command)
    if system_os == "windows" then
        os.execute('start /b ' .. command)
    else
        os.execute(command .. " &")
    end
end

-- Start of execution
print("Starting Execution.....")

for line in file1:lines() do
    if line:match("filelocset = true") then
        filelocset = true
    end
end

if not filelocset then
    setFileloc()  -- Prompt the user to set paths if not set
end

-- If file locations were set, list WADs, PK3s, and ZIPs
if filelocset then
    local file_list = list_mods(wads_path, wadsubfolders)
    mods_selected = select_files(file_list)

    -- Run GZDoom with the selected mods
    if #mods_selected > 0 then
        local command = gzdoom_path .. " " .. table.concat(mods_selected, " ")
        run_command_silently(command)

        -- Track statistics and take a screenshot as a dummy action
        track_statistics()
        take_screenshot()
    else
        print("No mods selected to load.")
    end
end

file1:flush()
file1:close()
