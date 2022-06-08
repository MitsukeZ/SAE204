/*
h) Ecrire une fonction qui renvoie pour tous les clients sa plus petite quantité
achetée (min) et sa plus grande quantité achetée (max) et la somme totale de ses
quantités achetées de BD.
Vous devrez donc créer un type composite ‘clientBD’ comportant quatre
attributs: l'identifiant du client, son nom, sa plus petite quantité achetée, sa plus
grande quantité achetée, et la somme totale de ses quantités achetées. Votre
procédure devra retourner des éléments de ce type de données.
On rajoutera le comportement suivant : si le minimum est égal au maximum pour
un client, on affichera le message 'Egalité du minimum et maximum pour le
client %' en précisant le nom du client.
*/

DROP TYPE IF EXISTS clientBD CASCADE;

CREATE TYPE clientBD AS (
    numClient INT,
    nomClient VARCHAR(11),
    qteMin    INT,
    qteMax    INT,
    qteTotale INT
);

DROP FUNCTION IF EXISTS getQteMinMaxClients();

CREATE OR REPLACE FUNCTION getQteMinMaxClients() RETURNS SETOF clientBD
AS $$
    DECLARE
        tuple clientBD;
    BEGIN
        FOR tuple IN SELECT c.numClient, c.nomClient, MIN(co.quantite), MAX(co.quantite), SUM(co.quantite)
                     FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                                     JOIN Concerner co ON v.numVente  = co.numVente
                     GROUP BY c.numClient, c.nomClient
        LOOP
            RETURN NEXT tuple;
        END LOOP;
    END
$$ LANGUAGE PLPGSQL;

SELECT * FROM getQteMinMaxClients();