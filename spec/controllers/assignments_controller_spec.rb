require 'rails_helper'
RSpec.configure do |c|
  c.include Contexts
end

RSpec.describe AssignmentsController, type: :controller do

  before do
    create_employees
    create_stores
    create_assignments
  end

  after do
    remove_employees
    remove_stores
    remove_assignments
  end


  describe "GET #index" do
    it "has all assignments" do
      get :index
      expect(:current_assignments).to_not be_nil
      expect(:past_assignments).to_not be_nil
      expect(:assignments).to eq([assignment])
    end
  end

  describe "GET #show" do
    it "assigns the requested assignment as @assignment" do
      get :show, params: @assign_ben.id
      expect(:assignment).to eq(@assign_ben)
    end
  end

  describe "GET #new" do
    it "assigns a new assignment as @assignment" do
      get :new
      expect(:assignment).to be_a_new(Assignment)
    end
  end

  describe "GET #edit" do
    it "assigns the requested assignment as @assignment" do
      get :edit, id: @assign_ben
      expect(:assignment).to eq(@assign_ben)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Assignment" do
        expect {
          post :create, params: { employee_id: @ben.id, store_id: @oakland.id, start_date: Date.current, pay_level: 5 }
        }.to change(Assignment, :count).by(1)
      end

      it "assigns a newly created assignment as @assignment" do
        post :create, params: { employee_id: @ed.id, store_id: @oakland.id, start_date: Date.current, pay_level: 5 }
        expect(:assignment).to be_a(Assignment)
        expect(:assignment).to be_persisted
      end

      it "redirects to the created assignment" do
        post :create, params: { employee_id: @ed.id, store_id: @cmu.id, start_date: Date.current, pay_level: 5 }
        expect(response).to redirect_to(Assignment.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved assignment as @assignment" do
        post :create, params: { employee_id: "", store_id: "", start_date: "", pay_level: -5 }
        expect(:assignment).to be_a_new(Assignment)
      end

      it "re-renders the 'new' template" do
        post :create, params: { employee_id: "", store_id: "", start_date: "", pay_level: -5 }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do

      it "updates the requested assignment" do
        patch :update, id: @promote_ben, assignment: { employee_id: @ben.id, store_id: @cmu.id, start_date: @promote_ben.start_date, pay_level: 5 }
        assignment.reload
        expect(@promote_ben.pay_level).to eq 5
      end

      it "assigns the requested assignment as @assignment" do
        patch :update, id: @promote_ben, assignment: { employee_id: @ben.id, store_id: @cmu.id, start_date: @promote_ben.start_date, pay_level: 5 }
        expect(:assignment).to eq(@promote_ben)
      end

      it "redirects to the assignment" do
        patch :update, id: @promote_ben, assignment: { employee_id: @ben.id, store_id: @cmu.id, start_date: @promote_ben.start_date, pay_level: 5 }
        expect(response).to redirect_to(@promote_ben)
      end
    end

    context "with invalid params" do
      it "assigns the assignment as @assignment" do
        patch :update, id: @promote_ben, assignment: { employee_id: "", store_id: "", start_date: "", pay_level: -5 }
        expect(:assignment).to eq(@promote_ben)
      end

      it "re-renders the 'edit' template" do
        patch :update, id: @promote_ben, assignment: { employee_id: "", store_id: "", start_date: "", pay_level: -5 }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested assignment" do
      expect {
        delete :destroy, id: @promote_ben
      }.to change(Assignment, :count).by(-1)
    end

    it "redirects to the assignments list" do
      delete :destroy, id: @promote_ben
      expect(response).to redirect_to(assignments_url)
    end
  end

end
