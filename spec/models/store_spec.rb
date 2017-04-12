require 'rails_helper'
RSpec.configure do |c|
  c.include Contexts
end

RSpec.describe Store, type: :model do
  # Test relationships 
  it { should have_many(:assignments) }
  it { should have_many(:employees).through(:assignments) }
 
  # Test basic validations 
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:street) }
  it { should validate_presence_of(:zip) }
  # tests for zip 
  it { should allow_value("15213").for(:zip) }
  it { should_not allow_value("bad").for(:zip) }
  it { should_not allow_value("1512").for(:zip) }
  it { should_not allow_value("152134").for(:zip) }
  it { should_not allow_value("15213-0983").for(:zip) }
  # tests for state 
  it { should allow_value("OH").for(:state) }
  it { should allow_value("PA").for(:state) }
  it { should allow_value("WV").for(:state) }
  it { should_not allow_value("bad").for(:state) }
  it { should_not allow_value("NY").for(:state) }
  it { should_not allow_value(10).for(:state) }
  it { should_not allow_value("CA").for(:state) }
  # tests for phone 
  it { should allow_value("4122683259").for(:phone) }
  it { should allow_value("412-268-3259").for(:phone) }
  it { should allow_value("412.268.3259").for(:phone) }
  it { should allow_value("(412) 268-3259").for(:phone) }
  it { should_not allow_value("2683259").for(:phone) }
  it { should_not allow_value("14122683259").for(:phone) }
  it { should_not allow_value("4122683259x224").for(:phone) }
  it { should_not allow_value("800-EAT-FOOD").for(:phone) }
  it { should_not allow_value("412/268/3259").for(:phone) }
  it { should_not allow_value("412-2683-259").for(:phone) }

    # Establish context
  # Testing other methods with a context
  describe "Creating stores" do
    # create the objects I want with factories
    before do 
      create_stores
    end
    
    # and provide a teardown method as well
    after do
      remove_stores
    end
  
    # now run the tests:
    # test one of each factory (not really required, but not a bad idea)
    it "shows that all factories are properly created" do
      expect(@cmu.name).to eq "CMU"
      expect(@oakland.active).to be true
      expect(@hazelwood.active).to be false
    end
    
    # test stores must have unique names
    it "forces stores to have unique names" do
      repeat_store = FactoryGirl.build(:store, name: "CMU")
      expect(repeat_store).to_not be_valid
    end
    
    # test the callback is working 'reformat_phone'
    it "shows that Oakland's phone is stripped of non-digits" do
      expect(@oakland.phone).to eq "4122688211"
    end
    
    # test the scope 'alphabetical'
    it "shows that there are three stores in in alphabetical order" do
      expect(Store.alphabetical.map{|s| s.name}).to eq ["CMU", "Hazelwood", "Oakland"]
    end
    
    # test the scope 'active'
    it "shows that there are two active stores" do
      expect(Store.active.size).to eq 2
      expect(Store.active.alphabetical.map{|s| s.name}).to eq ["CMU", "Oakland"]
    end
    
    # test the scope 'inactive'
    it "shows that there is one inactive store" do
      expect(Store.inactive.size).to eq 1
      expect(Store.inactive.alphabetical.map{|s| s.name}).to eq ["Hazelwood"]
    end 
     
  end
end
