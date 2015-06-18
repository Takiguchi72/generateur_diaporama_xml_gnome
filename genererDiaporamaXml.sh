#! /bin/bash
##########################################################################
# Script de création de fichier xml pour faire un fond d'écran dynamique #
##########################################################################

#####################
# F O N C T I O N S #
#####################

# Fonction permettant d'écrire le paragraphe correspondant à une image dans le fichier xml
# @param Le nom de l'image à traiter [String]
ajouterImage()
{
	
	if [ $# -eq 0 ]
	then
		echo "La fonction a été appelée sans paramètres !"
		echo "Génération du fichier xml annulée..."
		exit 1
	else
		echo "Ajout de l'image '$1' au fichier xml..."
		echo "	<static>" >> $xmlFileName
		echo "		<duration>$duree</duration>" >> $xmlFileName
		echo "		<file>$folderPath$1</file>" >> $xmlFileName
		echo "	</static>" >> $xmlFileName
		echo "Image ajoutée."
		echo " "
	fi
}

#########################################
# P R O G R A M M E   P R I N C I P A L #
#########################################

# Liste des variables
# $1 <=> Chemin du dossier contenant les images
folderPath=$1
# $2 <=> Chemin du fichier xml
xmlFileName="fond_ecran_dynamique.xml"
duree="60.0"

# Si l'utilisateur n'a pas spécifié le chemin du fichier xml à générer, on le placera dans le dossier personnel
#if [ -z $2 ]
#then
	xmlFilePath=$(cd && pwd)/$xmlFileName
#else
#	xmlFilePath=$2/$xmlFileName
#fi

contenuDossier=$(ls $1)
nombreFichiers=$(ls $1 | wc -l) 
# Si le contenu du dossier qu'a choisit l'utilisateur est vide, on affiche une erreur et on arrête le script
if [ $nombreFichiers -eq 0 ]
then
	echo "Il n'y a rien dans le dossier '$1'..."
	echo "Génération du fichier xml annulée..."
	exit 1
fi

echo "<background>" > $xmlFileName

# Pour chaque image dans le dossier qu'a choisit l'utilisateur, on va ajouter un bloc dans le fichier xml
for fichier in $(ls $1)
do
	# Si l'extension du fichier est "jpg" ou "png", on ajoute l'image au diaporama
	if [ ${fichier##*.} = "jpg" -o ${fichier##*.} = "png" ]
	then
		ajouterImage $fichier
	fi
done
echo "</background>" >> $xmlFileName
echo " "
echo "Votre diaporama a été enregistré ici :"
echo $xmlFilePath
