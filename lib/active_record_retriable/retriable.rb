# frozen_string_literal: true

require 'active_record_retriable/version'

require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/array/wrap'
require 'active_record'
require 'active_record/base'

module ActiveRecordRetriable
  extend ActiveSupport::Concern

  included do
    Rails.configuration.active_record.default_transaction_retries = 1
  end

  module ClassMethods
    def transaction(retry_on: nil,
                    num_retries: Rails.configuration.active_record.default_transaction_retries,
                    before_retry: nil,
                    **options, &block)
      return super(options, &block) if retry_on.blank?

      retry_on = Array.wrap(retry_on)
      total_retries = num_retries
      num_retries = 0
      begin
        super(options, &block)
      rescue *retry_on => e
        num_retries += 1
        if total_retries.nil? || num_retries <= total_retries
          before_retry&.call(num_retries, e)
          retry
        end
        raise
      end
    end
  end
end
