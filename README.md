# Open Applist

Open Applist is a tool designed for macOS users who prefer to work with their apps in full-screen mode and want a way to automatically launch their most-used apps in full-screen each time they login/power on their Mac.

Before:![Screenshot 2024-04-12 at 2 34 23 PM](https://github.com/code-name-carter/open_applist/assets/48076414/c375ac41-8500-49ee-b52b-803cf5b06ebe)

After:![Screenshot 2024-04-12 at 2 33 41 PM](https://github.com/code-name-carter/open_applist/assets/48076414/01232abf-0644-4c7d-9f5e-943a0ca09362)

## How to

1. Clone this repo
    - `git clone <repo>`
    - `cd open_applist`
2. Create `app_list.txt`
    - `cp app_list.txt.example app_list.txt`
    - Edit `app_list.txt` to contain all the apps you want to have opened.
3. Run the deploy script
    - `./deploy.sh`
4. Grant `osascript` accessibility permissions at "System Settings -> Privacy & Security -> Accessibility"
    - The easiest way to do this is to log out and log back in. The deploy script will create the Open Applist app and add it to your login items. When you login and it tries to run Open Applist, it won't work due to the missing permissions but it will add the necessary item to the Accessibility list, then you can just navigate to "System Settings -> Privacy & Security -> Accessibility" and allow the app.
    - If this doesn't work, you can find `osascript` at `/usr/bin/osascript` (tricky to navigate to that location in Finder)
5. Celebrate! Now everytime you login, your apps will launch how ya like 'em!

## Logging

- By default errors are logged to `~/Library/Application\ Support/OpenApplist/error.log`
  - To view the error log:

    ```bash
    cat ~/Library/Application\ Support/OpenApplist/error.log
    ```

## Troubleshooting

- System Events got an error: Can’t get process "<Process Name>".
  - **Application Process Name Mismatch:**
        - Most app's application name is the same as their processes name, but not all of them. For example, the process for the app "Visual Studio Code" is called "code". Apps like this need special attention in the `OpenApplist` file.
        - If you encounter this, just add another line similar the following code in `OpenApplist` with the correct process name (you can find this by watching the Activity Monitor)
            ```
            -- Check if the application is Visual Studio Code and adjust the process name
            if   theApp contains "Visual Studio Code" then set processName to "Code"
            ```
    - **Application Launch Delay:**
      - The default delay time between opening and app and trying to fullscreen it is 3 seconds. Sometimes that's too short for an application's process to actually begin. Find `set openDelayTime to 3` in the `OpenApplist` file and extend it, then re-run `./deploy.sh`

## Compatibility

- Developed and tested on macOS Sonoma 14.2.1
- Tested on macOS Ventura 13.4

## Contributing

If you encounter issues or have suggestions for improvements, feel free to reach out or create a pull request. Contributions are welcome!
