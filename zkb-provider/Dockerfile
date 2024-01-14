FROM node:16-alpine

WORKDIR /usr/src/app

RUN apk update
RUN apk add bash
RUN apk add nodejs npm
RUN apk add curl
RUN apk add git

ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh /wait-for-it.sh
RUN chmod +x /wait-for-it.sh

COPY install.sh install.sh
RUN chmod +x install.sh

CMD ["./install.sh"]
