/*
i) Construire et afficher une vue bdEditeur qui affiche le nombre 
de BD vendues par an et par éditeur, par ordre croissant des années 
et des noms d’éditeurs.  On y affichera le nom de l’éditeur, 
l’année considérée et le nombre de BD publiées.
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