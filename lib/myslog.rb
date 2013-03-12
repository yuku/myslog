#
# MySlog
#
# Copyright (C) 2012 Yuku TAKAHASHI
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
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
      while line != nil && !line.start_with?("#")
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

        elems = record.split(" ")
        response[:user]      = elems[2].strip
        if elems[5] == nil
          response[:host]    = nil
          response[:host_ip] = elems[4].strip[1...-1]
        else
          response[:host]    = elems[4].strip
          response[:host_ip] = elems[5].strip[1...-1]
        end
      elsif record.start_with? "#"

        # split with two space
        elems = record[2..-1].strip().split " "
        if elems.size == 3 && elems[0] == "Time:"
          response[:date] = Time.parse(elems[1]+" "+elems[2])
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
        response[:sql] = record
      end
    end

    response
  end
end
