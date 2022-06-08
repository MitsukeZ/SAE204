/*
a) Ecrire une procédure qui prend en paramètre un numéro d’auteur dessinateur et
qui renvoie pour chaque titre de BD de l’auteur, le nombre d’exemplaires vendus
de cette BD.
*/

CREATE OR REPLACE FUNCTION getVentesParAuteur(numDessinateur Auteur.numAuteur%TYPE)
RETURNS SETOF Concerner.quantite%TYPE AS
$$

DECLARE
    qte Concerner.quantite%TYPE;

BEGIN
    FOR qte IN SELECT   sum(quantite)
                 FROM     Concerner c JOIN Bd ON c.isbn = Bd.isbn
                 WHERE    numAuteurDessinateur = numDessinateur
                 GROUP BY Bd.isbn
    LOOP
        return NEXT qte;
    END LOOP;
END
$$ LANGUAGE plpgsql;