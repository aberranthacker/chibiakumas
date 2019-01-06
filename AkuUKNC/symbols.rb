require 'pry'

REGEXS = [
  /^\s*(?<symbol>[a-z]\w+)(:|\s+)\s*(equ|defb|defw|db|dw|ds)\s+/i,
  /^\s*(?<symbol>[a-z]\w+):\s*/i
]

Dir.chdir('../Aku')

def extract_symbols(file_name)
  text = read_file(file_name)

  [].tap do |symbols|
    text.each_line.with_index(1) do |line, idx|
      next if /^\s*;/ === line

      if (match = line.match(/^\s*read\s*"(?<filename>[^"]+)/i))
        symbols.concat(extract_symbols(match[:filename]))
        next
      end

      REGEXS.each do |regex|
        match = regex.match(line)
        symbols << match[:symbol] if match
      end
    end
  end
end

def read_file(file_name)
  return '' if /(srczx|srcent|srcmsx)\\/i === file_name
  file_name.gsub!('\\', '/')
  File.read(file_name)
rescue Errno::ENOENT
  abort "File not found."
end

symbols = extract_symbols('Build.asm').uniq.sort
puts symbols
puts "#{symbols.count} in total"
