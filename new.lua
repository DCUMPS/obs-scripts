-- Script to randomize media playback on scene transitions
-- Place this script in your OBS scripts folder

-- Global variables
local source_name = "RandomAdPackages"
local media_folder = "I:/My Drive/MPS 2024-2025/24 Hour Broadcast/2023 Assets/FINISHED AD PACKAGES/"
local files = {}

-- Create script properties
function script_properties()
    local props = obs.obs_properties_create()
    
    -- Add media source selection
    local p = obs.obs_properties_add_list(props, "source", "Media Source", obs.OBS_COMBO_TYPE_EDITABLE, obs.OBS_COMBO_FORMAT_STRING)
    local sources = obs.obs_enum_sources()
    if sources ~= nil then
        for _, source in ipairs(sources) do
            local name = obs.obs_source_get_name(source)
            obs.obs_property_list_add_string(p, name, name)
        end
        obs.source_list_release(sources)
    end
    
    -- Add folder path selection
    obs.obs_properties_add_path(props, "folder", "Media Folder", obs.OBS_PATH_DIRECTORY, "", "")
    
    return props
end

-- Script description shown in OBS
function script_description()
    return "Randomizes media playback from a folder when transitioning between scenes."
end

-- Save user settings
function script_update(settings)
    source_name = obs.obs_data_get_string(settings, "source")
    media_folder = obs.obs_data_get_string(settings, "folder")
    scan_directory()
end

-- Scan the media directory for compatible files
function scan_directory()
    files = {}
    if media_folder ~= "" then
        local handle = io.popen('dir "' .. media_folder .. '" /b')
        if handle then
            for file in handle:lines() do
                -- Add files with common media extensions
                if file:match("%.mp4$") or file:match("%.mov$") or 
                   file:match("%.mkv$") or file:match("%.avi$") or
                   file:match("%.webm$") then
                    table.insert(files, file)
                end
            end
            handle:close()
        end
    end
end

-- Get a random file from the directory
function get_random_file()
    if #files > 0 then
        local index = math.random(1, #files)
        return media_folder .. "\\" .. files[index]
    end
    return nil
end

-- Called when transitioning between scenes
function on_transition(callback_type)
    if callback_type == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
        local source = obs.obs_get_source_by_name(source_name)
        if source ~= nil then
            local settings = obs.obs_source_get_settings(source)
            local new_file = get_random_file()
            
            if new_file then
                obs.obs_data_set_string(settings, "local_file", new_file)
                obs.obs_source_update(source, settings)
            end
            
            obs.obs_data_release(settings)
            obs.obs_source_release(source)
        end
    end
end

-- Register callback for scene changes
function script_load(settings)
    math.randomseed(os.time())
    obs.obs_frontend_add_event_callback(on_transition)
end