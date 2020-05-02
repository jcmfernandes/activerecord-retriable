# frozen_string_literal: true

require 'activerecord-retriable'

RSpec.describe 'retriable transactions' do
  before(:all) do
    class TestModel < ActiveRecord::Base; end
    TestModel.connection.create_table(TestModel.table_name) do |t|
      t.integer :value
    end
  end

  before do
    TestModel.delete_all
  end

  describe '.transaction' do
    it 'works' do
      TestModel.transaction do
        TestModel.create!
      end
      expect(TestModel.count).to be 1
    end

    it 'passes all extra parameters to the original method' do
      expect do
        TestModel.transaction(random_kwarg: true) do
          TestModel.create!
        end
      end.to raise_error(ArgumentError, /unknown keyword: [:]{0,1}random_kwarg/)
      expect(TestModel.count).to be_zero

      TestModel.transaction(requires_new: true) do
        TestModel.create!
      end
      expect(TestModel.count).to be 1
    end

    it 'must support options :retry_on and :num_retries to retry' do
      a = []

      expect do
        TestModel.transaction(retry_on: [ActiveRecord::SerializationFailure, ActiveRecord::Deadlocked], num_retries: 1) do
          TestModel.new(value: 1).tap { |tm| a << tm }.tap { |tm| tm.save! }

          raise ActiveRecord::SerializationFailure if a.size == 1
          raise ActiveRecord::Deadlocked if a.size == 2
        end
      end.to raise_error(ActiveRecord::Deadlocked)
      expect(TestModel.count).to be_zero
      expect(a.map(&:value)).to contain_exactly(1, 1)
    end

    it 'must support num_retries: nil to retry indefinitely' do
      a = []

      expect do
        TestModel.transaction(retry_on: [ActiveRecord::Deadlocked], num_retries: nil) do
          TestModel.new(value: 1).tap { |tm| a << tm }.tap { |tm| tm.save! }

          raise ActiveRecord::SerializationFailure if a.size >= 100
          raise ActiveRecord::Deadlocked
        end
      end.to raise_error(ActiveRecord::SerializationFailure)
      expect(TestModel.count).to be_zero
      expect(a.map(&:value)).to match_array([1] * 100)
    end

    it 'must support :before_retry option for invoking callback before retrying' do
      a = []
      retryer = proc { a << TestModel.new(value: 2) }

      expect do
        TestModel.transaction(retry_on: [ActiveRecord::Deadlocked], num_retries: 1, before_retry: retryer) do
          TestModel.new(value: 1).tap { |tm| a << tm }.tap { |tm| tm.save! }
          raise ActiveRecord::Deadlocked
        end
      end.to raise_error(ActiveRecord::Deadlocked)
      expect(TestModel.count).to be_zero
      expect(a.map(&:value)).to contain_exactly(1, 2, 1)
    end
  end
end
