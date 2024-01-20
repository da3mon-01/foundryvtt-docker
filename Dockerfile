FROM debian:bookworm as build

ADD FoundryVTT-11.315.zip .
RUN apt update &&\
    apt install -y unzip &&\
    unzip FoundryVTT-11.315.zip -d /opt/foundry

##############################################
FROM node:20-bookworm-slim as worker

LABEL maintainer="https://github.com/da3mon-01"

ENV FOUNDRY_USER_HOME=/home/foundry
ENV FOUNDRY_HOME=${FOUNDRY_USER_HOME}/fvtt
ENV FOUNDRY_DATA=${FOUNDRY_USER_HOME}/fvttdata
ENV NODE_ENV=production
# controls how cp command should copy over existing config
# check cp manual how to use
ENV FOUNDRY_CONFIG_CP_OPTION="-f"

# Set the foundry install home
RUN userdel -r node &&\
    adduser foundry --comment vtt --disabled-password &&\
    mkdir -p ${FOUNDRY_HOME} &&\
    mkdir -p ${FOUNDRY_DATA} &&\
    chown foundry:foundry -R ${FOUNDRY_USER_HOME}

WORKDIR "${FOUNDRY_HOME}"
USER foundry

COPY --from=build  --chown=foundry:foundry /opt/foundry ${FOUNDRY_HOME}/
COPY --chown=foundry:foundry docker-entrypoint.sh .

VOLUME [ "${FOUNDRY_DATA}" ]
EXPOSE 30000

# not using envvar as 
ENTRYPOINT [ "./docker-entrypoint.sh" ]
