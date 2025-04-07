require "rails_helper"

RSpec.describe Order, type: :model do
  describe "Columns" do
    it { is_expected.to have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:delivery_partner_id).of_type(:integer) }
    it { is_expected.to have_db_column(:product_id).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:quantity).of_type(:integer).with_options(null: false) }
    it { is_expected.to have_db_column(:discount_percentage).of_type(:decimal).with_options(default: 0.0) }
    it { is_expected.to have_db_column(:rating).of_type(:decimal).with_options(default: 0.0) }
    it { is_expected.to have_db_column(:review).of_type(:text) }
    it { is_expected.to have_db_column(:coupon_code).of_type(:string) }
    it { is_expected.to have_db_column(:delivered_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime).with_options(null: false) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime).with_options(null: false) }
  end

  describe "Indexes" do
    it { is_expected.to have_db_index([:user_id]) }
    it { is_expected.to have_db_index([:delivery_partner_id]) }
    it { is_expected.to have_db_index([:product_id]) }
  end

  describe "Validations" do
    context "Attributes" do
      it "is valid with valid attributes" do
        order = build(:order)

        expect(order).to be_valid
      end

      it "is valid without a delivery partner" do
        order = build(:order, delivery_partner_id: nil)

        expect(order).to be_valid
      end

      it "is not valid without status" do
        order = build(:order, status: nil)

        expect(order).to_not be_valid
        expect(order.errors[:status]).to include("can't be blank")
      end

      it "is not valid without quantity" do
        order = build(:order, quantity: nil)

        expect(order).to_not be_valid
        expect(order.errors[:quantity]).to include("can't be blank")
      end

      it "is valid without discount_percentage" do
        order = build(:order, discount_percentage: 0)

        expect(order).to be_valid
        expect(order.discount_percentage).to eq(0.0)
      end

      it "is valid with default rating" do
        order = build(:order, rating: 0)

        expect(order).to be_valid
        expect(order.rating).to eq(0.0)
      end
    end

    context "Rating" do
      it "is valid with a rating between 0 and 5" do
        order = build(:order, rating: 4.5)
        expect(order).to be_valid
      end

      it "is not valid with a rating less than 0" do
        order = build(:order, rating: -1)
        expect(order).to_not be_valid
        expect(order.errors[:rating]).to include("must be between 0 and 5")
      end

      it "is not valid with a rating greater than 5" do
        order = build(:order, rating: 5.1)
        expect(order).to_not be_valid
        expect(order.errors[:rating]).to include("must be between 0 and 5")
      end
    end

    context "inventory_available" do
      let(:product) { create(:product) }
      
      it "is valid when inventory quantity is available" do
        create(:inventory, product: product, quantity: 10)
        order = build(:order, product: product, quantity: 5)
        
        expect(order).to be_valid
      end
      
      it "is not valid when inventory quantity is less than order quantity" do
        create(:inventory, product: product, quantity: 3)
        order = build(:order, product: product, quantity: 5)
        
        expect(order).to_not be_valid
        expect(order.errors[:base]).to include("Insufficient inventory")
      end
      
      it "is valid when product has no inventory" do
        order = build(:order, product: product, quantity: 5)
        
        expect(order).to be_valid
      end
    end
  end

  describe "Callbacks" do
    describe "before_update :status_change_allowed?" do
      context "when delivery partner is not assigned" do
        it "does not allow the change status and adds an error" do
          order = create(:order, status: "pending", delivery_partner_id: nil)
          order.status = "completed"
  
          expect(order.save).to be_falsey
          expect(order.errors[:status]).to include("cannot be changed from pending to the selected status as delivery partner is not assigned")
        end
      end
  
      context "when delivery_partner_id is present" do
        it "allows the change status" do
          order = create(:order, status: "pending", delivery_partner_id: nil)
          expect(order).to be_valid

          delivery_partner = create(:delivery_partner)
          order.update(delivery_partner_id: delivery_partner.id)
          order.status = "completed"
  
          expect(order.save).to be_truthy
        end
      end
    end

    describe "before_update :delivery_partner_assignment_status_update" do
      context "when delivery partner is assined" do
        it "will update the status to assigned_delivery_partner" do
            order = create(:order)

            expect(order.status).to eq(Order.statuses.key(0))

            delivery_partner = create(:delivery_partner)
            order.update(delivery_partner_id: delivery_partner.id)

            expect(order.status).to eq(Order.statuses.key(1))
        end
      end
    end

    describe "after_commit :reduce_inventory, on: :create" do
      let(:product) { create(:product) }

      context "when quantity is there" do
        it "reduces the inventory of the product after order creation" do
          create(:inventory, product: product, quantity: 10)
          order = create(:order, product: product, quantity: 2)
  
          expect(product.reload.inventory.quantity).to eq(8)
        end
      end

      context "when quantity is zero" do
        it "throws an error if an attempt is made to decrement quantity when it is zero" do
          create(:inventory, product: product, quantity: 0)
          order = build(:order, product: product, quantity: 1)

          expect(order.save).to be_falsey
        end
      end
    end
  end
end
