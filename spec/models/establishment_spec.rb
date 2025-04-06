require "rails_helper"

RSpec.describe Establishment, type: :model do
  let(:valid_attributes) { attributes_for(:establishment) }

  describe "Columns" do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:establishment_type).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:email_address).of_type(:string).with_options(null: false) }
    it { should have_db_column(:full_address).of_type(:string).with_options(null: false) }
    it { should have_db_column(:city).of_type(:string).with_options(null: false) }
    it { should have_db_column(:latitude).of_type(:float).with_options(null: false) }
    it { should have_db_column(:longitude).of_type(:float).with_options(null: false) }
    it { should have_db_column(:rating).of_type(:decimal).with_options(default: 0.0) }
    it { should have_db_column(:phone_number).of_type(:string).with_options(null: false) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { should have_db_index([:name]).unique }
    it { should have_db_index([:email_address]).unique }
    it { should have_db_index([:city]) }
  end

  describe "Validations" do
    context "with valid attributes" do
      it "is valid with valid attributes" do
        establishment = build(:establishment, valid_attributes)

        expect(establishment).to be_valid
      end
    end

    context "with missing attributes" do
      it "validates presence of required attributes" do
        valid_attributes.each do |attribute, value|
          establishment = build(:establishment, attribute => nil)
          expect(establishment).to be_invalid
          expect(establishment.errors[attribute]).to include("can't be blank")
        end
      end
    end

    context "latitude " do
      it "validates latitude is within range" do
        establishment = build(:establishment, latitude: 100)
        expect(establishment).to be_invalid
        expect(establishment.errors[:latitude]).to include("must be less than or equal to 90")
  
        establishment.latitude = -100
        expect(establishment).to be_invalid
        expect(establishment.errors[:latitude]).to include("must be greater than or equal to -90")
  
        establishment.latitude = 45
        expect(establishment).to be_valid
      end
    end

    context "longitude" do
      it "validates longitude is within range" do
        establishment = build(:establishment, longitude: 200)
        expect(establishment).to be_invalid
        expect(establishment.errors[:longitude]).to include("must be less than or equal to 180")
  
        establishment.longitude = -200
        expect(establishment).to be_invalid
        expect(establishment.errors[:longitude]).to include("must be greater than or equal to -180")
  
        establishment.longitude = 90
        expect(establishment).to be_valid
      end
    end

    context "Rating" do
      it "is valid with a rating between 0 and 5" do
        establishment = build(:establishment, rating: 4.5)
        expect(establishment).to be_valid
      end

      it "is not valid with a rating less than 0" do
        establishment = build(:establishment, rating: -1)
        expect(establishment).to_not be_valid
        expect(establishment.errors[:rating]).to include("must be between 0 and 5")
      end

      it "is not valid with a rating greater than 5" do
        establishment = build(:establishment, rating: 5.1)
        expect(establishment).to_not be_valid
        expect(establishment.errors[:rating]).to include("must be between 0 and 5")
      end
    end

    context "email validation" do
      it "validates email address format, presence, and uniqueness" do
        invalid_email = build(:establishment, email_address: "invalid_email")
        expect(invalid_email).to be_invalid
        expect(invalid_email.errors[:email_address]).to include("is invalid")

        duplicate_email = create(:establishment, email_address: "test@example.com")
        duplicate_email_check = build(:establishment, email_address: "test@example.com")
        expect(duplicate_email_check).to be_invalid
        expect(duplicate_email_check.errors[:email_address]).to include("has already been taken")

        missing_email = build(:establishment, email_address: nil)
        expect(missing_email).to be_invalid
        expect(missing_email.errors[:email_address]).to include("can't be blank")

        valid_email = build(:establishment, email_address: "valid@example.com")
        expect(valid_email).to be_valid
      end
    end
  end

  describe "Normalizes email_address" do
    it "strips and downcases the email address" do
      establishment = create(:establishment, email_address: "  TEST@EXAMPLE.COM  ")
      expect(establishment.email_address).to eq("test@example.com")
    end

    it "normalizes on update" do
      establishment = create(:establishment, email_address: "  TEST@EXAMPLE.COM  ")
      establishment.update(email_address: "  ANOTHER@EXAMPLE.COM  ")
      expect(establishment.email_address).to eq("another@example.com")
    end
  end

  describe "Associations" do
    it { should have_many(:products).dependent(:destroy) }
    it { should have_many(:inventories).dependent(:destroy) }
  end

  describe "Enums" do
    it { should define_enum_for(:establishment_type).with_values(restaurant: 0, cafe: 1, bar: 2, bakery: 3, stall: 4) }
  end
end
