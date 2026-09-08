-- Mots de passe des comptes de test :
-- admin@notes.com      : Admin1234!
-- enseignant@notes.com : Enseignant1234!
-- etudiant@notes.com   : Etudiant1234!

UPDATE users SET password = '$2a$10$RmhNxBQuzGLItcIJorqJuuUnX7E6ezGFJh6PjqUti9jago9YNHUKW'
WHERE email = 'admin@notes.com';

UPDATE users SET password = '$2a$10$wIID1erSm/AwJGxGaH6sROjfBt8GWg.RSxQJ8hT.PllLi3etki.1y'
WHERE email = 'enseignant@notes.com';

UPDATE users SET password = '$2a$10$CPWmv3xt2s7rjN.LG9QDDu5kjCAgdWoS56ocVLZh.BH6yl7OYMWii'
WHERE email = 'etudiant@notes.com';