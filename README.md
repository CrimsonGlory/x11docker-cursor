Run Cursor inside docker with [x11docker](https://github.com/mviereck/x11docker).

# Dependencies
- docker
- x11docker
- Xephyr
- xclip

# How to execute
The parameters of x11docker will depend on your needs.I have tested it with ```x11docker --network -- --shm-size=1g -- cursor``` and Xephyr installed on the host. If  Xephyr is not installed on the host, there are other alternatives. Check the x11docker documentation. ```---shm-size=1g``` is needed because the default docker shm-size is 64MiB, and Cursor crashes with error 5.

Also you likely will want to map a folder. I use docker mapping instead of x11docker because it is more flexible:
```x11docker --verbose --network -- --volume=/path/to/my/folder/:/home/<user>/  --shm-size=1g -e KEYBOARD_LAYOUT=$(grep "XKBLAYOUT" /etc/default/keyboard  | sed "s/XKBLAYOUT=//g" | tr -d '"') -- cursor```

Replace ```/path/to/my/folder/``` with the folder you want cursor stuff stored. Also replace ```<user>``` with your host non-root user.

I use the ```es``` keyboard layout, and in order to make Alt Gr worked I had to do the following:

```x11docker --verbose --network -- --volume=/path_to_my_folder/:/home/<user>/  --shm-size=1g -e KEYBOARD_LAYOUT=$(grep "XKBLAYOUT" /etc/default/keyboard  | sed "s/XKBLAYOUT=//g" | tr -d '"') -- cursor```

Also, we add ```--volume=/path/to/repo/x11docker-cursor/bin:/opt/cursor/``` in order to store the AppImage outside the container, so we can use the built-in update method, beta and nightly versions of Cursor.

The final result is:

```x11docker --verbose --network -- --volume=/path_to_my_folder/:/home/<user>/ --volume=/path/to/repo/x11docker-cursor/bin:/opt/cursor/ --shm-size=1g -e KEYBOARD_LAYOUT=$(grep "XKBLAYOUT" /etc/default/keyboard  | sed "s/XKBLAYOUT=//g" | tr -d '"') -- cursor```

# Authentication
In order to perform authentication on Cursor a browser is needed. Given that there is no browser inside the container we will have to copy the link and open it outside the container. x11docker clipboard has to be enabled for this. Execute it with ```--clipboard=c2h```. Make right click on the ```sign in``` button and then "```copy sign in link```". Paste it on your browser on the host and continue the steps.

# Clipboard
x11docker has three options for the clipboard parameter. The most comfortable is the bidirectional clipboard, but breaks isolation. A most secure is none, but it is impractical. A good trade-off is c2h (container to host) plus using the script copy_clipboard.sh to copy host clipboard contents to the container (xclip is needed on the host).

# Motivation
Cursor is closed source, and running it in a VM is not very comfortable. There are other cursor-on-docker solutions but they all are the cursor-inside-browser kind of solution, and that way there are shortcuts that you cannot use. Why x11docker? To execute it with the least privileges possible (if connected to the X11 server directly, it would be able to capture all the keystrokes)

# To Do
Dockerfile can be trimmed further.
