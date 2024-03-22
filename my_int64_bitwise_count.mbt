pub fn clz(self : MyInt64) -> Int {
  if self.hi != 0 {
    self.hi.clz()
  } else {
    32 + self.lo.clz()
  }
}

pub fn ctz(self : MyInt64) -> Int {
  if self.lo == 0 {
    32 + self.lo.ctz()
  } else {
    self.hi.ctz()
  }
}

pub fn popcnt(self : MyInt64) -> Int {
  self.hi.popcnt() + self.lo.popcnt()
}
