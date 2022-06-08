/*
c) Écrire une fonction qui prend en paramètre un nom d’éditeur et un nom d’auteur
dessinateur et un nom d’auteur scénariste, et qui renvoie la liste des BD de ces
auteurs éditées par l’éditeur choisi. Si l’éditeur n’a pas édité de BD de ces
auteurs, ou qu’il n’existe pas de BD de ces deux auteurs, on devra générer le
message suivant « l’éditeur % n’a pas édité de BD des auteurs % et %» où on
remplacera les « % » par les noms correspondants.
*/

CREATE OR REPLACE FUNCTION proc_c(nomDediteur    Editeur.nomEditeur%TYPE,
                                  nomDessinateur Auteur.nomAuteur%TYPE,
                                  nomScenariste  Auteur.nomAuteur%TYPE)
RETURNS SETOF Bd AS
$$

DECLARE
    idSerie Serie.numSerie%TYPE;
    nomDeLediteur Editeur.nomEditeur%TYPE;
    bdCorrect Bd;

BEGIN
    RETURN QUERY SELECT Bd.* FROM Bd JOIN Serie  s ON Bd.numSerie = s.numSerie
                                     JOIN Auteur a ON Bd.numAuteurDessinateur = a.numAuteur
                                     JOIN Auteur au ON Bd.numAuteurScenariste = au.numAuteur

                 WHERE s.numSerie IN (SELECT numSerie
                                     FROM   Serie s JOIN Editeur e ON S.numEditeur = e.numEditeur
                                     Where nomEditeur = nomDediteur)

                 AND Bd.numAuteurDessinateur = (SELECT numAuteur
                                                FROM   Auteur
                                                WHERE  nomAuteur = nomDessinateur)

                 AND Bd.numAuteurScenariste  = (SELECT numAuteur
                                                FROM   Auteur
                                                WHERE  nomAuteur = nomScenariste);

    IF (NOT FOUND) THEN
        RAISE EXCEPTION USING MESSAGE = 'l''éditeur ' || nomDediteur || ' n''a pas édité de BD des auteurs ' || nomDessinateur || ' et ' || nomScenariste;
    END IF;
END
$$ LANGUAGE plpgsql;