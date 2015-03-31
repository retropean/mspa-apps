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
#define a die
U=range(1,7,1) 
dice = list(U[:6])
print dice

#define number of attackers and defenders
numatt=1
numdef=1
#number of dice rolled will be the combined sum of attacking and defending armies
dicerolls=numatt+numdef

twodice = []

#create list of all the dice needed
i = 0
while i!=dicerolls:
    twodice.append(dice)
    i+=1
print twodice

#create all possible iterations
outcome = list(itertools.product(*twodice))

#check if same (yes)
print len(outcome)
print 6**dicerolls

print outcome
#first list
#print outcome[0]
#first item of first list
#print outcome[0][0]

key = []
i=0
while i!=numatt:
    key.append('a')
    i+=1
print key
i=0
while i!=numdef:
    key.append('d')
    i+=1
print key

i=0
attack=0.0
defense=0.0

while i!=len(outcome):
#decide which dice go where
#    outcome[i][key.index('d')]
    
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