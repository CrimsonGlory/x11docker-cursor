this is a work-in-progress to run Cursor inside docker with x11docker. The current state is that cursor opens with ```x11docker --verbose --network -- --shm-size=1g -- cursor``` and Xephyr installed on the host.


Authentication will likely require to enable the shared clipboard at least once.


Dockerfile can be trimmed further.
