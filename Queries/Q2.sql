/*
b) Lister les clients (numéro, nom) et leur nombre d’achats (que l’on nommera nbA) 
triés par ordre décroissant de leur nombre d’achats (sans prendre en compte la quantité achetée)
*/

SELECT c.numClient, c.nomClient, COUNT(v.numClient) AS nbA
FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                JOIN Concerner co ON v.numVente  = co.numVente
GROUP BY c.numClient
ORDER BY nbA DESC;

/*
 numclient |  nomclient  | nba
-----------+-------------+-----
         4 | Poret       |  19
         7 | Don Devello |  12
         6 | Timable     |  12
         8 | Ohm         |  11
         3 | Hauraque    |  11
        10 | Hautine     |   9
         5 | Menvussa    |   9
         9 | Ginal       |   8
         2 | Fissile     |   8
         1 | Torguesse   |   6
        11 | Kament      |   4
(11 lignes)
*/