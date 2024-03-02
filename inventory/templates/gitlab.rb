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

# Restrict Resource Usage
puma['worker_processes'] = 0
sidekiq['max_concurrency'] = 10
gitlab_rails['env'] = {
  'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000'
}
gitaly['env'] = {
'MALLOC_CONF' => 'dirty_decay_ms:1000,muzzy_decay_ms:1000',
'GITALY_COMMAND_SPAWN_MAX_PARALLEL' => '2'
}
gitaly['configuration'] = {
  concurrency: [
    {
      rpc: '/gitaly.SmartHTTPService/PostReceivePack',
      max_per_repo: 3,
    },
    {
      rpc: '/gitaly.SSHService/SSHUploadPack',
      max_per_repo: 3,
    },
  ],
}

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
# gitlab_rails['ldap_enabled'] = true
# gitlab_rails['prevent_ldap_sign_in'] = false
# gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
#   main:
#     label: 'LDAP'
#     host: 'rigurd.{{ local_domain }}'
#     port: 389
#     uid: 'uid'
#     bind_dn: 'uid={{ gitlab_ldap_user }},cn=users,cn=accounts,{{ ipa_bind_domain_dc_components|join(",") }}'
#     password: '{{ gitlab_ldap_password }}'
#     encryption: 'start_tls'
#     base: 'cn=accounts,{{ ipa_bind_domain_dc_components|join(",") }}'
#     verify_certificates: false
#     smartcard_auth: false
#     active_directory: false
#     attributes:
#       username: ['uid']
#       email: ['mail']
#       name: 'displayName'
#       first_name: 'givenName'
#       last_name: 'sn'
#     allow_username_or_email_login: false
#     lowercase_usernames: false
#     block_auto_created_users: false
#     user_filter: '(memberof=CN=gitlabusers,CN=groups,CN=accounts,{{ ipa_bind_domain_dc_components|join(",") }})'
# EOS

# Mount data onto data-disk
git_data_dirs({"default" => { "path" => "{{ gitlab_root_data_dir }}/git-data"} })
gitlab_rails['uploads_directory'] = '{{ gitlab_root_data_dir }}/uploads'
gitlab_rails['shared_path'] = '{{ gitlab_root_data_dir }}/shared'
gitlab_ci['builds_directory'] = '{{ gitlab_root_data_dir }}/builds'
