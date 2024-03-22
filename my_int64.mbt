struct MyInt64 {
  hi : Int
  lo : Int
}

pub fn MyInt64::from_bits(hi : Int, lo : Int) -> MyInt64 {
  { hi, lo }
}
