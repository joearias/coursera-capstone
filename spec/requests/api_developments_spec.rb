require 'rails_helper'

RSpec.describe "ApiDevelopments", type: :request do
  def parsed_body
    JSON.parse(response.body)
  end

  describe "RDMS-backed" do
    before(:each) {Foo.delete_all}
    after(:each) {Foo.delete_all}
#binding.pry
    before(:each) {City.delete_all}
    after(:each) {City.delete_all}

    it "create RDBMS-backed model names Foo" do
      object=Foo.create(:name=>"test")
      expect(Foo.find(object.id).name).to eq("test")
    end

    it "create RDBMS-backed model names City" do
      object=City.create(:name=>"test_city")
      expect(City.find(object.id).name).to eq("test_city")
    end

    it "exposes RDBMS-backed API resource named Foo" do
      object=Foo.create(:name=>"test")
      expect(foos_path).to eq("/api/foos")
      get foo_path(object.id)
      expect(response).to have_http_status(:ok)
      expect(parsed_body["name"]).to eq("test")
    end
#binding.pry
    it "exposes RDBMS-backed API resource named City" do
      object=City.create(:name=>"Los Angeles")
      expect(cities_path).to eq("/api/cities")
      get city_path(object.id)
      expect(response).to have_http_status(:ok)
      expect(parsed_body["name"]).to eq("Los Angeles")
    end

    describe "updates are disabled to cities" do
      let!(:city) {City.create(:name=>"original_name")}
      it "prevents users from updating the city name" do
        json = { :format => 'json', :city => {:name => "updated_name"}}
        url = "/api/cities/#{city.id}"
        put url, json
        expect(response).to have_http_status(204)
        get city_path(city.id)
        expect(response).to have_http_status(:ok)
        expect(parsed_body["name"]).to eq("original_name")
      end
      it "prevents users from deleting the city" do
        json = { :format => 'json'}
        url = "/api/cities/#{city.id}"
        delete url, json
        expect(response).to have_http_status(204)
        get city_path(city.id)
        expect(response).to have_http_status(:ok)
      end
  end
  end

  describe "MongoDB-backed" do
    before(:each) {Bar.delete_all}
    after(:each) {Bar.delete_all}

    it "create MongoDB-backed model named Bar" do 
      object=Bar.create(:name=>"bar_test1")
      expect(Bar.find(object.id).name).to eq("bar_test1")
    end

    it "create MongoDB-backed model name State" do 
      object=State.create(:name=>"Nevada")
      expect(State.find(object.id).name).to eq("Nevada")
    end
    it "exposes MongoDB-backed API resource name Bar" do
      object=Bar.create(:name=>"test_bar")
      expect(bars_path).to eq("/api/bars")

      get bar_path(object.id)
      expect(response).to have_http_status(:ok)
      expect(parsed_body["name"]).to eq("test_bar")
      expect(parsed_body).to include("created_at")
      expect(parsed_body).to include("id"=>object.id.to_s)
    end

    it "exposes MongoDB-backed API resource name State" do
      object=State.create(:name=>"California")
      expect(states_path).to eq("/api/states")

      get state_path(object.id)
      expect(response).to have_http_status(:ok)
      expect(parsed_body["name"]).to eq("California")
      expect(parsed_body).to include("created_at")
      expect(parsed_body).to include("id"=>object.id.to_s)
    end

    describe "updates are disabled to states" do
      let!(:state) {State.create(:name=>"original_name")}
      it "prevents users from updating the State name" do
        json = { :format => 'json', :state => {:name => "updated_name"}}
        url = "/api/states/#{state.id.to_s}"
        put url, json
        expect(response).to have_http_status(204)
        get state_path(state.id)
        expect(response).to have_http_status(:ok)
        expect(parsed_body["name"]).to eq("original_name")
      end
      it "prevents users from deleting the State" do
        json = { :format => 'json'}
        url = "/api/states/#{state.id.to_s}"
        delete url, json
        expect(response).to have_http_status(204)
        get state_path(state.id)
        expect(response).to have_http_status(:ok)
      end
  end
  end
end
