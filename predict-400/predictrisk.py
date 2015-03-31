#find all possible combinations between two sets
#dice range

import itertools
#>>> a = [[1,2,3],[4,5,6],[7,8,9,10]]
#>>> list(itertools.product(*a))
'''U=range(1,7,1) 
B=U[:6]
C=U[:6]
B=list(B)
C=list(C)
B.append(C)
print C
print B

(itertools.product(*B))'''
U=range(1,7,1) 
dice = list(U[:6])
print dice
twodice = []
twodice.append(dice)
twodice.append(dice)
print twodice

#twodice = [ [ 1, 2, 3, 4, 5, 6], [ 1, 2, 3, 4, 5, 6]]
outcome = list(itertools.product(*twodice))
print outcome
print outcome[0]
print outcome[0][0]

i=0
attack=0.0
defense=0.0
6**2
while i!=len(outcome):
    if outcome[i][0]>outcome[i][1]:
        print "attack wins"
        attack=attack+1
        i=i+1
    elif outcome[i][0]<outcome[i][1]:
        print "defense wins"
        defense=defense+1
        i=i+1
    elif outcome[i][0]==outcome[i][1]:
        print "defense wins"
        defense=defense+1
        i=i+1
print i
print defense
print attack
print defense/i
print attack/i