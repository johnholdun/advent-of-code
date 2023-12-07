class Response
  def call(lines)
    time, distance = lines.map { |l| l.gsub(/[^0-9]/, '').to_i }

    time.times.count do |duration|
      (time - duration) * duration > distance
    end
  end
end
