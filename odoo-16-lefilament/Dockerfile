FROM python:3.11-slim-bullseye AS builder
RUN set -x; \
        apt-get update &&\
        apt-get install -y --no-install-recommends build-essential libldap2-dev libpq-dev libsasl2-dev &&\
        pip install wheel &&\
        pip wheel --wheel-dir=/svc/wheels -r https://raw.githubusercontent.com/oca/OCB/16.0/requirements.txt &&\
        # astor required by base_view_inheritance_extension
        # openupgradelib required for OCA module migration from one version to another
        # phonenumbers required by phone_validation
        # python-stdnum>=1.18 required by l10n_fr_siret and l10n_fr_siret_lookup
        # PyYAML required by custom scripts for adding modules (https://sources.le-filament.com/lefilament/ansible-roles/docker_odoo/-/tree/master/templates)
        # zxcvbn required by password_security
        pip wheel --wheel-dir=/svc/wheels astor openupgradelib phonenumbers python-stdnum>=1.18 PyYAML zxcvbn


FROM python:3.11-slim-bullseye AS final
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PGDATABASE=odoo

RUN set -x; \
        apt-get update &&\
        apt-get install -y --no-install-recommends \
            curl \
            git \
            gnupg \
            openssh-client \
            xmlsec1 &&\
        echo 'deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main' >> /etc/apt/sources.list.d/postgresql.list &&\
        curl -SL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - &&\
        curl -o wkhtmltox.deb -SL https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-2/wkhtmltox_0.12.6.1-2.bullseye_amd64.deb &&\
        echo 'cecbf5a6abbd68d324a7cd6c51ec843d71e98951 wkhtmltox.deb' | sha1sum -c - &&\
        apt-get update &&\
        apt-get install -y --no-install-recommends ./wkhtmltox.deb &&\
        apt-get install -y --no-install-recommends postgresql-client &&\
        apt-get -y autoremove &&\
        rm -rf /var/lib/apt/lists/* wkhtmltox.deb

COPY --from=builder /svc /svc
RUN pip3 install --no-index --find-links=/svc/wheels -r https://raw.githubusercontent.com/oca/OCB/16.0/requirements.txt &&\
        pip3 install -U --no-index --find-links=/svc/wheels astor openupgradelib phonenumbers python-stdnum>=1.18 PyYAML zxcvbn

# Add Git Known Hosts
COPY ./ssh_known_git_hosts /root/.ssh/known_hosts

# Install Odoo and remove not French translations and .git directory to limit amount of data used by container
RUN set -x; \
        useradd --create-home --home-dir /opt/odoo --no-log-init odoo &&\
        /bin/bash -c "mkdir -p /opt/odoo/{etc,odoo,additional_addons,private_addons,data,private}" &&\
        curl -L https://github.com/OCA/OCB/tarball/16.0 | tar -xzC /opt/odoo/odoo --strip-components 1 &&\
        find /opt/odoo/odoo/addons/*/i18n/ /opt/odoo/odoo/odoo/addons/base/i18n/ -type f -not -name 'fr.po' -delete &&\
        chown -R odoo:odoo /opt/odoo

