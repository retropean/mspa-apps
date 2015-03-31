import numpy 
from numpy import arange, cos
import matplotlib.pyplot 
from matplotlib.pyplot import *

def der(x,delta):
    delta = float(delta)
    if delta < (0.0000001):
        print ('Value chosen for delta is too small.')
        return 1/delta
    else:
        slope = (f(x + delta) - f(x))/delta
        return slope

def f(x):
    f = 0.0024*x**2 - 0.0326*x + 0.0591
    return f
    
point = 11.0

number = 12
increment =1
y = []
x = []

for k in range(increment, number, increment):
    delta = 1.0/(k+1)
    d = der(point,delta)
    x = x + [k]
    y = y + [d]
    max_x = k + increment

limit=der(point,0.000001)    
print "Final value equals %2.3f " %limit
point = 3.0

w=arange(point-1.0,point+1.1,0.1)
t=f(point)+limit*(w-point)
domain=12.0
u=arange(point-domain,point+domain+0.1,0.1)
z=f(u)


figure()
xlim(0,12)
ylim(min(z)-.02,.02)

plot(w,t,c='r')
plot(u,z,c='b')
scatter(point,f(point),c='g',s=40)
xlabel('x-axis')
ylabel('y-axis')
title('ridership polynomial regression')
show()
