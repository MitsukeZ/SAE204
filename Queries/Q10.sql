/*
j) Construire et afficher une vue bdEd10 qui affiche les éditeurs qui 
ont publié plus de 10 BD, en donnant leur nom et email, ainsi que 
le nombre de BD différentes qu’ils ont publiées.
*/

DROP VIEW IF EXISTS bdEd10;

CREATE VIEW bdEd10 AS
SELECT e.nomEditeur, e.mailEditeur, COUNT(BD.isbn) AS nbBD
FROM   Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur
                 JOIN BD      ON s.numSerie   = BD.numSerie
GROUP BY e.nomEditeur, e.mailEditeur
HAVING   COUNT(BD.isbn) > 10;

SELECT * FROM bdEd10;

/*
 nomediteur |    mailediteur     | nbbd 
------------+--------------------+------
 Lombard    | info@Lombard.be    |   27
 Dargaud    | contact@dargaud.fr |   49
(2 lignes)
*/