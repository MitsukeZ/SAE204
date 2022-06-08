--a) Lister les clients (numéro et nom) triés par ordre alphabétique du nom

SELECT   numClient, nomClient
FROM     Client
ORDER BY nomClient;

/*
 numclient |  nomclient  
-----------+-------------
         7 | Don Devello
         2 | Fissile
         9 | Ginal
         3 | Hauraque
        10 | Hautine
        11 | Kament
         5 | Menvussa
         8 | Ohm
         4 | Poret
         6 | Timable
         1 | Torguesse
(11 rows)
*/


--b) Lister les clients (numéro, nom) et leur nombre d’achats (que l’on nommera nbA) triés par ordre décroissant de leur nombre d’achats (sans prendre en compte la quantité achetée)

SELECT c.numClient, c.nomClient, COUNT(v.numClient) AS nbA
FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                JOIN Concerner co ON v.numVente  = co.numVente
GROUP BY c.numClient
ORDER BY nbA DESC;

/*
 numclient |  nomclient  | nba
-----------+-------------+-----
         4 | Poret       |  19
         7 | Don Devello |  12
         6 | Timable     |  12
         8 | Ohm         |  11
         3 | Hauraque    |  11
        10 | Hautine     |   9
         5 | Menvussa    |   9
         9 | Ginal       |   8
         2 | Fissile     |   8
         1 | Torguesse   |   6
        11 | Kament      |   4
(11 lignes)
*/


--c) Lister les clients (numéro, nom) avec leur coût total d’achats (que l’on nommera coutA) triés par leur coût décroissant, qui ont totalisé au moins 50000€ d’achats..

SELECT c.numClient, c.nomClient, SUM(co.prixVente*co.quantite) AS coutA
FROM   Client c JOIN Vente v      ON c.numClient = v.numClient
                JOIN Concerner co ON v.numVente  = co.numVente
GROUP BY c.numClient
HAVING   SUM(co.prixVente*co.quantite) >= 50000
ORDER BY coutA DESC;

/*
 numclient |  nomclient  |  couta
-----------+-------------+----------
         4 | Poret       | 129141.2
         6 | Timable     |  93406.5
         8 | Ohm         |  92865.9
         7 | Don Devello |  82909.4
         9 | Ginal       |  66003.9
        10 | Hautine     |  59519.1
         5 | Menvussa    |  56772.3
         3 | Hauraque    |    51684
(8 lignes)
*/


--d) Afficher le chiffre d’affaire des ventes effectuées en 2021 (on pourra utiliser la fonction extract pour récupérer l’année seule d’une date)

SELECT   SUM(co.prixVente * co.quantite) as chiffreAffaires
FROM     Vente v JOIN Concerner co ON v.numVente = co.numVente
GROUP BY EXTRACT(YEAR FROM v.dteVente)
HAVING   EXTRACT(YEAR FROM v.dteVente) = 2021;

/*
 chiffreaffaires
-----------------
         54833.6
(1 ligne)
*/


--e) Créer une vue appelée CA qui affiche le chiffre d’affaire réalisé par année en listant dans l’ordre croissant des années (champ appelé annee) et en face le chiffre réalisé (appelé chA).

DROP VIEW IF EXISTS CA;

CREATE VIEW CA AS 
SELECT   EXTRACT(YEAR FROM v.dteVente) AS annee, SUM(co.prixVente * co.quantite) as chA
FROM     Vente v JOIN Concerner co ON v.numVente = co.numVente
GROUP BY annee
ORDER BY annee;

--Requete pour voir le contenu de la vue
SELECT * FROM CA;

/*
 annee |   cha
-------+---------
  2000 |   34059
  2001 | 52765.6
  2002 | 46068.5
  2003 | 15867.5
  2004 | 45393.9
  2005 | 64904.7
  2006 | 14602.5
  2007 | 34254.8
  2008 | 19389.8
  2009 | 14755.2
  2010 | 15545.4
  2011 | 17137.5
  2012 | 29922.4
  2013 |   11316
  2014 | 46403.7
  2015 |  9294.3
  2016 | 25570.3
  2017 | 23346.3
  2018 | 76295.8
  2019 |   59304
  2020 |   24000
  2021 | 54833.6
(22 lignes)
*/


