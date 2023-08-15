def generate(bits)
  (2**bits).times.to_a.map do |i|
    i.to_s(2).rjust(bits, '0').chars.reverse.join.to_i(2)
  end
end

REVERSE_TABLE_4BIT = generate(4).freeze

REVERSE_TABLE_8BIT = generate(8).freeze
