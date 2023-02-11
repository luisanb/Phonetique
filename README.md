# Synthèse de la parole avec Praat

Projet réalisé dans le cadre du cours Phonétique et synthèse de la parole, en M1 TAL, 2022-2023.

Vous trouverez dans le fichier zippé les documents :
- script praat ;
- fichier wav ;
- fichier TextGrid ;
- fichier texte contenant un dictionnaire ;
- et fichier texte README.

Version Praat utilisé : 6.2.09 (sur Ubuntu).

## Les démarches du projet
Les élèves du master ont été tous invités à participer à ce projet étant donné le but de synthétiser la voix. D'abord, on a dû choisir 15 mots et créer autant de phrases qu'on pouvait à partir de ces mots. On a transformé toutes les phrases écrites - en alphabet latin à priori - en alphabet phonétique. Avec ces phonèmes, on a composé notre propre dictionnaire, qui contient deux colonnes : l'une dédiée au mot orthographe, l'autre dédiée au mot phonétique. Ensuite, on devait récupérer les diphones produits par ces phrases et les enregistrer oralement. Les diphones sont deux phonèmes qui se trouvent côte à côte dans un mot / une phrase. Ils sont importants à mésure qu'un phonème exerce une influence sur les phonèmes qui se trouvent au tour de lui. Par exemple, dans les phonèmes /fe/ et /fa/, le /f/ est différement influencé en raison de la voyelle qui le suit.

Pour faire l'enregistrement vocale, on a créé des pseudo-mots, des logatomes, où notre diphone se trouvait au milieu de ce mot et entouré des phonèmes les moins articulés, /p/ et /a/. Par exemple, si on avait le diphone /fe/, le logatome construit serait /pafepa/.

Après l'enregistrement des diphones, on devait l'avoir en format wav pour qu'on puisse travailler sur Praat. Dans l'étape suivante, on devait segmenter nos diphones à l'aide d'une grille, le fichier TextGrid, obtenu sur le programme. De cette façon, on était prêts pour créer un script qui automatise la synthèse de ces diphones afin de créer des mots ou même des phrases.

## Le programme
### I. MODE D'EMPLOI
Dès qu'on lance le script, il apparaît une boîte de dialogue qui permet de :
1. Choisir une phrase dans le menu déroulant, ou taper un mot parmi ceux proposés dans la liste ;
2. Cocher une ou deux options pour la modification de la prosodie, soit une modification sur la fréquence fondamentale, la F0, soit sur la durée ;
3. Choisir les paramètres de la F0 en Hz et de la durée en secondes, au début, au milieu et à la fin, au cas où on ait choisi une modification.

Un aperçu de la boîte de dialogue :

# METTRE UNE IMAGE

### II. LES PHRASES / MOTS À SYNTHÉTISER
Dans le menu déroulant de la boîte de dialogue, il est possible de choisir soit les phrases suivantes :

![image](https://user-images.githubusercontent.com/115032201/218250792-7e8e92ad-bfb4-47db-9c5c-8b0de35fd77f.png)

soit les mots de la liste ci-dessous :

![image](https://user-images.githubusercontent.com/115032201/218251684-b42aa68a-3ad3-454d-9503-be9eb68a8ff3.png)

dans laquelle il se trouve des mots grammaticaux et des mots lexicaux.

### III. LE DICTIONNAIRE 
Le dictionnaire dont on a déjà commenté n'est constitué que des caractères ASCII. C'est pourquoi il a fallu remplacer quelques phonèmes par des caractères présents dans cette table. 

![image](https://user-images.githubusercontent.com/115032201/218251081-e6ae7e91-7553-43c0-9be1-90c727d4028a.png)

### IV. LE SCRIPT
Afin de le rendre plus organisé, le script a été divisé en sections selon la tâche principale réalisée dans ce moment-là.

1. Le tout début concerne l'ouverture des fichiers et la création des variables qu'on va utiliser dans tout le reste du programme ;
2. Ensuite, on a la création de la boîte de dialogues ;
3. Dans cette partie, on a le programme proprement dit, qui a été également divisé en : le parcours et le stockage des mots, la concaténation des diphones et, finalement, la manipulation des diphones, où on appelle des procédures ; 
4. À la fin du script, il y a les procédures qui ont été créées pour la manipulation des diphones : la modification de F0 et de la durée.
