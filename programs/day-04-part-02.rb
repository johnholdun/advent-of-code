require 'date'
require './day'

class Day4Part2 < Day
  DAY = 4
  PART = 2

  def call
    guards_logs =
      parse_logs(input)
        .values
        .group_by { |l| l[:guard] }

    counts =
      guards_logs.map do |guard_id, logs|
        minutes = Hash.new(0)

        logs.flat_map { |d| d[:sleeps] }.each do |start_minute, duration|
          duration.times do |dm|
            minutes[start_minute + dm] += 1
          end
        end

        minute, times = minutes.to_a.max_by(&:last)

        [guard_id, minute, times.to_i]
      end

    guard = counts.max_by { |_, _, times| times }
    guard[0] * guard[1]
  end

  private

  def parse_logs(input)
    input.sort.each_with_object({}) do |event, log|
      match = event.scan(/^\[1518-(..)-(..) (..):(..)\] (.+)$/)[0]

      month = match[0].to_i
      date = match[1].to_i
      hour = match[2].to_i
      minute = match[3].to_i
      message = match[4]
      guard_id = nil

      current_date = Date.new(1518, month, date).yday

      # You're early!
      current_date += 1 if hour == 23

      current_time = hour * 60 + minute
      current_time = 2400 - current_time if hour == 23

      case message
      when /Guard #(\d+) begins shift/
        guard_id = Regexp.last_match[1].to_i
        log[current_date] = { guard: guard_id, sleeps: [] }
      when 'falls asleep'
        log[current_date][:sleeps].push([current_time])
      when 'wakes up'
        start_time = log[current_date][:sleeps].last.first
        log[current_date][:sleeps].last.push(current_time - start_time)
      else
        raise "wtf? #{event}"
      end
    end
  end
end
