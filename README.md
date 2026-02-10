this is a work-in-progress to run Cursor inside docker with x11docker.

==How to execute==
I have tested it with ```x11docker --network -- --shm-size=1g -- cursor``` and Xephyr installed on the host. If  Xephyr is not installed on the host, there are other alternatives. Check the x11docker documentation. ```---shm-size=1g``` is needed because the default docker shm-size is 64MiB, and Cursor crashes with error 5.

==Authentication==
In order to authentication x11docker clipboard has to be enabled. Execute it with ```x11docker --verbose --network --clipboard=c2h -- --volume=/some/folder/to/save/cursor/data/:/home/<user>/  --shm-size=1g -- cursor```. Make right click on the ```sign in``` button and then "```copy sign in link```". Paste it on your browser on the host. I use the docker volume commands instead of ```shared``` flag or ```home``` flag because of my setup. Check x11docker documentation for storage flag.

==To Do==
Dockerfile can be trimmed further.
