#!/usr/bin/env ruby

require_relative 'diff'

class Diff
  def to_diff
    out = ''
    offset = 0
    @diffs.each do |b|
      first = b[0][1]
      length = b.length
      action = b[0][0]
      addcount = 0
      remcount = 0
      b.each do |l|
        if l[0] == "+"
          addcount += 1
        elsif l[0] == "-"
          remcount += 1
        end
      end
      if addcount == 0
        out << "#{diffrange(first+1, first+remcount)}d#{first+offset}\n"
      elsif remcount == 0
        out << "#{first-offset}a#{diffrange(first+1, first+addcount)}\n"
      else
        out << "#{diffrange(first+1, first+remcount)}c#{diffrange(first+offset+1, first+offset+addcount)}\n"
      end
      lastdel = (b[0][0] == "-")
      b.each do |l|
        if l[0] == "-"
          offset -= 1
          out << "< "
        elsif l[0] == "+"
          offset += 1
          if lastdel
            lastdel = false
            out << "---\n"
          end
          out << "> "
        end
        out << l[2]
      end
    end
    out
  end

  private
  def diffrange(a, b)
    if (a == b)
      "#{a}"
    else
      "#{a},#{b}"
    end
  end
end

if $0 == __FILE__

  file1 = ARGV.shift
  file2 = ARGV.shift

  ary1 = File.read file1
  ary2 = File.read file2

  diff = Diff.new(ary1, ary2)
  puts diff.to_diff

end
