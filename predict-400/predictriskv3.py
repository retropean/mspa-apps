#Ukraine is game to you!? ...find out.
import itertools

#define a die
U=range(1,7,1) 
dice = list(U[:6])
#print dice

'''
#define total number of troops
attleft=3
defleft=2
a=0
b=0

#a and b are to be assigned to dice rolls, where attleft and
#defleft are variables to keep track of actual armies left
while attleft!=0 and defleft!=0:
    if attleft > 3:
        a=3
    else:
        a=attleft
    if defleft > 2:
        b=2
    else:
        b=defleft
    
    attleft = totatt-a
    defleft = totdef-b
    
    print a
    print b
    print attleft
    print defleft
'''    
prob={}
numatt=3
numdef=2
while numdef!=0:
    #define number of attackers' and defenders' dice
    numatt=numatt
    numdef=numdef
    
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
    stratt=str(numatt)
    strdef=str(numdef)
    strdic=stratt+'v'+strdef+'a'
    prob[strdic]=attack/i
    strdic=stratt+'v'+strdef+'d'
    prob[strdic]=defense/i
    strdic=stratt+'v'+strdef+'t'
    prob[strdic]=tie/i
    if numatt==1:
        numdef-=1
        numatt=3
    else:
        numatt-=1
print prob
'''
attleft=3
defleft=2

print diclookup
print prob[diclookup]
if attleft > 3:
    a=3
else:
    a=attleft
if defleft > 2:
    b=2
else:
    b=defleft
'''
totprob={}
totprob['1v2a'] = (prob['1v2a']*prob['1v1a'])
totprob['1v1a'] = (prob['1v1a'])
totprob['2v2a'] = (prob['2v2a'])+(prob['2v2t']*prob['1v1a'])
totprob['2v1a'] = (prob['2v1a']+(prob['2v1d']*prob['1v1a']))
totprob['3v1a'] = prob['3v1a']+(prob['3v1d']*prob['2v1a'])+(prob['3v1d']*prob['2v1d']*prob['1v1a'])
totprob['3v2a'] =(prob['3v2a'])+(prob['3v2t']*prob['2v1a'])+(prob['3v2t']*prob['2v1d']*prob['1v1a'])+(prob['3v2d']*totprob['1v2a'])
print totprob['3v2a']

print prob['3v2a']+prob['3v2d']*prob['3v2d']*totprob['3v2a']+prob['3v1d']*totprob['3v1a']

def tryAttackNoRecursion(attackers, defenders) :
    #if(attackers > 3) : 
      #  return tryAttack(attackers-1,defenders)
    if (defenders <= 0) : 
            return [[1, 0, 0]]
    if (attackers <= 0) : 
            return [[0, 1, 0]]        
    attackers -= 1
    defenders -= 1
    lookup = str(attackers)+'v'+str(defenders)
    return [[prob[lookup+'a']][prob[lookup+'a']],[prob[lookup+'d']][prob[lookup+'d']],[prob[lookup+'t']][prob[lookup+'t']]]
    
print tryAttackNoRecursion(2,2)

def tryAttackRecursion(attackers, defenders) : 
    if (attackers <= 0 and defenders <= 0) : 
        return [[0,0,0]]
    if (defenders <= 0) : 
        return [[1, 0, 0]]
    if (attackers <= 0) : 
        return [[0, 1, 0]]        
    RoundResults = transpose(tryAttackNoRecursion(min(attackers,3), min(defenders,2)))[:]
#    print "round results", attackers, defenders, ":", RoundResults
#    print tryAttackRecursion(attackers,defenders-2)#*RoundResults [0]
#    print tryAttackRecursion(attackers-2,defenders)#*RoundResults [1]
#    print tryAttackRecursion(attackers-1,defenders-1)#*RoundResults [2]
    return tryAttackRecursion(attackers,defenders-min(2,attackers))*RoundResults[0]  + tryAttackRecursion(attackers-min(2,defenders),defenders)*RoundResults[1] + tryAttackRecursion(attackers-1,defenders-1)*RoundResults[2]

#diclookup=str(a)+'v'+str(b)+'a'        
                
#attleft = totatt-a
#defleft = totdef-b