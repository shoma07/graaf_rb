# frozen_string_literal: true

require 'ffi'
require 'securerandom'
require_relative 'graal_ffi/version'
require_relative 'graal_ffi/create_isolate_params'
require_relative 'graal_ffi/library'
require_relative 'graal_ffi/builder'

# GraalFFI
module GraalFFI
  # GraalFFI::Error
  class Error < StandardError; end

  # GraalFFI::CreateIsolateError
  class CreateIsolateError < Error; end
end
