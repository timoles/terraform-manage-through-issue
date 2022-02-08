# Configure the Hetzner Cloud Provider

provider "hcloud" {
  token = var.hcloud_token
}

# Create Clients
resource "hcloud_server" "server_spawn_github_action" {
  name        = var.servername
  server_type = var.server_type
  image       = var.snapshot_id
  location    = var.location
  ssh_keys    = [var.public_key_name]
  labels = {
    "github_action_spawn" : ""
  }
  
  user_data = templatefile("user_data.yml.tfpl", { user_pw_string = "${var.cloud_init_user_name}:${var.cloud_init_user_password}", username = "${var.cloud_init_user_name}" })  # TODO yamlencode this input, also user_pw_string needs to contain the same username as specified in username
}

output "instance_ip_addr" {
  value = hcloud_server.server_spawn_github_action.ipv4_address
}
