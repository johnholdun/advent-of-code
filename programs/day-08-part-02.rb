require './day'

class Day8Part2 < Day
  DAY = 8
  PART = 2

  Node = Struct.new(:id, :children_size, :metadata_size, :children, :metadata, :total)

  def call
    parse_input
    table = nodes.each_with_object({}) { |n, h| h[n.id] = n }
    nodes.reverse_each do |node|
      node.total =
        if node.children_size.zero?
          node.metadata.inject(:+)
        else
          node
            .metadata
            .map { |i|
              child = table[node.children[i - 1]]
              child ? child.total : 0
            }
            .inject(:+)
        end
    end
    nodes[0].total
  end

  private

  attr_reader :nodes, :indices

  def parse_input
    values = input.first.split(' ').map(&:to_i)
    @nodes = [generate_node(1)]
    @indices = [0]

    begin
      evaluate(values.shift)
    end while values.size > 0
  end

  def generate_node(id)
    Node.new(id, nil, nil, [], [], nil)
  end

  def evaluate(value)
    node = nodes[indices.last]

    if node.children_size.nil?
      node.children_size = value
    elsif node.metadata_size.nil?
      node.metadata_size = value
    elsif node.children.size < node.children_size
      new_node = generate_node(nodes.size + 1)
      nodes.push(new_node)
      node.children.push(new_node.id)
      indices.push(nodes.size - 1)
      evaluate(value)
    elsif node.metadata.size < node.metadata_size
      node.metadata ||= []
      node.metadata.push(value)
    else
      indices.pop
      evaluate(value)
    end
  end
end
