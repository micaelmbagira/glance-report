# Document de Synthèse

## Contexte et sujet

Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud distribué.  
Notre travail doit faire suite à celui effectué par Jonathan Pastor qui a créé un ORM NoSQL appelé [`ROME`](github.com/badock/rome) pour remplacer `sqlalchemy` utilisé par les différentes API de l'application open-source [Devstack](http://docs.openstack.org/developer/devstack/). Il a aussi modifié l'API composant Nova (qui s'occupe de la gestion des unités de calcul) pour qu'elle puisse au choix utiliser `sqlalchemy`ou `ROME`.

## Problématique

Comment adapter Glance à une structure distribuée ?
Pour répondre à cette problématique il a fallu faire face à plusieurs problèmes.
- Charger toutes les dépendances nécessaires à l'exécution de ROME, Glance et devstack.
- Régler les fichiers de configuration et les scripts de lancement.
- Tester les appels de Glance à sa base de donnée (et donc à un cluster dans notre cas).
- Ajouter les fonctionnalités manquantes dans ROME.
- Adapter et résoudre des bugs dans Glance tout en produisant du code non intrusif.

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

## Travaux réalisés

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

## Résultats

Nous avons réussi à déployer notre version de Glance avec Devstack. Les fonctionnalités critiques de Glance, c'est-à-dire la sauvegarde des images de machines virtuelles et des metadata, fonctionnent sur un cluster local. Des tests sur une structure distribuée sont en cours. //TODO JONATHAN

## Perspectives

Le projet Discovery en général, et les avancées que nous avons réalisé en particulier, suscitent un grand intérêt de la part de la communauté Openstack. Cela a été souligné à notre tuteur lors d'une convention réunissant les principaux acteurs du projet.
Notamment de la part d'Orange Labs, qui travaille déjà sur un autre module pour la distribtion d'Openstack.
Un doctorant de l'école Mines Nantes qui travaille sur les tests d'intégration de la version Discovery d'Openstack va utiliser nos résultats.
Enfin notre contribution participe à visibilité générale sur la disbribution et l'échelonnage d'Openstack.

## Bilan

#### Compétences acquises

Nous avons amélioré notre connaissance de python, et nous nous sommes familiarisés avec l'architecture d'Openstack. De plus nous avons du nous confronter à un projet de recherche de très grande ampleur. Enfin, nous avons au cours du projet progessé sur le débuggage en python et les test unitaires.

#### Conclusion
