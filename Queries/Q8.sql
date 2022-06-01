/*
h) Créer et afficher une vue nommée best5 qui liste les 5 meilleurs clients (ayant 
donc dépensé le plus d’argent en BD) en affichant leur numéro, nom et adresse 
mail, ainsi que le nombre total de BD qu’ils ont acheté (champ nbBD en tenant 
compte des quantités achetées), ainsi que le total de leurs achats (champ coutA).
*/

CREATE VIEW AS
Select numClient, nomClient, mailClient, 