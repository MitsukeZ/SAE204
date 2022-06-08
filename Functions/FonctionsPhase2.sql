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



SELECT * FROM getVentesParAuteur(3);

/*
 getventesparauteur 
--------------------
                574
                354
*/

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

SELECT * FROM proc_f('Asterix le gaulois');

/*
 nbexemplairevendu | chiffredaffaire 
-------------------+-----------------
                57 |             684
                34 |             408
               137 |            1644
               426 |            5112
               561 |            6732
               358 |            4296
               567 |            6804
               737 |            8844
               234 |            2808
                43 |             516
               225 |            2700
               624 |            7488
               326 |            3912
               562 |            6744
               367 |            4404
               938 |           11256
               657 |            7884
               742 |            8904
               359 |            4308
               825 |            9900
               327 |            3924
                95 |            1140
               357 |            4284
                32 |             384
               187 |            2244
               436 |            5232
               499 |            5988
               588 |            7056
               452 |            5424
               826 |            9912
               576 |            6912
               415 |            4980
               924 |           11088
               736 |            8832
               308 |            3696
               137 |            1644
                35 |             420
               857 |           10284
               667 |            8004
*/

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

SELECT * FROM proc_c('Dargaud', 'Uderzo', 'Goscinny');

/*
       isbn        |                       titre                       | prixactuel | numtome | numserie | numauteurdessinateur | numauteurscenariste 
-------------------+---------------------------------------------------+------------+---------+----------+----------------------+---------------------
 978-2-2050-0096-2 | Astérix le gaulois                                |         12 |       1 |        2 |                   31 |                  14
 978-2-0121-0134-0 | La serpe d or                                     |         12 |       2 |        2 |                   31 |                  14
 978-2-0121-0135-7 | Astérix et les Goths                              |         12 |       3 |        2 |                   31 |                  14
 978-2-0121-0136-4 | Astérix Gladiateur                                |         12 |       4 |        2 |                   31 |                  14
 978-2-0121-0137-1 | Le tour de Gaule d Astérix                        |         12 |       5 |        2 |                   31 |                  14
 978-2-0121-0138-8 | Astérix et Cléopâtre                              |         12 |       6 |        2 |                   31 |                  14
 978-2-0121-0139-5 | Le combat des chefs                               |         12 |       7 |        2 |                   31 |                  14
 978-2-0121-0140-1 | Astérix chez les Bretons                          |         12 |       8 |        2 |                   31 |                  14
 978-2-0121-0141-8 | Astérix et les Normands                           |         12 |       9 |        2 |                   31 |                  14
 978-2-0121-0142-5 | Astérix Légionnaire                               |         12 |      10 |        2 |                   31 |                  14
 978-2-0121-0143-2 | Le bouclier Arverne                               |         12 |      11 |        2 |                   31 |                  14
 978-2-0121-0144-9 | Astérix aux jeux Olympiques                       |         12 |      12 |        2 |                   31 |                  14
 978-2-0121-0145-6 | Astérix et le chaudron                            |         12 |      13 |        2 |                   31 |                  14
 978-2-0121-0146-3 | Astérix en Hispanie                               |         12 |      14 |        2 |                   31 |                  14
 978-2-0121-0147-0 | La zizanie                                        |         12 |      15 |        2 |                   31 |                  14
 978-2-0121-0148-7 | Astérix chez les Helvètes                         |         12 |      16 |        2 |                   31 |                  14
 978-2-0121-0149-4 | Le domaine des dieux                              |         12 |      17 |        2 |                   31 |                  14
 978-2-0121-0150-0 | Les lauriers de César                             |         12 |      18 |        2 |                   31 |                  14
 978-2-0121-0151-7 | Le devin                                          |         12 |      19 |        2 |                   31 |                  14
 978-2-0121-0152-4 | Astérix en Corse                                  |         12 |      20 |        2 |                   31 |                  14
 978-2-0121-0153-1 | Le cadeau de César                                |         12 |      21 |        2 |                   31 |                  14
 978-2-0121-0154-8 | La grande traversée                               |         12 |      22 |        2 |                   31 |                  14
 978-2-0121-0155-5 | Obélix et compagnie                               |         12 |      23 |        2 |                   31 |                  14
 978-2-0121-0156-2 | Astérix chez les Belges                           |         12 |      24 |        2 |                   31 |                  14
 978-2-8649-7153-5 | Astérix et la rentrée gauloise                    |         12 |      32 |        2 |                   31 |                  14
 978-2-8649-7230-3 | L Anniversaire d Astérix & Obélix - Le livre d Or |         12 |      34 |        2 |                   31 |                  14
(26 rows)
*/

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

