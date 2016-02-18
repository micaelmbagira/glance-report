# Document de Synthèse

## Contexte et sujet

Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud collaboratif et distribué. Le projet Discovery s'intéresse principalement à Openstack, un projet open-source très populaire.  
OpenStack est un ensemble de logiciels permettant de déployer des infrastructures de cloud computing. La technologie possède une architecture modulaire composée de plusieurs projets corrélés (Nova, Swift, Glance...) qui permettent de contrôler les différentes ressources des machines virtuelles telles que la puissance de calcul, le stockage ou encore le réseau inhérents au centre de données sollicité.  
Notre travail fait suite à celui effectué par Jonathan Pastor, doctorant à l'école des Mines de Nantes, qui a travaillé sur le module Nova d'Openstack (qui s'occupe de la gestion des unités de calcul). Il a créé un ORM NoSQL appelé [ROME](github.com/badock/rome) pour remplacer l'ORM relationnel SQLAlchemy utilisé par Openstack.  
L'ensemble de ces projets sont codés en Python. Le développement et les tests d'Openstack s'effectuent sur les sources github [Devstack](http://docs.openstack.org/developer/devstack/).
Le but de notre projet a été d'étendre l'utilisation de ROME au module Glance, le service d'image d'OpenStack. Il permet de stocker et récupérer des images de machines virtuelles, ainsi que leurs metadonnées.

## Problématique

Comment adapter le composant Glance à une structure distribuée ?

###Cahier des charges/Objectifs

- Modifier Glance pour qu'il utilise l'ORM NoSQL : ROME
- Tester les appels de Glance à sa base de données NoSQL (et donc à un cluster dans notre cas).
- Ajouter les fonctionnalités manquantes dans ROME.
- Adapter et résoudre des bugs dans Glance tout en produisant du code non intrusif.

## Méthode

#### Méthodologie organisationnelle
Notre tuteur de projet  était Adrien Lèbre, et nous avons aussi beaucoup échangé avec Jonathan Pastor. Nous avons organisé notre groupe autour d'un chef de projet. Il proposait les réunions et séances de travail. Il récupérait les comptes-rendus des différents membres de l'équipe. Il organisait le partage des tâches en proposant les différentes pistes évoquées par les tuteurs.
N'importe quel membre de l'équipe pouvait entrer en contact avec les tuteurs pour surmonter les difficultés techniques rencontrées.  
Nous avons adopté une méthodologie agile. Nous avons divisé le projet en sprints portés par des objectifs précis. A chaque échéance et progression, nous faisions un compte rendu à Adrien Lèbre et/ou à Jonathan Pastor.

#### Méthodologie technique
Nous avons utilisé un dépôt git en faisant un fork à partir du projet officiel Openstack pour Glance, et du projet de Jonathan Pastor pour ROME. Puis nous avons travaillé sur une branche créée à partir de master. Nous avons créé dans glance/db un répertoire "discovery" dans lequel nous avons concentré toutes nos modifications, de manière à réaliser un code non instrusif tant que cela était possible.  
Nous échangions avec Jonathan Pastor pour l'intégration de nos modifications de ROME et la découverte de bugs. Notre environnement de travail était Ubuntu 14.04 sur VirtualBox.  
Afin de nous familiariser avec l'environnement Linux, Python et OpenStack, nous avons commencé par travailler sur l'installation et le démarrage de DevStack, la version de développement d'OpenStack. Puis nous avons lancé le projet sur Glance et ROME.

## Travaux réalisés

1. Installation de Devstack, configuration VM et familiarisation avec Glance (1 semaine)
2. Recherches sur Devstack et le travail de Jonathan (1 semaine)
3. Définir des tests unitaires critiques et les faire fonctionner avec ROME
(4 semaines)
4. Intégration de notre Glance modifié dans DevStack (5 semaines)
 - Travail sur les tests unitaires restants
 - Régler avec Jonathan les problèmes restants et critiques pour l’installation
5. Finalisation du projet (2 semaines)
 - Réalisation d’un script pour changer la version de Glance à chaud
 - Rédaction des rapports

## Résultats

Dans un premier temps, nous avons réussi à faire fonctionner 21 tests unitaires sur 41, ces 21 tests étaient jugés critiques pour aller plus loin dans le prototype. Ces tests testaient les opérations CRUD (Create, Read, Update, Delete) de l'API de Glance. Les tests restants servaient à récupérer des images avec différents filtres (en fonction du type, trié par nom, etc.). 

Nous avons ensuite, réussi à déployer notre version de Glance avec DevStack. Pour cela, il faut lancer l'installation de DevStack en remplaçant le composant Glance d'origine par le notre. L'installation effectue plusieurs tests basiques pour chaque composant dont les opérations CRUD pour Glance. Si un des tests ne passe pas, l'installation s'interrompt.  
Les fonctionnalités critiques de Glance, c'est-à-dire la sauvegarde des images de machines virtuelles et des metadata, fonctionnent sur un cluster local. Des tests sur la structure distribuée   [Grid500](https://www.grid5000.fr/) sont en cours.

## Perspectives

Une perspective directe de notre projet est sa reprise future par Orange Labs, qui a montré un fort intérêt à notre tuteur.
Le projet Discovery, et notamment notre contribution, suscite beaucoup d'enthousiasme dans la communauté Openstack. Cela a été souligné à notre tuteur par le directeur de l'ingénierie de la fondation Openstack.
De plus Anthony Simonet, doctorant à l'école des Mines de Nantes, va utiliser nos résultats dans son travail sur les tests d'intégration de la version Discovery d'Openstack .
Enfin notre contribution sur le module Glance participe à visibilité générale sur la disbribution et l'échelonnage d'Openstack, et rapproche du but final du projet Discovery.

## Bilan

#### Compétences acquises

Nous avons amélioré notre connaissance de Python et de son environnement (IDE, tests unitaires, débuggage, typage dynamique, etc.) , et nous nous sommes familiarisés avec l'architecture d'Openstack. De plus, nous avons aussi amélioré nos connaissances dans l'environnement Unix et la manipulation du terminal dans sa globalité. Enfin, nous avons dû nous confronter à un projet de recherche de très grande ampleur. 

#### Conclusion

Nous avons eu l'opportunité de contribuer à un projet de grande envergure et de nous confronter à des problèmatiques de recherche. Il a été difficile de définir un planning, et nous avons constaté des écarts entre ce que nous avions prévu et ce que nous avons effectivement réalisé.  
Ce décalage peut être expliqué par certains problèmes que nous avons recontrés durant le projet.
Il y a eu au départ un travail important d'installation et de configuration, dont nous ne comprenions pas la source. De plus nous avons eu du mal à appréhender le code de ROME et de Glance, qui s'appuie sur plusieurs années de développement. Enfin nous avons sous-estimé le temps nécessaire à l'intégration de notre version de Glance à l'architecture Openstack.  
Malgré ces difficultés, nous avons réussi à atteindre notre objectif. Notre version de Glance intégrée à Devstack et utilisant ROME est fonctionnelle.  
Nous avons beaucoup appris, sur un projet intéressant et aux objectifs ambitieux. Nous espérons que nos résultats serons utiles aux développeurs qui porteront le projet Discovery.
