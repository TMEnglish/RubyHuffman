
# Every HuffmanTree is either a HuffmanLeaf or a HuffmanBranch.
#
# A HuffmanTree has a weight, width, height, and offset. All but the
# weight are used to generate an image of the tree.
#
class HuffmanTree

    # Called only by subclass initializers.
    #
    def initialize(weight, width, height, offset)
        raise ArgumentError unless weight.is_a? Numeric
        raise ArgumentError unless width.is_a? Numeric
        raise ArgumentError unless height.is_a? Numeric
        raise ArgumentError unless offset.is_a? Numeric
        raise 'Do not instantiate the base class directly' \
              unless self.is_a? HuffmanLeaf or self.is_a? HuffmanBranch
        @weight = weight
        @width = width
        @height = height
        @offset = offset
    end


    # Is this HuffmanTree an instance of subclass HuffmanLeaf?
    #
    def leaf?
        self.is_a? HuffmanLeaf
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
            y_scale = 40
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

end # class HuffmanTree



# A HuffmanLeaf is a kind of HuffmanTree.
#
# A HuffmanLeaf has, in addition to the attributes of a HuffmanTree,
# a symbol.
#
# Its weight is assigned on construction. Its width and height are 1,
# and its offset is 0.5.
#
class HuffmanLeaf < HuffmanTree

    # Assign a Numeric weight and a symbol to a leaf.
    #
    def initialize(weight, symbol)
       super(weight, 1, 1, 0.5)
       @symbol = symbol
    end


    # Number of characters in 'dump' representation of leaf label
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
        [ draw_link(bits),
          "draw_leaf(#{@offset}, #{symbol.dump.dump});"
        ].join("\n")
    end


    # The String associated with a weight in a leaf node.
    attr_reader :symbol

end # class HuffmanLeaf



# A HuffmanBranch is a kind of HuffmanTree.
#
# A HuffmanBranch has, in addition to the attributes of a HuffmanTree,
# a sequence of two HuffmanTree objects called subtrees.
#
# Its weight and width are the sums of the weights and widths,
# respectively, of its subtrees.
#
# Its height is 1 plus the maximum of the heights of its subtrees.
#
# Its offset the average of the offsets of the two subtrees, after
# their bounding boxes are adjoined.
#
class HuffmanBranch < HuffmanTree

    # Assign two HuffmanTree objects to a branch node.
    #
    def initialize(weighted_tree0, weighted_tree1)
        @subtrees = [weighted_tree0, weighted_tree1]
        raise ArgumentError, 'Not a HuffmanTree' \
              unless @subtrees.all? { |t| t.is_a? HuffmanTree }
        weight = @subtrees.inject(0) { |sum, t| sum + t.weight }
        width = @subtrees.inject(0) { |sum, t| sum + t.width }
        offset = (@subtrees[0].offset + @subtrees[0].width \
                                      + @subtrees[1].offset) / 2.0
        height = 1 + [@subtrees[0].height, @subtrees[1].height].max
        super(weight, width, height, offset)
    end


    # Length of longest leaf-label in deepest level of tree.
    #
    def margin(deepest, depth=0)
        [@subtrees[0].margin(deepest, depth+1),
         @subtrees[1].margin(deepest, depth+1)].max
    end


    # Reference a subtree of the HuffmanBranch node.
    #
    def [](index)
        @subtrees[index.to_i]
    end


    # Generate JavaScript to draw tree rooted at this node.
    #
    def draw(bits='')
        offset = @subtrees.map { |t| t.offset }
        width  = @subtrees.map { |t| t.width }
        [ draw_link(bits),
          "draw_line(1, #{offset[0]}, 1, #{offset[1] + width[0]});",
          "translate(1, 0);",
          @subtrees[0].draw(bits+'0'),
          "translate(0, #{width[0]});",
          @subtrees[1].draw(bits+'1'),
          "translate(-1, #{-width[0]});"
        ].join("\n")
    end

end # class HuffmanBranch


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

    
    function draw_link(offset, bits, weight) {
    
    //  Draw a horizontal line from (0, offset) to (1, offset) with
    //  scaling of dimensions. Label it above with string `bits' (red),
    //  and below with string `weight' (in black).
    
        draw_line(0, offset, 1, offset);
        bits_off = offset * Y_SCALE - 0.33 * FONT_SIZE;
        weight_off = offset * Y_SCALE + 1.1 * FONT_SIZE;
        ctx.fillStyle = 'red';
        ctx.textAlign = 'center';
        ctx.fillText(bits, X_SCALE/2, bits_off);
        ctx.fillStyle = 'black';
        ctx.fillText(weight, X_SCALE/2, weight_off);
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
