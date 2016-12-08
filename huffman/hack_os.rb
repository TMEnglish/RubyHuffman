require 'rbconfig'

# Quick-and-dirty substitute for OS gem.
class OS

    # Return the value of 'host_os' in the Ruby configuration.
    def self.host_os
        RbConfig::CONFIG['host_os']
    end

    # Categorize the host OS as Windows, Mac, Linux, BSD, or unknown.
    def self.os_category
        if OS.windows? then
            "Windows"
        elsif OS.mac?
            "Mac OS"
        elsif OS.linux?
            "Linux"
        elsif OS.bsd?
            "BSD Unix"
        else
            "UNKNOWN"
        end
    end

    # Running on Windows?
    def self.windows?
        host_os =~ /mswin|mingw|cygwin|win32|dos|bccwin|wince|emx/
    end

    # Running on Mac Os?
    def self.mac?
        host_os =~ /darwin/
    end

    # Running on Linux?
    def self.linux?
        host_os =~ /linux/
    end

    # Running on BSD Unix?
    def self.bsd?
        host_os =~ /bsd/
    end

    # Running on a POSIX system?
    def self.posix?
        OS::mac? or OS::linux? or OS::bsd?
    end
end

STDERR.puts "*** Supplying a poor substitute for Ruby gem `os'."
STDERR.puts "*** It sees your system #{OS.host_os} as #{OS.os_category}."
STDERR.puts "*** If this is wrong, install the `os' gem."
STDERR.puts
