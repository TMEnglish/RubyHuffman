var search_data = {"index":{"searchIndex":["huffmancodec","huffmanio","huffmantree","branch","leaf","node","launchy","os","object","priorityqueue","entry","source","usererror","<<()","<=>()","[]()","[]()","bsd?()","check_decoded()","close()","cross_entropy()","decode()","decoded_matches_symbols()","display_in_browser()","draw()","draw()","draw_link()","encode()","host_os()","html()","html()","leaf?()","linux?()","mac?()","margin()","margin()","new()","new()","new()","new()","new()","new()","new()","new()","open()","os_category()","posix?()","report()","run()","run_as_script()","shift()","size()","to_s()","warn()","windows?()"],"longSearchIndex":["huffmancodec","huffmanio","huffmantree","huffmantree::branch","huffmantree::leaf","huffmantree::node","launchy","os","object","priorityqueue","priorityqueue::entry","source","usererror","priorityqueue::entry#<<()","priorityqueue::entry#<=>()","huffmantree::branch#[]()","priorityqueue#[]()","os::bsd?()","huffmanio#check_decoded()","huffmanio#close()","huffmancodec#cross_entropy()","huffmancodec#decode()","huffmanio#decoded_matches_symbols()","object#display_in_browser()","huffmantree::branch#draw()","huffmantree::leaf#draw()","huffmantree::node#draw_link()","huffmancodec#encode()","os::host_os()","huffmancodec#html()","huffmantree::node#html()","huffmantree::node#leaf?()","os::linux?()","os::mac?()","huffmantree::branch#margin()","huffmantree::leaf#margin()","huffmancodec::new()","huffmanio::new()","huffmantree::branch::new()","huffmantree::leaf::new()","huffmantree::node::new()","priorityqueue::new()","priorityqueue::entry::new()","source::new()","launchy::open()","os::os_category()","os::posix?()","huffmanio#report()","object#run()","object#run_as_script()","priorityqueue#shift()","priorityqueue#size()","huffmancodec#to_s()","object#warn()","os::windows?()"],"info":[["HuffmanCodec","","HuffmanCodec.html","","<p>A HuffmanCodec constructs a binary Huffman code on initialization, and\nsupplies methods for\n<p>(1) encoding …\n"],["HuffmanIO","","HuffmanIO.html","","<p>TO DO: document\n"],["HuffmanTree","","HuffmanTree.html","","<p>TO DO\n"],["HuffmanTree::Branch","","HuffmanTree/Branch.html","","<p>A Branch is a kind of Node.\n<p>A Branch has, in addition to the attributes of a Node, a sequence of two  …\n"],["HuffmanTree::Leaf","","HuffmanTree/Leaf.html","","<p>A Leaf is a kind of Node.\n<p>A Leaf has, in addition to the attributes of a Node, a symbol. The width\nand …\n"],["HuffmanTree::Node","","HuffmanTree/Node.html","","<p>Every Node is either a Leaf or a Branch.\n<p>A Node has a weight, width, height, and offset. All but the weight …\n"],["Launchy","","Launchy.html","","<p>Quick-and-dirty substitute for Launchy gem.\n"],["OS","","OS.html","","<p>Quick-and-dirty substitute for OS gem.\n"],["Object","","Object.html","",""],["PriorityQueue","","PriorityQueue.html","","<p>Inefficient and poorly tested substitute for priority_queue gem.\n<p>The underlying data structure is a sorted …\n"],["PriorityQueue::Entry","","PriorityQueue/Entry.html","","<p>An Entry has a priority and an item\n"],["Source","","Source.html","","<p>A Source contains attributes of a sequence of bytes, called symbols.\n"],["UserError","","UserError.html","","<p>An Exception subclass for errors external to the code.\n"],["<<","PriorityQueue::Entry","PriorityQueue/Entry.html#method-i-3C-3C","(item)","<p>This is the only way to set the item.\n"],["<=>","PriorityQueue::Entry","PriorityQueue/Entry.html#method-i-3C-3D-3E","(rhs)","<p>Comparison of priority values.\n"],["[]","HuffmanTree::Branch","HuffmanTree/Branch.html#method-i-5B-5D","(index)","<p>Reference a subtree of the Branch node.\n"],["[]","PriorityQueue","PriorityQueue.html#method-i-5B-5D","(priority)","<p>Return a new Entry in the queue, with only priority set.\n"],["bsd?","OS","OS.html#method-c-bsd-3F","()","<p>Running on BSD Unix?\n"],["check_decoded","HuffmanIO","HuffmanIO.html#method-i-check_decoded","()","<p>Return two Boolean values: Is :decoded is identical to :symbols?\n<p>(1) Use a well tested internal method …\n"],["close","HuffmanIO","HuffmanIO.html#method-i-close","()","<p>Close IO objects, ignoring exceptions.\n"],["cross_entropy","HuffmanCodec","HuffmanCodec.html#method-i-cross_entropy","()","<p>Cross entropy of the source and code distributions.\n<p>The “source distribution” p is the probability …\n"],["decode","HuffmanCodec","HuffmanCodec.html#method-i-decode","(bits_in, symbols_out)","<p>Print decoding of `bits_in.each_char&#39; to IO stream `symbols_out&#39;.\n<p>An ArgumentError occurs if the …\n"],["decoded_matches_symbols","HuffmanIO","HuffmanIO.html#method-i-decoded_matches_symbols","(wait=0)","<p>Are :symbols and :decoded IO objects identical in contents?\n"],["display_in_browser","Object","Object.html#method-i-display_in_browser","(html_source, path=nil)","<p>Write HTML source to a file, and launch browser on that file.\n"],["draw","HuffmanTree::Branch","HuffmanTree/Branch.html#method-i-draw","(bits='')","<p>Generate JavaScript to draw tree rooted at this node.\n"],["draw","HuffmanTree::Leaf","HuffmanTree/Leaf.html#method-i-draw","(bits='')","<p>Generate JavaScript to draw leaf.\n<p>Draw a labeled link to the node. Write the symbol at the end of the …\n"],["draw_link","HuffmanTree::Node","HuffmanTree/Node.html#method-i-draw_link","(bits)","<p>Generate JavaScript to draw link to node.\n"],["encode","HuffmanCodec","HuffmanCodec.html#method-i-encode","(symbols_in, bits_out)","<p>Print encoding of `symbols_in.each_byte&#39; to IO stream `bits_out&#39;.\n<p>An ArgumentError occurs if the …\n"],["host_os","OS","OS.html#method-c-host_os","()","<p>Return the value of &#39;host_os&#39; in the Ruby configuration.\n"],["html","HuffmanCodec","HuffmanCodec.html#method-i-html","()","<p>Return HTML/JavaScript (as string) for drawing the Huffman tree.\n"],["html","HuffmanTree::Node","HuffmanTree/Node.html#method-i-html","()","<p>Return HTML/Javascript (as String) to draw tree (sideways).\n"],["leaf?","HuffmanTree::Node","HuffmanTree/Node.html#method-i-leaf-3F","()","<p>Is this Node an instance of subclass Leaf?\n"],["linux?","OS","OS.html#method-c-linux-3F","()","<p>Running on Linux?\n"],["mac?","OS","OS.html#method-c-mac-3F","()","<p>Running on Mac Os?\n"],["margin","HuffmanTree::Branch","HuffmanTree/Branch.html#method-i-margin","(deepest, depth=0)","<p>Length of the longest symbol in the deepest level of tree.\n"],["margin","HuffmanTree::Leaf","HuffmanTree/Leaf.html#method-i-margin","(deepest, depth=0)","<p>Number of characters in &#39;dump&#39; representation of :symbol.\n"],["new","HuffmanCodec","HuffmanCodec.html#method-c-new","(distribution)","<p>Construct codec from a Hash map of symbols to probabilities.\n<p>Symbol frequencies may be supplied in place …\n"],["new","HuffmanIO","HuffmanIO.html#method-c-new","(argument)","<p>Open IO objects :symbols, :encoded, :decoded according to `argument&#39;.\n<p>If `argument&#39; matches &#39;–string=&lt;string&gt;&#39; …\n"],["new","HuffmanTree::Branch","HuffmanTree/Branch.html#method-c-new","(weighted_tree0, weighted_tree1)","<p>Assign two Node objects (subtrees) to a branch node.\n<p>The weight and width are the sums of the weights …\n"],["new","HuffmanTree::Leaf","HuffmanTree/Leaf.html#method-c-new","(weight, symbol)","<p>Assign a Numeric weight and a symbol (String) to a leaf.\n<p>The width and height are 1, and the offset is …\n"],["new","HuffmanTree::Node","HuffmanTree/Node.html#method-c-new","(weight, width, height, offset)","<p>Called only by subclass initializers.\n"],["new","PriorityQueue","PriorityQueue.html#method-c-new","()","<p>Make an empty queue.\n"],["new","PriorityQueue::Entry","PriorityQueue/Entry.html#method-c-new","(priority)","<p>The priority must be set first.\n"],["new","Source","Source.html#method-c-new","(symbols)","<p>Analyze sequence generated by `symbols.each_byte&#39;.\n"],["open","Launchy","Launchy.html#method-c-open","(link)","<p>Open link in the default web browswer.\n"],["os_category","OS","OS.html#method-c-os_category","()","<p>Categorize the host OS as Windows, Mac, Linux, BSD, or unknown.\n"],["posix?","OS","OS.html#method-c-posix-3F","()","<p>Running on a POSIX system?\n"],["report","HuffmanIO","HuffmanIO.html#method-i-report","(n_symbols, entropy, cross_entropy)","<p>TO DO: document EXTENSIVELY\n"],["run","Object","Object.html#method-i-run","(argument)","<p>TO DO: document\n"],["run_as_script","Object","Object.html#method-i-run_as_script","()","<p>Process the command line, and pass argument to `run&#39;.\n"],["shift","PriorityQueue","PriorityQueue.html#method-i-shift","()","<p>Return highest-priority item, removing its entry from queue.\n"],["size","PriorityQueue","PriorityQueue.html#method-i-size","()","<p>The number of entries in the queue.\n"],["to_s","HuffmanCodec","HuffmanCodec.html#method-i-to_s","(tree=@tree, bits='')","<p>Return String representation of Huffman tree\n"],["warn","Object","Object.html#method-i-warn","(message)","<p>Write script name along with `message&#39; to standard error.\n"],["windows?","OS","OS.html#method-c-windows-3F","()","<p>Running on Windows?\n"]]}}