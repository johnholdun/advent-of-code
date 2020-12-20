class Response
  def call(input)
    adapters = [0] + input.map(&:to_i).sort

    links =
      adapters.each_with_object({}) do |adapter, hash|
        hash[adapter] = adapters.select { |a| (1..3).include?(a - adapter) }
      end

    distance =
      adapters.reverse.each_with_object({}) do |tail, distance|
        distance[tail] =
          links[tail].sum { |a| a == adapters.max ? 1 : distance[a] }
      end

    distance[0]
  end
end
