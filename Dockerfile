ARG ARCH
FROM docker.io/alberic89/wesnoth-build-env:${ARCH} AS needs-squashing
COPY .. /tmp/wesnoth/
WORKDIR /tmp/wesnoth/
RUN BUILD_DATE=$(date)
RUN cmake . -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` 
RUN make install -j`nproc` 
WORKDIR /home/wesnoth-travis
RUN rm -rfv /tmp/wesnoth
RUN apt purge -y -qq openssl gdb xvfb bzip2 git cmake make gcc g++ lld doxygen graphviz gettext pigz apt-utils libboost*
RUN apt autoremove --purge -y -qq
RUN apt clean

FROM scratch
COPY --from=needs-squashing / /
CMD echo "Running The Battle for Wesnoth"; wesnoth
