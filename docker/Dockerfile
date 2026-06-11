FROM elixir:1.20

ENV DEPLOY_USER das
ENV DEPLOY_USER_DIR /opt/das

RUN mkdir ${DEPLOY_USER_DIR}

RUN useradd ${DEPLOY_USER} --create-home --shell /bin/bash

# install dependencies
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        bash locales sudo git ca-certificates \
        && \
    update-ca-certificates && \
    apt-get clean && \
    find /var/lib/apt/lists -type f -delete

RUN echo "${DEPLOY_USER} ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV LANG C.UTF-8

RUN chown ${DEPLOY_USER}:${DEPLOY_USER} -R ${DEPLOY_USER_DIR}

USER ${DEPLOY_USER}

RUN mkdir ${DEPLOY_USER_DIR}/das

WORKDIR ${DEPLOY_USER_DIR}/das

RUN git clone https://github.com/Rafaeltheraven/das.git .

RUN cp config/runtime.exs.docker config/runtime.exs

RUN mix local.hex --force

RUN mix local.rebar --force

RUN mix deps.get

ENV MIX_ENV=prod

RUN mix release das

WORKDIR ${DEPLOY_USER_DIR}/das/_build/prod/rel/das

CMD ["./bin/das", "start"]
