require "time"

class MySlog
  def parse(text)
    divide(text.split("\n")).map {|r| parse_record(r) }
  end

  def divide(lines)
    records = []

    line = lines.shift

    while line
      record = []

      while line != nil && line.start_with?("#")
        record << line.strip
        line = lines.shift
      end

      sql = []
      while line != nil && !line.start_with?("# Time") && !line.start_with?("# User@Host") && !line.start_with?("# Query_time")
        sql << line.strip
        line = lines.shift
      end
      record << sql.join(" ")

      records << record
    end

    records
  end

  def parse_record(records)
    response = {}

    while (record = records.shift) != nil

      if record.start_with? "# User@Host:"

        elems = record.split(/ /, 7)
        response[:user]    = elems[2].strip
        response[:host]    = elems[4].empty? ? nil : elems[4].strip
        response[:host_ip] = elems[5].strip[1...-1]
      elsif record.start_with? "#"

        elems = record[2..-1].strip().split " "
        if elems.size == 3 && elems[0] == "Time:"
          response[:date] = Time.parse(elems[1]+" "+elems[2])
        elsif elems.size == 2 && elems[0] == "Time:"
          response[:date] = Time.parse(elems[1][0..9]+" "+elems[1][11..18])
        else
          elems.each_with_index do |elem,i|
            if elem.include?(":") && !elems[i+1].include?(":")
              value = elems[i+1]
              case value
              when /^\d+$/
                value = value.to_i
              when /^\d+\.\d+(?:e[-+]\d+)?$/
                value = value.to_f
              end
              response[elem[0...-1].downcase.to_sym] = value
            end
          end
        end
      else
        if database = record.match(/^use ([^;]+)/)
          response[:db] = database[1]
        end

        if timestamp = record.match(/SET timestamp=(\d+)/)
          response[:date] = Time.at(timestamp[1].to_i)
        end

        response[:sql] = record
      end
    end

    response
  end
end
