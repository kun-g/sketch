def readFile(filename)
  puts "============ Using code block ================"
  File.open(filename, 'r') {|f| puts(f.read())}

  puts "=========== Not using code block ============="
  f = File.open(filename, 'r')
  puts(f.read())
end

#readFile("./guessNumber.rb")

def printArray()
  array = []
  (0..15).each {|i| array[i] = i}
  count = 1
  array.each do |a| 
    print a, " "
    print "\n" if count%4 == 0 
    count = count + 1
  end

  puts(" ")
  array.each_slice(4) {|a| p a}
end

#printArray()

class MyTree
  attr_accessor :children, :node_name

  def initialize(tree={})
    @children = []
    tree.each do |k, v|
      v.each {|k1, v1| @children.insert(-1, MyTree.new(Hash[k1, v1]))}
      @node_name = k
    end
  end

  def visit_all(&block)
    visit &block
    children.each {|c| c.visit_all &block}
  end

  def visit(&block)
    block.call self
  end
end

def makeATree()
  ruby_tree = MyTree.new({'grandpa' => 
                           {'dad' => {'child 1' => {}, 'child 2' => {} }, 
                           'uncle' => {'child 3' => {}, 'child 4' => {} } } })

  ruby_tree.visit {|node| puts node.node_name}
  puts(" ")
  ruby_tree.visit_all {|node| puts node.node_name}
end

#makeATree()

def grep(pattern, path)
  File.open(path, 'r') do |f| 
    lineNo = 1
    f.read.each_line do |str|
      print "line #{lineNo}:\n#{str}" if str.match(pattern)
      lineNo = lineNo + 1
    end
  end
end

grep("tree", "./day2.rb")
