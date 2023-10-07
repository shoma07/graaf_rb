# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

# rubocop
require 'rubocop/rake_task'
RuboCop::RakeTask.new(:lint) do |t|
  t.options = %w[--parallel]
end
namespace :lint do
  desc 'Lint fix (Rubocop)'
  task fix: :autocorrect

  namespace :fix do
    desc 'Lint fix all (Rubocop)'
    task all: :autocorrect_all
  end
end

# steep
# @see https://github.com/soutaro/steep/blob/master/exe/steep
require 'rbs'
require 'rbs/cli'
require 'steep'
require 'steep/cli'
desc 'Typecheck (Steep)'
task :typecheck do
  Steep::CLI.new(
    argv: %w[check -j4], stdout: $stdout, stderr: $stderr, stdin: $stdin
  ).run.zero? || exit(1)
end

namespace :typecheck do
  desc 'Install RBS Collection'
  task :install do
    RBS::CLI.new(stdout: $stdout, stderr: $stderr).run('collection install --frozen'.split)
  end

  desc 'Update RBS Collection'
  task :update do
    RBS::CLI.new(stdout: $stdout, stderr: $stderr).run('collection update'.split)
  end
end

# yard
require 'yard'
## custom rake task
desc 'Generate and Check code documents'
task :doc do
  # @note hack yard logger
  # @see https://github.com/lsegal/yard/blob/92b9b7c/lib/yard/logging.rb#L38-L40
  io = StringIO.new
  YARD::Logger.instance(io)
  YARD::CLI::CommandParser.run(*%w[stats --list-undoc])
  result = io.tap(&:rewind).read
  $stdout.puts(result)
  result.lines(chomp: true).last.strip == '100.00% documented' || exit(1)
end

task default: %i[lint typecheck doc spec]
