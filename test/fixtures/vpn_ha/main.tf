/**
 * Copyright 2020 Google LLC
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

module "vpn_ha" {
  source = "../../../examples/vpn_ha"

  region                 = var.region
  mgt_project_id         = var.mgt_project_id
  mgt_network_self_link  = var.mgt_network_self_link
  prod_project_id        = var.prod_project_id
  prod_network_self_link = var.prod_network_self_link
}

