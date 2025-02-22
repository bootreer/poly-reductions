theory IMP_Minus_Base
  imports Main
begin

datatype bit = Zero | One

type_synonym vname = string

type_synonym state = "vname \<rightharpoonup> bit"

fun nat_to_bit:: "nat \<Rightarrow> bit" where
  "nat_to_bit 0 = Zero" |
  "nat_to_bit _ = One"

declare bit.exhaust[elim]
lemma bit_zero_or_one[intro,simp]: "x = Zero \<or> x = One" by (cases x) auto

lemma bit_neq_zero_iff[simp]: "x \<noteq> Zero \<longleftrightarrow> x = One" by (cases x) auto
lemma bit_neq_zero_iff2[simp]: "Zero \<noteq> x \<longleftrightarrow> x = One" by (cases x) auto

lemma bit_neq_one_iff[simp]: "x \<noteq> One \<longleftrightarrow> x = Zero" by (cases x) auto
lemma bit_neq_one_iff2[simp]: "One \<noteq> x \<longleftrightarrow> x = Zero" by (cases x) auto

lemma nat_to_bit_eq_if: "nat_to_bit n = (if n = 0 then Zero else One)"
  by (cases n) auto

lemma nat_to_bit_eq_One_iff: "nat_to_bit x = One \<longleftrightarrow> x > 0"
  by (cases x) auto

lemma nat_to_bit_eq_One_iff': "One = nat_to_bit x \<longleftrightarrow> x > 0"
  by (cases x) auto

lemma nat_to_bit_eq_Zero_iff: "nat_to_bit x = Zero \<longleftrightarrow> x = 0"
  by (cases x) auto

lemma nat_to_bit_eq_Zero_iff': "Zero = nat_to_bit x \<longleftrightarrow> x = 0"
  by (cases x) auto

lemmas nat_to_bit_cases = nat_to_bit_eq_One_iff nat_to_bit_eq_One_iff' nat_to_bit_eq_Zero_iff
  nat_to_bit_eq_Zero_iff'

end