require 'rails_helper'

RSpec.describe Session, type: :model do
  describe "Columns" do
    it { should have_db_column(:resource_type).of_type(:string).with_options(null: false) }
    it { should have_db_column(:resource_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:ip_address).of_type(:string) }
    it { should have_db_column(:user_agent).of_type(:string) }
    it { should have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { should have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { should have_db_index([:resource_type, :resource_id]) }
    it { should have_db_index([:resource_type, :resource_id]) }
  end

  describe "Associations" do
    it { should belong_to(:resource) }
  end
end