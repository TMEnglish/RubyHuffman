STDERR.puts "*** Supplying a poor substitute for Ruby gem `launchy'."
STDERR.puts "*** Launchy is used to load a file into your web browser."
STDERR.puts "*** You can load the file manually by clicking on its icon."
STDERR.puts

# Quick-and-dirty substitute for Launchy gem.
#
class Launchy

    # Open link in the default web browswer.
    #
    def self.open(link)
        if OS.windows?
            system "start #{link}"
        elsif OS.mac?
            system "open #{link}"
        elsif OS.linux? or OS.bsd?
            system "xdg-open #{link}"
        else
            STDERR.puts "Don't recognize your operating system."
            STDERR.puts "Guessing Windows, trying to open browser."
            system "start #{link}"
        end
    end
end
