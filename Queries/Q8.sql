/*
h) Créer et afficher une vue nommée best5 qui liste les 5 meilleurs clients (ayant 
donc dépensé le plus d’argent en BD) en affichant leur numéro, nom et adresse 
mail, ainsi que le nombre total de BD qu’ils ont acheté (champ nbBD en tenant 
compte des quantités achetées), ainsi que le total de leurs achats (champ coutA).
*/

DROP VIEW IF EXISTS best5;

CREATE VIEW best5 AS
SELECT cl.numClient, nomClient, mailClient, SUM(quantite) AS nbBD, SUM(quantite * prixVente) AS totalAchat

FROM   Client cl JOIN Vente v
       ON cl.numClient = v.numClient
       JOIN Concerner co
       ON v.numVente = co.numVente

GROUP BY cl.numClient, nomClient, mailClient

ORDER BY SUM(quantite * prixVente) DESC

LIMIT 5;