\# Système de Gestion des Notes Étudiantes



Application de gestion des notes : saisie par les enseignants, consultation

par les étudiants, génération de relevés PDF et exports Excel.



Deux interfaces consomment la même API : un front Angular et un front React.



\## Architecture



| Composant | Technologie | Dossier |

|---|---|---|

| API | Spring Boot 3.3 / Java 21, Spring Modulith, JWT | `notes-backend` |

| Front Angular | Angular 19, Tailwind | `frontend` |

| Front React | React, Vite | `frontend-react` |

| Base de données | PostgreSQL 16 | conteneur |



Les migrations de schéma sont gérées par Flyway et s'appliquent

automatiquement au démarrage.



\## Prérequis



\- Docker Desktop (avec Docker Compose v2)

\- Les ports 4204, 4205, 8082 et 5434 libres



\## Démarrage



copy .env.example .env





Sous Linux ou macOS : `cp .env.example .env`



Deux variables sont obligatoires et bloquent le démarrage si elles sont vides :



| Variable | Description |

|---|---|

| `DB\_PASSWORD` | Mot de passe PostgreSQL, libre |

| `JWT\_SECRET` | Clé de signature des jetons, encodée en Base64 |



Le `JWT\_SECRET` doit être une chaîne Base64 valide, car l'application la

décode au démarrage. Pour en générer une sous PowerShell :



$bytes = New-Object byte\[] 48

\[System.Security.Cryptography.RandomNumberGenerator]::Create().GetBytes($bytes)

\[Convert]::ToBase64String($bytes)





Coller le résultat sur une seule ligne dans le `.env`.



Puis :



docker compose up -d --build

docker compose ps





Attendre que `notes-backend` affiche `healthy`. Le premier lancement prend

plusieurs minutes : compilation Maven et installation des dépendances npm

des deux fronts.



\## URLs d'accès



| Interface | URL |

|---|---|

| Front Angular | http://localhost:4204 |

| Front React | http://localhost:4205 |

| Documentation API (Swagger) | http://localhost:8082/swagger-ui.html |

| Schéma OpenAPI | http://localhost:8082/api-docs |



\## Comptes de test



Créés par les migrations `V5`, `V8` et `V9`, donc recréés automatiquement

après un `docker compose down -v`.



| Email | Mot de passe | Rôle |

|---|---|---|

| admin@notes.com | Admin1234! | ROLE\_ADMIN |

| enseignant@notes.com | Enseignant1234! | ROLE\_ENSEIGNANT |

| etudiant@notes.com | Etudiant1234! | ROLE\_ETUDIANT |



Les mots de passe se terminent par un point d'exclamation. Les migrations

créent également une classe de démonstration, cinq matières et cinq notes,

de sorte que les écrans ne sont pas vides à la première connexion.



\## Arrêt



docker compose down





Pour tout supprimer, base de données comprise :



docker compose down -v





\## Dépannage



\*\*Un port est déjà occupé\*\*



Modifier les ports dans le `.env` :



ANGULAR\_PORT=4204

REACT\_PORT=4205

API\_PORT=8082

DB\_PORT\_HOST=5434





`DB\_PORT\_HOST` désigne le port exposé sur la machine ; `DB\_PORT` est le port

interne du conteneur et ne doit pas être modifié.



\*\*Le démarrage échoue avec `DB\_PASSWORD manquant`\*\*



Le `.env` n'a pas été créé ou la variable est vide. Reprendre l'étape de

copie du `.env.example`.



\*\*`password authentication failed for user "postgres"`\*\*



Le volume PostgreSQL conserve le mot de passe de sa première

initialisation. Après un changement de `DB\_PASSWORD` :



docker compose down -v

docker compose up -d





\*\*Flyway échoue avec `Validate failed` ou un checksum différent\*\*



Une migration déjà appliquée a été modifiée. Les fichiers de migration

sont immuables une fois exécutés. Repartir d'une base vierge :



docker compose down -v

docker compose up -d --build





\*\*Une modification du code n'a aucun effet\*\*



Les fronts sont compilés dans les images. Après toute modification,

reconstruire :



docker compose up -d --build





Si le cache persiste : `docker compose build --no-cache <service>`.

Penser aussi au rechargement forcé du navigateur (Ctrl+Maj+R).



\*\*Erreur `ERR\_CONNECTION\_REFUSED` depuis un front\*\*



Le front appelle une URL absolue vers un port qui n'est plus exposé. Les

fronts doivent appeler l'API en relatif, sur `/api`, nginx assurant le

proxy. Vérifier `src/environments/` côté Angular et `.env.production`

côté React.



\*\*Erreur 403 ou message CORS\*\*



L'origine du navigateur n'est pas autorisée. `CorsConfig.java` utilise

`setAllowedOriginPatterns` avec `http://localhost:\*`, ce qui couvre tous

les ports locaux.



\*\*Le build Angular échoue sur une erreur TS2339\*\*



Les fichiers `environment.ts` et `environment.prod.ts` doivent déclarer

exactement les mêmes propriétés ; seules les valeurs peuvent différer.

