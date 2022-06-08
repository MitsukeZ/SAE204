/*
a) représenter dans le tableur de Libre Office par une courbe des valeurs
d’évolution des ventes de BD (chiffre d’affaires) par année de vente (dans l’ordre
croissant des années). Les années sont en abscisse et le chiffre d’affaire en
ordonnée.
*/

SELECT   EXTRACT(YEAR FROM dteVente) AS annee, sum(quantite*prixVente) AS Chiffre_affaire
FROM     Concerner NATURAL JOIN Vente
GROUP BY EXTRACT(YEAR FROM dteVente)
ORDER BY EXTRACT(YEAR FROM dteVente) ASC;


\copy (SELECT EXTRACT(YEAR FROM dteVente), sum(quantite*prixVente) AS Chiffre_affaire FROM   Concerner NATURAL JOIN Vente GROUP BY EXTRACT(YEAR FROM dteVente) ORDER BY EXTRACT(YEAR FROM dteVente) ASC;) TO './Question_A.csv' DELIMITER ';' QUOTE '"' CSV HEADER