/*
e) Créer une fonction qui prend en paramètre un nombre nbBD de BD et une année
donnée, et qui renvoie la liste des éditeurs ayant vendu au moins ce nombre de
BD dans l’année en question. Si aucun éditeur ne répond à la requête, le signaler
par un message approprié.
*/

create or replace function getInfonbBdAnnee(nbBd int,dateBD int)
returns SETOF Editeur
as $$

DECLARE
    resultat Editeur;
    sommeQteAcheter Concerner.quantite%TYPE;

BEGIN
    FOR sommeQteAcheter IN SELECT sum(c.quantite) FROM Concerner c NATURAL JOIN Editeur e GROUP BY e.numEditeur

    LOOP
        SELECT DISTINCT (ed.*) INTO resultat
        FROM BD bd join Concerner co on co.isbn       = bd.isbn
                   join Vente ve     on co.numVente   = ve.numVente
                   join Serie se     on se.numSerie   = bd.numSerie
                   join Editeur ed   on ed.numEditeur = se.numEditeur

        WHERE ed.numEditeur in (Select numEditeur
                                From   Serie
                                Where  numSerie in (Select  numserie
                                                    From    BD
                                                    Where   isbn in (Select isbn
                                                                    From   Concerner
                                                                    Where  sommeQteAcheter >= nbBd and
                                                                            numVente in (select numVente
                                                                                        from   Vente
                                                                                        where  EXTRACT(YEAR FROM dteVente) = dateBD))));
    END LOOP;

    LOOP
        RETURN NEXT resultat;
    END LOOP;

    IF (NOT FOUND) THEN
    RAISE EXCEPTION USING MESSAGE = 'Aucun éditeur n’a pas édité autant de BD a cette date ';
    END IF;

END
$$ language plpgsql;