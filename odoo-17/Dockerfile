FROM debian:bullseye-slim
MAINTAINER Yann Le Doaré <odoo-services@linuxconsole.org>

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

# Generate locale C.UTF-8 for postgres and general locale data
ENV LANG C.UTF-8

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        xz-utils

RUN curl -o wkhtmltox.deb -sSL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb \
    && echo 'cecbf5a6abbd68d324a7cd6c51ec843d71e98951 wkhtmltox.deb' | sha1sum -c - \
    && dpkg -x ./wkhtmltox.deb /
RUN rm wkhtmltox.deb

RUN curl -o libssl1.deb -sSL http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.1_1.1.1n-0+deb11u5_amd64.deb \
    && echo 'e8a80e4821679f43e796d2932830be21ab484344 libssl1.deb' | sha1sum -c - \
    && dpkg -x ./libssl1.deb /
RUN rm libssl1.deb

RUN apt-get install -y python3-pip
RUN apt-get install -y postgresql-client
RUN apt-get install -y libpq-dev
RUN apt-get install -y libldap-dev libsasl2-dev
RUN apt-get install -y wget libxrender1

# Install Odoo
ENV ODOO_VERSION 17.0
ARG ODOO_RELEASE=20240528
ARG ODOO_SHA=2201b25b944db607ef9c94cab21a6db87c37b0bf
RUN curl -o odoo.deb -sSL https://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.${ODOO_RELEASE}_all.deb \
    && echo "${ODOO_SHA} odoo.deb" | sha1sum -c - \
    && dpkg -x odoo.deb /

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /etc/odoo/
RUN useradd odoo
# Set permissions and Mount /var/lib/odoo to allow restoring filestore and /mnt/extra-addons for users addons
RUN install -d /var/lib/odoo
RUN chown odoo /var/lib/odoo
RUN chown odoo /etc/odoo/odoo.conf \
    && mkdir -p /mnt/extra-addons \
    && chown -R odoo /mnt/extra-addons
VOLUME ["/var/lib/odoo", "/mnt/extra-addons"]

# Expose Odoo services
EXPOSE 8069 8071 8072

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

COPY wait-for-psql.py /usr/local/bin/wait-for-psql.py

ENV PIP_ROOT_USER_ACTION=ignore

RUN pip3 install --upgrade pip
RUN pip install --upgrade pip setuptools wheel
RUN wget https://raw.githubusercontent.com/odoo/odoo/17.0/requirements.txt && pip3 install -r requirements.txt

USER odoo
ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
