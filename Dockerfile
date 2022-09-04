FROM apache/airflow:2.2.3

USER root
RUN apt-get update
RUN apt-get install -y wget

USER airflow

ARG GECKODRIVER_VERSION=v0.30.0
ARG FILENAME=geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz
RUN wget https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/${FILENAME} \
    && tar -xvzf ${FILENAME} \
    && chmod +x geckodriver \
    && rm ${FILENAME}

USER root
RUN apt-get purge wget -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends firefox-esr \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/* \
    && mv geckodriver /usr/local/bin

USER airflow
