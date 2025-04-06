require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe "Columns" do
    it { should have_db_column(:name).of_type(:string) }
    it { should have_db_column(:full_address).of_type(:string) }
    it { should have_db_column(:city).of_type(:string) }
    it { should have_db_column(:latitude).of_type(:float) }
    it { should have_db_column(:longitude).of_type(:float) }
    it { should have_db_column(:phone_number).of_type(:string) }
    it { should have_db_column(:website).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { should have_db_index([:name]).unique }
  end

  describe "name unqiueness" do
    context "when a restaurant with the same name already exists" do
      it "does not allow duplicate names" do
        create(:restaurant, name: "Unique Restaurant")
        
        restaurant2 = build(:restaurant, name: "Unique Restaurant")
        
        expect(restaurant2.valid?).to be_falsey
      end
    end
  end
end
