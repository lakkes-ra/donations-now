# Define base image
FROM --platform=linux/amd64 php:8.1-cli-alpine

# Define build arguments
ARG USER_ID
ARG GROUP_ID

# Define environment variables
ENV USER_ID=$USER_ID
ENV GROUP_ID=$GROUP_ID
ENV USER_ID=${USER_ID:-1001}
ENV GROUP_ID=${GROUP_ID:-1001}
ENV PS1='\u@\h \W \[\033[1;33m\]\$ \[\033[0m\]'

# Add group and user based on build arguments
RUN addgroup --gid ${GROUP_ID} vvuser
RUN adduser --disabled-password --gecos '' --uid ${USER_ID} --ingroup vvuser vvuser

# Set user and group of working directory
RUN chown -R vvuser:vvuser /var/www/html

# Update and install packages
RUN apk update && apk add \
    bash \
    gnupg \
    libzip-dev \
    nodejs~=18 \
    npm \
    unzip \
    zip

# Install PHP extensions
RUN apk add \
    php81-pdo \
    php81-session \
    php81-xml \
    php81-dom \
    php81-tokenizer \
    php81-xmlwriter \
    php81-fileinfo

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    composer self-update
