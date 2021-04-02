FROM node:10.22-alpine

ENV HOST 0.0.0.0
EXPOSE 3000

WORKDIR /usr/app
COPY . ./

RUN yarn install --production
RUN yarn global add pm2

CMD ["pm2-runtime", "./bin/www"]
