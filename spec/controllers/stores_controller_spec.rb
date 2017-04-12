require 'rails_helper'
RSpec.configure do |c|
  c.include Contexts
end

RSpec.describe StoresController, type: :controller do
  before(:each) do
    create_stores
  end

  after(:each) do
    remove_stores
  end

  describe "GET #index" do
    it "assigns all stores as @stores" do
      get :index
      expect(:active_stores).to_not be_nil
      expect(:inactive_stores).to_not be_nil
      expect(:active_stores).map(&:name).to eq %w[CMU Oakland]
    end
  end

  describe "GET #show" do
    it "assigns the requested store as @store" do
      create_employees
      create_assignments
      get :show, id: @cmu
      expect(:store).to eq(@cmu)
      expect(:current_assignments).to_not be_nil
      expect((:store).name).to eq "CMU"
      expect((:current_assignments).map{|a| a.employee.last_name}).to eq %w[Crawford Sisko]
      remove_employees
      remove_assignments
    end
  end

  describe "GET #new" do
    it "assigns a new store as @store" do
      get :new
      expect(:store).to be_a_new(Store)
    end
  end

  describe "GET #edit" do
    it "assigns the requested store as @store" do
      get :edit, id: @cmu
      expect(:store).to eq(@cmu)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Store" do
        expect {
          post :create, store: { active: @cmu.active, city: @cmu.city, name: "Porter", phone: "4122683259", state: @cmu.state, street: @cmu.street, zip: @cmu.zip }
        }.to change(Store, :count).by(1)
      end

      it "assigns a newly created store as @store" do
        post :create, store: { active: @cmu.active, city: @cmu.city, name: "Porter", phone: "4122683259", state: @cmu.state, street: @cmu.street, zip: @cmu.zip }
        expect(:store).to be_a(Store)
        expect(:store).to be_persisted
      end

      it "redirects to the created store" do
        post :create, store: { active: @cmu.active, city: @cmu.city, name: "Porter", phone: "4122683259", state: @cmu.state, street: @cmu.street, zip: @cmu.zip }
        expect(response).to redirect_to(Store.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved store as @store" do
        post :create, store: { active: -1, city: "", name: "", phone: "", state: "", street: "", zip: "" }
        expect(:store).to be_a_new(Store)
      end

      it "re-renders the 'new' template" do
        post :create, store: { active: -1, city: "", name: "", phone: "", state: "", street: "", zip: "" }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested store" do
        patch :update, id: @cmu, store: { active: @cmu.active, city: @cmu.city, name: @cmu.name, phone: "4122688211", state: @cmu.state, street: @cmu.street, zip: @cmu.zip }
        :store.reload
        expect(@cmu.phone).to eq "4122688211"
      end

      it "assigns the requested store as @store" do
        patch :update, id: @cmu, store: { active: @cmu.active, city: @cmu.city, name: @cmu.name, phone: "4122688211", state: @cmu.state, street: @cmu.street, zip: @cmu.zip }
        expect(:store).to eq(@cmu)
      end

      it "redirects to the store" do
        patch :update, id: @cmu, store: { active: @cmu.active, city: @cmu.city, name: @cmu.name, phone: "4122688211", state: @cmu.state, street: @cmu.street, zip: @cmu.zip }
        expect(response).to redirect_to(@cmu)
      end
    end

    context "with invalid params" do
      it "assigns the store as @store" do
        patch :update, id: @cmu, store: { active: -1, city: "", name: "", phone: "", state: "", street: "", zip: "" }
        expect(:store).to eq(store)
      end

      it "re-renders the 'edit' template" do
        patch :update, id: @cmu, store: { active: -1, city: "", name: "", phone: "", state: "", street: "", zip: "" }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested store" do
      expect {
        delete :destroy, id: @cmu
      }.to change(Store, :count).by(-1)
    end

    it "redirects to the stores list" do
      delete :destroy, id: @cmu
      expect(response).to redirect_to(stores_url)
    end
  end

end
