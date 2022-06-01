/*
b) Lister les clients (numéro, nom) et leur nombre d’achats (que l’on nommera nbA) 
triés par ordre décroissant de leur nombre d’achats (sans prendre en compte la quantité achetée)
*/

SELECT c.numClient, c.nomClient, SUM(co.quantite) AS nbA
FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                JOIN Concerner co ON v.numVente  = co.numVente
GROUP BY c.numClient
ORDER BY nbA DESC;

/*
 numclient |  nomclient  | nba  
-----------+-------------+------
         4 | Poret       | 8816
         6 | Timable     | 6639
         8 | Ohm         | 6159
         7 | Don Devello | 5664
         9 | Ginal       | 4564
         3 | Hauraque    | 4307
         5 | Menvussa    | 4093
        10 | Hautine     | 3865
         2 | Fissile     | 3651
         1 | Torguesse   | 2645
        11 | Kament      | 1691
(11 rows)
*/