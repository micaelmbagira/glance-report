# Document de Synthèse

## Contexte et sujet

Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud distribué.  
Notre travail doit faire suite à celui effectué par Jonathan Pastor qui a créé un ORM NoSQL appelé [`ROME`](github.com/badock/rome) pour remplacer `sqlalchemy` utilisé par les différentes API de l'application open-source [Devstack](http://docs.openstack.org/developer/devstack/). Il a aussi modifié l'API composant Nova (qui s'occupe de la gestion des unités de calcul) pour qu'elle puisse au choix utiliser `sqlalchemy`ou `ROME`.

## Problématique

// TODO !

## Méthode

#### Méthodologie organisationnelle
Nous avons organisé notre groupe autour d'un chef de projet. Il proposait les réunions et séances de travail. Il récupérait les comptes-rendus des différents membres de l'équipe. Il organisait le partage des tâches en proposant les différentes pistes évoquées par les tuteurs.
N'importe quel membre de l'équipe pouvait entrer en contact avec les tuteurs pour surmonter des difficultés techniques.

#### Méthodologie technique
Nous avons utilisé un dépôt git en faisant un fork à partir du projet officiel Openstack pour Glance, et du projet de Jonathan Pastor pour ROME. Puis nous avons travaillé sur une branche créée à partir de master.
Nous avons créé dans glance/db un répertoire "discovery" dans lequel nous avons concentré toutes nos modifications, de manière à réaliser un code non instrusif tant que cela était possible.
Nous échangions avec Jonathan Pastor pour l'intégration de nos modifications de ROME et la découverte de bugs.
Notre environnement de travail était Ubuntu 14.04 sur VirtualBox.
Afin de nous familiariser avec l'environnement Linux, Python et Openstack, nous avons commencé par travailler sur l'installation et le démarrage de Devstack, la version de développement d'Openstack.
Puis nous avons lancé le projet sur Glance et ROME.

## Bilan

// TODO !

#### Workflow

1. Installer et démarrer Glance, puis ajouter ROME (4 personnes)
2. S'assurer que Glance utilise ROME.
  - Recherche sur les tests unitaires (2 personnes)
  - S'assurer que la librairie utilisée par Glance est bien ROME et non pas sqlalchemy (2 personnes)
3. Rendre ROME fonctionnel : Installer toutes les dépendances. (4 personnes)
4. Faire fonctionner les tests unitaires critiques pour un fonctionnement minimal. 4*(1 personne)
5. Intégrer notre Glance dans Devstack
  - Travail sur les autres tests unitaires. (2 personnes)
  - Régler des problèmes dans ROME critiques pour le lancement de Devstack. (2 personnes)
6. Finaliser le projet (4 personnes)
  - Réaliser un script pour forcer Devstack à utiliser notre version de Glance après lancement.
  - Rédiger et/ou finaliser les rapports.
