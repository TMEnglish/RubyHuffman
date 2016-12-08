#!/usr/bin/ruby

$LOAD_PATH << '.'
require 'stringio'
require 'huffman_codec'
require 'source'
begin
    require 'os'
rescue LoadError
    require 'hack_os'
end
begin
    require 'launchy'
rescue LoadError
    require 'hack_launchy'
end 


# Write script name along with `message' to standard error.
def warn(message)
    STDERR.puts "#$0: #{message}"
end

# An Exception subclass for errors external to the code.
class UserError < StandardError
end


# Process the command line, and pass argument to `run'.
def run_as_script
    begin
        if ARGV.length != 1 then
            raise UserError, "USAGE #$0 [--string=<string> | <path>]"
        end
        run ARGV[0]
    rescue UserError => e
        warn e.message
        exit -1
    end
end


# TO DO: document
def run(argument)
    io = HuffmanIO.new(argument)
    begin
        source = Source.new(io.symbols)
        codec = HuffmanCodec.new(source.frequencies)
        codec.encode(io.symbols, io.encoded)
        codec.decode(io.encoded, io.decoded)
        io.report(source.frequencies.size, source.entropy, codec.cross_entropy)
        display_in_browser(codec.html)
    ensure
        io.close
    end
end


# Write HTML source to a file, and launch browser on that file.
#
def display_in_browser(html_source, path=nil)
    path = "#{Dir.pwd}/tmpHuffman.html" if path == nil
    url = "file:///#{path}"
    warn "Launch browser on URL #{url}"
    begin
        html = File.new(path, 'w+')
    rescue
        warn "Cannot open #{path} to write HTML."
    else
        begin
            html << html_source
            begin
                Launchy.open(url)
            rescue
                warn "Launch failed. Try browsing URL manually."
            end
        ensure
            html.close
        end
    end
end


# TO DO: document
class HuffmanIO

    # Iterate tight loop at most 2**FLUSH_WAIT times waiting on file flush.
    FLUSH_WAIT=24


    # Open IO objects :symbols, :encoded, :decoded according to `argument'.
    #
    # If `argument' matches '--string=<string>' then the IO objects are
    # of class StringIO, with :symbols initialized to <string>, and with
    # :encoded and :decoded empty.
    #
    # Otherwise, the IO objects are of class File, with `argument' the
    # path of the :symbols File, and with `argument' extended with
    # '.encoded' and '.decoded' the paths of :encoded and :decoded,
    # respectively.
    #
    # The :symbols IO object is read-only. The other IO objects are
    # opened to write ("w+"), but are also readable.
    #
    def initialize(argument)
        if /^--string=/.match(argument) then
            string = argument.sub(/^--string=/, '')
            @symbols = StringIO.new(string, 'r')
            @decoded = StringIO.new('', 'w+')
            @encoded = StringIO.new('')
        else
            begin
                @symbols = File.new(argument, 'r')
                @decoded = File.new(argument + '.encoded', 'w+')
                @encoded = File.new(argument + '.decoded', 'w+')
            rescue Exception => e
                close
                raise UserError, e.message
            end
        end
        if @symbols.size == 0 then
            close
            raise UserError, "Empty source of symbols `#{argument}'"
        end
    end


    # Close IO objects, ignoring exceptions.
    #
    def close
        for io in [@symbols, @decoded, @encoded]
            begin
                io.close
            rescue
            end
        end
    end


    # Are :symbols and :decoded IO objects identical in contents?
    #
    def decoded_matches_symbols(wait=0)
        @decoded.flush
        (0..2**wait).each { |busy_waiting| busy_waiting + 1 }
        @symbols.rewind
        @decoded.rewind
        match = @symbols.each_byte.all? { |b| b == decoded.getbyte }
        match or ((wait < FLUSH_WAIT) and decoded_matches_symbols(wait + 1))
    end


    # Return two Boolean values: Is :decoded is identical to :symbols?
    #
    # (1) Use a well tested internal method to perform the check.
    #
    # (2) Execute OS utility to compare source and decoded files on disk, 
    # if the OS is recognized as Windows or POSIX. There is no reason for
    # this but to play around with Ruby.
    #
    def check_decoded
        match = decoded_matches_symbols
        alt_match = match
        if @symbols.is_a? StringIO then
            # Nothing is on disk
        elsif OS.windows? then
            command = "FC /B #{@symbols.path} #{@decoded.path}"
            alt_match = system(command)
            warn "Failed to execute Windows FC" if alt_match == nil
        elsif OS.posix? then
            command = "diff #{@symbols.path} #{@decoded.path} -q"
            alt_match = system(command)
            warn "Failed to execute POSIX diff" if alt_match == nil
        end
        return match, alt_match
    end


    # TO DO: document EXTENSIVELY
    #
    def report(n_symbols, entropy, cross_entropy)
        match, alt_match = check_decoded
        bit_rate = @encoded.size / @symbols.size.to_f
        divergence = bit_rate - entropy
        puts
        puts "Source file size               : #{@symbols.size} bytes"
        puts "Encoded file size              : #{@encoded.size} bits"
        puts "Decoded file size              : #{@decoded.size} bytes"
        puts "Source and decoded files match : #{match}"
        puts "Confirm match (experimental)   : #{alt_match}"
        puts "Number of distinct symbols     : #{n_symbols}"
        puts "Entropy H(p)                   : #{entropy.round(5)} bits"
        puts "Cross entropy H(p, q)          : #{cross_entropy.round(5)} bits"
        puts "Actual bits per encoded symbol : #{bit_rate.round(5)}"
        puts "Relative entropy D(p||q)       : #{divergence.round(5)} bits"
        puts
        puts "Here p is the distribution of symbols in the source"
        puts "and q is the ideal distribution of symbols for the code,"
        puts "with H(p, q) = H(p) + D(p||q)."
        puts
    end


    # IO from which the encoder reads symbols.
    attr_reader :symbols

    # IO to which the encoder writes and from which the decoder reads.
    attr_reader :encoded

    # IO to which the decoder writes.
    attr_reader :decoded

end # HuffmanIO


run_as_script if __FILE__==$0
