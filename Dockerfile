FROM node:17.0-alpine

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ARG LINK=no

RUN adduser -S ory -D -u 10000 -s /bin/nologin

COPY package.json .
COPY package-lock.json .

RUN npm ci --fetch-timeout=600000

COPY . /usr/src/app

RUN if [ "$LINK" == "true" ]; then (cd ./contrib/sdk/generated; rm -rf node_modules; npm ci; npm run build); \
    cp -r ./contrib/sdk/generated/* node_modules/@ory/kratos-client/; \
    fi


ENV HOME=/usr/src/app
ENV PORT=80
ENV KRATOS_PUBLIC_URL=http://kratos:4433/
ENV KRATOS_BROWSER_URL=/.ory/kratos/public/

RUN npm run build

USER 10000

ENTRYPOINT npm run serve

EXPOSE 80
