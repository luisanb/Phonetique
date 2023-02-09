##########################################
#                                                                                                                        #
# ---------------------- Script Praat Synthétiseur -------------------------- #
#                  Auteur : Luísa NASCIMENTO BATISTA                         #
#                                                                                                                        #
##########################################

# On nettoie toujours le run précédent 
clearinfo


##########################################
#                           TRAITREMENT DES FICHIERS                               #
##########################################



# Ouverture des fichiers qui contiennent la grille, l'enregistrement des logatomes et le dictionnaire, en enregistrant les variables

segmentation = Read from file: "/home/luisa/MASTER/S1/SynParole/projet/logatomes.TextGrid"
number_intervals = Get number of intervals: 1

son = Read from file: "/home/luisa/MASTER/S1/SynParole/projet/logatomes.wav"
analyse_son = To PointProcess (zeroes): 1, "no", "yes"

dico = Read Table from tab-separated file: "/home/luisa/MASTER/S1/SynParole/projet/dico.txt"


# Création d'un fichier vierge dans lequel on va recolter les diphones
son_vide = Create Sound from formula: "sineWithNoise", 1, 0, 0.05, 16000, "0"



##########################################
#                              DÉBUT DU PROGRAMME                                    #
##########################################

 
form Quel mot souhaitez-vous synthétiser ?
text mot_orthographe les Pyrénées
endform 



##########################################
#                                       LE PROGRAMME                                             #
##########################################


# Pour identifier le dernier mot
mot_orthographe$ = mot_orthographe$ + " "

# Pour compter la longueur du mot orthographe	
longueur_mot_orthographe = length (mot_orthographe$)

# Pour stocker le(s) mot(s) repéré(s) à travers la boucle
stock_mot$ = "" 

while longueur_mot_orthographe > 0 

		espace =  index (mot_orthographe$, " ")
		premier_mot$ = left$ (mot_orthographe$, espace - 1)

		# Extraire un mot de la colonne orthographe du dico
		select 'dico'
		extraction = Extract rows where column (text): "orthographe", "is equal to", premier_mot$
		mot_phonetique$ = Get value: 1, "phonetique"
		stock_mot$ = stock_mot$ + mot_phonetique$
		
		mot_orthographe$ = right$ (mot_orthographe$, longueur_mot_orthographe - espace)
	
		# Pour arrêter la boucle
		longueur_mot_orthographe = length (mot_orthographe$) 

		# On silencie les pauses 1 et 2 car on verra tous les résultats stockés dans la troisième
		#pause (1) premier_mot = 'premier_mot$' 
		#pause (2) reste = 'mot_orthographe$'
		
printline 'premier_mot$'

endwhile


# On a tous les mots stockés et on ajoute le silence au début et à la fin
stock_mot$ = "_" + stock_mot$ + "_"
pause (3) stock = 'stock_mot$'



##########################################
#                     CONCATÉNATION DES DIPHONES                            #
##########################################


longueur_mot = length (stock_mot$)

for i from 1 to longueur_mot -1      
           
	diphone$ = mid$ (stock_mot$, i, 2)
	caractere1_diphone$ = left$ (diphone$, 1)
	caractere2_diphone$ = right$ (diphone$, 1)
	printline 'caractere1_diphone$' / 'caractere2_diphone$'

	select 'segmentation'
	number_intervals = Get number of intervals: 1

	for j from 1 to number_intervals-1

		select 'segmentation'
		start_interval = Get start time of interval: 1, j
		end_interval = Get end time of interval: 1, j
		label_interval$ = Get label of interval: 1, j
		label_next_interval$ = Get label of interval: 1, j+1
		end_next_interval = Get end time of interval: 1, j+1

		if (label_interval$ = caractere1_diphone$ and label_next_interval$ = caractere2_diphone$)
				m1 = (end_interval - start_interval)/2 + start_interval
				m2 = (end_next_interval - end_interval)/2 + end_interval
				#printline 'm1:3' / 'm2:3'
				
				select 'son'
				analyse_son = To PointProcess (zeroes): 1, "no", "yes"

				select 'analyse_son'
				nearest_index1 = Get nearest index:  'm1'
				time_index1 = Get time from index:  'nearest_index1'
				nearest_index2 = Get nearest index:  'm2'
				time_index2 = Get time from index:  'nearest_index2'
				#printline 'time1' / 'time2'


				select 'son'
				son_extrait = Extract part: time_index1, time_index2, "rectangular", 1, "no"

				# Concaténation des diphones dans un seul fichier
				select 'son_vide'  
				plus 'son_extrait'
				son_vide = Concatenate

		endif
	endfor
endfor



##########################################
#                        MANIPULATION DES DIPHONES                            #
##########################################

# OPTION #1

select 'son_vide'
manipulation = To Manipulation: 0.01, 75, 600

pitch = Extract pitch tier

Remove points between: 0, 0.85

Add point: 0.001, 220
Add point: 0.45, 220
Add point: 0.85, 280

select 'manipulation'
plus 'pitch'

Replace pitch tier

select 'manipulation'
Get resynthesis (overlap-add)

# OPTION #2

To Manipulation: 0.01, 75, 600

To Manipulation: 0.01, 75, 600
Extract duration tier

Add point: 0.001, 1
Add point: 0.45, 1
Add point: 0.451, 1.5
Add point: 0.85, 1,5

Replace duration tier
Get resynthesis (overlap-add)
