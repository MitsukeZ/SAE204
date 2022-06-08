/*
a) l’administrateur a les droits de création/suppression des bases, des tables, et
toutes les opérations de lecture/écriture sur la base et l’affectation des privilèges
aux autres utilisateurs/roles
*/
grant SELECT,INSERT, UPDATE, DELETE
   ON Serie, BD, Editeur, Vente, Client, Concerner
   to administrateur WITH GRANT OPTION;
