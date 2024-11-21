local media_source_name = "RandomAdPackages"
local folder_path = "I:/My Drive/MPS 2024-2025/24 Hour Broadcast/FINISHED AD PACKAGES"

function get_random_file(folder)
    local i, files = 0, {}
    for file in io.popen('dir "'..folder..'" /b'):lines() do
        i = i + 1
        files[i] = file
    end
    if i == 0 then return nil end
    return files[math.random(i)]
end

function on_event(event)
    if event == obs.OBS_FRONTEND_EVENT_SCENE_CHANGED then
        local random_file = get_random_file(folder_path)
        if random_file then
            local source = obs.obs_get_source_by_name(media_source_name)
            if source then
                local settings = obs.obs_source_get_settings(source)
                obs.obs_data_set_string(settings, "local_file", folder_path .. random_file)
                obs.obs_source_update(source, settings)
                obs.obs_data_release(settings)
                obs.obs_source_release(source)
            end
        end
    end
end

function script_description()
    return "Play a random media file on scene transition."
end

function script_properties()
    return nil
end

function script_load(settings)
    obs.obs_frontend_add_event_callback(on_event)
end
