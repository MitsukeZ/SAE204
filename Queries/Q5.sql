/*
e) Créer une vue appelée CA qui affiche le chiffre d’affaire réalisé 
par année en listant dans l’ordre croissant des années 
(champ appelé annee) et en face le chiffre réalisé (appelé chA).
*/

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

