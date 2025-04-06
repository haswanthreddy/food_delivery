require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe "Columns" do
    it { should have_db_column(:product_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:establishment_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:quantity).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { should have_db_index([:establishment_id, :product_id]).unique }
  end

  describe "Associations" do
    it { should belong_to(:product) }
    it { should belong_to(:establishment) }
  end

  describe "Validations" do
    it "validates presence of product_id" do
      inventory = build(:inventory, product_id: nil)
      expect(inventory).to_not be_valid
      expect(inventory.errors[:product_id]).to include("can't be blank")
    end

    it "validates presence of establishment_id" do
      inventory = build(:inventory, establishment_id: nil)
      expect(inventory).to_not be_valid
      expect(inventory.errors[:establishment_id]).to include("can't be blank")
    end

    it "validates presence of quantity" do
      inventory = build(:inventory, quantity: nil)
      expect(inventory).to_not be_valid
      expect(inventory.errors[:quantity]).to include("can't be blank")
    end

    it "validates numericality of quantity" do
      inventory = build(:inventory, quantity: -1)
      expect(inventory).to_not be_valid
      expect(inventory.errors[:quantity]).to include("must be greater than or equal to 0")
    end

    context "with inventory existing for the same establishment and product" do
      it "is not valid" do
        establishment = create(:establishment)
        product = create(:product)
        create(:inventory, establishment: establishment, product: product)
        
        inventory = build(:inventory, establishment: establishment, product: product)
        expect(inventory).to_not be_valid
        expect(inventory.errors[:establishment_id]).to include("Combination with product must be unique")
      end
    end
  end
end
