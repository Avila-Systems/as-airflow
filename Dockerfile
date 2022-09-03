FROM apache/airflow:2.2.3

USER root
RUN apt-get update
RUN apt-get install -y aria2

USER airflow
RUN pip install --no-cache-dir selenium>=3.141 bs4>=0.0.1 lxml>=4.6.3 tqdm>=4.62.3

# RUN mkdir -p /opt/airflow/secrets
# COPY service-account.json /opt/airflow/secrets

ARG GECKODRIVER_VERSION=v0.30.0
ARG FILENAME=geckodriver-${GECKODRIVER_VERSION}-linux64.tar.gz
RUN aria2c https://github.com/mozilla/geckodriver/releases/download/${GECKODRIVER_VERSION}/${FILENAME} \
    && tar -xvzf ${FILENAME} \
    && chmod +x geckodriver \
    && rm ${FILENAME}

USER root
RUN apt-get purge aria2 -y \
    && apt-get update \
    && apt-get install -y --no-install-recommends firefox-esr \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/* \
    && mv geckodriver /usr/local/bin

USER airflow
