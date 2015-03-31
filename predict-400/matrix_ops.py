m= array([[3,1,2],[3,2,1],[2,1,2]])
n= array([[100],[110],[90]])
print m
print n
#add
q= m + n
print q

#multiply
q=m*n
print q

#subtract
q= m - n
print q

#multiply by scalar
s= 2.0
q= s*q
print q

#inverse
IA= inv(m)
print IA
result = dot(IA,n)
result = int_(result)
print result

#identity
I= dot(IA,m)
I= int_(I)               # This converts floating point to integer.
print I

#transpose
t = transpose(m)
print t