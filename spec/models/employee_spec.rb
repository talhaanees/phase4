require 'rails_helper'
RSpec.configure do |c|
  c.include Contexts
end

RSpec.describe Employee, type: :model do
  # Test relationships 
  it { should have_many(:assignments) }
  it { should have_many(:stores).through(:assignments) }
   
  # Test basic validations 
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:ssn) }
  it { should validate_presence_of(:role) }
  it { should validate_presence_of(:date_of_birth) }
  # tests for phone 
  it { should allow_value("4122683259").for(:phone) }
  it { should allow_value("412-268-3259").for(:phone) }
  it { should allow_value("412.268.3259").for(:phone) }
  it { should allow_value("(412) 268-3259").for(:phone) }
  it { should allow_value(nil).for(:phone) }
  it { should_not allow_value("2683259").for(:phone) }
  it { should_not allow_value("14122683259").for(:phone) }
  it { should_not allow_value("4122683259x224").for(:phone) }
  it { should_not allow_value("800-EAT-FOOD").for(:phone) }
  it { should_not allow_value("412/268/3259").for(:phone) }
  it { should_not allow_value("412-2683-259").for(:phone) }
  # tests for ssn 
  it { should allow_value("123456789").for(:ssn) }
  it { should_not allow_value("12345678").for(:ssn) }
  it { should_not allow_value("1234567890").for(:ssn) }
  it { should_not allow_value("bad").for(:ssn) }
  it { should_not allow_value(nil).for(:ssn) }
  # test date_of_birth 
  it { should allow_value(17.years.ago.to_date).for(:date_of_birth) }
  it { should allow_value(15.years.ago.to_date).for(:date_of_birth) }
  it { should allow_value(14.years.ago.to_date).for(:date_of_birth) }
  it { should_not allow_value(13.years.ago).for(:date_of_birth) }
  it { should_not allow_value("bad").for(:date_of_birth) }
  it { should_not allow_value(nil).for(:date_of_birth) }
  # tests for role 
  it { should allow_value("admin").for(:role) }
  it { should allow_value("manager").for(:role) }
  it { should allow_value("employee").for(:role) }
  it { should_not allow_value("bad").for(:role) }
  it { should_not allow_value("hacker").for(:role) }
  it { should_not allow_value(10).for(:role) }
  it { should_not allow_value("vp").for(:role) }
  it { should_not allow_value(nil).for(:role) }

  describe "Creating employees" do
    # create the objects I want with factories
    before do 
      create_employees
    end
    
    # and provide a teardown method as well
    after do
      remove_employees
    end
  
    # now run the tests:
    # test employees must have unique ssn
    it "forces employees to have unique ssn" do
      repeat_ssn = FactoryGirl.build(:employee, first_name: "Steve", last_name: "Crawford", ssn: "084-35-9822")
      expect(repeat_ssn).to_not be_valid
    end
    
    # test scope younger_than_18
    it "shows there are two employees under 18" do
      expect(Employee.younger_than_18.size).to eq 2
      expect(Employee.younger_than_18.map{|e| e.last_name}.sort).to eq ["Crawford", "Wilson"]
    end
    
    # test scope younger_than_18
    it "shows there are four employees over 18" do
      expect(Employee.is_18_or_older.size).to eq 4
      expect(Employee.is_18_or_older.map{|e| e.last_name}.sort).to eq ["Gruberman", "Heimann", "Janeway", "Sisko"]
    end
    
    # test the scope 'active'
    it "shows that there are five active employees" do
      expect(Employee.active.size).to eq 5
      expect(Employee.active.map{|e| e.last_name}.sort).to eq ["Crawford", "Gruberman", "Heimann", "Janeway", "Sisko"]
    end
    
    # test the scope 'inactive'
    it "shows that there is one inactive employee" do
      expect(Employee.inactive.size).to eq 1
      expect(Employee.inactive.map{|e| e.last_name}.sort).to eq ["Wilson"]
    end
    
    # test the scope 'regulars'
    it "shows that there are 3 regular employees: Ed, Cindy and Ralph" do
      expect(Employee.regulars.size).to eq 3
      expect(Employee.regulars.map{|e| e.last_name}.sort).to eq ["Crawford","Gruberman","Wilson"]
    end
    
    # test the scope 'managers'
    it "shows that there are 2 managers: Ben and Kathryn" do
      expect(Employee.managers.size).to eq 2
      expect(Employee.managers.map{|e| e.last_name}.sort).to eq ["Janeway", "Sisko"]
    end
    
    # test the scope 'admins'
    it "shows that there is one admin: Alex" do
      expect(Employee.admins.size).to eq 1
      expect(Employee.admins.map{|e| e.last_name}.sort).to eq ["Heimann"]
    end
    
    # test the method 'name'
    it "shows name as last, first name" do
      expect(@alex.name).to eq "Heimann, Alex" 
    end   
    
    # test the method 'proper_name'
    it "shows proper name as first and last name" do
      expect(@alex.proper_name).to eq "Alex Heimann" 
    end 
    
    # test the method 'current_assignment'
    it "shows return employee's current assignment if it exists" do
      create_stores
      create_assignments
      # person with a current assignment
      expect(@cindy.current_assignment).to eq @assign_cindy  # only 1 assignment ever
      expect(@ben.current_assignment).to eq @promote_ben  # 2 assignments, returns right one
      # person had assignments but has no current assignment
      expect(@ed.current_assignment).to be_nil
      @assign_cindy.update_attribute(:end_date, Date.current)
      @cindy.reload
      expect(@cindy.current_assignment).to be_nil
      # person with no assignments ever has no current assignment
      expect(@alex.current_assignment).to be_nil
      remove_assignments
      remove_stores
    end
    
    # test the callback is working 'reformat_ssn'
    it "shows that Cindy's ssn is stripped of non-digits" do
      expect(@cindy.ssn).to eq "084359822"
    end
    
    # test the callback is working 'reformat_phone'
    it "shows that Ben's phone is stripped of non-digits" do
      expect(@ben.phone).to eq "4122682323"
    end
    
    # test the method 'over_18?'
    it "shows that over_18? boolean method works" do
      expect(@ed.over_18?).to be true
      expect(@cindy.over_18?).to be false
    end
    
    # test the method 'age'
    it "shows that age method returns the correct value" do
      expect(@ed.age).to eq 19
      expect(@cindy.age).to eq 17
      expect(@kathryn.age).to eq 30
    end
  end
end