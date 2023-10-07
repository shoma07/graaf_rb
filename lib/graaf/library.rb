# frozen_string_literal: true

module Graaf
  # Graaf::Library
  module Library
    include FFI::Library

    # @return [String]
    ALIAS_PREFIX = '__graaf_'
    private_constant :ALIAS_PREFIX

    # @!method graal_create_isolate
    #   @private
    #   @param params [Graaf::CreateIsolateParams]
    #   @param graal_isolate_t [FFI::MemoryPointer]
    #   @param graal_isolatethread_t [FFI::MemoryPointer]
    #   @return [Integer]
    # @!method graal_attach_thread
    #   @private
    #   @param graal_isolate_t [FFI::Pointer]
    #   @param graal_isolatethread_t [FFI::MemoryPointer]
    #   @return [Integer]
    # @!method graal_detach_thread
    #   @private
    #   @param graal_isolatethread_t [FFI::Pointer]
    #   @return [Integer]
    # @!method graal_tear_down_isolate
    #   @private
    #   @param graal_isolatethread_t [FFI::Pointer]
    #   @return [Integer]
    # @!method graal_detach_all_threads_and_tear_down_isolate
    #   @private
    #   @param graal_isolatethread_t [FFI::Pointer]
    #   @return [Integer]

    private

    # @param args [Array]
    # @return [void]
    def private_attach_function(*args)
      attach_function(*args)
      private_class_method(args[0])
    end

    # @param names [Array<String>]
    # @return [void]
    def graaf_lib(*names)
      ffi_lib(*names)
      private_attach_function :graal_create_isolate, [CreateIsolateParams.by_ref, :pointer, :pointer], :int
      private_attach_function :graal_attach_thread, %i[pointer pointer], :int
      private_attach_function :graal_detach_thread, %i[pointer], :int
      private_attach_function :graal_tear_down_isolate, %i[pointer], :int
      private_attach_function :graal_detach_all_threads_and_tear_down_isolate, %i[pointer], :int
    end

    # @param func [#to_s]
    # @param args [Array<Symbol>]
    # @param returns [Symbol]
    # @param options [Hash]
    # @option options [Boolean] :blocking
    # @option options [Symbol] :convention
    # @option options [FFI::Enums] :enums
    # @option options [Hash] :type_map
    # @return [void]
    # @raise [FFI::NotFoundError]
    def graaf_attach_function(func, args, returns = nil, options = nil)
      alias_method_name = "#{ALIAS_PREFIX}#{func}"
      private_attach_function(alias_method_name, func, [:pointer] + args, returns, options)
      define_singleton_method(func) do |*override_args|
        with_isolate { |thread| __send__(alias_method_name, thread, *override_args) }
      end
    end

    # @yieldparam thread [FFI::Pointer]
    # @yieldreturn [Object]
    # @return [Object]
    def with_isolate
      thread = FFI::MemoryPointer.new(:pointer)
      isolate = FFI::MemoryPointer.new(:pointer)
      graal_create_isolate(nil, isolate, thread).zero? || (raise CreateIsolateError)
      yield thread.read_pointer
    ensure
      graal_tear_down_isolate(thread.read_pointer)
    end
  end
end
