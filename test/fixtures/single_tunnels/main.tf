/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */



module "mgt_project" {
  source              = "terraform-google-modules/project-factory/google"
  version             = "~> 3.2.0"
  random_project_id   = true
  name                = "mgt-sample-project"
  org_id              = var.org_id
  folder_id           = var.folder_id
  billing_account     = var.billing_account
  activate_apis       = ["compute.googleapis.com"]
  credentials_path    = var.credentials_path
  domain              = "phoogle.net"
  auto_create_network = true
}

module "single_tunnels" {
  source = "../../../examples/single_tunnels"

  mgt_project_id  = module.mgt_project.project_id
  mgt_network     = var.mgt_network
  prod_project_id = var.prod_project_id
  prod_network    = var.prod_network
}

