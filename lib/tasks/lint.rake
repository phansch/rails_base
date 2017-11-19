# frozen_string_literal: true

namespace :lint do
  desc 'Run Haml Linting'
  task :haml do |task|
    run_task('bundle exec haml-lint app/views', task)
  end

  desc 'Run rubocop lints'
  task :rubocop do |task|
    run_task('bundle exec rubocop', task)
  end

  desc 'Run bundle audit'
  task :bundle_audit do |task|
    run_task('bundle audit check --update', task)
  end

  desc 'Run brakeman'
  task :brakeman do |task|
    run_task('bundle exec brakeman -A --no-pager', task)
  end

  desc 'Run yamllint'
  task :yaml do |task|
    run_task('yamllint -c config/yamllint.yml .', task)
  end

  desc 'Run javascript linting'
  task :js do |task|
    run_task('yarn run lint', task)
  end

  desc 'Run scss linting'
  task :scss do |task|
    run_task('yarn run sass-lint', task)
  end

  desc 'Run cane check'
  task :cane do |task|
    run_task('bundle exec cane --no-style --no-doc --gte "coverage/.last_run.json,95"', task)
  end
end

def run_task(command, task)
  puts
  puts "==> Invoking 'rake #{task}'"
  puts "  > Running '#{command}'"
  system(command)
end

task :lint do
  Rake::Task['lint:haml'].invoke
  Rake::Task['lint:rubocop'].invoke
  Rake::Task['lint:cane'].invoke
  Rake::Task['lint:bundle_audit'].invoke
  Rake::Task['lint:brakeman'].invoke
  Rake::Task['lint:yaml'].invoke
  Rake::Task['lint:js'].invoke
  Rake::Task['lint:scss'].invoke
end
