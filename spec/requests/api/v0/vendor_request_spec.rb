require 'rails_helper'

RSpec.describe 'Vendor API', type: :request do
  describe 'GET /api/v0/vendors/:id' do 
    it 'returns a vendor if valid vendor id is passed in' do 
      vendor = create(:vendor)

      get "/api/v0/vendors/#{vendor.id}"

      expect(response).to have_http_status(200)

      vendor_response = JSON.parse(response.body, symbolize_names: true)
      data = vendor_response[:data]

      expect(data[:id]).to be_a(String)
      expect(data[:type]).to eq('vendor')
      expect(data[:attributes]).to be_a(Hash)
      expect(data[:attributes][:name]).to be_a(String)
      expect(data[:attributes][:description]).to be_a(String)
      expect(data[:attributes][:contact_name]).to be_a(String)
      expect(data[:attributes][:contact_phone]).to be_a(String)
      expect(data[:attributes][:credit_accepted]).to be_in([true, false])
    end

    it 'returns a 404 if invalid vendor id is passed in' do 
      get "/api/v0/vendors/9021000000"

      expect(response).to have_http_status(404)
      
      nope = JSON.parse(response.body, symbolize_names: true)

      expect(nope).to have_key(:errors)
      expect(nope[:errors]).to be_an(Array)
      expect(nope[:errors].first).to have_key(:details)
      expect(nope[:errors].first[:details]).to eq("Couldn't find Vendor with 'id'=9021000000")
    end
  end

  describe "POST /api/v0/vendors" do
    it "can create a new vendor w/ attributes" do 

      vendor_params = ({ 
        name: "ICE C.R.E.A.M",
        description: "Dolla Dolla Bill Y'all",
        contact_name: "GZA",
        contact_phone: "(917)-922-5483",
        credit_accepted: false 
              })

      headers = { "CONTENT_TYPE" => "application/json" }

      post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to have_http_status(201)

      new_vendor = JSON.parse(response.body, symbolize_names: true)[:data]
      
      expect(new_vendor[:attributes][:name]).to eq("ICE C.R.E.A.M")
      expect(new_vendor[:attributes][:description]).to eq("Dolla Dolla Bill Y'all")
      expect(new_vendor[:attributes][:contact_name]).to eq("GZA")
      expect(new_vendor[:attributes][:contact_phone]).to eq("(917)-922-5483")
      expect(new_vendor[:attributes][:credit_accepted]).to eq(false)
    end
  end

  it "can't create a new vendor w/o attributes" do 
    vendor_params = ({ 
      name: "ICE C.R.E.A.M",
      description: "Dolla Dolla Bill Y'all",
      credit_accepted: false 
            })

    headers = { "CONTENT_TYPE" => "application/json" }

    post "/api/v0/vendors", headers: headers, params: JSON.generate(vendor_params)

    expect(response).to have_http_status(400)
    
    nope = JSON.parse(response.body, symbolize_names: true)

    expect(nope).to have_key(:errors)
    expect(nope[:errors]).to be_an(Array)
    expect(nope[:errors].first).to have_key(:details)
    expect(nope[:errors].first[:details]).to eq("Validation failed: Contact name can't be blank, Contact phone can't be blank")
  end

  describe "PATCH /api/v0/vendors/:id" do
    it "can update a vendor w/ any number of attributes" do 
      vendor = create(:vendor)

      expect(vendor.name).to_not eq("ICE C.R.E.A.M")
      expect(vendor.description).to_not eq("Dolla Dolla Bill Y'all")

      id = vendor.id
      vendor_params = ({name: "ICE C.R.E.A.M", description: "Dolla Dolla Bill Y'all", credit_accepted: false})
      headers = { "CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to have_http_status(200)

      expect(Vendor.find(id).name).to eq("ICE C.R.E.A.M")
      expect(Vendor.find(id).description).to eq("Dolla Dolla Bill Y'all")
      expect(Vendor.find(id).credit_accepted).to eq(false)
    end

    it 'returns 404 when trying to update a vendor with invalid id' do 
      id = 9021090210
      vendor_params = ({name: "ICE C.R.E.A.M", description: "Dolla Dolla Bill Y'all", credit_accepted: false})
      headers = { "CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{id}", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to have_http_status(404)
      
      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first

      expect(nope[:details]).to eq("Couldn't find Vendor with 'id'=9021090210")
    end

    it 'cannot update vendor with invalid attributes' do 
      vendor = create(:vendor)
      vendor_params = ({name: "", credit_accepted: false})
      headers = { "CONTENT_TYPE" => "application/json"}

      patch "/api/v0/vendors/#{vendor.id}", headers: headers, params: JSON.generate(vendor_params)

      expect(response).to have_http_status(400)
      expect(Vendor.find(vendor.id).name).to eq(vendor.name)

      nope = JSON.parse(response.body, symbolize_names: true)[:errors].first
      expect(nope[:details]).to eq("Validation failed: Name can't be blank")
    end
  end
end