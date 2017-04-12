require 'rails_helper'
RSpec.configure do |c|
  c.include Contexts
end

RSpec.describe Assignment, type: :model do
  # Test relationships
  it { should belong_to(:employee) }
  it { should belong_to(:store) }

  # Test basic validations
  # for pay level
  it { should allow_value(1).for(:pay_level) }
  it { should allow_value(2).for(:pay_level) }
  it { should allow_value(3).for(:pay_level) }
  it { should allow_value(4).for(:pay_level) }
  it { should allow_value(5).for(:pay_level) }
  it { should allow_value(6).for(:pay_level) }
  it { should_not allow_value("bad").for(:pay_level) }
  it { should_not allow_value(0).for(:pay_level) }
  it { should_not allow_value(7).for(:pay_level) }
  it { should_not allow_value(2.5).for(:pay_level) }
  it { should_not allow_value(-2).for(:pay_level) }
  # for start date
  it { should allow_value(7.weeks.ago.to_date).for(:start_date) }
  it { should allow_value(2.years.ago.to_date).for(:start_date) }
  it { should_not allow_value(1.week.from_now.to_date).for(:start_date) }
  it { should_not allow_value("bad").for(:start_date) }
  it { should_not allow_value(nil).for(:start_date) }

  # Need to do the rest with a context
  describe "Scopes" do
    before do
      create_stores
      create_employees
      create_assignments
    end

    after do
      remove_stores
      remove_employees
      remove_assignments
    end

    it "has a scope 'for_store' that works" do
      expect(Assignment.for_store(@cmu.id).size).to eq 4
      expect(Assignment.for_store(@oakland.id).size).to eq 1
    end

    it "has a scope 'for_employee' that works" do
      expect(Assignment.for_employee(@ben.id).size).to eq 2
      expect(Assignment.for_employee(@kathryn.id).size).to eq 1
    end
    
    it "has a scope 'for_pay_level' that works" do
      expect(Assignment.for_pay_level(1).size).to eq 2
      expect(Assignment.for_pay_level(2).size).to eq 0
      expect(Assignment.for_pay_level(3).size).to eq 2
      expect(Assignment.for_pay_level(4).size).to eq 1
    end

    it "has a scope 'for_role' that works" do
      expect(Assignment.for_role("employee").size).to eq 2
      expect(Assignment.for_role("manager").size).to eq 3
    end

    it "has all the assignments listed alphabetically by store name" do
      expect(Assignment.by_store.map{|a| a.store.name}).to eq ["CMU", "CMU", "CMU", "CMU", "Oakland"]
    end

    it "has all the assignments listed chronologically by start date" do
      expect(Assignment.chronological.map{|a| a.employee.first_name}).to eq ["Ben", "Kathryn", "Ed", "Cindy", "Ben"]
    end

    it "has all the assignments listed alphabetically by employee name" do
      expect(Assignment.by_employee.map{|a| a.employee.last_name}).to eq ["Crawford", "Gruberman", "Janeway", "Sisko", "Sisko"]
    end

    it "has a scope to find all current assignments for a store or employee" do
      expect(Assignment.current.for_store(@cmu.id).size).to eq 2
      expect(Assignment.current.for_store(@oakland.id).size).to eq 1
      expect(Assignment.current.for_employee(@ben.id).size).to eq 1
      expect(Assignment.current.for_employee(@ed.id).size).to eq 0
    end

    it "has a scope to find all past assignments for a store or employee" do
      expect(Assignment.past.for_store(@cmu.id).size).to eq 2
      expect(Assignment.past.for_store(@oakland.id).size).to eq 0
      expect(Assignment.past.for_employee(@ben.id).size).to eq 1
      expect(Assignment.past.for_employee(@cindy.id).size).to eq 0
    end

    it "allows for a end date in the past (or today) but after the start date" do
      # Note that we've been testing end_date: nil for a while now so safe to assume works...
      @assign_alex = FactoryGirl.build(:assignment, employee: @alex, store: @oakland, start_date: 3.months.ago.to_date, end_date: 1.month.ago.to_date)
      expect(@assign_alex).to be_valid
      @second_assignment_for_alex = FactoryGirl.build(:assignment, employee: @alex, store: @oakland, start_date: 3.weeks.ago.to_date, end_date: Date.current)
      expect(@second_assignment_for_alex).to be_valid
    end

    it "does not allow for a end date in the future or before the start date" do
      # since Ed finished his last assignment a month ago, let's try to assign the lovable loser again ...
      @second_assignment_for_ed = FactoryGirl.build(:assignment, employee: @ed, store: @oakland, start_date: 2.weeks.ago.to_date, end_date: 3.weeks.ago.to_date)
      expect(@second_assignment_for_ed).to_not be_valid
      @third_assignment_for_ed = FactoryGirl.build(:assignment, employee: @ed, store: @oakland, start_date: 2.weeks.ago.to_date, end_date: 3.weeks.from_now.to_date)
      expect(@third_assignment_for_ed).to_not be_valid
    end

    it "identifies a non-active store as part of an invalid assignment" do
      inactive_store = FactoryGirl.build(:assignment, store: @hazelwood, employee: @ed, start_date: 1.day.ago.to_date, end_date: nil)
      expect(inactive_store).to_not be_valid
    end

    it "identifies a non-active employee as part of an invalid assignment" do
      @fred = FactoryGirl.build(:employee, first_name: "Fred", active: false)
      inactive_employee = FactoryGirl.build(:assignment, store: @oakland, employee: @fred, start_date: 1.day.ago.to_date, end_date: nil)
      expect(inactive_employee).to_not be_valid
    end

    it "ends the current assignment if it exists before adding a new assignment for an employee" do
      @promote_kathryn = FactoryGirl.create(:assignment, employee: @kathryn, store: @oakland, start_date: 1.day.ago.to_date, end_date: nil, pay_level: 4)
      expect(@kathryn.assignments.first.end_date).to eq 1.day.ago.to_date
      @promote_kathryn.destroy
    end
  end  
end
