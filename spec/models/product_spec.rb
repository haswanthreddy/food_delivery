require "rails_helper"

RSpec.describe Product, type: :model do
  describe "Columns" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description).of_type(:string) }
    it { should have_db_column(:price).of_type(:decimal) }
    it { should have_db_column(:establishment_id).of_type(:integer) }
    it { should have_db_column(:rating).of_type(:decimal).with_options(default: 0.0) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { should have_db_index([:establishment_id, :name]).unique }
  end

  describe "Associations" do
    it { should belong_to(:establishment) }
    it { should have_many(:inventories).dependent(:destroy) }
  end

  describe "Validations" do
    context "Attributes" do
      it "is valid with valid attributes" do
        product = build(:product)
        expect(product).to be_valid
      end

      it "is not valid without a name" do
        product = build(:product, name: nil)
        expect(product).to_not be_valid
        expect(product.errors[:name]).to include("can't be blank")
      end

      it "is not valid without a price" do
        product = build(:product, price: nil)
        expect(product).to_not be_valid
        expect(product.errors[:price]).to include("can't be blank")
      end

      it "is not valid with a negative price" do
        product = build(:product, price: -10)
        expect(product).to_not be_valid
        expect(product.errors[:price]).to include("must be greater than or equal to 0")
      end

      it "is valid with a price of 0" do
        product = build(:product, price: 0)
        expect(product).to be_valid
      end
    end

    context "Rating" do
      it "is valid with a rating between 0 and 5" do
        product = build(:product, rating: 4.5)
        expect(product).to be_valid
      end

      it "is not valid with a rating less than 0" do
        product = build(:product, rating: -1)
        expect(product).to_not be_valid
        expect(product.errors[:rating]).to include("must be between 0 and 5")
      end

      it "is not valid with a rating greater than 5" do
        product = build(:product, rating: 5.1)
        expect(product).to_not be_valid
        expect(product.errors[:rating]).to include("must be between 0 and 5")
      end
    end

    context "Uniqueness" do
      it "is not valid with a duplicate name under the same establishment" do
        establishment = create(:establishment)
        create(:product, name: "Test Product", establishment: establishment)
        product = build(:product, name: "Test Product", establishment: establishment)

        expect(product).to_not be_valid
        expect(product.errors[:name]).to include("has already been taken")
      end
    end
  end
end
