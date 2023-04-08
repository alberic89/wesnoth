ARG ARCH
FROM docker.io/alberic89/wesnoth-build-env:${ARCH} AS needs-squashing
COPY .. /home/wesnoth-travis/wesnoth/
WORKDIR /home/wesnoth-travis/wesnoth/
RUN BUILD_DATE=$(date)
RUN cmake . -DCMAKE_BUILD_TYPE=Release -DFORCE_COLOR_OUTPUT=true -DENABLE_LTO=true -DLTO_JOBS=`nproc` && make install -j`nproc` && rm -rfv /home/wesnoth-travis/wesnoth
WORKDIR /home/wesnoth-travis
RUN tar -xvf deps-rm.tar.gz && rm -fv deps-rm.tar.gz && dpkg -P *.deb && rm -fv *.deb

FROM scratch
COPY --from=needs-squashing /usr /usr
CMD echo "Running The Battle for Wesnoth"; wesnoth
