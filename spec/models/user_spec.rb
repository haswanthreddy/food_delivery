require "rails_helper"

RSpec.describe User, type: :model do
  describe "Columns" do
    it { should have_db_column(:full_name).of_type(:string) }
    it { should have_db_column(:email_address).of_type(:string).with_options(null: false) }
    it { should have_db_column(:password_digest).of_type(:string).with_options(null: false) }
    it { should have_db_column(:phone_number).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { should have_db_index(:email_address).unique }
  end

  describe "Associations" do
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
    it { is_expected.to have_many(:orders).dependent(:destroy) }
  end

  describe "Validations" do
    it { should have_secure_password }

    it "requires a password" do
      user = build(:user, password: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "encrypts the password" do
      user = create(:user, password: "password123")
      expect(user.password_digest).to be_present
    end

    it "authenticates with the correct password" do
      user = create(:user, password: "password123")
      expect(user.authenticate("password123")).to eq(user)
    end

    it "fails authentication with an incorrect password" do
      user = create(:user, password: "password123")
      expect(user.authenticate("wrong_password")).to be false
    end

    it "requires password confirmation if provided" do
      user = build(:user, password: "password123", password_confirmation: "wrong_password")
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe "Normalizes email_address" do
    it "strips and downcases the email address" do
      user = create(:user, email_address: "  TEST@EXAMPLE.COM  ")
      expect(user.email_address).to eq("test@example.com")
    end

    it "normalizes on update" do
      user = create(:user, email_address: "  TEST@EXAMPLE.COM  ")
      user.update(email_address: "  ANOTHER@EXAMPLE.COM  ")
      expect(user.email_address).to eq("another@example.com")
    end
  end
end