/*
b) Écrire une fonction qui prend en paramètre le nom d’une série de BD et qui
renvoie pour chaque titre de la série le nombre d’exemplaires vendus et le chiffre
d’affaire réalisé par titre.
*/

DROP TYPE IF EXISTS nbVenteAndCa CASCADE;

CREATE TYPE nbVenteAndCa AS (nbExemplaireVendu INTEGER, chiffreDaffaire INTEGER);


CREATE OR REPLACE FUNCTION proc_f(nomDeLaSerie Serie.nomSerie%TYPE)
RETURNS SETOF nbVenteAndCa AS
$$

DECLARE
    nbExemplaireVendu nbVenteAndCa;


BEGIN
    FOR nbExemplaireVendu IN SELECT sum(quantite), sum(prixVente*quantite)
                             FROM   Concerner c   Join Bd      ON c.isbn      = Bd.isbn
                                                  JOIN Serie s ON Bd.numSerie = s.numSerie
                             Where  s.numSerie = (SELECT numSerie
                                                  FROM   Serie
                                                  WHERE  nomSerie = nomDeLaSerie)
                             GROUP BY Bd.isbn
    LOOP
        RETURN NEXT nbExemplaireVendu;
    END LOOP;
END
$$ LANGUAGE plpgsql;