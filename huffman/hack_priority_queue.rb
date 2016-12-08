STDERR.puts "*** Supplying a poor substitute for Ruby gem `priority_queue'."
STDERR.puts "*** I've tested it little, so you'd better install the gem."
STDERR.puts

# Inefficient and poorly tested substitute for priority_queue gem.
#
# The underlying data structure is a sorted list. Make it a min-heap,
# and this implementation is unobjectionable.
#
class PriorityQueue

    # An Entry has a priority and an item
    #
    class Entry

        # The priority must be set first.
        def initialize(priority)
            raise ArgumentError unless priority.is_a? Numeric
            @priority = priority
            @item = nil
        end

        # This is the only way to set the item.
        def <<(item)
            raise "item already set" unless @item == nil
            @item = item
        end

        # Comparison of priority values.
        def <=>(rhs)
            @priority <=> rhs.priority
        end

        # The item stored in an Entry of the queue
        attr_reader :item

        # The priority of an Entry of the queue
        attr_reader :priority
    end

    # Make an empty queue.
    def initialize
        @q = []
    end

    # Return a new Entry in the queue, with only priority set.
    def [](priority)
        entry = Entry.new(priority)
        i = @q.find_index {|e| e.priority >= priority}
        @q.insert(i == nil ? -1 : i, entry)
        return entry
    end

    # Return highest-priority item, removing its entry from queue.
    def shift
        @q.shift.item
    end

    # The number of entries in the queue.
    def size
        @q.length
    end
end
