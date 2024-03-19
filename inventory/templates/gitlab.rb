external_url 'https://{{ gitlab_domain }}'
letsencrypt['enable'] = false
nginx['redirect_http_to_https'] = true
nginx['ssl_certificate'] = "/etc/gitlab/ssl/{{ gitlab_domain }}.crt"
nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/{{ gitlab_domain }}.key"

registry_external_url 'https://{{ gitlab_registry_domain }}'
registry['enable'] = true
registry_nginx['ssl_certificate'] = "/etc/gitlab/ssl/{{ gitlab_domain }}.crt"
registry_nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/{{ gitlab_domain }}.key"

pages_external_url "https://{{ gitlab_pages_domain }}/"
gitlab_pages['enable'] = true
pages_nginx['ssl_certificate'] = "/etc/gitlab/ssl/{{ gitlab_domain }}.crt"
pages_nginx['ssl_certificate_key'] = "/etc/gitlab/ssl/{{ gitlab_domain }}.key"
gitlab_pages['namespace_in_path'] = true

# Disable SSH
gitlab_sshd['enable'] = false

# # Auth
# gitlab_rails['omniauth_enabled'] = true
# gitlab_rails['omniauth_allow_single_sign_on'] = ['saml']
# gitlab_rails['omniauth_auto_sign_in_with_provider'] = 'saml'
# gitlab_rails['omniauth_block_auto_created_users'] = false
# gitlab_rails['omniauth_auto_link_saml_user'] = true
# gitlab_rails['omniauth_providers'] = [{
#   name: 'saml',
#   label: '{{ gitlab_keycloak_realm }} Login',
# # Re-enable user/password login as this will overwrite the users group type
# #    groups_attribute: 'Roles',
# #    admin_groups: ['admin'],
#   args: {
#     assertion_consumer_service_url: 'https://{{ gitlab_domain }}/users/auth/saml/callback',
#     idp_cert_fingerprint: '69:DB:06:EF:D2:1F:CC:78:A6:4D:6C:28:0D:0C:7A:BC:96:2F:A0:B6',
#     idp_sso_target_url: 'https://{{ keycloak_domain }}/realms/{{ gitlab_keycloak_realm }}/protocol/saml/clients/{{ gitlab_domain }}',
#     issuer: '{{ gitlab_domain }}',
#     name_identifier_format: 'urn:oasis:names:tc:SAML:2.0:nameid-format:persistent'
#   }
# }]

# https://gitlab.com/gitlab-org/gitlab/-/issues/391298
gitlab_rails['ldap_enabled'] = true
gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
   main:
     label: 'LDAP'
     host: 'rigurd.{{ local_domain }}'
     port: 636
     uid: 'uid'
     bind_dn: 'uid={{ gitlab_ldap_user }},cn=users,cn=accounts,{{ gitlab_ldap_suffix }}'
     password: '{{ gitlab_ldap_password }}'
     encryption: 'simple_tls'
     verify_certificates: false
     smartcard_auth: false
     active_directory: false
     allow_username_or_email_login: false
     lowercase_usernames: false
     block_auto_created_users: false
     base: '{{ gitlab_ldap_suffix }}'
     user_filter: 'memberof=cn=gitlab-user,cn=groups,cn=accounts,{{ gitlab_ldap_suffix }}'
EOS

# Mount data onto data-disk
git_data_dirs({"default" => { "path" => "{{ gitlab_root_data_dir }}/git-data"} })
gitlab_rails['uploads_directory'] = '{{ gitlab_root_data_dir }}/uploads'
gitlab_rails['shared_path'] = '{{ gitlab_root_data_dir }}/shared'
gitlab_ci['builds_directory'] = '{{ gitlab_root_data_dir }}/builds'

gitlab_rails['backup_path'] = '{{ gitlab_backup_data_dir }}'
