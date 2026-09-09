import Lax489179.IntegerEncoding
import Lax489179.ThreeSUM

/-!
---
title: Integer encodings and distinct 3-SUM entries
type: lemma
---
The signed-integer and optional-integer decoders are left inverses of
their encoders. In particular, both encodings are injective. A 3-SUM
yes-instance has at least three entries.
-/

namespace Lax489179.EncodingProperties

open IntegerEncoding

axiom decode_encode_int (z : ℤ) : decodeInt (encodeInt z) = z

axiom decode_encode_option (z : Option ℤ) : decodeOption (encodeOption z) = z

axiom encode_int_injective : Function.Injective encodeInt

axiom encode_option_injective : Function.Injective encodeOption

axiom three_entries (input : List ℤ) (h : ThreeSUM.HasZeroSum input) : 3 ≤ input.length

end Lax489179.EncodingProperties
