\<^marker>\<open>creator "Kevin Kappelmann"\<close>
theory HOL_To_IMP_Arithmetics
  imports
    HOL_To_IMP_Primitives
    "HOL-Library.Discrete_Functions"
begin

paragraph \<open>Power\<close>

context HOL_To_HOL_Nat
begin

fun power_acc_nat :: "nat \<Rightarrow> nat \<Rightarrow> nat \<Rightarrow> nat" where
"power_acc_nat x 0 acc = acc" |
"power_acc_nat x (Suc n) acc = power_acc_nat x n (x * acc)"
declare power_acc_nat.simps[simp del]

lemma power_acc_nat_eq_power_mul: "power_acc_nat x y z = x^y * z"
  by (induction x y z arbitrary: z rule: power_acc_nat.induct)
  (auto simp: power_acc_nat.simps)

case_of_simps power_acc_nat_eq : power_acc_nat.simps
function_compile_nat power_acc_nat_eq

lemma power_eq_power_acc_nat_one: "x^y = power_acc_nat x y 1"
  using power_acc_nat_eq_power_mul by simp

function_compile_nat power_eq_power_acc_nat_one

end

context HOL_Nat_To_IMP
begin

lemmas power_acc_nat_nat_eq = HTHN.power_acc_nat_nat_eq_unfolded[unfolded case_nat_eq_if]
compile_nat power_acc_nat_nat_eq basename power_acc
HOL_To_IMP_correct HTHN.power_acc_nat_nat by cook

compile_nat HTHN.power_nat_eq_unfolded basename power
HOL_To_IMP_correct HTHN.power_nat by cook

end

context HOL_To_HOL_Nat
begin

(*takes lower and upper bound for root*)
function sqrt_aux_nat :: "nat \<Rightarrow> nat \<Rightarrow> nat \<Rightarrow> nat" where
  "sqrt_aux_nat x L R = (if Suc L < R
    then
      let M = (L + R) div 2
      in
        if M\<^sup>2 \<le> x
        then sqrt_aux_nat x M R
        else sqrt_aux_nat x L M
    else L)"
  by auto
termination by (relation "Wellfounded.measure (\<lambda>(_, L, R). R - L)") auto
declare sqrt_aux_nat.simps[simp del]

lemma square_sqrt_aux_nat_le:
  assumes "L\<^sup>2 \<le> x" "x < R\<^sup>2"
  shows "(sqrt_aux_nat x L R)\<^sup>2 \<le> x"
  using assms
  by (induction x L R rule: sqrt_aux_nat.induct)
  (auto simp: sqrt_aux_nat.simps Let_def)

lemma lt_square_Suc_sqrt_aux_nat:
  assumes "L\<^sup>2 \<le> x" "x < R\<^sup>2"
  shows "x < (Suc (sqrt_aux_nat x L R))\<^sup>2"
  using assms
  by (induction x L R rule: sqrt_aux_nat.induct)
  (use order_less_le_trans in \<open>force simp: sqrt_aux_nat.simps Let_def\<close>)

function_compile_nat sqrt_aux_nat.simps

definition sqrt_nat :: "nat \<Rightarrow> nat" where
  "sqrt_nat x = sqrt_aux_nat x 0 (Suc x)"

lemma square_sqrt_nat_le: "(sqrt_nat x)\<^sup>2 \<le> x"
  using square_sqrt_aux_nat_le unfolding sqrt_nat_def by (simp add: power2_eq_square)

lemma lt_square_Suc_sqrt_nat: "x < (Suc (sqrt_nat x))\<^sup>2"
  using lt_square_Suc_sqrt_aux_nat unfolding sqrt_nat_def by (simp add: power2_eq_square)

corollary sqrt_nat_eq: "sqrt_nat y = floor_sqrt y"
  using square_sqrt_nat_le lt_square_Suc_sqrt_nat
  by (intro floor_sqrt_unique[symmetric]) auto

corollary floor_sqrt_eq_sqrt_aux_nat: "floor_sqrt x = sqrt_aux_nat x 0 (Suc x)"
  using sqrt_nat_eq sqrt_nat_def by simp

function_compile_nat sqrt_nat_def

end

context HOL_Nat_To_IMP
begin

compile_nat HTHN.sqrt_aux_nat_nat_eq_unfolded
HOL_To_IMP_correct HTHN.sqrt_aux_nat_nat by cook
  (*Example step-by-step tactic invocation for debugging purposes.*)
  (* apply (tactic \<open>HM.correct_if_IMP_tailcall_correct_tac HT.get_IMP_def @{context} 1\<close>)
  apply (tactic \<open>HT.setup_induction_tac HT.get_fun_inducts @{context} 1\<close>)
  apply (tactic \<open>HT.start_case_tac HT.get_IMP_def @{context} 1\<close>)
  apply (tactic \<open>HT.run_tac HT.get_imp_correct @{context} 1\<close>)
  apply (tactic \<open>SOLVED' (HT.finish_tac HB.get_HOL_eqs @{context}) 1\<close>)
  apply (tactic \<open>SOLVED' (HT.finish_tac HB.get_HOL_eqs @{context}) 1\<close>)
  apply (tactic \<open>SOLVED' (HT.finish_tac HB.get_HOL_eqs @{context}) 1\<close>)
  oops *)

compile_nat HTHN.sqrt_nat_nat_eq_unfolded
HOL_To_IMP_correct HTHN.sqrt_nat_nat by cook

end

end
