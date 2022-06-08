/*
d) Créer une fonction qui prend en paramètre le nom d’une série de BD et
qui renvoie les clients ayants acheté tous les albums de la série (utiliser des
boucles FOR et/ou des curseurs).
Si aucun client ne répond à la requête alors on affichera un message
d’avertissement ‘Aucun client n’a acheté tous les exemplaires de la série %’, en
complétant le ‘ %’ par le nom de la série.
*/

DROP FUNCTION IF EXISTS getClientSerieComplete(paramSerie Serie.nomSerie%TYPE);

CREATE OR REPLACE FUNCTION getClientSerieComplete(paramSerie Serie.nomSerie%TYPE) RETURNS SETOF Client
AS $$
    DECLARE
        nbVolumes INT;
    BEGIN
        --Récupération du nombre de volumes de la série
        SELECT count(*) INTO nbVolumes
        FROM   BD JOIN Serie s ON BD.numSerie = s.numSerie
        WHERE  s.nomSerie = paramSerie;

        IF (NOT FOUND) THEN
            RAISE EXCEPTION 'Série Inexistante';
        END IF;

        PERFORM DISTINCT c.* FROM Client c JOIN Vente v      ON c.numClient  = v.numClient
                            JOIN Concerner co ON v.numVente   = co.numVente
                            JOIN BD           ON co.isbn      = BD.isbn
                            JOIN Serie s      ON BD.numSerie  = s.numSerie
        GROUP BY c.numClient
        HAVING   COUNT(BD.isbn) = nbVolumes;

        IF (NOT FOUND) THEN
            RAISE EXCEPTION USING MESSAGE = 'Aucun client n’a acheté tous les exemplaires de la série ' || paramSerie;
        END IF;

        RETURN QUERY SELECT DISTINCT c.* 
                     FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                     JOIN Concerner co ON v.numVente   = co.numVente
                                     JOIN BD           ON co.isbn      = BD.isbn
                                     JOIN Serie s      ON BD.numSerie  = s.numSerie
                     GROUP BY c.numClient
                     HAVING   COUNT(BD.isbn) = nbVolumes;


    END
$$ LANGUAGE PLPGSQL;

