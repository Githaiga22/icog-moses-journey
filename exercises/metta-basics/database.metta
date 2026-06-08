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


  ; build knowledge about car drivers and companies

  (drives Jason Audi)
  (drives Mary Audi)
  (drives Bob Mercdes)
  (drives John mitsubishi)
  (drives Ken Dodge)
  (drives Victor subaru)

  ;query what all drivers make is

  !(match &self (drives John $car) $car)
  !(match &self (drives Ken $car) $car)
  !(match &self (drives Victor $car) $car)

  ;     query which driver drives a certain make
  !(match &self( drives $driver Audi) $driver)

  ; Notes 
  ; (drives Allan mitsubishi) -- database storage into the Atomspace
  ; match -- scans everything stored in the &self
  ; &self -- name for the current Atomspace, where your stored facts live eg. (drives Allan mitsubishi)
  ; $car -- the $ means the blank variable..when metta scans and search the whole database  for any fact such as (drives Allan ??) and returns/fills in the  ?? value as the output


  ; Database for teachers and the subjects they teachers

  (teacher Amos Maths)
  (teacher Alex Physics)
  (teacher Jane Biology)
  (teacher Grace English)

  ;query which subject the teacher is responsible of
  !(match &self (teacher Amos $subject) $subject)

  ; query who teaches Biology
  !(match &self (teacher $lecturer Biology) $lecturer)