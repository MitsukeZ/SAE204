/*
j) Construire et afficher une vue bdEd10 qui affiche les éditeurs qui ont publié plus 
de 10 BD, en donnant leur nom et email, ainsi que le nombre de BD différentes 
qu’ils ont publiées.
*/

DROP VIEWS IF EXISTS bdEd10;

SELECT nomEditeur, mailEditeur

From Editeur

where 