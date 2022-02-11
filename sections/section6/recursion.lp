fun fact with n = if n < 2 then 1 else n * (fact (n - 1))
in
fact 3

// gets parsed as
// let fact = fix (lambda fact. lambda n. if n < 2 then 1 else n * (fact (n - 1))) in fact 3
