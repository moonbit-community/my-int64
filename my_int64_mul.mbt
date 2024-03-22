fn op_mul(self : MyInt64, other : MyInt64) -> MyInt64 {
  let { hi: ahi, lo: alo } = self
  let { hi: bhi, lo: blo } = other
  let a48 = ahi.lsr(16)
  let a32 = ahi.land(0xffff)
  let a16 = alo.lsr(16)
  let a00 = alo.land(0xffff)
  let b48 = bhi.lsr(16)
  let b32 = bhi.land(0xffff)
  let b16 = blo.lsr(16)
  let b00 = blo.land(0xffff)
  let c00 = a00 * b00
  let c16 = c00.lsr(16)
  let c00 = c00.land(0xffff)
  let c16 = c16 + a16 * b00
  let c32 = c16.lsr(16)
  let c16 = c16.land(0xffff)
  let c16 = c16 + a00 * b16
  let c32 = c32 + c16.lsr(16)
  let c16 = c16.land(0xffff)
  let c32 = c32 + a32 * b00
  let c48 = c32.lsr(16)
  let c32 = c32.land(0xffff)
  let c32 = c32 + a16 * b16
  let c48 = c48 + c32.lsr(16)
  let c32 = c32.land(0xffff)
  let c32 = c32 + a00 * b32
  let c48 = c48 + c32.lsr(16)
  let c32 = c32.land(0xffff)
  let c48 = c48 + a48 * b00 + a32 * b16 + a16 * b32 + a00 * b48
  let c48 = c48.land(0xffff)
  { hi: c48.lsl(16).lor(c32), lo: c16.lsl(16).lor(c00) }
}
