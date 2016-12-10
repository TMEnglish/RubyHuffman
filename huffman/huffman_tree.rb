# TO DO
#
module HuffmanTree

    # Every Node is either a Leaf or a Branch.
    #
    # A Node has a weight, width, height, and offset. All but the
    # weight are used to generate an image of the tree.
    #
    class Node
    
        # Called only by subclass initializers.
        #
        def initialize(weight, width, height, offset)
            raise ArgumentError unless weight.is_a? Numeric
            raise ArgumentError unless width.is_a? Numeric
            raise ArgumentError unless height.is_a? Numeric
            raise ArgumentError unless offset.is_a? Numeric
            raise 'Do not instantiate the base class directly' unless
                  self.is_a? Leaf or self.is_a? Branch
            @weight = weight
            @width = width
            @height = height
            @offset = offset
        end
    
    
        # Is this Node an instance of subclass Leaf?
        #
        def leaf?
            self.is_a? Leaf
        end
    
    
        # Generate JavaScript to draw link to node.
        #
        def draw_link(bits)
            "draw_link(#{@offset}, '#{bits}', '#{@weight}');"
        end
    
    
        # Return HTML/Javascript (as String) to draw tree (sideways).
        #
        def html
            if @width > 128 then
                y_scale = 32
                font_size = 11
            else
                y_scale = 42
                font_size = 14
            end
            x_scale = 0.62 * font_size * @height;
            left_margin = 0.1
            right_margin = margin(@height, 1) / @height.to_f + 0.1
            "
            <!DOCTYPE html>
            <html>
              <body>
                 <canvas
                    id='myCanvas'
                    width='#{x_scale  * (@height + left_margin + right_margin)}'
                    height='#{y_scale * @width}'
                    style='border:1px solid #d3d3d3;'>
                 </canvas>
                 <script>
                    const X_SCALE = #{x_scale};
                    const Y_SCALE = #{y_scale};
                    const FONT_SIZE = #{font_size};
                    const FONT = '#{font_size}px \"Lucida Console\", Monaco';
                    #{JAVASCRIPT_DRAWING_DEFINITIONS}
                    translate(#{left_margin}, 0);
                    #{draw}
                 </script>
              </body>
            </html>
            "
        end
    
    
        # The total weight of all leaves of the tree.
        attr_reader :weight
    
        # Width of the bounding box of the tree in graphics.
        attr_reader :width
    
        # Height of the bounding box of the tree in graphics.
        attr_reader :height
    
        # Offset of node from edge of the bounding box in graphics.
        attr_reader :offset
    
    end # class Node
    
    
    
    # A Leaf is a kind of Node.
    #
    # A Leaf has, in addition to the attributes of a Node, a symbol.
    # The width and height are 1, and the offset is 0.5.
    #
    class Leaf < Node
    
        # Assign a Numeric weight and a symbol (String) to a leaf.
        #
        # The width and height are 1, and the offset is 0.5.
        #
        def initialize(weight, symbol)
           super(weight, 1, 1, 0.5)
           @symbol = symbol
        end
    
    
        # Number of characters in 'dump' representation of :symbol.
        #
        def margin(deepest, depth=0)
            depth == deepest ?  @symbol.dump.length : 0
        end
    
    
        # Generate JavaScript to draw leaf.
        #
        # Draw a labeled link to the node.
        # Write the symbol at the end of the link.
        #
        def draw(bits='')
            "#{draw_link(bits)}
             draw_leaf(#{@offset}, #{symbol.dump.dump});"
        end
    
    
        # The String associated with a weight in a leaf node.
        attr_reader :symbol
    
    end # class Leaf
    
    
    
    # A Branch is a kind of Node.
    #
    # A Branch has, in addition to the attributes of a Node,
    # a sequence of two Node objects called subtrees.
    #
    # Its weight and width are the sums of the weights and widths,
    # respectively, of its subtrees.
    #
    # Its height is 1 plus the maximum of the heights of its subtrees.
    #
    # Its offset the average of the offsets of the two subtrees, after
    # their bounding boxes are merged into one.
    #
    class Branch < Node
    
        # Assign two Node objects (subtrees) to a branch node.
        #
        # The weight and width are the sums of the weights and widths,
        # respectively, of the subtrees.
        #
        # The height is 1 plus the maximum of the heights of the subtrees.
        #
        # The offset the average of the offsets of the two subtrees, after
        # their bounding boxes are merged into one.
        #
        def initialize(weighted_tree0, weighted_tree1)
            @subtrees = [weighted_tree0, weighted_tree1]
            raise ArgumentError, 'Not a Node' unless @subtrees[0].is_a? Node
            raise ArgumentError, 'Not a Node' unless @subtrees[1].is_a? Node
            weight = @subtrees.inject(0) { |sum, t| sum + t.weight }
            width = @subtrees.inject(0) { |sum, t| sum + t.width }
            height = 1 + [@subtrees[0].height, @subtrees[1].height].max
            offset = @subtrees[0].offset + @subtrees[1].offset
            offset = (offset + @subtrees[0].width) / 2.0
            super(weight, width, height, offset)
        end
    
    
        # Length of the longest symbol in the deepest level of tree.
        #
        def margin(deepest, depth=0)
            [@subtrees[0].margin(deepest, depth+1),
             @subtrees[1].margin(deepest, depth+1)].max
        end
    
    
        # Reference a subtree of the Branch node.
        #
        def [](index)
            @subtrees[index.to_i]
        end
    
    
        # Generate JavaScript to draw tree rooted at this node.
        #
        def draw(bits='')
            offset = @subtrees.map { |t| t.offset }
            width  = @subtrees.map { |t| t.width }
            " #{draw_link(bits)}
              draw_line(1, #{offset[0]}, 1, #{offset[1] + width[0]});
              translate(1, 0);
              #{@subtrees[0].draw(bits+'0')}
              translate(0, #{width[0]});
              #{@subtrees[1].draw(bits+'1')}
              translate(-1, #{-width[0]});
            "
        end
    
    end # class Branch
    
    
    # JavaScript functions for drawing the Huffman tree on an HTML canvas.
    #
    JAVASCRIPT_DRAWING_DEFINITIONS = "
        var canvas = document.getElementById('myCanvas');
        var ctx = canvas.getContext('2d');
        ctx.font = FONT;
       
        function translate(x, y) {
    
        //  Translate the coordinate system in scaled units.
        
            ctx.translate(x * X_SCALE, y * Y_SCALE);
        }
         
    
        function draw_line(x0, y0, x1, y1) {
    
        //  Draw line from (x0, y0) to (x1, y1) with scaling of dimensions.
    
            ctx.moveTo(x0 * X_SCALE, y0 * Y_SCALE);
            ctx.lineTo(x1 * X_SCALE, y1 * Y_SCALE);
            ctx.stroke();
        }
    
        
        function draw_link(y, bits, weight) {
        
        //  Draw a horizontal line from (0, y) to (1, y) with
        //  scaling of dimensions. Label it above with string `bits' (red),
        //  and below with string `weight' (in black).
        
            draw_line(0, y, 1, y);
            bits_y = y * Y_SCALE - 0.33 * FONT_SIZE;
            weight_y = y * Y_SCALE + 1.1 * FONT_SIZE;
            ctx.fillStyle = 'red';
            ctx.textAlign = 'center';
            ctx.fillText(bits, X_SCALE/2, bits_y);
            ctx.fillStyle = 'black';
            ctx.fillText(weight, X_SCALE/2, weight_y);
        }
        
        
        function draw_leaf(y, symbol) {
    
        //  Write symbol at (1, y) with scaling of coordinates.
    
            x = 1 * X_SCALE + 0.10 * FONT_SIZE
            y = y * Y_SCALE + 0.25 * FONT_SIZE;
            ctx.fillStyle = 'green';
            ctx.textAlign = 'left';
            ctx.fillText(symbol, x, y);
        }
    "

end # module HuffmanTree
