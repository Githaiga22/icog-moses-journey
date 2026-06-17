; Example 1

(= (only-a A) (Input is accepted)) ; This defines a rule that says: "if you call only-a with exactly the symbol A, return (Input is accepted)."

!(only-a A).  ; do I have a rule for (only-a A)? Yes. Returns (Input is accepted).
!(only-a B).  ; do I have a rule for (only-a B)? No — the only rule is for A, not B. So nothing matches. metta-py returns it
              ; unevaluated, PeTTa shows nothing.
!(only-a $x).  ; $x is a variable — it means "any value". MeTTa asks: does any rule for only-a exist? Yes — for A. So $x gets filled in as A and the rule fires. Returns
               ;(Input is accepted).


; Example 2
(= (only-A a) (INPUT IS ACCEPTED))

; This is the match style — querying the Atomspace directly instead of calling the function.
!(match &self (= (only-A a) $result) $result)
!(match &self (= (only-A b) $result) $result)
!(match &self(= (only-A $x) $result) $result)