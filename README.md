`update_icons.sh` script used to update icons of Google Chrome apps on macOS, stored
in `~/Applications/Chrome Apps` directory.

## Usage

- run sh script using bash ```update_icons.sh```
- script will upload icons from `icons/input_png` and convert them to `.icns` format
- script will replace icons of Google Chrome apps in `~/Applications/Chrome Apps` directory
- if you add new icon to `icons/input_png` directory, you need to:
    - add new line in `update_icons.sh` script and specify name of the app,
      e.g. `update_icon "Name of App" "name of image"`.
    - This will replace icon of `Name of App` with `name of image.png` from `icons/input_png` directory.
  

