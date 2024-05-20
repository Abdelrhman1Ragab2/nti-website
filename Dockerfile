FROM nginx:latest

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./rayban/  /usr/share/nginx/html

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]