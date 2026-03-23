# ==============================================================================
# DOCKERFILE - InfluxDB3 with Custom User Mapping and Secrets Support
# ==============================================================================
# Description: InfluxDB3 Core with custom user and Docker secrets handling
# Version: 3.8.0-custom
# ==============================================================================
# Base Image: influxdb:3.8.0-core
# Target Architecture: amd64
# Security: custom user mapping, Docker secrets support
# ==============================================================================

FROM influxdb:3.8.0-core

ARG USER_ID
ARG GROUP_ID
ARG USERNAME
ARG GROUPNAME
ARG OG_UID
ARG OG_GID

SHELL ["/bin/bash", "-c"]

USER root

RUN echo "Checking for UID ${USER_ID} and GID ${GROUP_ID}..."

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    echo "User and group found."; \
    echo "Deleting user ${USERNAME}..."; \
    userdel -f ${USERNAME} &&\
    echo "Searching if UID ${USER_ID} is already in use..."; \
    if [ ! -z $(id -un ${USER_ID}) ]; then \
       echo "Found user $(id -un ${USER_ID}) with UID ${USER_ID}."; \
       echo "Deleting user $(id -un ${USER_ID})..."; \
       userdel -f $(id -un ${USER_ID}); \
    fi &&\
    echo "Searching for group ${GROUPNAME}..."; \
    if getent group ${GROUPNAME}; then \
        echo "Found group ${GROUPNAME}."; \
        echo "Deleting ${GROUPNAME}..."; \
        groupdel ${GROUPNAME}; \
    else \
        echo "Group ${GROUPNAME} not found."; \
    fi &&\
    echo "Creating group ${GROUPNAME} with GID ${GROUP_ID}..."; \
    groupadd -g ${GROUP_ID} ${GROUPNAME} &&\
    echo "Creating user ${USERNAME} with UID ${USER_ID}..."; \
    useradd -l -u ${USER_ID} -g ${GROUPNAME} ${USERNAME} &&\
    echo "Creating user ${USERNAME} home directory..."; \
    install -d -m 0755 -o ${USERNAME} -g ${GROUPNAME} /home/${USERNAME}/ &&\
    echo "Changing existing folder permissions from original ${OG_UID}:${OG_GID} to ${USER_ID}:${GROUP_ID}"; \
    if [ -d "/home/ubuntu/" ]; then \
        mv "/home/ubuntu/*" "/home/${USERNAME}/"; \
        rm -r "/home/ubuntu/"; \
    fi &&\
    chown --changes --silent --no-dereference --recursive \
        --from=${OG_UID}:${OG_GID} ${USER_ID}:${GROUP_ID} \
            /home/${USERNAME}/ \
            /var/lib/influxdb3/ \
            /plugins/ \
;fi

RUN echo "Finished successfully."

COPY influxdb3-entrypoint.sh /influxdb3-entrypoint.sh
RUN chmod 755 /influxdb3-entrypoint.sh

USER ${USERNAME}

ENTRYPOINT ["/influxdb3-entrypoint.sh"]
CMD ["serve"]
