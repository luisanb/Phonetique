
# ---------------------- Script Praat Synthétiseur -------------------------- #
#                  Auteur : Luísa NASCIMENTO BATISTA                         #
#------------------------------------------------------------------------------------------#
# On nettoie toujours le run précédent 
clearinfo


##########################################
#                 	          TRAITEMENT DES FICHIERS                               #
##########################################

# Ouverture des fichiers qui contiennent la grille, l'enregistrement 
# des logatomes et le dictionnaire, en enregistrant les variables

segmentation = Read from file: "logatomes.TextGrid"
number_intervals = Get number of intervals: 1

son = Read from file: "logatomes.wav"
analyse_son = To PointProcess (zeroes): 1, "no", "yes"

dico = Read Table from tab-separated file: "dico.txt"


# Création d'un fichier vierge dans lequel on va recolter les diphones
son_concatene = Create Sound from formula: "sineWithNoise", 1, 0, 0.05, 16000, "0"


##########################################
#                              DÉBUT DU PROGRAMME                                     #
##########################################

# On crée une boîte de dialogue
form Synthétiseur vocale 
	comment Quelle phrase souhaitez-vous synthétiser ?
	comment
	optionmenu choisir_une_phrase
		
		option Je ne choisis pas de phrase.
		option dans les Pyrénées
		option une femme est dans les Pyrénées
		option un homme fait un gâteau
		option un homme et une femme voyagent
		option le vent dans les Pyrénées
		option un voyage dans les Pyrénées
		option le beau gâteau
		option une femme sent le gâteau
		option un homme fait cent gâteaux

	comment Ou saisissez un mot entre ceux de la liste ci-dessous :
	comment les, le, un, une, dans, homme, femme, beau, beaux, est, et, fait, sent, cent, 
	comment sans, gâteau, gâteaux, pyrénées, vent, vend, voyage.
	text mot_orthographe
	comment _________________________________________________________________________________  	
	comment Souhaitez-vous faire quelque modification prosodique ?
        	boolean F0
        	boolean Duree
	comment F0 paramètres (en Hz) :
		real f0_debut 250.0
		real f0_milieu 80.0
		real f0_fin 50.0
	comment Durée paramètres (en secondes) :
		real duree_debut 0.8
		real duree_milieu 0.5
		real duree_fin 0.4

endform

# Au cas où le mot_orthographe soit, en effet, une phrase du menu déroulant
if mot_orthographe$ = ""

	mot_orthographe$ = choisir_une_phrase$

endif

writeInfoLine : "Vous avez choisi le mot / la phrase : ", mot_orthographe$,"."


##########################################
#                                       LE PROGRAMME                                     	   #
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

		# Extraire le mot de la colonne orthographe du dico
		select 'dico'
		#pause //'premier_mot$'//
		extraction = Extract rows where column (text): "orthographe", "is equal to", premier_mot$
		mot_phonetique$ = Get value: 1, "phonetique"
		stock_mot$ = stock_mot$ + mot_phonetique$
		
		mot_orthographe$ = right$ (mot_orthographe$, longueur_mot_orthographe - espace)
	
		# Pour arrêter la boucle
		longueur_mot_orthographe = length (mot_orthographe$) 

		# On silencie les pauses 1 et 2 car on verra tous les résultats stockés dans la 3
		#pause (1) premier_mot = 'premier_mot$' 
		#pause (2) reste = 'mot_orthographe$'
		
printline 'premier_mot$'

endwhile


# On a tous les mots stockés et on ajoute le silence au début et à la fin
stock_mot$ = "_" + stock_mot$ + "_"
pause (3) stock = 'stock_mot$'



##########################################
#	                         Concaténation des diphones                              #
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
				

				select 'analyse_son'
				nearest_index1 = Get nearest index:  'm1'
				time_index1 = Get time from index:  'nearest_index1'
				nearest_index2 = Get nearest index:  'm2'
				time_index2 = Get time from index:  'nearest_index2'
				#printline 'time1' / 'time2'


				select 'son'
				son_extrait = Extract part: time_index1, time_index2, "rectangular", 1, "no"

				# Concaténation des diphones dans un seul fichier
				select 'son_concatene'  
				plus 'son_extrait'
				son_concatene = Concatenate

		endif

	endfor

endfor



##########################################
#    	                        Manipulation des diphones                            	   #
##########################################

# On appelle la procédure responsable pour la modification de la F0

if ( f0 )

		@modification_f0

endif 


# On appelle la procédure responsable pour la modification de la durée
if ( duree ) 
		
		@modification_duree

endif


# __________________________________________________ #
#													      		  #
#                       			PROCEDURES       			                  #
# __________________________________________________ #


#	01.	Procédure de modification de F0 :

procedure modification_f0

		printline modification prosodique : 'modification f0'

		select 'son_concatene'
		end_time = Get end time
		manipulation = To Manipulation: 0.01, 75, 600
		extract_pitch = Extract pitch tier

		Remove points between: 0, end_time

		Add point: 0.01, f0_debut
		Add point: end_time/2, f0_milieu
		Add point: end_time, f0_fin

		select 'extract_pitch'
		plus 'manipulation'
		Replace pitch tier

		select 'manipulation'
		son_concatene = Get resynthesis (overlap-add)

endproc

# ----------------------------------------------------------------------------------- #

#	02.	Procédure de modication de durée :

procedure modification_duree

		printline modification prosodique : 'modification duree'

		select 'son_concatene'
		end_time = Get end time
		manipulation = To Manipulation:  0.01, 75, 600
		extract = Extract duration tier

		Remove points between: 0, end_time

		Add point: 0.01, duree_debut
		Add point: end_time/2, duree_milieu
		Add point: end_time, duree_fin
		
		select 'manipulation'
		plus 'extract'
		Replace duration tier

		select 'manipulation'
		son_concatene = Get resynthesis (overlap-add)

endproc

##########################################
# 											C'EST FINI		   #
##########################################