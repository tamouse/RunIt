=begin rdoc

= RUNIT.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-04-23
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
== Description

A simple class to wrap Open3 to execute a command and return the result, stdout and stderr

== Synopsis

    require 'RunIt'

    runner = RunIt.new "/bin/ls"
    runner.run
    puts runner.output

=end

require 'open3'
require 'ostruct'

class RunIt

  # Version 
  VERSION = "1.0.0"

  # cmd:: set/get the command to execute
  attr_accessor :cmd

  # input:: set/get the input for the command
  attr_accessor :input

  # output:: get the output from the command
  attr_reader :output

  # error:: get the error messages from the command
  attr_reader :error

  # result:: the result of the command as a Process::Status object
  attr_reader :result


  # Class function to tell if mocking is turned on
  def self.mock?
    @@mock
  end

  # Class method to turn on mocking
  def self.mock!
    @@mock = true
  end

  # Class method to turn off mocking
  def self.unmock!
    @@mock = false
  end
  
  # Initialize the RunIt object
  #
  # cmd:: (required) [String] - the full command line to execute
  # input:: (optional) [String] - input to the command, if any
  def initialize(cmd, input=nil)
    self.cmd = cmd
    self.input = input
    self.result = nil
    @@mock = false
  end

  # Execute the specified command
  #
  # If mocking is on, only return the command as the output, and set success to true
  def run

    if @@mock

      self.result = OpenStruct.new(:success? => true, :exitstatus => 0)
      self.output = "Command entered: #{self.cmd}"
      self.error  = ''
      return true

    else

      self.output = ''
      self.error  = ''
      self.result = nil

      begin

        Open3.popen3(self.cmd) do |stdin, stdout, stderr, wait|
          stdin.puts self.input unless self.input.nil?
          stdin.close
          until stdout.eof?
            self.output <<  stdout.gets
          end
          until stderr.eof?
            self.error <<  stderr.gets
          end
          self.result = wait.value
        end

      rescue Exception => e

        self.result = OpenStruct.new(:success? => false, :exitstatus => -1)
        self.error << "#{cmd} raised an error: #{e.class}:#{e}"

      end

      self.result.success?

    end

  end

  # Whether the command completed successfully
  def success?
    self.result.success?
  end

  # The exit status of the command
  def exitstatus
    self.result.exitstatus
  end

  # Instance method to tell if mocking is turned on
  def mock?
    @@mock
  end

  private


end

