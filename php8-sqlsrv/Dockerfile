FROM php:8-apache

RUN apt-get update -y 
RUN apt-get install -y libgssapi-krb5-2
RUN apt-get install -y unixodbc-dev
RUN apt-get install -y gnupg2
RUN pecl install sqlsrv
RUN pecl install pdo_sqlsrv
RUN echo extension=pdo_sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/10_pdo_sqlsrv.ini
RUN echo extension=sqlsrv.so >> `php --ini | grep "Scan for additional .ini files" | sed -e "s|.*:\s*||"`/20_sqlsrv.ini
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
 RUN ACCEPT_EULA=Y apt-get install -y mssql-tools18
COPY docker-run.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-run.sh
EXPOSE 80

ENTRYPOINT ["docker-run.sh"]
