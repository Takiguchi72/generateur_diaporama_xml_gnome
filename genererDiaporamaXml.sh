#! /bin/bash
##########################################################################
# Script de création de fichier xml pour faire un fond d'écran dynamique #
##########################################################################

#####################
# F O N C T I O N S #
#####################

# Fonction permettant d'écrire le paragraphe correspondant à une image dans le fichier xml
# @param $1 - Le nom de l'image à traiter [String]
ajouterImage()
{
	
	if [ $# -eq 0 ]
	then
		echo "La fonction a été appelée sans paramètres !"
		echo "Génération du fichier xml annulée..."
		exit 1
	else
		echo "Ajout de l'image '$1' au fichier xml..."
		echo "	<static>" >> $diaporama
		echo "		<duration>$duree</duration>" >> $diaporama
		echo "		<file>$dossierDImages/$1</file>" >> $diaporama
		echo "	</static>" >> $diaporama
		echo "Image ajoutée."
		echo " "
	fi
}

#########################################
# P R O G R A M M E   P R I N C I P A L #
#########################################

# Liste des variables
dossierDImages=$1									# $1 <=> Chemin du dossier contenant les images
dossierDImages=${dossierDImages%/}		# On supprime le "/" à la fin de la chaine, s'il y en a un
dossierDuDiaporama=$2								# $2 <=> Chemin du diamopara
nomDuDiaporama="fond_ecran_dynamique.xml"
duree="60.0"

nombreFichiers=$(ls $dossierDImages | wc -l) 
# Si le contenu du dossier qu'a choisit l'utilisateur est vide, on affiche une erreur et on arrête le script
if [ $nombreFichiers -eq 0 ]
then
	echo "Il n'y a rien dans le dossier '$dossierDImages'..."
	echo "Génération du fichier xml annulée..."
	exit 1
fi

# On vérifie si l'utilisateur a spécifié où il souhaitait que le diaporama soit généré :
# Si il ne l'a pas spécifié,
if [ -z $dossierDuDiaporama ]
then
	# On va créer le diaporama à la racine de son dossier personnel (/home/[Utilisateur]/fond_ecran_dynamique.xml)
	diaporama=$(cd && pwd)/$nomDuDiaporama
else
	# Sinon on le créer là où l'a précisé
	diaporama=${dossierDuDiaporama%/}/$nomDuDiaporama	# "${chaine%/}" permet de supprimer le "/" à la fin de la chaine, s'il y en a un...
fi

echo "<background>" > $diaporama

# Si la commande précédente a retourné autre chose que "0", c'est qu'il est impossible de générer le fichier xml, donc on arrête le script
if [ $? -ne 0 ]
then
	echo "Impossible de créer/modifier le fichier xml !"
	exit 1
fi

# Pour chaque fichier dans le dossier qu'a choisit l'utilisateur,
for fichier in $(ls $dossierDImages)
do
	# Si le fichier est une image "jpg" ou "png", on ajoute l'image au diaporama
	if [ ${fichier##*.} = "jpg" -o ${fichier##*.} = "png" ]
	then
		ajouterImage $fichier
	fi
done

echo "</background>" >> $diaporama
echo "Votre diaporama a été enregistré ici :"
echo $diaporama
