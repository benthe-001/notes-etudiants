-- Correction des roles : V5 inserait des identifiants numeriques
-- alors que l'entite attend les constantes de l'enum Role
UPDATE user_roles SET role_id = 'ROLE_ADMIN'      WHERE role_id = '1';
UPDATE user_roles SET role_id = 'ROLE_ENSEIGNANT' WHERE role_id = '2';
UPDATE user_roles SET role_id = 'ROLE_ETUDIANT'   WHERE role_id = '3';

-- Mot de passe des comptes de test : Admin1234!
UPDATE users
SET password = '$2a$10$1wNJjhfiQUT89UQ62Ze1AuaoGN7h3yzAVd1jwuea/wHyJ7cetnVmi'
WHERE email IN ('admin@notes.com', 'enseignant@notes.com', 'etudiant@notes.com');