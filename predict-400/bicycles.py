p=poly1d([.016666666666666,0,5,10])
r=poly1d([-1,90,0])
f=poly1d([-.05,-2,85])
# As a final example, we will find the first and second derivatives of the
# polynomial p, find the roots of the derivatives and plot the functions.
p(1)
g=p.deriv(m=1)
print p.roots
print ('\nRoots of First Derivative')
print g.roots
print e
print ('\nRoots of Second Derivative')
q=p.deriv(m=2)
print q.roots
#-16*1.875**2+60*1.875+5
#p(13)
#q(-1)
#p(7.85626743)
x=linspace(0,60,101)
y=p(x)
y2=r(x)
y3=f(x)
yg=g(x)  # These statements define points for plotting.
yq=q(x)
y0=0*x   # This statement defines the y axis for plotting.

# What is shown below is a different way to legends using a label.  Python
# will pick the colors to assign to the labels and the plotted points.

plot (x,y,label ='cost')
plot (x,y2,label ='revenue')
plot (x,y3,label ='derived revenue-cost')
#plot (x,yg,label ='First Derivative')
#plot (x,yq,label ='Second Derivative')
legend(loc='best')

plot (x,y0)
xlabel('production of bicycles per week')
ylabel('cost/revenue')
title ('Bicycle Production')
show()