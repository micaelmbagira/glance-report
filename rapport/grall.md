# Document de Synthèse

## Contexte et sujet

Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud distribué.
Le projet Discovery s'intéresse principalement à Openstack, un projet open-source très populaire.
OpenStack est un ensemble de logiciels permettant de déployer des infrastructures de cloud computing. La technologie possède une architecture modulaire composée de plusieurs projets corrélés (Nova, Swift, Glance...) qui permettent de contrôler les différentes ressources des machines virtuelles telles que la puissance de calcul, le stockage ou encore le réseau inhérents au centre de données sollicité.
Notre travail fait suite à celui effectué par Jonathan Pastor, doctorant à l'école des Mine de Nantes, qui a travaillé sur le module Nova d'Openstack (qui s'occupe de la gestion des unités de calcul).
Il a créé un ORM NoSQL appelé [`ROME`](github.com/badock/rome) pour remplacer l'ORM relationnel `sqlalchemy` utilisé par Openstack.
L'ensemble de ces projets sont codés en Python. Le développement et les tests d'Openstack s'effectue sur les sources github [Devstack](http://docs.openstack.org/developer/devstack/).
Le but de notre pojet a été d'étendre l'utilisation de ROME au module Glance, le service d'image d'OpenStack. Il permet de gérer les images disque, ainsi que de stocker des sauvegardes et des metadonnées.

## Problématique

Comment adapter le Glance à une structure distribuée ?
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

Une perspective directe de notre projet est sa reprise future par Orange Labs, qui a montré un fort intérêt à notre tuteur.
Le projet Discovery, et notamment notre contribution, suscite beaucoup d'enthousiasme dans la communauté Openstack. Cela a été souligné à notre tuteur par le directeur de l'ingénierie de la fondation Openstack.
De plus Anthony Simonet, doctorant à l'école des Mines de Nantes, va utiliser nos résultats dans son travail sur les tests d'intégration de la version Discovery d'Openstack .
Enfin notre contribution sur le module Glance participe à visibilité générale sur la disbribution et l'échelonnage d'Openstack, et rapproche du but du tout distribué.

## Bilan

#### Compétences acquises

Nous avons amélioré notre connaissance de python, et nous nous sommes familiarisés avec l'architecture d'Openstack. De plus nous avons du nous confronter à un projet de recherche de très grande ampleur. Enfin, nous avons au cours du projet progessé sur le débuggage en python et les test unitaires.

#### Conclusion
