/**
 * Copyright 2019 Google LLC
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

output "prod_project_id" {
  value       = module.prod-project.project_id
  description = "The name of the production VPC to be created."
}

output "prod_network_self_link" {
  value       = format("https://www.googleapis.com/compute/v1/projects/%s/global/networks/default", module.prod-project.project_id)
  description = "Self link of the production VPC to be created."
}

output "mgt_project_id" {
  value       = module.mgt-project.project_id
  description = "The ID of the management project where the VPC will be created."
}

output "mgt_network_self_link" {
  value       = format("https://www.googleapis.com/compute/v1/projects/%s/global/networks/default", module.mgt-project.project_id)
  description = "Self link of the production VPC to be created."
}

output "sa_key" {
  value     = google_service_account_key.int_test.private_key
  sensitive = true
}
