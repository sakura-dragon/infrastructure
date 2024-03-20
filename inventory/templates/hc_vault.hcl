ui            = true
api_addr      = "https://0.0.0.0:8200"

storage "file" {
  path = "{{ hc_vault_data_dir }}"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "{{ acme_default_certificate_root_path }}/{{ vault_domain }}-fullchain.crt"
  tls_key_file  = "{{ acme_default_certificate_root_path }}/{{ vault_domain }}.key"
}

#telemetry {
#  statsite_address = "0.0.0.0:8125"
#  disable_hostname = true
#}
