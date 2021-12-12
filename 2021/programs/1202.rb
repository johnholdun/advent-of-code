require 'set'

class Node
  attr_reader :id
  attr_accessor :neighbors

  def initialize(id)
    @id = id
    @neighbors = Set.new
  end

  def start?
    id == 'start'
  end

  def end?
    id == 'end'
  end

  def large?
    id.upcase == id
  end

  def small?
    !large?
  end
end

class Network
  def initialize(links)
    @links = links
    nodes
  end

  def paths
    return @paths if defined?(@paths)

    @paths = [[nodes_by_id['start']]]
    last_paths_count = 1

    loop do
      edited = 0

      @paths.each do |path|
        node = path.last
        next if node.end?
        node
          .neighbors
          .select do |node|
            node.large? ||
            (
              !node.start? &&
              (
                !path.include?(node) ||
                (
                  path.count(node) == 1 &&
                  path.select(&:small?).all? { |n| path.count(n) == 1 }
                )
              )
            )
          end
          .each_with_index do |neighbor, index|
            if index.zero?
              @paths.push(path + [neighbor])
            else
              @paths.push(path + [neighbor])
            end
            edited += 1
          end
      end

      break if edited.zero?
      @paths = @paths.uniq
      break if last_paths_count == @paths.count
      last_paths_count = @paths.count
    end

    @paths
  end

  def nodes
    return @nodes if defined?(@nodes)
    @nodes = links.flatten.uniq.map { |r| Node.new(r) }
    @nodes_by_id = @nodes.each_with_object({}) { |n, h| h[n.id] = n }
    links.each do |a, b|
      nodes_by_id[a].neighbors.add(nodes_by_id[b])
      nodes_by_id[b].neighbors.add(nodes_by_id[a])
    end
    @nodes
  end

  private

  attr_reader :links, :nodes_by_id
end

class Response
  def call(input)
    Network
      .new(input.map { |i| i.split('-')})
      .paths
      .count { |p| p.last.end? }
  end
end
