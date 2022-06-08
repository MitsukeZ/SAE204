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

--Valeurs de Test
INSERT INTO Vente  (numVente, dteVente, numClient)
VALUES (115, '2021-10-10', 3),
       (116, '2021-10-11', 3);

INSERT INTO Concerner (isbn, numVente, prixVente, quantite)
VALUES ('978-2-7560-2538-4', 116, 727, 10);

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

--Cas 1 : Vente non référencée dans la table concerner
SELECT * FROM supprimerVente(115);

--Cas 2 : Vente référencée dans la table concerner
SELECT * FROM supprimerVente(116);

--Cas 3 : Vente inexistante
SELECT * FROM supprimerVente(117);