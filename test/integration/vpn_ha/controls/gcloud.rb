# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

mgt_project_id    = attribute('mgt_project_id')
prod_project_id   = attribute('prod_project_id')
mgt_gateway_name  = attribute('mgt_gateway_name')
prod_gateway_name = attribute('prod_gateway_name')
prod_tunnel_names = attribute('prod_tunnel_names').values
mgt_tunnel_names  = attribute('mgt_tunnel_names').values
region            = attribute('region')

control "gcloud" do
  title "gcloud configuration"

  describe command("gcloud compute vpn-gateways describe #{mgt_gateway_name} --project=#{mgt_project_id} --region=#{region} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
    let(:selfLink) { "https://www.googleapis.com/compute/v1/projects/#{mgt_project_id}/regions/#{region}/vpnGateways/#{mgt_gateway_name}" }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "mgtGatewaySelfLink" do
      it "should be correct" do
        expect(data["selfLink"]).to eq selfLink
      end
    end
  end

  describe command("gcloud compute vpn-gateways describe #{prod_gateway_name} --project=#{prod_project_id} --region=#{region} --format=json") do
    its(:exit_status) { should eq 0 }
    its(:stderr) { should eq '' }
    let(:selfLink) { "https://www.googleapis.com/compute/v1/projects/#{prod_project_id}/regions/#{region}/vpnGateways/#{prod_gateway_name}" }

    let(:data) do
      if subject.exit_status == 0
        JSON.parse(subject.stdout)
      else
        {}
      end
    end

    describe "prodGatewaySelfLink" do
      it "should be correct" do
        expect(data["selfLink"]).to eq selfLink
      end
    end
  end

  for tunnel_name in prod_tunnel_names do
    describe command("gcloud compute vpn-tunnels describe #{tunnel_name} --project=#{prod_project_id} --region=#{region} --format=json") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }

      let(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
         {}
        end
      end

      describe "tunnelStatus" do
        it "should be ESTABLISHED" do
          expect(data["status"]).to eq "ESTABLISHED"
        end
      end
    end
  end

  for tunnel_name in mgt_tunnel_names do
    describe command("gcloud compute vpn-tunnels describe #{tunnel_name} --project=#{mgt_project_id} --region=#{region} --format=json") do
      its(:exit_status) { should eq 0 }
      its(:stderr) { should eq '' }

      let(:data) do
        if subject.exit_status == 0
          JSON.parse(subject.stdout)
        else
         {}
        end
      end

      describe "tunnelStatus" do
        it "should be ESTABLISHED" do
          expect(data["status"]).to eq "ESTABLISHED"
        end
      end
    end
  end

end
