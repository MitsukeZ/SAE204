/*
b) le vendeur a les droits en lecture/écriture sur la table des ventes et des clients et
sur la table Concerner entre les deux.
*/

grant SELECT,INSERT
   ON Vente, Client, Concerner
   to vendeur;