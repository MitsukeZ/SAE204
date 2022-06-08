/*
f) Écrire une fonction qui prend en paramètre une année donnée, et un nom
d’éditeur et qui renvoie le(s) tuple(s) comportant l’année et le nom de l’éditeur
d’une part, associé au nom et email du(des) client(s) d’autre part ayant acheté le
plus de BD cette année-là chez cet éditeur.
*/

SELECT *
FROM (SELECT EXTRACT(YEAR FROM v.dteVente)::INT as annee, e.nomEditeur, c.nomClient, c.mailClient, SUM(co.quantite) as qte
                     FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                     JOIN Concerner co ON v.numVente   = co.numVente
                                     JOIN BD           ON co.isbn      = BD.isbn
                                     JOIN Serie s      ON BD.numSerie  = s.numSerie
                                     JOIN Editeur e    ON s.numEditeur = e.numEditeur
                     GROUP BY EXTRACT(YEAR FROM v.dteVente), e.nomEditeur, c.nomClient, c.mailClient
                     HAVING   e.nomEditeur = 'Dargaud' AND
                              EXTRACT(YEAR FROM v.dteVente) = 2000) AS query
WHERE qte = (SELECT MAX(qte) FROM (SELECT EXTRACT(YEAR FROM v.dteVente)::INT as annee, e.nomEditeur, c.nomClient, c.mailClient, SUM(co.quantite) as qte
                     FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                     JOIN Concerner co ON v.numVente   = co.numVente
                                     JOIN BD           ON co.isbn      = BD.isbn
                                     JOIN Serie s      ON BD.numSerie  = s.numSerie
                                     JOIN Editeur e    ON s.numEditeur = e.numEditeur
                     GROUP BY EXTRACT(YEAR FROM v.dteVente), e.nomEditeur, c.nomClient, c.mailClient
                     HAVING   e.nomEditeur = 'Dargaud' AND
                              EXTRACT(YEAR FROM v.dteVente) = 2000) AS query);
/*
SELECT EXTRACT(YEAR FROM v.dteVente)::INT, e.nomEditeur, c.nomClient, c.mailClient
                     FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                     JOIN Concerner co ON v.numVente   = co.numVente
                                     JOIN BD           ON co.isbn      = BD.isbn
                                     JOIN Serie s      ON BD.numSerie  = s.numSerie
                                     JOIN Editeur e    ON s.numEditeur = e.numEditeur
                     GROUP BY EXTRACT(YEAR FROM v.dteVente), e.nomEditeur, c.nomClient, c.mailClient
                     HAVING   e.nomEditeur = 'Dargaud' AND
                              EXTRACT(YEAR FROM v.dteVente) = 2000;*/



DROP TYPE IF EXISTS ClientMaxi CASCADE;

CREATE TYPE ClientMaxi AS (
    annee INT,
    nomEditeur VARCHAR(23),
    nomClient  VARCHAR(11),
    mailClient TEXT
);

DROP FUNCTION IF EXISTS getClientsDeLannee(paramAnnee INT, paramEditeur Editeur.nomEditeur%TYPE);

CREATE OR REPLACE FUNCTION getClientsDeLannee(paramAnnee INT, paramEditeur Editeur.nomEditeur%TYPE) RETURNS SETOF ClientMaxi
AS $$
    BEGIN
        RETURN QUERY SELECT annee, nomEditeur, nomClient, mailClient
                     FROM (SELECT EXTRACT(YEAR FROM v.dteVente)::INT as annee, e.nomEditeur, c.nomClient, c.mailClient, SUM(co.quantite) as qte
                           FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                           JOIN Concerner co ON v.numVente   = co.numVente
                                           JOIN BD           ON co.isbn      = BD.isbn
                                           JOIN Serie s      ON BD.numSerie  = s.numSerie
                                           JOIN Editeur e    ON s.numEditeur = e.numEditeur
                           GROUP BY EXTRACT(YEAR FROM v.dteVente), e.nomEditeur, c.nomClient, c.mailClient
                           HAVING   e.nomEditeur = paramEditeur AND
                                    EXTRACT(YEAR FROM v.dteVente) = paramAnnee) AS query
                     WHERE qte = (SELECT MAX(qte) 
                                  FROM (SELECT EXTRACT(YEAR FROM v.dteVente)::INT as annee, e.nomEditeur, c.nomClient, c.mailClient, SUM(co.quantite) as qte
                                        FROM   Client c JOIN Vente v      ON c.numClient  = v.numClient
                                                        JOIN Concerner co ON v.numVente   = co.numVente
                                                        JOIN BD           ON co.isbn      = BD.isbn
                                                        JOIN Serie s      ON BD.numSerie  = s.numSerie
                                                        JOIN Editeur e    ON s.numEditeur = e.numEditeur
                                        GROUP BY EXTRACT(YEAR FROM v.dteVente), e.nomEditeur, c.nomClient, c.mailClient
                                        HAVING   e.nomEditeur = paramEditeur AND
                                                 EXTRACT(YEAR FROM v.dteVente) = paramAnnee) AS query);
    END
$$ LANGUAGE PLPGSQL;
