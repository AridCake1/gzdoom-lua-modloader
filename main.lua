--[[ 
    AridCake's GZDoom Mod Loader
    
    Thing ChatGPT added for me, because I'm lazy:
    - Added cross-platform support for Windows, macOS, and Linux
    - Added functionality to list and select both .wad and .pk3 files
    - Added handling for recursive searching of WADs and PK3s in subfolders
    - File locations for GZDoom, WADs, and subfolders are saved in a config file
    - Silent command execution for launching GZDoom without showing the console window
    - User can modify settings on boot and select WADs and PK3s to load
--]]

-- Variables
local filelocset = false
local gzdoom_path = "/path/to/gzdoom"
local wads_path = "/path/to/wads"
local wadsubfolders = false
local system_os = ""  -- To detect if it's Windows, Linux, or macOS

-- Detect Operating System
if package.config:sub(1,1) == '\\' then
    system_os = "windows"
elseif io.popen("uname"):read("*l") == "Darwin" then
    system_os = "macos"
else
    system_os = "linux"
end

print("Operating System Detected: " .. system_os)

-- File location management
function fileloc(define)
    local file = io.open("config.cfg", define)
    return file
end

local file1 = fileloc("a+")

-- Check if file locations have been set
if not file1 then
    print("Syntax error, please restart modloader")
end

-- Function to add GZDoom, WADs folder, and WAD subfolder settings to the file
function att1(gzdoom, wads, subfolders, filelocset)
    if file1 then
        file1:write("gzdoom_path = \"" .. gzdoom .. "\"\n")
        file1:write("wads_path = \"" .. wads .. "\"\n")
        file1:write("wadsubfolders = " .. tostring(subfolders) .. "\n")
        file1:write("filelocset = " .. tostring(filelocset) .. "\n")
        file1:flush()
    else
        print("Error: Could not write to the file.")
    end
end

-- Set file locations function
function setFileloc()
    print("Please set GZDoom Path: ")
    gzdoom_path = io.read()
    print("Please set WADs folder path: ")
    wads_path = io.read()
    print("Do you have subfolders with WADs/PK3s? (yes/no)")
    local subfolder_answer = io.read()
    wadsubfolders = (subfolder_answer == "yes")
    filelocset = true
    att1(gzdoom_path, wads_path, wadsubfolders, filelocset)
end

-- Function to list WADs and PK3s in a directory (and subdirectories if enabled)
function list_wads_and_pk3s(directory, include_subfolders)
    local file_list = {}
    local command_wad
    local command_pk3

    -- Handle listing files differently based on OS
    if system_os == "windows" then
        command_wad = 'dir "' .. directory .. '" /b /s *.wad'
        command_pk3 = 'dir "' .. directory .. '" /b /s *.pk3'
    else
        command_wad = 'find "' .. directory .. '" -type f -name "*.wad"'
        command_pk3 = 'find "' .. directory .. '" -type f -name "*.pk3"'
    end

    if include_subfolders then
        -- Search for both WAD and PK3 files
        local handle_wad = io.popen(command_wad)
        local handle_pk3 = io.popen(command_pk3)
        
        for file in handle_wad:lines() do
            table.insert(file_list, file)
        end
        for file in handle_pk3:lines() do
            table.insert(file_list, file)
        end
        handle_wad:close()
        handle_pk3:close()
    else
        -- Only check the root directory
        local handle_wad = io.popen(command_wad .. " | grep -v '/subfolder/'")
        local handle_pk3 = io.popen(command_pk3 .. " | grep -v '/subfolder/'")
        
        for file in handle_wad:lines() do
            table.insert(file_list, file)
        end
        for file in handle_pk3:lines() do
            table.insert(file_list, file)
        end
        handle_wad:close()
        handle_pk3:close()
    end

    -- Display the list of WADs and PK3s to the user
    if #file_list > 0 then
        print("Available WADs and PK3s:")
        for i, file in ipairs(file_list) do
            print(i .. ": " .. file)
        end
    else
        print("No WAD or PK3 files found.")
    end
end

-- Function to allow user to select WADs and PK3s to load
function select_files()
    print("Select the WADs/PK3s to load (separate numbers with commas):")
    local choices = io.read()
    local selected_files = {}
    for choice in string.gmatch(choices, '([^,]+)') do
        table.insert(selected_files, tonumber(choice))
    end
    return selected_files
end

-- Windows-specific command handling
function run_command_silently(command)
    if system_os == "windows" then
        os.execute('start /b ' .. command)
    else
        os.execute(command .. " &")
    end
end

-- Start of execution
print("Starting Execution.....")

if file1 then
    for line in file1:lines() do
        -- Read the file to check if filelocset is true
        if line:match("filelocset = true") then
            filelocset = true
        else
            setFileloc()  -- If not set, prompt the user to set paths
        end
    end

    -- If file locations were set, list WADs and PK3s
    if filelocset then
        list_wads_and_pk3s(wads_path, wadsubfolders)
        local selected_files = select_files()

        -- Run GZDoom with the selected WADs and PK3s
        local command = gzdoom_path .. " " .. table.concat(selected_files, " ")
        run_command_silently(command)
    end

    file1:flush()
    file1:close()
end