SELECT * FROM getClientSerieComplete('L histoire des 3 Adolf');

/*
 numclient | nomclient |  numtelclient  | mailclient 
-----------+-----------+----------------+------------
        11 | Kament    | 08 21 24 15 54 | 
(1 row)
*/

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

SELECT * FROM getInfoNbBdAnnee(500, 2021);

/*
 numediteur |  nomediteur   |                      adresseediteur                       | numtelediteur  |           mailediteur            
------------+---------------+-----------------------------------------------------------+----------------+----------------------------------
          1 | Delcourt      | 8     rue Leon Jouhaux,         75010  Paris              | 01 56 03 92 20 | accueil-paris@groupedelcourt.com
          7 | Vents d Ouest | 31/33 rue Ernest-Renan          92130 Issy-les-Moulineaux | 04 50 27 85 41 | ventsdouest@videotron.com
          8 | Lombard       | 57    rue Gaston TessierF 7     5019 Paris                |                | info@Lombard.be
(3 rows)
*/

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

SELECT * FROM getClientsDeLannee(2021, 'Delcourt');

/*
 annee | nomediteur | nomclient |  mailclient  
-------+------------+-----------+--------------
  2021 | Delcourt   | Fissile   | mail@ange.fr
(1 row)
*/

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

SELECT * FROM classerClients('Dargaud');

/*
 numclient |  nomclient  |  numtelclient  |   mailclient    |      rang       
-----------+-------------+----------------+-----------------+-----------------
         1 | Torguesse   | 03 33 08 67 87 | mail@lisse.com  | bon client
         2 | Fissile     | 04 98 04 71 29 | mail@ange.fr    | bon client
         3 | Hauraque    | 06 37 46 13 75 | mail@odie.net   | très bon client
         4 | Poret       | 04 04 05 36 45 | mail@he.fr      | bon client
         5 | Menvussa    | 08 71 72 00 86 | mail@lisse.com  | mauvais client
         6 | Timable     | 06 56 53 01 40 | mail@limelo.com | bon client
         7 | Don Devello | 08 78 63 01 68 | mail@he.fr      | bon client
         8 | Ohm         | 06 17 76 81 86 | mail@odie.net   | mauvais client
         9 | Ginal       | 08 89 78 48 51 | mail@ange.fr    | mauvais client
        10 | Hautine     | 02 75 25 73 17 | mail@bas.com    | mauvais client
        11 | Kament      | 08 21 24 15 54 |                 | mauvais client
(11 rows)
*/

/*
h) Ecrire une fonction qui renvoie pour tous les clients sa plus petite quantité
achetée (min) et sa plus grande quantité achetée (max) et la somme totale de ses
quantités achetées de BD.
Vous devrez donc créer un type composite ‘clientBD’ comportant quatre
attributs: l'identifiant du client, son nom, sa plus petite quantité achetée, sa plus
grande quantité achetée, et la somme totale de ses quantités achetées. Votre
procédure devra retourner des éléments de ce type de données.
On rajoutera le comportement suivant : si le minimum est égal au maximum pour
un client, on affichera le message 'Egalité du minimum et maximum pour le
client %' en précisant le nom du client.
*/

DROP TYPE IF EXISTS clientBD CASCADE;

CREATE TYPE clientBD AS (
    numClient INT,
    nomClient VARCHAR(11),
    qteMin    INT,
    qteMax    INT,
    qteTotale INT
);

DROP FUNCTION IF EXISTS getQteMinMaxClients();

CREATE OR REPLACE FUNCTION getQteMinMaxClients() RETURNS SETOF clientBD
AS $$
    DECLARE
        tuple clientBD;
    BEGIN
        FOR tuple IN SELECT c.numClient, c.nomClient, MIN(co.quantite), MAX(co.quantite), SUM(co.quantite)
                     FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                                     JOIN Concerner co ON v.numVente  = co.numVente
                     GROUP BY c.numClient, c.nomClient
        LOOP
            RETURN NEXT tuple;
        END LOOP;
    END
$$ LANGUAGE PLPGSQL;

