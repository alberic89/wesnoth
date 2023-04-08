ARG ARCH
FROM docker.io/alberic89/wesnoth-build-env:${ARCH} AS needs-squashing
COPY .. /home/wesnoth-travis/wesnoth/
WORKDIR /home/wesnoth-travis/wesnoth/
RUN BUILD_DATE=$(date)
RUN cmake . -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` && make install -j`nproc` && rm -rfv /home/wesnoth-travis/wesnoth
RUN apt purge -y -qq openssl gdb xvfb bzip2 git cmake make gcc g++ lld doxygen graphviz gettext pigz apt-utils && apt autoremove --purge -y -qq && apt clean

FROM scratch
COPY --from=needs-squashing /usr /usr
WORKDIR /home/wesnoth-travis
CMD echo "Running The Battle for Wesnoth"; wesnoth
