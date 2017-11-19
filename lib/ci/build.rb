# frozen_string_literal: true

module CI # :nodoc:
  load 'Rakefile'

  # Run different build jobs and deal with the job results
  #
  # The Build assumes that there is a rake task with the given name loaded.
  #
  # If you have a new .rake file, you have to load it above.
  #
  # rubocop:disable Rails/Output,Rails/Exit
  class Build
    def initialize
      @results = {}
    end

    # Runs the given rake task
    def run_task(task_name)
      puts heading("Running #{task_name}")
      @results[task_name] = Rake::Task[task_name].invoke
    end

    def heading(text)
      "\n\e[1;33m[Travis CI] #{text}\e[m\n"
    end

    def failures
      @results.reject { |_, value| value }
    end

    def handle_results
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
end
