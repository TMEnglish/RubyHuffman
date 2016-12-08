$LOAD_PATH << '.'
require 'huffman_tree'

begin
    require 'priority_queue'
rescue LoadError
    require 'hack_priority_queue'
end


# A HuffmanCodec constructs a binary Huffman code on initialization,
# and supplies methods for
#
# (1) encoding sequences of symbols as sequences of bits,
#
# (2) decoding sequences of bits obtained by encoding,
#
# (3) displaying the code graphically in a browser.
#
# Here a symbol is a byte of data, displayed as a character, and a bit
# is either the character '0' or the character '1'.
#
# The initializer receives a mapping of symbols to positive weights,
# to which there corresponds implicitly a probability mass function p
# (divide each weight by the sum total of the weights). It constructs
# a mapping c of symbols x to strings of bits c(x) called codewords.
# A Huffman code is prefix-free, meaning that for all symbols w and x,
# the codeword c(w) is not a prefix of the codeword c(x). This has an
# important consequence: any sequence of bits formed by concatenation
# of codewords c(x1), c(x2), ..., c(xn) decodes uniquely to the
# sequence of symbols x1, x2, ..., xn. The encoder indeed processes a
# given sequence of symbols by concatenating the codewords of the
# symbols.
#
# Suppose that a symbol X is drawn randomly, with probabilities of the
# possible outcomes given by p. Huffman established that the expected
# length of the codeword c(X) is the least possible for any prefix-free
# code. By Shannon's source coding theorem (see Wikipedia) for symbol
# codes, the expected codeword length is no less than the entropy H(p), 
# and is less than H(p) + 1. The expected codeword length is equal to
# the entropy if and only if all symbols x have probabilities p(x) that
# are integer powers of 2.
#
# In concrete terms, if you supply the initializer with the frequencies
# n(x) of symbols x in a "source" file of length N, and then supply the
# source to the encoder, the number of bits in the encoded source is at
# least N * H(p), and is less than N * (H(p) + 1). Here p(x) = n(x) / N
# for all symbols x in the source.
# 
class HuffmanCodec

    # Construct codec from a Hash map of symbols to probabilities.
    #
    # Symbol frequencies may be supplied in place of probabilites.
    #
    def initialize(distribution)
        trees = PriorityQueue.new
        distribution.each {|s, w| trees[w] << HuffmanLeaf.new(w, s)}
        while trees.size > 1 do
            combined = HuffmanBranch.new(trees.shift, trees.shift)
            trees[combined.weight] << combined
        end
        @tree = trees.shift
        @encoder = Hash.new
        set_encoder(@tree)
        @dist = distribution
    end


    # Construct Hash map of symbols to binary codewords.
    #
    def set_encoder(tree, bits='')
        if tree.leaf? then
            @encoder[tree.symbol] = bits
        else
            set_encoder(tree[0], bits+'0')
            set_encoder(tree[1], bits+'1')
        end
    end


    # Print encoding of `symbols_in.each_byte' to IO stream `bits_out'.
    #
    # An ArgumentError occurs if the input contains a symbol for which
    # there is no codeword. (There are codewords only for symbols
    # associated with probabilities on initialization.)
    #
    def encode(symbols_in, bits_out)
        symbols_in.rewind
        bits_out.rewind
        @encoder.default_proc = proc do |unused, symbol|
            raise ArgumentError, "Unencodable symbol '#{symbol}'"
        end
        symbols_in.each_byte {|s| bits_out.print(@encoder[s.chr])}
    end


    # Print decoding of `bits_in.each_char' to IO stream `symbols_out'.
    #
    # An ArgumentError occurs if the input contains a character other
    # than '0' or '1' or if there are excess bits at the end of the
    # input (not decoded to a symbol).
    #
    def decode(bits_in, symbols_out)
        bits_in.rewind
        symbols_out.rewind
        tree = @tree
        bits_in.each_char do |bit|
            raise ArgumentError, "Non-bit '#{bit}' in `bits in'" \
                  unless bit == '0' or bit == '1'
            tree = tree[bit.to_i]
            if tree.leaf? then
                symbols_out.print(tree.symbol.chr)
                tree = @tree
            end
        end
        raise ArgumentError, "Undecodable bits at end of input" \
              unless tree == @tree 
    end


    # Cross entropy of the source and code distributions.
    #
    # The "source distribution" p is the probability distribution for
    # which the code was designed.
    #
    # The "code distribution" q is the probability distribution for
    # which the code is ideal, i.e.,  q(x) = 2^-|c(x)|, where |c(x)| is
    # the length of the codeword for symbol x.
    #
    # The cross entropy H(p, q) = H(p) + D(p||q), where H(p) is the
    # entropy of p, and D(p||q) is the entropy of p relative to q, also
    # known as the Kullback-Leibler divergence of q from p. See the
    # Wikipedia article on cross entropy.
    #
    def cross_entropy
        norm = @tree.weight.to_f
        @encoder.each_pair.inject(0) do |sum, (x, w)|
            sum + @dist[x] / norm * @encoder[x].length
        end
    end


    # Return HTML/JavaScript (as string) for drawing the Huffman tree.
    #
    def html
        @tree.html
    end


    # Return String representation of Huffman tree
    #
    def to_s(tree=@tree, bits='')
        indent = ' ' * (4 * bits.length)
        node = "'#{bits}' #{tree.weight}"
        if tree.leaf?
            rest = " '#{tree.symbol}'\n"
        else
            rest = "\n#{to_s(tree[0], bits+'0')}#{to_s(tree[1], bits+'1')}"
        end
        return [indent, node, rest].join('')
    end

    private :set_encoder

end # class HuffmanCodec
