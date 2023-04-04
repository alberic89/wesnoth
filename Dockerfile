ARG ARCH
ARG BFW_VERSION
FROM docker.io/alberic89/wesnoth-build-env:${ARCH}
COPY * /tmp/wesnoth/
WORKDIR /tmp/wesnoth/
RUN BUILD_DATE=$(date)
RUN cmake . -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` 
RUN make -j`nproc` 
RUN make install -j`nproc` 
WORKDIR /home/wesnoth-travis
RUN rm -rfv /tmp/wesnoth
CMD echo "Run The Battle for Wesnoth $BFW_VERSION"; echo "Build date: $BUILD_DATE"; wesnoth
