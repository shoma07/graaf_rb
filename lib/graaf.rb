# frozen_string_literal: true

require 'ffi'
require 'securerandom'
require_relative 'graaf/version'
require_relative 'graaf/create_isolate_params'
require_relative 'graaf/library'
require_relative 'graaf/builder'

# Graaf
module Graaf
  # Graaf::Error
  class Error < StandardError; end

  # Graaf::CreateIsolateError
  class CreateIsolateError < Error; end
end
