mock_provider "google" {}
mock_provider "random" {}

variables {
  project_id = "test-project"
  network    = "test-network"
  region     = "europe-west1"
  peer_ips   = ["1.1.1.1"]
}

run "default_no_cipher_suite" {
  command = plan

  assert {
    condition     = length(google_compute_vpn_tunnel.tunnel-static[0].cipher_suite) == 0
    error_message = "cipher_suite block must be omitted when the variable is left unset"
  }
}

run "explicit_static_cipher_suite" {
  command = plan

  variables {
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

  assert {
    condition     = length(google_compute_vpn_tunnel.tunnel-static[0].cipher_suite) == 1
    error_message = "cipher_suite block must be present when explicitly configured"
  }

  assert {
    condition     = tolist(google_compute_vpn_tunnel.tunnel-static[0].cipher_suite[0].phase1[0].encryption) == tolist(["AES-CBC-256"])
    error_message = "phase1 encryption must match the explicit configuration"
  }

  assert {
    condition     = tolist(google_compute_vpn_tunnel.tunnel-static[0].cipher_suite[0].phase2[0].pfs) == tolist(["Group-14"])
    error_message = "phase2 pfs must match the explicit configuration"
  }
}

run "explicit_dynamic_cipher_suite" {
  command = plan

  variables {
    cr_enabled = true
    cr_name    = "test-router"
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

  assert {
    condition     = length(google_compute_vpn_tunnel.tunnel-dynamic[0].cipher_suite) == 1
    error_message = "dynamic tunnels must emit an explicitly configured cipher_suite block"
  }
}
