require 'json'

class Response
  def call(input)
    @bits = input.first.to_i(16).to_s(2).split('').map(&:to_i)
    packet, next_bits = take_packet(@bits)
    # haha this sucks but i don't want to recursively unpack this data
    packet.to_json.scan(/"version":(\d+)/).flatten.map(&:to_i).inject(:+)
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
end
