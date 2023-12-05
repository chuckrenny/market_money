require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:contact_name) }
    it { should validate_presence_of(:contact_phone) }
    # it { should validate_inclusion_of(:credit_accepted).in_array([true, false]) }
    # You are using `validate_inclusion_of` to assert that a boolean column
    # allows boolean values and disallows non-boolean ones. Be aware that it
    # is not possible to fully test this, as boolean columns will
    # automatically convert non-boolean values to boolean ones. Hence, you
    # should consider removing this test.
  end

  describe "relationships" do
    it { should have_many(:market_vendors)}
    it { should have_many(:markets).through(:market_vendors)}
  end
end