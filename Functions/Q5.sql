/*
e) Créer une fonction qui prend en paramètre un nombre nbBD de BD et une année
donnée, et qui renvoie la liste des éditeurs ayant vendu au moins ce nombre de
BD dans l’année en question. Si aucun éditeur ne répond à la requête, le signaler
par un message approprié.
*/

DROP FUNCTION IF EXISTS getInfoNbBdAnnee(nbBD INT, anneeBD INT);

CREATE OR REPLACE FUNCTION getInfoNbBdAnnee(nbBD INT, anneeBD INT) RETURNS SETOF Editeur
AS $$
    BEGIN
        PERFORM e.*
                     FROM   Editeur e JOIN Serie s      ON e.numEditeur = s.numEditeur
                                      JOIN BD           ON s.numSerie   = BD.numSerie
                                      JOIN Concerner co ON BD.isbn      = co.isbn
                                      JOIN Vente v      ON co.numVente  = v.numVente
                     WHERE EXTRACT(YEAR FROM v.dteVente) = anneeBD
                     GROUP BY e.numEditeur
                     HAVING SUM(co.quantite) >= nbBD;

        IF (NOT FOUND) THEN
            RAISE EXCEPTION 'Aucun éditeur n''a vendu autant/plus de BD que le nombre en paramètre';
        END IF;
        
        RETURN QUERY SELECT e.*
                     FROM   Editeur e JOIN Serie s      ON e.numEditeur = s.numEditeur
                                      JOIN BD           ON s.numSerie   = BD.numSerie
                                      JOIN Concerner co ON BD.isbn      = co.isbn
                                      JOIN Vente v      ON co.numVente  = v.numVente
                     WHERE EXTRACT(YEAR FROM v.dteVente) = anneeBD
                     GROUP BY e.numEditeur
                     HAVING SUM(co.quantite) >= nbBD;
    END
$$ LANGUAGE PLPGSQL;

SELECT * FROM getInfoNbBdAnnee(500, 2020);
