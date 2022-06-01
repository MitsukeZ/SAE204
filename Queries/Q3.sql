/*
c) Lister les clients (numéro, nom) avec leur coût total d’achats 
(que l’on nommera coutA) triés par leur coût décroissant, 
qui ont totalisé au moins 50000€ d’achats..
*/

SELECT c.numClient, c.nomClient, SUM(co.prixVente*co.quantite) AS coutA
FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                JOIN Concerner co ON v.numVente  = co.numVente
GROUP BY c.numClient
HAVING   SUM(co.prixVente*co.quantite) >= 50000
ORDER BY coutA DESC;

/*
 numclient |  nomclient  |  couta
-----------+-------------+----------
         4 | Poret       | 129141.2
         6 | Timable     |  93406.5
         8 | Ohm         |  92865.9
         7 | Don Devello |  82909.4
         9 | Ginal       |  66003.9
        10 | Hautine     |  59519.1
         5 | Menvussa    |  56772.3
         3 | Hauraque    |    51684
(8 lignes)
*/