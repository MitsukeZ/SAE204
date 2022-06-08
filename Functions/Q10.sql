/*
j) On souhaite classer tous les clients par leur quantité totale d'achats de BD. Ainsi
on veut associer à chaque client son rang de classement en tant qu'acheteur dans
l'ordre décroissant des quantités achetées. Ainsi le client de rang 1 (classé
premier) aura totalisé le plus grand nombre d'achats.
Vous devez donc créer un nouveau type de données ‘rangClient’, qui associe
l'identifiant du client, son nom et son classement dans les acheteurs (attribut
nommé ‘rang’).
Ecrire une procédure qui renvoie pour tous les clients, son identifiant, son nom et
son classement d'acheteur décrit ci-dessus.
NB : on pourra avantageusement utiliser une boucle FOR ou un curseur...
*/

DROP TYPE IF EXISTS rangClient CASCADE;

CREATE TYPE rangClient AS (
    numClient  INT,
    nomClient  VARCHAR(11),
    rang       INT
);

DROP FUNCTION IF EXISTS getClassementClients();

CREATE OR REPLACE FUNCTION getClassementClients() RETURNS SETOF rangClient
AS $$
    DECLARE
        tuple rangClient;
        cpt   INT;
    BEGIN
        
        cpt := 1;
        FOR tuple IN SELECT c.numClient, c.nomClient
                     FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                                     JOIN Concerner co ON v.numVente  = co.numVente
                     GROUP BY c.numClient
                     ORDER BY SUM(co.quantite) DESC
        LOOP
            
            tuple.rang := cpt;
            cpt := cpt + 1;
            RETURN NEXT tuple;
        END LOOP;
    END
$$ LANGUAGE PLPGSQL;

SELECT * FROM getClassementClients();
