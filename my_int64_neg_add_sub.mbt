pub fn op_neg(self : MyInt64) -> MyInt64 {
  if self.lo == 0 {
    { hi: self.hi.lnot() + 1, lo: 0 }
  } else {
    { hi: self.hi.lnot(), lo: self.lo.lnot() + 1 }
  }
}

fn add_hi_lo(self : MyInt64, bhi : Int, blo : Int) -> MyInt64 {
  let { hi: ahi, lo: alo } = self
  let lo = alo + blo
  let s = lo.asr(31)
  let as_ = alo.asr(31)
  let bs = blo.asr(31)
  let c = as_.land(bs).lor(s.lnot().land(as_.lxor(bs))).land(1)
  let hi = ahi + bhi + c
  { hi, lo }
}

fn op_add(self : MyInt64, other : MyInt64) -> MyInt64 {
  add_hi_lo(self, other.hi, other.lo)
}

fn op_sub(self : MyInt64, other : MyInt64) -> MyInt64 {
  if other.lo == 0 {
    { hi: self.hi - other.hi, lo: self.lo }
  } else {
    add_hi_lo(self, other.hi.lnot(), other.lo.lnot() + 1)
  }
}
