external_url 'https://{{ gitlab_domain }}'

# Listen on localhost only as running behind cloudflared
nginx['listen_addresses'] = ["127.0.0.1"]
registry_nginx['listen_addresses'] = ["127.0.0.1"]
mattermost_nginx['listen_addresses'] = ["127.0.0.1"]
pages_nginx['listen_addresses'] = ["127.0.0.1"]

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
# Don't think these are needed, but we are running behind a reverse proxy
letsencrypt['enable'] = false
nginx['listen_port'] = 80
nginx['listen_https'] = false

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

# Mount data onto data-disk
git_data_dirs({"default" => { "path" => "{{ gitlab_root_data_dir }}/git-data"} })
gitlab_rails['uploads_directory'] = '{{ gitlab_root_data_dir }}/uploads'
gitlab_rails['shared_path'] = '{{ gitlab_root_data_dir }}/shared'
gitlab_ci['builds_directory'] = '{{ gitlab_root_data_dir }}/builds'
