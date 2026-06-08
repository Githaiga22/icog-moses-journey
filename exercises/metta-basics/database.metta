 ; Build a mini knowledge base about yourself
  (knows Allan MeTTa)
  (knows Allan Solidity)
  (knows Allan Python)
  (knows Bob MOSES)
  (knows Bob MeTTa)

  ; Query: what does Allan know?
  !(match &self (knows Allan $skill) $skill)
  !(match &self (knows Bob $skill) $skill)

  ; Query: who knows MeTTa?
  !(match &self (knows $person MeTTa) $person)