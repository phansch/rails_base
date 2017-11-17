#!/usr/bin/env ruby
# frozen_string_literal: true

load 'Rakefile'
load 'lib/tasks/lint.rake'

# Run different build jobs and deal with the job results
#
# The Build assumes that there is a rake task with the given name loaded.
#
# If you have a new .rake file, you have to load it above.
class Build
  def initialize
    @results = {}
  end

  def run_job(job_name)
    puts heading("Running #{job_name}")
    @results[job_name] = Rake::Task[job_name].invoke
  end

  def heading(text)
    "\n\e[1;33m[Travis CI] #{text}\e[m\n"
  end

  def handle_results
    failures = @results.reject { |_, value| value }
    puts
    if failures.empty?
      puts 'Build finished successfully'
      exit(true)
    else
      puts "Build FAILED because of #{failures.map(&:first).join(', ')}"
      exit(false)
    end
  end
end

build = Build.new

if ENV['RUN'] == 'test'
  build.run_job('spec')
  build.run_job('lint:haml')
  build.run_job('lint:rubocop')
  build.run_job('lint:bundle_audit')
  build.run_job('lint:brakeman')
  system('PATH=$HOME/.local/bin:$PATH pip install --user yamllint')
  build.run_job('lint:yaml')
  build.run_job('lint:js')
else
  build.run_job('spec')
end

build.handle_results
