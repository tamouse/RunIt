# Things to do

## Utilize Threads to ensure process output doesn't block the process:

From Robert Klemme <shortcutter@googlemail.com> via ruby-lang.org:

And here's a solution using open3:

    require 'open3'

    Open3.popen3( %w{make codename} ) do |stdin, stdout, stderr, t|
      stdin.close
      err_thr = Thread.new { IO.copy_stream(stderr, outfile) }
      puts "Reading STDOUT"
      IO.copy_stream(stdout, outfile)
      err_thr.join
    end
 
Note: I also used an Array for the make command invocation because that avoids parsing issues in the shell because it omits the shell altogether (see Process.spawn).

You might also prefer a more line based approach

    def copy_lines(str_in, str_out)
      str_in.each_line {|line| str_out.puts line}
    end

    Open3.popen3( 'make codename' ) do |stdin, stdout, stderr, t|
      stdin.close
      err_thr = Thread.new { copy_lines(stderr, $stderr) }
      puts "Reading STDOUT"
      copy_lines(stdout, $stdout)
      err_thr.join
    end

