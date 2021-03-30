FROM node:10.7-alpine

ENV HOST 0.0.0.0
EXPOSE 3000

WORKDIR /usr/app
COPY . ./

RUN npm install --production
RUN npm cache clean --force

CMD ["npm", "start"]
