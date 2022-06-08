/*
d) Créer une fonction qui prend en paramètre le nom d’une série de BD et
qui renvoie les clients ayants acheté tous les albums de la série (utiliser des
boucles FOR et/ou des curseurs).
Si aucun client ne répond à la requête alors on affichera un message
d’avertissement ‘Aucun client n’a acheté tous les exemplaires de la série %’, en
complétant le ‘ %’ par le nom de la série.
*/

CREATE OR REPLACE FUNCTION proc_d(nomDeSerie Serie.nomSerie%TYPE)
RETURNS SETOF Client AS

DECLARE
    client Client;


BEGIN
    FOR client IN SELECT c.* FROM Client c WHERE 


    IF (NOT FOUND) THEN
        RAISE EXCEPTION USING MESSAGE = 'Aucun client n''a acheté tous les exemplaires de la série' || nomDeSerie;

END
$$ LANGUAGE plpgsql