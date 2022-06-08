/*
b) Représenter le nombre de BD vendues par éditeur de deux manières : par un
diagramme de type histogramme (les noms des éditeurs sont en abscisse et le
nombre de BD est en ordonnée) et par un diagramme de type secteur (on les
placera sur la même feuille).
*/

SELECT   sum(quantite), nomEditeur
FROM     Concerner NATURAL JOIN Editeur
GROUP BY numEditeur;

\copy  (SELECT sum(quantite), nomEditeur FROM Concerner NATURAL JOIN Editeur GROUP BY nomEditeur;) TO './Question_B.csv' DELIMITER ';' QUOTE '"' CSV HEADER