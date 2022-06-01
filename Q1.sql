/*
a) Lister les clients (numéro et nom) triés par ordre alphabétique du nom
*/

SELECT   numClient, nomClient
FROM     Client
ORDER BY nomClient;