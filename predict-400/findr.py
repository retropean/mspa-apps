from math import sqrt
x=550
y=595.5
xy=28125
x2=38500
y2=38249.41
n=10

r=(n*xy-x*y)/(sqrt(n*x2-x**2)*sqrt(n*y2-y**2))
print r

m=(n*xy-x*y)/(n*x2-x**2)
print m