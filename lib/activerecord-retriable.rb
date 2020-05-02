# frozen_string_literal: true

require 'active_record_retriable/retriable'

ActiveRecord::Base.include(ActiveRecordRetriable)
