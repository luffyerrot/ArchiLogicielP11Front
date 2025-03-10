FROM node:lts-alpine as build-stage

WORKDIR /app

COPY package*.json ./

COPY yarn.lock ./

RUN yarn install

COPY . .

RUN yarn run build

FROM nginx:stable-alpine as production-stage

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=build-stage /app/dist /usr/share/nginx/html

EXPOSE 8080

CMD [ "nginx", "-g", "daemon off;" ]