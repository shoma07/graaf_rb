# frozen_string_literal: true

# Example
module Example
  extend Graaf::Library

  graaf_lib(File.expand_path('libexample.so', __dir__))

  graaf_attach_function :add, %i[int int], :int
end
