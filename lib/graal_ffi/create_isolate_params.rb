# frozen_string_literal: true

module GraalFFI
  # GraalFFI::CreateIsolateParams
  class CreateIsolateParams < FFI::Struct
    layout(:version, :int)
  end
end
