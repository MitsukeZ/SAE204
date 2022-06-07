/*
a) Ecrire une procédure qui prend en paramètre un numéro d’auteur dessinateur et
qui renvoie pour chaque titre de BD de l’auteur, le nombre d’exemplaires vendus
de cette BD.
*/

CREATE OR REPLACE FUNCTION getVentesParAuteur(idauteur Auteur.numAuteur%TYPE)
RETURNS Concerner.quantite%TYPE AS
$$

DECLARE
    quantiteTotal Concerner.quantite%TYPE;


BEGIN
    FOR 



END
$$ LANGUAGE plpgsql;