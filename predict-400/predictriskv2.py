#Ukraine is game to you!? ...find out.
import itertools

#define a die
U=range(1,7,1) 
dice = list(U[:6])
#print dice

#define number of attackers and defenders
numatt=2
numdef=2

#number of dice rolled will be the combined sum of attacking and defending armies
dicerolls=numatt+numdef

totdice = []

#create list of all the dice needed
i = 0
while i!=dicerolls:
    totdice.append(dice)
    i+=1
#print totdice

#create all possible iterations
outcome = list(itertools.product(*totdice))

#check if same (yes)
#print len(outcome)
#print 6**dicerolls

#print all possible outcomes
#print outcome

i=0
attack=0.0
defense=0.0
tie=0.0
ftotal=0.0
while i!=len(outcome):
#decide which dice go where
#    outcome[i][key.index('d')]
    attset=[]
    defset=[]
    j=0
    while numatt != j:
        attset.append(outcome[i][j])
        j+=1
    while j !=len(outcome[i]):
        defset.append(outcome[i][j])
        j+=1
    attset.sort(reverse=True)
    defset.sort(reverse=True)
    f = 0
    ac=0
    dc=0
    while f!=len(defset) and f!=len(attset):
        if attset[f]>defset[f]:
#            print "attack wins"
            ac=ac+1
            f+=1
        elif attset[f]<defset[f]:
#          print "defense wins"
           dc=dc+1
           f+=1
        elif attset[f]==defset[f]:
#            print "defense wins"
            dc=dc+1
            f+=1
    ftotal +=f
    if(dc==ac):
        tie+=1
    elif dc>ac:
        defense +=1
    elif ac>dc:
        attack +=1
    i+=1
print "possible outcomes"
print i
print "defense victories"
print defense
print "attack victories"
print attack
print "defense probability"
print defense/i
print "attack probability"
print attack/i
print "one each probability"
print tie/i