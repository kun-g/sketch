likes(a, wow).
likes(b, wow).
likes(c, starcraft).

friend(X, Y) :- \+(X = Y), likes(X, Z), likes(Y, Z).

