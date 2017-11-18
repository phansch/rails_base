# frozen_string_literal: true

require 'spec_helper'
require 'ci/build'

module CI
  RSpec.describe Build do
    let(:build) { Build.new }
    let!(:success_task) { Rake::Task.define_task(:abc) }
    let!(:failure_task) { Rake::Task.define_task(:fail) }

    before do
      allow(success_task).to receive(:invoke).and_return(true)
      allow(failure_task).to receive(:invoke).and_return(false)
    end

    describe '#run_task' do
      it 'calls the correct rake task' do
        expect(success_task).to receive(:invoke).once
        expect do
          build.run_task('abc')
        end.to output(/Running abc/).to_stdout
      end
    end

    describe '#failures' do
      subject(:failures) { build.failures }

      it 'returns the failed tasks' do
        expect do
          build.run_task('abc')
        end.to output(/Running abc/).to_stdout
        expect do
          build.run_task('fail')
        end.to output(/Running fail/).to_stdout
        expect(failures).to eq('fail' => false)
      end
    end

    describe '#handle_results' do
      context 'with no failures' do
        before do
          expect { build.run_task('abc') }.to output.to_stdout
        end

        it 'prints the success message' do
          expect do
            begin build.handle_results
            rescue SystemExit
            end
          end.to output(/Build finished successfully/).to_stdout
        end
      end

      context 'with failures' do
        before do
          expect { build.run_task('fail') }.to output.to_stdout
        end

        it 'prints the failure message' do
          expect do
            begin build.handle_results
            rescue SystemExit
            end
          end.to output(/Build FAILED because of fail/).to_stdout
        end
      end
    end
  end
end
