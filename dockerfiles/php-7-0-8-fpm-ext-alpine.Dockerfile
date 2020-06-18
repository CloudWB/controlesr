version: '2'

services:
  nginx:
    image: nginx:alpine
    restart: always
    links:
      - fpm5-6-23
      - fpm7-0-8
      - fpm-ext7-0-8
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/enabled:/etc/nginx/conf.d
      - ./nginx/snippets:/nginx/snippets
    volumes_from:
      - data

  fpm5-6-23:
    image: php:5.6.23-fpm-alpine
    restart: always
    volumes_from:
      - data

  fpm7-0-8:
    image: php:7.0.8-fpm-alpine
    restart: always
    volumes_from:
      - data

  fpm-ext7-0-8:
    build:
      context: ./dockerfiles
      dockerfile: php-7-0-8-fpm-ext-alpine.Dockerfile
    restart: always
    volumes_from:
      - data

  db:
    image: harianto/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
    volumes:
      - ./db/storage:/var/lib/mysql

  dbadmin:
    image: phpmyadmin/phpmyadmin
    restart: always
    depends_on:
      - db
    # ports:
    #   - "8080:80"

  data:
    image: alpine:latest
    command: echo "READY!!!"
    volumes:
      - ./vhosts:/vhosts
      - ./tmp:/tmp