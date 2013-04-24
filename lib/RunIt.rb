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

class RunIt

  attr_accessor :cmd, :input, :output, :error

  def initialize(cmd, input=nil, output=nil, error=nil)

    self.cmd = cmd
    self.input = input
    self.output = output ||= []
    self.error = error ||= []

  end

  def run

    Open3.popen3(self.cmd) do |stdin, stdout, stderr, wait|
      File.open(self.input,'r') {|infile| stdin.puts infile.gets} unless self.input.nil?
      until stdout.eof?
        self.output <<  stdout.gets
      end
      until stderr.eof?
        self.error <<  stderr.gets
      end
      result = wait.value
      [ result, output, error ]
    end
        
  end

end
 
