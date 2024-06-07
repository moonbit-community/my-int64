// for test only
fn MyInt64::from_int64(x : Int64) -> MyInt64 {
  { hi: x.lsr(32).to_int(), lo: x.to_int() }
}

// for test only
fn MyInt64::to_int64(self : MyInt64) -> Int64 {
  self.hi.to_int64().lsl(32).lor(Int64::extend_i32_u(self.lo))
}

test "from_int64 to_int64" {
  @assertion.assert_eq(MyInt64::from_int64(0L).to_int64(), 0L)?
  @assertion.assert_eq(MyInt64::from_int64(1L).to_int64(), 1L)?
  @assertion.assert_eq(MyInt64::from_int64(-1L).to_int64(), -1L)?
  @assertion.assert_eq(MyInt64::from_int64(0x7fffffffL).to_int64(), 0x7fffffffL)?
  @assertion.assert_eq(
    MyInt64::from_int64(-0x80000000L).to_int64(),
    -0x80000000L,
  )?
  @assertion.assert_eq(MyInt64::from_int64(0x80000000L).to_int64(), 0x80000000L)?
  @assertion.assert_eq(
    MyInt64::from_int64(-0x80000001L).to_int64(),
    -0x80000001L,
  )?
  @assertion.assert_eq(
    MyInt64::from_int64(0x7fffffff_ffffffffL).to_int64(),
    0x7fffffff_ffffffffL,
  )?
  @assertion.assert_eq(
    MyInt64::from_int64(-0x80000000_00000000L).to_int64(),
    -0x80000000_00000000L,
  )?
  @assertion.assert_eq(
    MyInt64::from_int64(0x80000000_00000000L).to_int64(),
    0x80000000_00000000L,
  )?
  @assertion.assert_eq(
    MyInt64::from_int64(-0x80000000_00000001L).to_int64(),
    -0x80000000_00000001L,
  )?
}

fn int64_to_string(x : Int64, alphabet : String) -> String {
  let base = alphabet.length().to_int64()
  let res = Buffer::make(0)
  let mut is_empty = true
  let mut x = x
  while x != 0L {
    let r = x % base
    res.write_char(alphabet[r.to_int()])
    is_empty = false
    x = x / base
  }
  if is_empty {
    "0"
  } else {
    res.to_string()
  }
}

fn int64_bin_string(x : Int64) -> String {
  "0b" + int64_to_string(x, "01")
}

fn test_unary(
  test_op : (MyInt64) -> MyInt64,
  ref_op : (Int64) -> Int64,
  ~op : String,
  ~loc : SourceLoc = _
) -> Result[Unit, String] {
  let cases = [
    0L, -1L, 1L, 0x7fffffffL, -0x80000000L, 0x80000000L, -0x80000001L,
  ]
  for i = 0; i < cases.length(); i = i + 1 {
    let x = cases[i]
    match
      @assertion.assert_eq(
        test_op(MyInt64::from_int64(x)).to_int64(),
        ref_op(x),
      ) {
      Ok(_) => ()
      Err(_) => {
        let rhs = test_op(MyInt64::from_int64(x)).to_int64()
        let rhs2 = ref_op(x)
        let lhs = {
          let x = int64_bin_string(x)
          "\(op) \(x)"
        }
        return Err(
          {
            let rhs = int64_bin_string(rhs)
            let rhs2 = int64_bin_string(rhs2)
            "\(lhs)\n| ACTUAL: \(rhs)\n| EXPECTED: \(rhs2)\n| LOC: \(loc)"
          },
        )
      }
    }
  } else {
    Ok(())
  }
}

fn test_binary(
  test_op : (MyInt64, MyInt64) -> MyInt64,
  ref_op : (Int64, Int64) -> Int64,
  ~op : String,
  ~loc : SourceLoc = _
) -> Result[Unit, String] {
  let xs = [0L, -1L, 1L, 0x7fffffffL, -0x80000000L, 0x80000000L, -0x80000001L]
  for i = 0; i < xs.length(); i = i + 1 {
    let x = xs[i]
    for j = 0; j < xs.length(); j = j + 1 {
      let y = xs[j]
      match
        @assertion.assert_eq(
          test_op(MyInt64::from_int64(x), MyInt64::from_int64(y)).to_int64(),
          ref_op(x, y),
          ~loc,
        ) {
        Ok(_) => ()
        Err(_) => {
          let rhs = test_op(MyInt64::from_int64(x), MyInt64::from_int64(y)).to_int64()
          let rhs2 = ref_op(x, y)
          let lhs = {
            let x = int64_bin_string(x)
            let y = int64_bin_string(y)
            "\(x) \(op) \(y)"
          }
          return Err(
            {
              let rhs = int64_bin_string(rhs)
              let rhs2 = int64_bin_string(rhs2)
              "\(lhs)\n| ACTUAL: \(rhs)\n| EXPECTED: \(rhs2)\n| LOC: \(loc)"
            },
          )
        }
      }
    }
  } else {
    Ok(())
  }
}

