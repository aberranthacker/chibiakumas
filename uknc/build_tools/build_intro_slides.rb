`mkdir -p build/ep1-intro`

sprites = File.binread('resources/ep1-intro-slides-1.raw')

0.upto(7).each do |i|
  sprite = sprites[i * 3072, 3072]
  file_name = "build/ep1-intro/ep1-intro-slide#{(i + 1).to_s.rjust(2, '0')}"
  File.binwrite("#{file_name}.raw", sprite)
  `build_tools/lzsa -f 1 -r #{file_name}.raw #{file_name}.raw.lzsa1`
end

sprites = File.binread('resources/ep1-intro-slides-2.raw')

0.upto(6).each do |i|
  sprite = sprites[i * 3072, 3072]
  file_name = "build/ep1-intro/ep1-intro-slide#{(i + 9).to_s.rjust(2, '0')}"
  File.binwrite("#{file_name}.raw", sprite)
  `build_tools/lzsa -f 1 -r #{file_name}.raw #{file_name}.raw.lzsa1`
end
