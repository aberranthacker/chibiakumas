table = []
256.times do |i|
  table << i.to_s(2)
            .rjust(8, '0')
            .chars
            .reverse
            .join
end

(0..255).step(8) do |i|
  table[i, 8]
end
