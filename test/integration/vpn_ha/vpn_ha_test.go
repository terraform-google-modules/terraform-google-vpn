// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package vpn_ha

import (
	"fmt"
	"testing"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/tft"
	"github.com/stretchr/testify/assert"
)

func TestVpnHa(t *testing.T) {
	vpn := tft.NewTFBlueprintTest(t)

	vpn.DefineVerify(func(assert *assert.Assertions) {
		vpn.DefaultVerify(assert)

		prodProjectId := vpn.GetStringOutput("prod_project_id")
		mgtProjectId := vpn.GetStringOutput("mgt_project_id")
		mgtGatewayName := vpn.GetStringOutput("mgt_gateway_name")
		prodGatewayName := vpn.GetStringOutput("prod_gateway_name")
		mgtTunnelNames := vpn.GetStringOutput("mgt_tunnel_names_list")
		prodTunnelNames := vpn.GetStringOutput("prod_tunnel_names_list")
		region := vpn.GetStringOutput("region")

		mgtGateway := gcloud.Run(t, fmt.Sprintf("compute vpn-gateways describe %s --project %s --region=%s", mgtGatewayName, mgtProjectId, region))
		assert.Equal(mgtGatewayName, mgtGateway.Get("name").String(), "has expected name")
		assert.Equal("IPV4_ONLY", mgtGateway.Get("stackType").String(), "has expected stackType")
		mgtVpnInterfaces := mgtGateway.Get("vpnInterfaces").Array()
		assert.Equal(2, len(mgtVpnInterfaces), "found 2 vpnInterfaces")

		prodGateway := gcloud.Run(t, fmt.Sprintf("compute vpn-gateways describe %s --project %s --region=%s", prodGatewayName, prodProjectId, region))
		assert.Equal(prodGatewayName, prodGateway.Get("name").String(), "has expected name")
		assert.Equal("IPV4_ONLY", prodGateway.Get("stackType").String(), "has expected stackType")
		prodVpnInterfaces := prodGateway.Get("vpnInterfaces").Array()
		assert.Equal(2, len(prodVpnInterfaces), "found 2 vpnInterfaces")

		mgtTunnel := gcloud.Run(t, fmt.Sprintf("compute vpn-tunnels list --project %s", mgtProjectId))
		for _, tunnel := range mgtTunnel.Array() {
			assert.Contains(mgtTunnelNames, tunnel.Get("name").String(), "tunnel name matched")
		}

		prodTunnel := gcloud.Run(t, fmt.Sprintf("compute vpn-tunnels list --project %s", prodProjectId))
		for _, tunnel := range prodTunnel.Array() {
			assert.Contains(prodTunnelNames, tunnel.Get("name").String(), "tunnel name matched")
		}

	})
	vpn.Test()
}
