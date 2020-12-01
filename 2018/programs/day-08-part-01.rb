require './day'

class Day8Part1 < Day
  DAY = 8
  PART = 1

  Node = Struct.new(:id, :children_size, :metadata_size, :children, :metadata)

  def call
    values = input.first.split(' ').map(&:to_i)
    @nodes = [new_node(0)]
    @indices = [0]

    begin
      evaluate(values.shift)
    end while values.size > 0

    nodes.flat_map(&:metadata).compact.inject(:+)
  end

  private

  attr_reader :nodes, :indices

  def new_node(id)
    Node.new(id, nil, nil, [], [])
  end

  def evaluate(value)
    node = nodes[indices.last]

    if node.children_size.nil?
      node.children_size = value
    elsif node.metadata_size.nil?
      node.metadata_size = value
    elsif node.children.size < node.children_size
      new_node = new_node(nodes.size)
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
