# BitSizeExt
#   Bit/Byte の Bit サイズ変換。
#   SI接頭辞, 2進接頭辞に対応しています。
#
# usage
# ```
# using BitSizeExt
#
# 1.KiB # => 8192
# ```
module BitSizeExt
  PREFIXES = %w(k M G T P E Z Y)

  refine Numeric do
    # TODO: 小数に対応する
    PREFIXES.each.with_index(1) do |prefix, i|
      define_method(prefix        +   "B") { self * 1000 ** i * 8 } # Byte (SI接頭辞)
      define_method(prefix.upcase +  "iB") { self * 1024 ** i * 8 } # Byte (2進接頭辞) ※ Kが大文字になる
      define_method(prefix        +   'b') { self * 1000 ** i     } # bit
      define_method(prefix        + 'bps') { self * 1000 ** i     } # bit per sec
    end

    def to_byte
      self / 8
    end

    def to_byte_s
      byte = to_byte
      byte < 1024 and return byte + "B"
      cnt = 0
      cnt += 1 while (byte /= 1024.0) >= 1.0
      (byte * 1024).round(2).to_s + PREFIXES[cnt - 1] + 'iB'
    end
  end
end
