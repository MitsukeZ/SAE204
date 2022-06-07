/*
g) Lister les clients (numéro et nom) qui n’ont acheté que les BD de la série ‘Asterix
le gaulois’ (en utilisant la clause EXCEPT)
*/

SELECT DISTINCT c.numClient, c.nomClient
FROM            Client c JOIN Vente v      ON c.numClient = v.numClient
                         JOIN Concerner co ON v.numVente  = co.numVente
                         JOIN BD           ON co.isbn     = BD.isbn
                         JOIN Serie s      ON BD.numSerie = s.numSerie
EXCEPT
SELECT DISTINCT c.numClient, c.nomClient
FROM            Client c JOIN Vente v      ON c.numClient = v.numClient
                         JOIN Concerner co ON v.numVente  = co.numVente
                         JOIN BD           ON co.isbn     = BD.isbn
                         JOIN Serie s      ON BD.numSerie = s.numSerie
WHERE s.nomSerie != 'Asterix le gaulois';

/*
 numclient | nomclient 
-----------+-----------
         3 | Hauraque
(1 ligne)
*/