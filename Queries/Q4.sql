/*
d) Afficher le chiffre d’affaire des ventes effectuées en 2021 
(on pourra utiliser la fonction extract pour récupérer 
l’année seule d’une date)
*/

SELECT   SUM(co.prixVente * co.quantite) as chiffreAffaires
FROM     Vente v JOIN Concerner co ON v.numVente = co.numVente
GROUP BY EXTRACT(YEAR FROM v.dteVente)
HAVING   EXTRACT(YEAR FROM v.dteVente) = 2021;

/*
  chiffreaffaires   
--------------------
 54833.600000000006
(1 row)
*/

