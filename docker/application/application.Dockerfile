FROM  --platform=linux/amd64 php:8.1-fpm-alpine

# Define build arguments
ARG USER_ID
ARG GROUP_ID

# Define environment variables
ENV DOCUMENT_ROOT=/var/www/html/public
ENV USER_NAME=vvuser
ENV GROUP_NAME=vvuser
ENV USER_ID=$USER_ID
ENV GROUP_ID=$GROUP_ID
ENV USER_ID=${USER_ID:-1001}
ENV GROUP_ID=${GROUP_ID:-1001}
ENV PS1='\u@\h \W \[\033[1;33m\]\$ \[\033[0m\]'

# Add group and user based on build arguments
RUN addgroup --gid ${GROUP_ID} ${GROUP_NAME}
RUN adduser --disabled-password --gecos '' --uid ${USER_ID} --ingroup vvuser vvuser

# Set user and group of working directory
RUN chown -R vvuser:vvuser /var/www/html

# Set nginx document root
RUN mkdir ${DOCUMENT_ROOT}

# Update and install packages
RUN apk update && apk add \
    bash \
    nginx \
    freetype-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    libpng-dev\
    jpeg \
    libxpm-dev

# Give root permissions to nginx files
RUN chown -R root:root /var/lib/nginx
RUN chmod -R +rx /var/lib/nginx

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install exif
RUN docker-php-ext-configure gd --with-freetype --with-webp --with-jpeg && \
    docker-php-ext-install gd

# Set nginx and PHP-FPM user
RUN sed -ri -e "s!user nginx!user ${USER_NAME}!g" /etc/nginx/nginx.conf
RUN sed -ri -e "s!user = www-data!user = ${USER_NAME}!g" /usr/local/etc/php-fpm.d/www.conf
RUN sed -ri -e "s!group = www-data!group = ${GROUP_NAME}!g" /usr/local/etc/php-fpm.d/www.conf

# Manualy expose port 80 for outside access to nginx
EXPOSE 80

# Copy configuration to application container
COPY docker/application/nginx.conf /etc/nginx/http.d/default.conf
COPY docker/application/php.ini /usr/local/etc/php/php.ini

# Start nginx and PHP-FPM
CMD nginx && docker-php-entrypoint php-fpm
