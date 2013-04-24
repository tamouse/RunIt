# RunIt

A small wrapper class for Open3#popen3

## Installation

Add this line to your application's Gemfile:

    gem 'RunIt'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install RunIt

## Usage

    require 'RunIt'
    runner = RunIt.new command
	runner.run
    if runner.result.success?
	   puts runner.output
	else
	   $stderr.puts runner.error
	end

Simple one-line thing:

    raise "Could not list files!!" unless (runner = RunIt.new "/bin/ls").run

Full usage:

    require 'RunIt'

    input <<-LIPSUM
    Lorem ipsum solar et domit.
    Now is the winter of our discount tent.
    For score and winning the game.
    Every good boy deserves favour.
    LIPSUM

    runner = RunIt.new "/bin/cat", input, [], nil
	if runner.run
	    # the output will be in an array
	    puts runner.output.join
    else
	    STDERR.puts runner.error.join
	end

    


## Contributing

1. Fork it [Githum repo](https://github.com/tamouse/RunIt)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
