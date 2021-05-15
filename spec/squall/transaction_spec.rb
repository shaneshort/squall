require 'spec_helper'

describe Squall::Transaction do
  before(:each) do
    @transaction = Squall::Transaction.new
    @keys = ["pid", "created_at", "updated_at", "actor", "priority",
      "parent_type", "action", "id", "user_id", "dependent_transaction_id",
      "allowed_cancel", "parent_id", "params", "log_output", "status", "identifier"
    ]
  end

  describe "#list" do
        around do |example|
      VCR.use_cassette 'transaction/list' do
        example.call
      end
    end

    it "lists transactions" do
      list = @transaction.list
      list.size.should be(3)

      first = list.first
      first.keys.should include(*@keys)
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'transaction/show' do
        example.call
      end
    end

    it "returns a transaction" do
      transaction = @transaction.show(1)
      transaction.keys.should include(*@keys)

      transaction['pid'].should == 2180
    end
  end

end
