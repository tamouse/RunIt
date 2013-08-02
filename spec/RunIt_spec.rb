require 'spec_helper'
require 'tmpdir'

describe RunIt do

  describe "/bin/ls" do

    it "should return the list of files" do
      
      runner = RunIt.new "/bin/ls"

      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do |dir|
          %w[a b c d].each {|fn| FileUtils.touch(fn)}
          runner.run.should be_true
          runner.success?.should be_true
          runner.exitstatus.should == 0
          runner.output.should == "a\nb\nc\nd\n"
          runner.error.should be_empty
        end
      end
    end
    
  end

  describe "/bin/cat" do

    let(:input) { "Now is the winter of our discount tent.\n" }
    let(:runner) { RunIt.new "/bin/cat", input }
    
    it "should return the same text as input" do
      runner.run.should be_true
      runner.success?.should be_true
      runner.output.should == input
      runner.error.should be_empty
    end

  end

  describe "Bogus Command" do

    let(:input) {"Why did the chicken cross the road? "}
    let(:runner) {RunIt.new "/xyzzy/not_a_command_issit", input}

    it "should give a false result" do
      runner.run.should be_false
      runner.success?.should be_false
      runner.error.should_not be_empty
      puts "Runner.error: " + runner.error.inspect
    end
    
  end

  describe "Test Mocking" do
    it "Should not do anything except return the command given in the output" do
      runner = RunIt.new "/bin/ls"
      RunIt.mock!
      runner.mock?.should be_true
      runner.run.should be_true
      runner.output.should == "Command entered: /bin/ls"
    end

    
  end



end
