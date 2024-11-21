1. Play a Random Media File from a Folder

To load a random media file every time you transition to a scene, you can use a Lua or Python script:
Steps:

    Prepare Your Media Files:
        Store the media files (e.g., MP4s, GIFs, etc.) in a dedicated folder.

    Add a Media Source:
        In the target scene, add a media source and point it to a placeholder video file. Later, the script will dynamically change this file.

    Install and Load the Script:
        Go to Tools > Scripts in OBS.
        Load a Lua script (like the one below) that changes the media source's file to a random one upon scene transition.

    Example Lua Script: Save this as random_media.lua and load it into OBS:

    Test the Script:
        Switch scenes in Studio Mode to trigger the script. A random file will play.

1. Ensure New File on Transition

To ensure the random media resets or starts a new file only on scene transition, ensure the following:

    Set Playback Mode:
        In the Media Source properties:
            Check Restart playback when source becomes active to restart the media when the scene transitions.

    Transition Configuration:
        Use Studio Mode to preview and transition manually.

