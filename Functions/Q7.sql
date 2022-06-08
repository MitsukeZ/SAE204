/*
g) Écrire une procédure SQL utilisant un curseur, qui classe pour un éditeur dont le
nom est donné en entrée, les clients de cet éditeur en trois catégories selon le
nombre de BD qu’ils leur ont achetées : les « très bons clients » (plus de 10
achats strictement), les « bons clients » (entre 2 et 10 BD), les « mauvais
clients » (moins ou égal à 2 BD)
*/

DROP TYPE IF EXISTS classementClients CASCADE;

CREATE TYPE classementClients AS (
    numClient          INT,
    nomClient          VARCHAR(11),
    numTelClient       TEXT,
	mailClient         TEXT,
    rang               TEXT
);

DROP FUNCTION IF EXISTS classerClients(paramEditeur Editeur.nomEditeur%TYPE);

CREATE OR REPLACE FUNCTION classerClients(paramEditeur Editeur.nomEditeur%TYPE) RETURNS SETOF classementClients
AS $$
    DECLARE
        curs CURSOR FOR SELECT c.*
                        FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                        JOIN Concerner co ON v.numVente   = co.numVente
                                        JOIN BD           ON co.isbn      = BD.isbn
                                        JOIN Serie s      ON BD.numSerie  = s.numSerie
                                        JOIN Editeur e    ON s.numEditeur = e.numEditeur 
                        GROUP BY c.numClient, e.nomEditeur
                        HAVING e.nomEditeur = paramEditeur; 
        
        tuple        classementClients;
        nbBDAchetees INT;
    BEGIN
        OPEN curs;
        LOOP
            FETCH curs INTO tuple;
            EXIT WHEN NOT FOUND;

            SELECT COUNT(co.isbn) INTO nbBDAchetees
            FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                            JOIN Concerner co ON v.numVente   = co.numVente
                            JOIN BD           ON co.isbn      = BD.isbn
                            JOIN Serie s      ON BD.numSerie  = s.numSerie
                            JOIN Editeur e    ON s.numEditeur = e.numEditeur 
            GROUP BY c.numClient, e.nomEditeur
            HAVING   e.nomEditeur = paramEditeur AND
                     c.numClient  = tuple.numClient;

            IF (nbBDAchetees <= 2) THEN 
                tuple.rang := 'mauvais client';
            END IF;
            
            IF (nbBDAchetees > 10) THEN 
                tuple.rang := 'très bon client';
            END IF;
                
            IF (nbBDAchetees > 2 AND nbBDAchetees <= 10) THEN 
                tuple.rang := 'bon client';
            END IF;

            RETURN NEXT tuple;
            
        END LOOP;

    END
$$ LANGUAGE PLPGSQL;

