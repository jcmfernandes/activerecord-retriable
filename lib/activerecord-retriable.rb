# frozen_string_literal: true

require 'active_record_retriable/retriable'

require 'active_record'
ActiveRecord::Base.include(ActiveRecordRetriable)
