FROM node:17.0-alpine

RUN mkdir -p /usr/src/app &&\
    chown -R nobody:nogroup /usr/src/app

ENV HOME=/usr/src/app
ENV PORT=80
ENV KRATOS_PUBLIC_URL=http://kratos:4433/
ENV KRATOS_BROWSER_URL=/.ory/kratos/public/
WORKDIR /usr/src/app
USER nobody

ADD --chown=nobody:nogroup ./package* ./
RUN npm ci --fetch-timeout=600000

EXPOSE 80
ENTRYPOINT ["npm", "run"]
CMD ["start"]

COPY --chown=nobody:nogroup . .
