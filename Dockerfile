ARG ARCH
FROM docker.io/alberic89/wesnoth-build-env:${ARCH} AS needs-squashing
COPY .. /tmp/wesnoth/
WORKDIR /tmp/wesnoth/
RUN BUILD_DATE=$(date)
RUN cmake . -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` && make install -j`nproc` && rm -rfv /tmp/wesnoth
RUN tar -xvf deps-rm.tar.gz && rm deps-rm.tar.gz && dpkg -P *.deb

FROM scratch
COPY --from=needs-squashing /usr /usr
CMD echo "Running The Battle for Wesnoth"; wesnoth
