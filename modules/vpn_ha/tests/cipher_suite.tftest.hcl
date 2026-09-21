# Verifies that the optional per-tunnel cipher_suite stays opt-in:
# - unset -> no cipher_suite block is produced (default Google Cloud negotiation)
# - explicit values -> the block is produced with the expected parameters

variables {
  project_id = "test-project"
  region     = "europe-west1"
  network    = "projects/test-project/global/networks/test-network"
  name       = "test-ha-vpn"
}

run "default_no_cipher_suite" {
  command = plan

  variables {
    tunnels = {
      remote-0 = {
        bgp_peer = {
          address = "169.254.1.1"
          asn     = 64513
        }
        bgp_session_range     = "169.254.1.2/30"
        ike_version           = 2
        vpn_gateway_interface = 0
        shared_secret         = "test-secret"
      }
    }
  }

  assert {
    condition     = length(google_compute_vpn_tunnel.tunnels["remote-0"].cipher_suite) == 0
    error_message = "cipher_suite block must be omitted when the variable is left unset"
  }
}

run "explicit_cipher_suite" {
  command = plan

  variables {
    tunnels = {
      remote-0 = {
        bgp_peer = {
          address = "169.254.1.1"
          asn     = 64513
        }
        bgp_session_range     = "169.254.1.2/30"
        ike_version           = 2
        vpn_gateway_interface = 0
        shared_secret         = "test-secret"
        cipher_suite = {
          phase1 = {
            encryption = ["AES-CBC-256"]
            integrity  = ["HMAC-SHA2-256-128"]
            prf        = ["PRF-HMAC-SHA2-256"]
            dh         = ["Group-14"]
          }
          phase2 = {
            encryption = ["AES-CBC-128"]
            integrity  = ["HMAC-SHA2-256-128"]
            pfs        = ["Group-14"]
          }
        }
      }
    }
  }

  assert {
    condition     = length(google_compute_vpn_tunnel.tunnels["remote-0"].cipher_suite) == 1
    error_message = "cipher_suite block must be present when explicitly configured"
  }

  assert {
    condition     = tolist(google_compute_vpn_tunnel.tunnels["remote-0"].cipher_suite[0].phase1[0].encryption) == tolist(["AES-CBC-256"])
    error_message = "phase1 encryption must match the explicit configuration"
  }

  assert {
    condition     = tolist(google_compute_vpn_tunnel.tunnels["remote-0"].cipher_suite[0].phase2[0].pfs) == tolist(["Group-14"])
    error_message = "phase2 pfs must match the explicit configuration"
  }
}
