# Dockerfile is essntially used to build the image in the virtual machine
# in other words, all the things we need to install and copy into the container before it gets executed.

FROM node:13.12.0-alpine as build
WORKDIR /todo-react

ENV PATH /todo-react/node_modules/.bin:$PATH

COPY ./todo-react/package.json ./
COPY ./todo-react/package-lock.json ./

RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent
COPY ./todo-react ./
RUN npm run build

# Production env
FROM nginx:stable-alpine
COPY --from=build /todo-react/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]