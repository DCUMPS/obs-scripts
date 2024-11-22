-- Diagnostic print to check if 'obs' is available
print("OBS Lua script loaded. Checking OBS API availability...")

-- Ensure OBS API is accessible
if not obs then
    print("Error: OBS API not available. Ensure this script is run inside OBS Studio.")
    return
end

local media_source_name = "RandomAdPackages" -- Name of the media source in OBS
local folder_path = "I:/My Drive/MPS 2024-2025/24 Hour Broadcast/2023 Assets/FINISHED AD PACKAGES/" -- Path to media files

-- Function to get a random file from the specified folder
function get_random_file(folder)
    local i, files = 0, {}
    for file in io.popen('dir "' .. folder .. '" /b'):lines() do
        i = i + 1
        files[i] = file
    end
    if i == 0 then return nil end
    return files[math.random(i)]
end

-- Event callback for scene changes
function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
        local random_file = get_random_file(folder_path)
        if random_file then
            print("Selected random file: " .. random_file)
            local source = obs.obs_get_source_by_name(media_source_name)
            if source then
                local settings = obs.obs_source_get_settings(source)
                obs.obs_data_set_string(settings, "local_file", folder_path .. random_file)
                obs.obs_source_update(source, settings)
                obs.obs_data_release(settings)
                obs.obs_source_release(source)
            else
                print("Error: Media source not found: " .. media_source_name)
            end
        else
            print("Error: No files found in folder: " .. folder_path)
        end
    end
end

-- Script description
function script_description()
    return "Play a random media file on scene transition."
end

-- Script properties (not used here, but required for the API)
function script_properties()
    return nil
end

-- Load the script and register the callback
function script_load(settings)
    print("Script loaded successfully. Adding event callback.")
    obs.obs_frontend_add_event_callback(on_event)
end