--f) Lister tous les clients (numéro et nom) ayant acheté des BD de la série ‘Astérix le gaulois’.

SELECT DISTINCT c.numClient, c.nomClient
FROM            Client c JOIN Vente v      ON c.numClient = v.numClient
                         JOIN Concerner co ON v.numVente  = co.numVente
                         JOIN BD           ON co.isbn     = BD.isbn
                         JOIN Serie s      ON BD.numSerie = s.numSerie
WHERE s.nomSerie = 'Asterix le gaulois';

/*
 numclient |  nomclient  
-----------+-------------
         1 | Torguesse
         2 | Fissile
         3 | Hauraque
         4 | Poret
         5 | Menvussa
         6 | Timable
         7 | Don Devello
         8 | Ohm
         9 | Ginal
        10 | Hautine
        11 | Kament
(11 lignes)
*/


--g) Lister les clients (numéro et nom) qui n’ont acheté que les BD de la série ‘Asterix le gaulois’ (en utilisant la clause EXCEPT)

SELECT DISTINCT c.numClient, c.nomClient
FROM            Client c JOIN Vente v      ON c.numClient = v.numClient
                         JOIN Concerner co ON v.numVente  = co.numVente
                         JOIN BD           ON co.isbn     = BD.isbn
                         JOIN Serie s      ON BD.numSerie = s.numSerie
EXCEPT
SELECT DISTINCT c.numClient, c.nomClient
FROM            Client c JOIN Vente v      ON c.numClient = v.numClient
                         JOIN Concerner co ON v.numVente  = co.numVente
                         JOIN BD           ON co.isbn     = BD.isbn
                         JOIN Serie s      ON BD.numSerie = s.numSerie
WHERE s.nomSerie != 'Asterix le gaulois';

/*
 numclient | nomclient 
-----------+-----------
         3 | Hauraque
(1 ligne)
*/

/*
h) Créer et afficher une vue nommée best5 qui liste les 5 meilleurs clients (ayant donc dépensé le plus d’argent en BD) en affichant leur numéro, nom et adresse 
mail, ainsi que le nombre total de BD qu’ils ont acheté (champ nbBD en tenant compte des quantités achetées), ainsi que le total de leurs achats (champ coutA).
*/

DROP VIEW IF EXISTS best5;

CREATE VIEW best5 AS
SELECT cl.numClient, nomClient, mailClient, SUM(quantite) AS nbBD, SUM(quantite * prixVente) AS totalAchat

FROM   Client cl JOIN Vente v
       ON cl.numClient = v.numClient
       JOIN Concerner co
       ON v.numVente = co.numVente
GROUP BY cl.numClient, nomClient, mailClient
ORDER BY SUM(quantite * prixVente) DESC
LIMIT 5;

--Requete pour voir le contenu de la vue
select * from best5;

/*
 numclient |  nomclient  |   mailclient    | nbbd | totalachat
-----------+-------------+-----------------+------+------------
         4 | Poret       | mail@he.fr      | 8816 |   129141.2
         6 | Timable     | mail@limelo.com | 6639 |    93406.5
         8 | Ohm         | mail@odie.net   | 6159 |    92865.9
         7 | Don Devello | mail@he.fr      | 5664 |    82909.4
         9 | Ginal       | mail@ange.fr    | 4564 |    66003.9
(5 lignes)
*/

/*
i) Construire et afficher une vue bdEditeur qui affiche le nombre de BD vendues par an et par éditeur, par ordre croissant des années 
et des noms d’éditeurs.  On y affichera le nom de l’éditeur, l’année considérée et le nombre de BD publiées.
*/

