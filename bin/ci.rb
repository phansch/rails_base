#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/ci/build'

build = CI::Build.new

if ENV['RUN'] == 'test'
  build.run_task('spec')
  build.run_task('lint:haml')
  build.run_task('lint:rubocop')
  build.run_task('lint:bundle_audit')
  build.run_task('lint:brakeman')
  system('PATH=$HOME/.local/bin:$PATH pip install --user yamllint')
  build.run_task('lint:yaml')
  build.run_task('lint:js')
end

build.handle_results
