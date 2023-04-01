FROM docker.io/alberic89/wesnoth:latest
RUN git clone https://github.com/wesnoth/wesnoth.git --recurse-submodules --depth=1
RUN cd wesnoth
RUN BFW_VERSION=$(echo 'import data.tools.wesnoth.version as v;print(v.as_string)' | python3)
RUN $BUILD_DATE=$(date)
RUN mkdir build && cd build
RUN cmake .. -DCMAKE_BUILD_TYPE=Release -DCXX_STD="g++" -DCMAKE_INSTALL_PREFIX="usr/" -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` 
RUN make -j`nproc` 
RUN make install DESTDIR=../../wesnoth-$BFW_VERSION -j`nproc` 
RUN cd ../../
RUN chmod +x wesnoth-$BFW_VERSION/usr/bin/wesnoth
RUN rm -rf wesnoth/
CMD echo "Run The Battle for Wesnoth $BFW_VERSION" && echo "Build date: $BUILD_DATE" && ./wesnoth-$BFW_VERSION/usr/bin/wesnoth
