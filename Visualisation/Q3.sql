/*
c) Proposer une troisième représentation graphique d’une donnée que vous
choisirez à visualiser
*/
/*
Le nombre d'achat par client
*/

SELECT sum(quantite) AS nbBdAcheter, nomClient
FROM Client c JOIN Vente v ON c.numClient = v.numClient
              JOIN Concerner co ON v.numVente = co.numVente
GROUP BY c.numClient;

(SELECT sum(quantite) AS nbBdAcheter, nomClient FROM Client c JOIN Vente v ON c.numClient = v.numClient JOIN Concerner co ON v.numVente = co.numVente GROUP BY c.numClient) TO './Question_B.csv' DELIMITER ';' QUOTE '"' CSV HEADER