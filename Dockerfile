FROM debian:bookworm as build

COPY FoundryVTT.zip .
RUN apt update &&\
    apt install -y unzip &&\
    unzip FoundryVTT.zip -d /opt/foundry

##############################################
FROM node:20-bookworm-slim as worker

LABEL maintainer="https://github.com/da3mon-01"

ARG FOUNDRY_UID=4567
ARG FOUNDRY_GID=4567
ENV FOUNDRY_USER_HOME=/home/foundry
ENV FOUNDRY_HOME=${FOUNDRY_USER_HOME}/fvtt
ENV FOUNDRY_DATA=${FOUNDRY_USER_HOME}/fvttdata
ENV NODE_ENV=production
ENV FOUNDRY_PORT=30000
# controls how cp command should copy over existing config
# check cp manual how this should behave
ENV CP_COMMAND_ARG="-vf"

# Set the foundry install home
RUN userdel -r node &&\
    addgroup -gid ${FOUNDRY_GID} foundry &&\
    adduser foundry --comment vtt --uid ${FOUNDRY_UID} --gid ${FOUNDRY_GID} --disabled-password &&\
    mkdir -p ${FOUNDRY_HOME} &&\
    mkdir -p ${FOUNDRY_DATA} &&\
    chown foundry:foundry -R ${FOUNDRY_USER_HOME}

WORKDIR "${FOUNDRY_HOME}"
USER foundry

COPY --from=build  --chown=foundry:foundry /opt/foundry ${FOUNDRY_HOME}/
COPY --chown=foundry:foundry docker-entrypoint.sh .

VOLUME [ "${FOUNDRY_DATA}" ]
EXPOSE ${FOUNDRY_PORT}

# not using envvar as
ENTRYPOINT [ "./docker-entrypoint.sh" ]