DROP VIEW IF EXISTS bdEditeur;

CREATE VIEW bdEditeur AS
SELECT EXTRACT(YEAR FROM v.dteVente) as annee, SUM(co.quantite), e.nomEditeur
FROM   Vente v JOIN Concerner co ON v.numVente   = co.numVente
               JOIN BD           ON co.isbn      = BD.isbn
               JOIN Serie s      ON BD.numSerie  = s.numSerie
               JOIN Editeur e    ON s.numEditeur = e.numEditeur
GROUP BY annee, e.nomEditeur
ORDER BY annee, e.nomEditeur;

--Requete pour voir le contenu de la vue
SELECT * FROM bdEditeur;

/*
 annee | sum  |       nomediteur
-------+------+------------------------
  2000 | 1362 | Dargaud
  2000 | 1025 | Lombard
  2001 | 1718 | Dargaud
  2001 |  157 | Les humanoides associe
  2001 | 1433 | Lombard
  2002 | 1363 | Dargaud
  2002 | 1210 | Les humanoides associe
  2002 |  495 | Lombard
  2003 |  415 | Dargaud
  2003 |  245 | Lombard
  2003 |  608 | Pika Edition
  2004 | 1778 | Dargaud
  2004 |  537 | Lombard
  2004 |  794 | Tonkan
  2005 |  567 | Bamboo Edition
  2005 | 2525 | Dargaud
  2005 | 1241 | Tonkan
  2006 |  826 | Dargaud
  2006 |  295 | Lombard
  2007 |  922 | Bamboo Edition
  2007 | 1485 | Dargaud
  2008 | 1235 | Dargaud
  2008 |  247 | Lombard
  2009 |  928 | Lombard
  2010 |  837 | Dargaud
  2010 |  346 | Lombard
  2011 |  308 | Dargaud
  2011 |  941 | Delcourt
  2012 |  624 | Dargaud
  2012 |  704 | Delcourt
  2012 |  796 | Lombard
  2013 |  277 | Dargaud
  2013 |  592 | Delcourt
  2014 |  857 | Dargaud
  2014 | 1879 | Delcourt
  2014 |  648 | Lombard
  2015 |  169 | Dargaud
  2015 |  457 | Lombard
  2016 | 1478 | Dargaud
  2016 |  277 | Lombard
  2016 |  245 | Vents d Ouest
  2017 | 1340 | Dargaud
  2017 |  457 | Lombard
  2018 | 2221 | Dargaud
  2018 | 1282 | Lombard
  2018 | 2090 | Vents d Ouest
  2019 | 1299 | Dargaud
  2019 | 1920 | Lombard
  2019 |  456 | Vents d Ouest
  2020 |   34 | Dargaud
  2020 |  780 | Vents d Ouest
  2021 |  456 | Delcourt
  2021 | 2324 | Lombard
  2021 |  406 | Vents d Ouest
(54 lignes)
*/

/*
j) Construire et afficher une vue bdEd10 qui affiche les éditeurs qui 
ont publié plus de 10 BD, en donnant leur nom et email, ainsi que 
le nombre de BD différentes qu’ils ont publiées.
*/

DROP VIEW IF EXISTS bdEd10;

CREATE VIEW bdEd10 AS
SELECT e.nomEditeur, e.mailEditeur, COUNT(BD.isbn) AS nbBD
FROM   Editeur e JOIN Serie s ON e.numEditeur = s.numEditeur
                 JOIN BD      ON s.numSerie   = BD.numSerie
GROUP BY e.nomEditeur, e.mailEditeur
HAVING   COUNT(BD.isbn) > 10;

--Requete pour voir le contenu de la vue
SELECT * FROM bdEd10;

/*
 nomediteur |    mailediteur     | nbbd 
------------+--------------------+------
 Lombard    | info@Lombard.be    |   27
 Dargaud    | contact@dargaud.fr |   49
(2 lignes)
*/