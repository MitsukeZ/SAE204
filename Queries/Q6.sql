/*
f) Lister tous les clients (numéro et nom) ayant acheté des 
BD de la série ‘Astérix le gaulois’.
*/

SELECT DISTINCT c.numClient, c.nomClient
FROM            Client c JOIN Vente v      ON c.numClient = v.numClient
                         JOIN Concerner co ON v.numVente  = co.numVente
                         JOIN BD           ON co.isbn     = BD.isbn
                         JOIN Serie s      ON BD.numSerie = s.numSerie
WHERE s.nomSerie = 'Asterix le gaulois';

/*
 numclient |  nomclient  
-----------+-------------
         1 | Torguesse
         2 | Fissile
         3 | Hauraque
         4 | Poret
         5 | Menvussa
         6 | Timable
         7 | Don Devello
         8 | Ohm
         9 | Ginal
        10 | Hautine
        11 | Kament
(11 lignes)
*/