/*
Creation des roles
*/

-- Administrateur
Create role administrateur  NOLOGIN CREATEDB;

-- Vendeur
Create role vendeur NOLOGIN NOCREATEDB;

-- Editeur
Create role editeur  NOLOGIN NOCREATEDB;



/*
a) l’administrateur a les droits de création/suppression des bases, des tables, et
toutes les opérations de lecture/écriture sur la base et l’affectation des privilèges
aux autres utilisateurs/roles
*/

grant SELECT,INSERT, UPDATE, DELETE
ON Serie, BD, Editeur, Vente, Client, Concerner
to administrateur WITH GRANT OPTION;



/*
b) le vendeur a les droits en lecture/écriture sur la table des ventes et des clients et
sur la table Concerner entre les deux.
*/

grant SELECT,INSERT
   ON Vente, Client, Concerner
   to vendeur;



/*
c) l’éditeur a les droits du vendeur plus les lectures/écritures sur les tables BD,
Serie, et Auteur.
*/

grant SELECT,INSERT
   ON Serie, BD, Editeur, Vente, Client, Concerner
   to editeur;