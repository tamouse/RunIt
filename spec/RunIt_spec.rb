require 'spec_helper'
require 'tmpdir'

describe RunIt do

  describe "/bin/ls" do

    it "should return the list of files in an array" do
      
      runner = RunIt.new "/bin/ls"

      Dir.mktmpdir do |dir|
        Dir.chdir(dir) do |dir|
          %w[a b c d].each {|fn| FileUtils.touch(fn)}
          runner.run.should be_true
          runner.result.success?.should be_true
          runner.output.should == "a\nb\nc\nd\n"
          runner.error.should be_empty
        end
      end
    end
    
  end

  describe "/bin/cat" do

    let(:input) { "Now is the winter of our discount tent." }
    let(:runner) { RunIt.new "/bin/cat", input }
    
    it "should return the same text as input" do
      runner.run.should be_true
      runner.result.success?.should be_true
      runner.output.chomp.should == input
      runner.error.should be_empty
    end

  end

  describe "array return" do

    let(:input) {%w[Every good boy deserves favour]}
    let(:runner) {RunIt.new "/bin/cat", input, [], nil}

    it "should return the same text as input, but in an array" do
      runner.run.should be_true
      runner.result.success?.should be_true
      runner.output.should be_a(Array)
      runner.output.count.should == input.count
      runner.output.map(&:chomp).should == input
      runner.error.should be_empty
    end
    
  end

  describe "Bogus Command" do

    let(:input) {"Why did the chicken cross the road? "}
    let(:runner) {RunIt.new "/xyzzy/not_a_command_issit", input}

    it "should give a false result" do
      runner.run.should be_false
      runner.result.success?.should be_false
      runner.error.chomp.should_not be_empty
      puts "Runner.error: " + runner.error.inspect
    end
    
  end




end
