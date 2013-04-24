=begin rdoc

= RUNIT.RB

*Author*::      Tamara Temple <tamara@tamaratemple.com>
*Since*::       2013-04-23
*Copyright*::   (c) 2013 Tamara Temple Web Development
*License*::     MIT
  
== Description

A simple class to wrap Open3 to execute a command and return the result, stdout and stderr

=end

require 'open3'
require 'ostruct'

class RunIt

  VERSION = "0.1.0"

  attr_accessor :cmd, :input, :output, :error, :result

  def initialize(cmd, input=nil, output=nil, error=nil)

    self.cmd = cmd
    self.output = output ||= ''
    self.error = error ||= ''

    # Input is a little more complicated

    case input
    when String ; self.input = input
    when Array ; self.input = input.flatten.join("\n")
    when NilClass ; self.input = nil
    else self.input = input.to_s
    end
    
  end

  def run

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
        self.result.success?
      end

    rescue Exception => e

      self.result = OpenStruct.new(:success? => false, :exitstatus => -1)
      self.error << "#{cmd} raised an error: #{e.class}:#{e}"
      false

    end
        
  end

end
 