SELECT * FROM getQteMinMaxClients();
/*
 numclient |  nomclient  | qtemin | qtemax | qtetotale 
-----------+-------------+--------+--------+-----------
         4 | Poret       |     72 |    784 |      8816
        10 | Hautine     |    137 |    976 |      3865
         6 | Timable     |     34 |   1345 |      6639
         2 | Fissile     |     35 |    924 |      3651
        11 | Kament      |    346 |    576 |      1691
         9 | Ginal       |    447 |    857 |      4564
         7 | Don Devello |    253 |    796 |      5664
         3 | Hauraque    |     32 |    742 |      4307
         1 | Torguesse   |    225 |    938 |      2645
         5 | Menvussa    |    135 |    976 |      4093
         8 | Ohm         |    274 |   1346 |      6159
(11 rows)
*/

/*
i) Ecrire une procédure qui supprime une vente dont l'identifiant est passé en
paramètre.

Vérifier d'abord que la vente associée à l'identifiant existe, si elle n'existe pas
afficher un message d'erreur le mentionnant; si elle existe on la supprime.
Cette suppression va générer une violation de clé étrangère dans la table
‘Concerner’.
Pour gérer cela, on utilisera le code d'erreur FOREIGN_KEY_VIOLATION
dans un bloc EXCEPTION dans lequel on supprimera tous les tuples de la table
‘Concerner’ qui possèdent ce numéro de vente, avant de supprimer la vente elle-
même. On pourra au passage afficher aussi un message d'avertissement sur cette
exception.
*/

DROP FUNCTION IF EXISTS supprimerVente(idVente Vente.numVente%TYPE);

CREATE OR REPLACE FUNCTION supprimerVente(idVente Vente.numVente%TYPE) RETURNS VOID
AS $$
    BEGIN
        --Vérification de l'existence de la vente passée en paramètre
        PERFORM * FROM Vente WHERE numVente = idVente;

        IF (NOT FOUND) THEN
            RAISE EXCEPTION 'Vente inexistante !';
        END IF;

        --Suppression de la vente
        DELETE FROM Vente WHERE numVente = idVente;
    
    EXCEPTION
        WHEN FOREIGN_KEY_VIOLATION THEN
            RAISE NOTICE 'Suppression des informations concernées par la Vente';
            DELETE FROM Concerner WHERE numVente = idVente;
            DELETE FROM Vente WHERE numVente = idVente;
    
    END
$$ LANGUAGE PLPGSQL;

/*
j) On souhaite classer tous les clients par leur quantité totale d'achats de BD. Ainsi
on veut associer à chaque client son rang de classement en tant qu'acheteur dans
l'ordre décroissant des quantités achetées. Ainsi le client de rang 1 (classé
premier) aura totalisé le plus grand nombre d'achats.
Vous devez donc créer un nouveau type de données ‘rangClient’, qui associe
l'identifiant du client, son nom et son classement dans les acheteurs (attribut
nommé ‘rang’).
Ecrire une procédure qui renvoie pour tous les clients, son identifiant, son nom et
son classement d'acheteur décrit ci-dessus.
NB : on pourra avantageusement utiliser une boucle FOR ou un curseur...
*/

DROP TYPE IF EXISTS rangClient CASCADE;

CREATE TYPE rangClient AS (
    numClient  INT,
    nomClient  VARCHAR(11),
    rang       INT
);

DROP FUNCTION IF EXISTS getClassementClients();

CREATE OR REPLACE FUNCTION getClassementClients() RETURNS SETOF rangClient
AS $$
    DECLARE
        tuple rangClient;
        cpt   INT;
    BEGIN
        
        cpt := 1;
        FOR tuple IN SELECT c.numClient, c.nomClient
                     FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                                     JOIN Concerner co ON v.numVente  = co.numVente
                     GROUP BY c.numClient
                     ORDER BY SUM(co.quantite) DESC
        LOOP
            
            tuple.rang := cpt;
            cpt := cpt + 1;
            RETURN NEXT tuple;
        END LOOP;
    END
$$ LANGUAGE PLPGSQL;

SELECT * FROM getClassementClients();

/*
 numclient |  nomclient  | classement 
-----------+-------------+------------
         4 | Poret       |          1
         6 | Timable     |          2
         8 | Ohm         |          3
         7 | Don Devello |          4
         9 | Ginal       |          5
         3 | Hauraque    |          6
         5 | Menvussa    |          7
        10 | Hautine     |          8
         2 | Fissile     |          9
         1 | Torguesse   |         10
        11 | Kament      |         11
(11 rows)
*/