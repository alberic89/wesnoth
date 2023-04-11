ARG ARCH
FROM docker.io/alberic89/wesnoth-ci:${ARCH}-alpine-latest AS needs-squashing
WORKDIR /home/wesnoth-travis/wesnoth/
RUN cmake . -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` 
RUN make -j`nproc` 
RUN make install -j`nproc` 
RUN apk del make cmake gcc g++ gettext

FROM scratch
COPY --from=needs-squashing /usr /usr
WORKDIR /home/wesnoth-travis
CMD echo -e "Running The Battle for Wesnoth from container...\n\n\
Make sure you have passed as argument the directories corresponding to your X server and your video/audio card before reporting a bug.\n\
Example:\n\
\n\
    podman run -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY --device /dev/snd --device /dev/dri/card1 docker.io/alberic89/wesnoth:amd64\n\
\n\
Replace --device /dev/<xxx> with the locations reported as not found by the program.\
"; wesnoth
