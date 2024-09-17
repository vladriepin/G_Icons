#!/bin/bash

# Define the path to your Chrome Apps
chrome_apps_path="$HOME/Applications/Chrome Apps.localized"

# Define the path to your new PNG icons
# Update this with the actual path
color_pack='white'
new_icons_path="icons/input_png/${color_pack}"

# Function to convert PNG to ICNS
convert_to_icns() {
    png_path=$1
    icon_name=$(basename "$png_path" .png)
    iconset_folder="${new_icons_path}/${icon_name}.iconset"
    mkdir -p "$iconset_folder"

    # Declare an associative array for sizes and corresponding names
    declare -A sizes=(
        [16]="icon_16x16"
        [32]="icon_16x16@2x icon_32x32"
        [64]="icon_32x32@2x"
        [128]="icon_128x128"
        [256]="icon_128x128@2x icon_256x256"
        [512]="icon_256x256@2x icon_512x512"
        [1024]="icon_512x512@2x"
    )

    # Check if the PNG file exists
    if [ ! -f "$png_path" ]; then
        echo "Error: File not found at '$png_path'"
        exit 1
    fi

    # Loop through the sizes array
    for size in "${!sizes[@]}"; do
        for name in ${sizes[$size]}; do
#            echo "Resizing to $size x $size and saving as $name.png"
            sips -z $size $size "$png_path" --out "$iconset_folder/$name.png"
        done
    done

    # Convert to ICNS
    iconutil -c icns "$iconset_folder" -o "${new_icons_path}/${icon_name}.icns"

    # Clean up the iconset folder
    rm -rf "$iconset_folder"
}

# Function to update icon
update_icon() {
    app_name=$1
    icon_name=$2

    echo "Updating icon for $app_name..."

    # Path to the existing icon
    existing_icon="$chrome_apps_path/$app_name.app/Contents/Resources/app.icns"

    # Path to the new PNG icon
    new_png_icon="$new_icons_path/$icon_name.png"

    # Convert PNG to ICNS
    convert_to_icns "$new_png_icon"

    # Path to the new ICNS icon
    new_icns_icon="${new_icons_path}/${icon_name}.icns"

    # Rename new icon to 'app.icns' before copying
    mv "$new_icns_icon" "${new_icons_path}/app.icns"
    new_icns_icon="${new_icons_path}/app.icns"

    # Replace the existing icon with the new one
    if [ -f "$existing_icon" ]; then
        cp "$new_icns_icon" "$existing_icon"
        echo "Icon for $app_name updated successfully."
    else
        echo "Icon for $app_name not found."
    fi
     rm -rf $new_icns_icon
    # Touch the app to update the icon
    touch "$chrome_apps_path/$app_name.app"
}


# Update icons for your apps
#update_icon "Gmail" "g_icons_g_gmail"
update_icon "Google Calendar" "g_icons_g_calendar"
update_icon "Google Chat" "g_icons_g_chat"
update_icon "Google Meet" "g_icons_g_meet"
update_icon "YouTube Music" "g_icons_music"
update_icon "Outlook" "g_icons_outlook"
#update_icon "Teams" "g_icons_teams"
update_icon "Microsoft Teams" "g_icons_teams"

# Reset icon cache and restart Dock
rm -rfv ~/Library/Caches/com.apple.iconservices.store
killall -KILL Dock

echo "All icons updated."
