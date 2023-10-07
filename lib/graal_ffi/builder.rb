# frozen_string_literal: true

module GraalFFI
  # GraalFFI::Builder
  class Builder
    # @param java_paths [Array<String>]
    # @param output_path [String]
    # @return [void]
    def initialize(java_paths:, output_path:)
      @java_paths = java_paths
      @output_path = output_path
      @output_dir = File.dirname(@output_path)
      @options = [
        '-march=native',
        '--enable-sbom',
        '--strict-image-heap',
        '-H:+UnlockExperimentalVMOptions'
      ].freeze
    end

    # @return [void]
    def execute
      class_path = random_class_path
      system(<<~SYSTEM)
        javac -d #{class_path} #{java_paths.join(' ')} && \
        native-image -cp #{class_path} -o #{output_path} --shared #{options.join(' ')} && \
        rm -r \
          #{class_path} \
          #{output_dir}/graal_isolate.h \
          #{output_dir}/graal_isolate_dynamic.h \
          #{output_path}.h \
          #{output_path}_dynamic.h
      SYSTEM
    end

    private

    # @return [String]
    def random_class_path
      File.expand_path("../../tmp/#{SecureRandom.hex(10)}", __dir__)
    end

    # @!attribute [r] java_paths
    # @return [String]
    attr_reader :java_paths
    # @!attribute [r] output_path
    # @return [String]
    attr_reader :output_path
    # @!attribute [r] output_dir
    # @return [String]
    attr_reader :output_dir
    # @!attribute [r] options
    # @return [Array<String>]
    attr_reader :options
  end
end
