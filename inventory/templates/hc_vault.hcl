ui            = true
api_addr      = "https://{{ vault_domain }}:8200"
cluster_addr = "http://127.0.0.1:8201"

storage "raft" {
  path    = "{{ hc_vault_data_dir }}"
  node_id = "node1"
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