# Install Odoo OCA default dependencies - Commented modules do not exist yet
RUN set -x; \
        mkdir -p /tmp/oca-repos/ &&\
        curl -L https://github.com/OCA/account-financial-tools/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="account-financial-tools" --strip-components 1 &&\
        mv /tmp/oca-repos/account-financial-tools/account_lock_date_update \
           /tmp/oca-repos/account-financial-tools/account_move_name_sequence \
           /tmp/oca-repos/account-financial-tools/account_usability \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/account-invoicing/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="account-invoicing" --strip-components 1 &&\
        mv /tmp/oca-repos/account-invoicing/sale_timesheet_invoice_description /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/account-reconcile/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="account-reconcile" --strip-components 1 &&\
        mv /tmp/oca-repos/account-reconcile/account_statement_base \
           /tmp/oca-repos/account-reconcile/account_reconcile_oca \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/bank-statement-import/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="bank-statement-import" --strip-components 1 &&\
        mv /tmp/oca-repos/bank-statement-import/account_statement_import_base \
           /tmp/oca-repos/bank-statement-import/account_statement_import_file \
           /tmp/oca-repos/bank-statement-import/account_statement_import_ofx \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/crm/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="crm" --strip-components 1 &&\
        mv /tmp/oca-repos/crm/crm_stage_probability /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/l10n-france/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="l10n-france" --strip-components 1 &&\
        mv /tmp/oca-repos/l10n-france/l10n_fr_siret \
           /tmp/oca-repos/l10n-france/l10n_fr_siret_lookup \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/partner-contact/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="partner-contact" --strip-components 1 &&\
        mv /tmp/oca-repos/partner-contact/partner_disable_gravatar \
           /tmp/oca-repos/partner-contact/partner_firstname \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/project/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="project" --strip-components 1 &&\
        mv /tmp/oca-repos/project/project_task_default_stage \
            /tmp/oca-repos/project/project_template \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/server-auth/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="server-auth" --strip-components 1 &&\
        mv /tmp/oca-repos/server-auth/password_security \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/server-brand/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="server-brand" --strip-components 1 &&\
        mv /tmp/oca-repos/server-brand/disable_odoo_online \
           /tmp/oca-repos/server-brand/portal_odoo_debranding \
           /tmp/oca-repos/server-brand/remove_odoo_enterprise \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/server-tools/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="server-tools" --strip-components 1 &&\
        mv /tmp/oca-repos/server-tools/base_view_inheritance_extension \
           /tmp/oca-repos/server-tools/module_change_auto_install \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/server-ux/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="server-ux" --strip-components 1 &&\
        mv /tmp/oca-repos/server-ux/server_action_mass_edit \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/social/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="social" --strip-components 1 &&\
        mv /tmp/oca-repos/social/mail_debrand \
           /tmp/oca-repos/social/mail_tracking \
           /opt/odoo/additional_addons/ &&\
        curl -L https://github.com/OCA/web/tarball/16.0 | tar -xzC /tmp/oca-repos/ --one-top-level="web" --strip-components 1 &&\
        mv /tmp/oca-repos/web/web_chatter_position \
           /tmp/oca-repos/web/web_environment_ribbon \
           /tmp/oca-repos/web/web_refresher \
           /tmp/oca-repos/web/web_responsive \
           /tmp/oca-repos/web/web_no_bubble \
           /tmp/oca-repos/web/web_theme_classic \
           /opt/odoo/additional_addons/ &&\
        rm -rf /tmp/oca-repos/ &&\
        find /opt/odoo/additional_addons/*/i18n/ -type f -not -name 'fr.po' -delete &&\
        # Install Le Filament default dependency
        git clone -b 16.0 --depth 1 https://sources.le-filament.com/lefilament/remove_login_links.git /opt/odoo/private_addons/remove_login_links &&\
        git clone -b 16.0 --depth 1 https://sources.le-filament.com/lefilament/lefilament_release_agent.git /opt/odoo/private_addons/lefilament_release_agent &&\
        chown -R odoo:odoo /opt/odoo

# Copy entrypoint script and Odoo configuration file
COPY ./entrypoint.sh /
COPY ./odoo.conf /opt/odoo/etc/odoo.conf
RUN chown odoo:odoo /opt/odoo/etc/odoo.conf

# Mount /opt/odoo/data to allow restoring filestore
VOLUME ["/opt/odoo/data/"]

# Expose Odoo services
EXPOSE 8069

# Set default user when running the container
USER odoo

# Start
ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]

# Metadata
LABEL org.label-schema.schema-version="16.0" \
      org.label-schema.vendor=LeFilament \
      org.label-schema.license=Apache-2.0 \
      org.label-schema.vcs-url="https://sources.le-filament.com/lefilament/odoo_docker"
