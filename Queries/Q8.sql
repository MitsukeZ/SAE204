/*
h) Créer et afficher une vue nommée best5 qui liste les 5 meilleurs clients (ayant 
donc dépensé le plus d’argent en BD) en affichant leur numéro, nom et adresse 
mail, ainsi que le nombre total de BD qu’ils ont acheté (champ nbBD en tenant 
compte des quantités achetées), ainsi que le total de leurs achats (champ coutA).
*/

DROP VIEW IF EXISTS best5;

CREATE VIEW best5 AS
SELECT numClient, nomClient, mailClient, SUM(quantite) AS nbBD

FROM   Client cl JOIN Vente v
       ON cl.numClient = v.numClient
       JOIN Concerner co
       ON v.numVente = co.numVente

ORDER BY SUM(quantite * prixVente)

LIMIT 5;