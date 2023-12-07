class Response
  def call(lines)
    times, distances = lines.map { |l| l.split(/ +/)[1..-1].map(&:to_i) }

    times
      .zip(distances)
      .map do |time, distance|
        time.times.count do |duration|
          (time - duration) * duration > distance
        end
      end
      .inject(:*)
  end
end
