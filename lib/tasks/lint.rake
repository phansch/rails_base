# frozen_string_literal: true

namespace :lint do
  desc 'Run Haml Linting'
  task :haml do
    system('bundle exec haml-lint app/views')
  end

  desc 'Run rubocop lints'
  task :rubocop do
    system('bundle exec rubocop')
  end

  desc 'Run bundle audit'
  task :bundle_audit do
    system('bundle audit check --update')
  end
end

task :lint do
  Rake::Task['lint:haml'].invoke
  Rake::Task['lint:rubocop'].invoke
  Rake::Task['lint:bundle_audit'].invoke
end