fn test_bitwise_shift(
  test_op : (MyInt64, Int) -> MyInt64,
  ref_op : (Int64, Int) -> Int64,
  ~op : String,
  ~loc : SourceLoc = _
) -> Result[Unit, String] {
  let xs = [
    0L, -1L, 1L, 0x7fffffffL, -0x80000000L, 0x80000000L, -0x80000001L, 0x7fffffff_ffffffffL,
    -0x80000000_00000000L, 0x80000000_00000000L, -0x80000000_00000001L,
  ]
  let shifts = [0, 1, 31, 32, 33, 63, 64, 65]
  for i = 0; i < xs.length(); i = i + 1 {
    let x = xs[i]
    for j = 0; j < shifts.length(); j = j + 1 {
      let y = shifts[j]
      match
        @assertion.assert_eq(
          test_op(MyInt64::from_int64(x), y).to_int64(),
          ref_op(x, y),
          ~loc,
        ) {
        Ok(_) => ()
        Err(_) => {
          let rhs = test_op(MyInt64::from_int64(x), y).to_int64()
          let rhs2 = ref_op(x, y)
          let lhs = {
            let x = int64_bin_string(x)
            "\(x) \(op) \(y)"
          }
          return Err(
            {
              let rhs = int64_bin_string(rhs)
              let rhs2 = int64_bin_string(rhs2)
              "\(lhs)\n| ACTUAL: \(rhs)\n| EXPECTED: \(rhs2)\n| LOC: \(loc)"
            },
          )
        }
      }
    }
  } else {
    Ok(())
  }
}

fn test_bitwise_count(
  test_op : (MyInt64) -> Int,
  ref_op : (Int64) -> Int,
  ~op : String,
  ~loc : SourceLoc = _
) -> Result[Unit, String] {
  let cases = [
    0L, -1L, 1L, 0x7fffffffL, -0x80000000L, 0x80000000L, -0x80000001L, 0x7fffffff_ffffffffL,
    -0x80000000_00000000L, 0x80000000_00000000L, -0x80000000_00000001L,
  ]
  for i = 0; i < cases.length(); i = i + 1 {
    let x = cases[i]
    match
      @assertion.assert_eq(test_op(MyInt64::from_int64(x)), ref_op(x), ~loc) {
      Ok(_) => ()
      Err(_) => {
        let rhs = test_op(MyInt64::from_int64(x))
        let rhs2 = ref_op(x)
        let lhs = "\(op) \(x)"
        return Err(
          "\(lhs)\n| ACTUAL: \(rhs)\n| EXPECTED: \(rhs2)\n| LOC: \(loc)",
        )
      }
    }
  } else {
    Ok(())
  }
}

test "lnot" {
  test_unary(MyInt64::lnot, Int64::lnot, ~op="~")?
}

test "land" {
  test_binary(MyInt64::land, Int64::land, ~op="&")?
}

test "lor" {
  test_binary(MyInt64::lor, Int64::lor, ~op="|")?
}

test "lxor" {
  test_binary(MyInt64::lxor, Int64::lxor, ~op="^")?
}

test "lsl" {
  test_bitwise_shift(MyInt64::lsl, Int64::lsl, ~op="<<")?
}

test "lsr" {
  test_bitwise_shift(MyInt64::lsr, Int64::lsr, ~op=">>")?
}

test "asr" {
  test_bitwise_shift(MyInt64::asr, Int64::asr, ~op=">>>")?
}

test "clz" {
  test_bitwise_count(MyInt64::clz, Int64::clz, ~op="clz")?
}

test "ctz" {
  test_bitwise_count(MyInt64::ctz, Int64::ctz, ~op="ctz")?
}

test "popcnt" {
  test_bitwise_count(MyInt64::popcnt, Int64::popcnt, ~op="popcnt")?
}

test "op_neg" {
  test_unary(MyInt64::op_neg, Int64::op_neg, ~op="-")?
}

test "op_add" {
  test_binary(MyInt64::op_add, Int64::op_add, ~op="+")?
}

test "op_sub" {
  test_binary(MyInt64::op_sub, Int64::op_sub, ~op="-")?
}

test "op_mul" {
  test_binary(MyInt64::op_mul, Int64::op_mul, ~op="*")?
}
