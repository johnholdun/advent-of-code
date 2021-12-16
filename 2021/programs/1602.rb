require 'json'

class Response
  def call(input)
    @bits = input.first.to_i(16).to_s(2).split('').map(&:to_i)
    packet, _ = take_packet(@bits)
    resolve_packets([packet]).first
  end

  private

  def take_packet(next_bits)
    return [nil, []] if next_bits.all?(&:zero?)

    version = bits_to_i(next_bits.shift(3))
    type_id = bits_to_i(next_bits.shift(3))
    data =
      case type_id
      when 4
        groups = []
        loop do
          group = next_bits.shift(5)
          groups += group[1, 4]
          break if group[0].zero?
        end
        bits_to_i(groups)
      else
        packets = []
        length_type_id = bits_to_i(next_bits.shift(1))
        case length_type_id
        when 0
          packet_bits = next_bits.shift(bits_to_i(next_bits.shift(15)))
          while packet_bits.size > 0 && !packet_bits.all?(&:zero?)
            packet, remaining_bits = take_packet(packet_bits)
            packets.push(packet)
            packet_bits = remaining_bits
          end
        else
          sub_packets_length = bits_to_i(next_bits.shift(11))
          while packets.size < sub_packets_length
            packet, remaining_bits = take_packet(next_bits)
            packets.push(packet)
            next_bits = remaining_bits
          end
        end
        packets
      end

    packet = { version: version, type_id: type_id, data: data }
    [packet, next_bits]
  end

  def bits_to_i(these_bits)
    these_bits.join.to_i(2)
  end

  def resolve_packets(packets)
    packets.map do |packet|
      case packet[:type_id]
      when 0 # sum
        resolve_packets(packet[:data]).inject(:+)
      when 1 # product
        resolve_packets(packet[:data]).inject(:*)
      when 2 # minimum
        resolve_packets(packet[:data]).sort.first
      when 3 # maximum
        resolve_packets(packet[:data]).sort.last
      when 4 # literal
        packet[:data]
      when 5 # greater-than
        values = resolve_packets(packet[:data])
        values.first > values.last ? 1 : 0
      when 6 # less-than
        values = resolve_packets(packet[:data])
        values.first < values.last ? 1 : 0
      when 7 # equal-to
        values = resolve_packets(packet[:data])
        values.first == values.last ? 1 : 0
      end
    end
  end
end
