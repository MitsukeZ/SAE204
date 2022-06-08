/*
b) Représenter le nombre de BD vendues par éditeur de deux manières : par un
diagramme de type histogramme (les noms des éditeurs sont en abscisse et le
nombre de BD est en ordonnée) et par un diagramme de type secteur (on les
placera sur la même feuille).
*/

SELECT   nomEditeur, sum(quantite) AS nbBDVendu
FROM     Editeur e JOIN Serie s     ON e.numEditeur = s.numEditeur
                   JOIN Bd          ON s.numSerie   = Bd.numSerie
                   JOIN Concerner c ON Bd.isbn      = c.isbn
GROUP BY nomEditeur;

\copy (SELECT sum(quantite) AS nbBDVendu, nomEditeur FROM Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur JOIN Bd ON s.numSerie = Bd.numSerie JOIN Concerner c ON Bd.isbn = c.isbn GROUP BY nomEditeur) TO './Question_B.csv' DELIMITER ';' QUOTE '"' CSV HEADER