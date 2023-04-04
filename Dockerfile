FROM docker.io/alberic89/wesnoth-build-env
COPY * /tmp/wesnoth/
WORKDIR /tmp/wesnoth/
RUN BFW_VERSION=$(echo 'import data.tools.wesnoth.version as v;print(v.as_string)' | python3)
RUN BUILD_DATE=$(date)
RUN mkdir build
WORKDIR /tmp/wesnoth/build/
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` 
RUN make -j`nproc` 
RUN make install -j`nproc` 
WORKDIR /
RUN rm -rfv /tmp/wesnoth
CMD echo "Run The Battle for Wesnoth $BFW_VERSION" && echo "Build date: $BUILD_DATE" && wesnoth
