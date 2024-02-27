# APP USSD MMGG CONTRAVENTION GUINEE

Cette application gère le parcours USSD Contravention GUINÉE

## Dépendances:

- [Ruby 2.6.0](https://www.ruby-lang.org/en/)
- [Rails 6.0](https://rubyonrails.org/)
- [Redis](https://redis.io/)
- [PostgreSQL 13](https://www.postgresql.org/)
- [Docker](https://www.docker.com/)
- [docker-compose](https://docs.docker.com/compose/)

# ChangeLog

## [1.0.0] - 16-11-2022

## Added

- Ajout de variable d'environnement 'USSD_FEES' pour le parametrage des montant USSD Contravention

## Démarrer

Pour démarrer l'application:

- Cloner le dépôt.
- Déployer le fichier master.key joint dans le dossier config. Le contenu du fichier doit être la valeur de la variable d'environnement RAILS_MASTER_KEY.
- Mettre à jour les fichiers suivants selon l'environnement d'exécution de l'application (`développement`, `preprod`, `production`) :
  - _.env_ (voir le modèle dans le fichier .example.env)
  - _docker-compose.yml_
- Générer les containers et démarrer les services:
  Les containers peuvent être lancer en utlisant les commandes de **docker-compose** ou avec l'utilitaire Make (voir fichier Makefile).
- Lancer les migrations de la BD avec la commande `make migrate`.
