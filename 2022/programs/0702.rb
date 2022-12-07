class Response
  def call(input)
    files = {}
    pwd = []

    input.each do |line|
      case line
      when /^\$ cd (.+)/
        arg = Regexp.last_match[1]

        case arg
        when  /^\//
          pwd =
            if arg == '/'
              []
            else
              arg.sub(/^\//, '').split('/')
            end
        when '..'
          pwd.pop
        else
          pwd += arg.split('/')
        end

      when /^(\d+) (.+)/
        size, name = Regexp.last_match.to_a.slice(1, 2)
        files["/#{(pwd + [name]).join('/')}"] = size.to_i

      when /^dir [a-z]+$/
        # ignore this command

      when /^\$ ls/
        # ignore this command

      else
        raise "unexpected: #{line}"

      end
    end

    values = {}

    files.each do |file, value|
      path_parts = file.split('/')
      (path_parts.size - 1).times do |index|
        path = path_parts.first(index + 1).join('/')
        path = '/' if path == ''
        values[path] ||= 0
        values[path] += value
      end
    end

    total = 70000000
    required = 30000000
    used = values['/']
    missing = required - (total - used)

    values.values.select { |v| v >= missing }.min
  end
end
