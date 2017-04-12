require 'rails_helper'
RSpec.configure do |c|
  c.include Contexts
end

RSpec.describe EmployeesController, type: :controller do

  before(:each) do
    create_employees
  end
  
  after(:each) do
    remove_employees
  end

  describe "GET #index" do
    it "assigns all employees" do
      get :index
      expect(:active_employees).to_not be_nil
      expect(:inactive_employees).to_not be_nil
      expect(:active_employees).map(&:last_name).to eq(%w[Crawford Gruberman Heimann Janeway Sisko]) 
    end
  end

  describe "GET #show" do
    it "assigns the requested employee as @employee" do
      create_stores
      create_assignments
      get :show, id: @ben
      expect(:employee).to eq(@ben)
      expect(:employee).to_not be_nil
      expect(:assignments).to_not be_nil
      expect((:employee).last_name).to eq "Sisko"
      expect((:assignments).map(&:pay_level).sort).to eq [3, 4]
      remove_stores
      remove_assignments
    end
  end

  describe "GET #new" do
    it "assigns a new employee as @employee" do
      get :new
      expect(:employee).to be_a_new(Employee)
    end
  end

  describe "GET #edit" do
    it "assigns the requested employee as @employee" do
      get :edit, id: @ben
      expect(:employee).to eq(@ben)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Employee" do
        expect {
          post :create, employee: { active: @ben.active, first_name: "Jake", last_name: @ben.last_name, role: "employee", ssn: "010101010", date_of_birth: 19.years.ago.to_date }
        }.to change(Employee, :count).by(1)
      end

      it "assigns a newly created employee as @employee" do
        post :create, employee: { active: @ben.active, first_name: "Jake", last_name: @ben.last_name, role: "employee", ssn: "010101010", date_of_birth: 19.years.ago.to_date }
        expect(:employee).to be_a(Employee)
        expect(:employee).to be_persisted
      end

      it "redirects to the created employee" do
        post :create, employee: { active: @ben.active, first_name: "Jake", last_name: @ben.last_name, role: "employee", ssn: "010101010", date_of_birth: 19.years.ago.to_date }
        expect(response).to redirect_to(Employee.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved employee as @employee" do
        post :create, employee: { active: -1, first_name: "", last_name: "", role: "", ssn: "", date_of_birth: 2.years.ago.to_date }
        expect(:employee).to be_a_new(Employee)
      end

      it "re-renders the 'new' template" do
        post :create, employee: { active: -1, first_name: "", last_name: "", role: "", ssn: "", date_of_birth: 2.years.ago.to_date }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the requested employee" do
        patch :update, id: @ben, employee: { active: @ben.active, first_name: @ben.first_name, last_name: @ben.last_name, role: @ben.role, ssn: @ben.ssn, date_of_birth: 49.years.ago.to_date }
        employee.reload
        expect(@ben.date_of_birth).to eq 49.years.ago.to_date
      end

      it "assigns the requested employee as @employee" do
        patch :update, id: @ben, employee: { active: @ben.active, first_name: @ben.first_name, last_name: @ben.last_name, role: @ben.role, ssn: @ben.ssn, date_of_birth: 49.years.ago.to_date }
        expect(:employee).to eq(@ben)
      end

      it "redirects to the employee" do
        patch :update, id: @ben, employee: { active: @ben.active, first_name: @ben.first_name, last_name: @ben.last_name, role: @ben.role, ssn: @ben.ssn, date_of_birth: 49.years.ago.to_date }
        expect(response).to redirect_to(@ben)
      end
    end

    context "with invalid params" do
      it "assigns the employee as @employee" do
        patch :update, id: @ben, employee: { active: -1, first_name: "", last_name: "", role: "", ssn: @ben.ssn, date_of_birth: 49.years.ago.to_date }
        expect(:employee).to eq(@ben)
      end

      it "re-renders the 'edit' template" do
        patch :update, id: @ben, employee: { active: -1, first_name: "", last_name: "", role: "", ssn: @ben.ssn, date_of_birth: 49.years.ago.to_date }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested employee" do
      expect {
        delete :destroy, id: @ben
      }.to change(Employee, :count).by(-1)
    end

    it "redirects to the employees list" do
      delete :destroy, id: @ben
      expect(response).to redirect_to(employees_url)
    end
  end

end
