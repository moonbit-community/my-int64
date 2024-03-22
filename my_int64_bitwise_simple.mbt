pub fn lnot(self : MyInt64) -> MyInt64 {
  { hi: self.hi.lnot(), lo: self.lo.lnot() }
}

pub fn land(self : MyInt64, other : MyInt64) -> MyInt64 {
  { hi: self.hi.land(other.hi), lo: self.lo.land(other.lo) }
}

pub fn lor(self : MyInt64, other : MyInt64) -> MyInt64 {
  { hi: self.hi.lor(other.hi), lo: self.lo.lor(other.lo) }
}

pub fn lxor(self : MyInt64, other : MyInt64) -> MyInt64 {
  { hi: self.hi.lxor(other.hi), lo: self.lo.lxor(other.lo) }
}
