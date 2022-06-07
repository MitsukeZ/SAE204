/*
a) Ecrire une procédure qui prend en paramètre un numéro d’auteur dessinateur et
qui renvoie pour chaque titre de BD de l’auteur, le nombre d’exemplaires vendus
de cette BD.
*/

CREATE OR REPLACE FUNCTION getVentesParAuteur(auteur Auteur.numAuteur%TYPE) RETURNS SETOF