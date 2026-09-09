import Mathlib.Data.Int.Basic

/-!
---
title: Encoding signed integers and missing distances
type: definition
---
Signed integers are stored in natural-number words using
$0\mapsto0$, $-1\mapsto1$, $1\mapsto2$, $-2\mapsto3$, and so on.
For an optional integer, zero denotes absence and an integer is encoded
by its signed code plus one. This separates a missing edge or infinite
distance from every finite weight, including zero and negative weights.
-/

namespace Lax489179.IntegerEncoding

def encodeInt : ℤ → ℕ
  | .ofNat n => 2 * n
  | .negSucc n => 2 * n + 1

def decodeInt (n : ℕ) : ℤ :=
  if n % 2 = 0 then .ofNat (n / 2) else .negSucc (n / 2)

def encodeOption : Option ℤ → ℕ
  | none => 0
  | some z => encodeInt z + 1

def decodeOption : ℕ → Option ℤ
  | 0 => none
  | n + 1 => some (decodeInt n)

end Lax489179.IntegerEncoding
