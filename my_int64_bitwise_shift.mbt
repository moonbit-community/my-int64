pub fn lsl(self : MyInt64, shift : Int) -> MyInt64 {
  let shift = shift.land(63)
  if shift == 0 {
    self
  } else if shift < 32 {
    {
      hi: self.hi.lsl(shift).lor(self.lo.lsr(32 - shift)),
      lo: self.lo.lsl(shift),
    }
  } else {
    { hi: self.lo.lsl(shift - 32), lo: 0 }
  }
}

pub fn lsr(self : MyInt64, shift : Int) -> MyInt64 {
  let shift = shift.land(63)
  if shift == 0 {
    self
  } else if shift < 32 {
    {
      hi: self.hi.lsr(shift),
      lo: self.lo.lsr(shift).lor(self.hi.lsl(32 - shift)),
    }
  } else {
    { hi: 0, lo: self.hi.lsr(shift - 32) }
  }
}

pub fn asr(self : MyInt64, shift : Int) -> MyInt64 {
  let shift = shift.land(63)
  if shift == 0 {
    self
  } else if shift < 32 {
    {
      hi: self.hi.asr(shift),
      lo: self.lo.lsr(shift).lor(self.hi.lsl(32 - shift)),
    }
  } else {
    { hi: self.hi.asr(31), lo: self.hi.asr(shift - 32) }
  }
}
