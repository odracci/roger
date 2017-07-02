FROM node:0.12

MAINTAINER Alessandro Nadalin "alessandro.nadalin@gmail.com"

# dev deps
RUN npm install -g nodemon
RUN apt-get update && \
    apt-get install -y git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    find /var/log -type f | while read f; do echo -ne '' > $f; done;

RUN mkdir /tmp/roger-builds \
    && mkdir /tmp/roger-builds/logs \
    && mkdir /tmp/roger-builds/tars \
    && mkdir /tmp/roger-builds/sources

COPY ./db /db

COPY ./src/client/package.json /src/src/client/

WORKDIR /src/src/client
RUN npm install

COPY ./package.json /src/
COPY ./npm-shrinkwrap.json /src/
WORKDIR /src
RUN npm install

COPY . /src

WORKDIR /src/src/client
RUN npm run build

WORKDIR /src

EXPOSE 8080
CMD ["node", "src/index.js", "--config", "/src/config.yml"]
