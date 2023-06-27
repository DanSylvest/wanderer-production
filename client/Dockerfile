FROM node:16-alpine

WORKDIR /usr/src/app

RUN apk update
RUN apk add curl
RUN apk add bzip2
RUN apk add git
RUN apk add postgresql
RUN apk add bash

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

COPY install.sh install.sh

RUN chmod +x install.sh

#CMD ["sh", "-c", "/wait-for-it.sh db:5432 -- ./install.sh"]
CMD ["./install.sh"]
