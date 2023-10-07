# frozen_string_literal: true

# Example
module Example
  extend GraalFFI::Library

  graal_ffi_lib(File.expand_path('libexample.so', __dir__))
  graal_attach_function :add, %i[int int], :int
end
