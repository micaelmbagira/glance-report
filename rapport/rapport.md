#Rapport technique
##Contexte et sujet
Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud distribué.  
Notre travail doit faire suite à celui effectué par Jonathan Pastor qui a créé un ORM NoSQL appelé [`ROME`](github.com/badock/rome) pour remplacer `sqlalchemy` utilisé par les différentes API de l'application open-source [Devstack](http://docs.openstack.org/developer/devstack/). Il a aussi modifié l'API composant Nova (qui s'occupe de la gestion des unités de calcul) pour qu'elle puisse au choix utiliser `sqlalchemy`ou `ROME`. 

##Cahier des charges
Le travail que nous avions à faire était de modifier de la même manière, l'API du composant Glance (chargé de la gestion des images virtuelles) pour qu'elle puisse aussi utilisé les deux ORM.  

##Méthodologie organisationnelle
Mettre à peu près le planning et les durées que ça nosu a pris

##Méthodologie technique
###Architecture du code

![alt text](../schema2.jpeg)

(Glance registry est une couche optionnelle qui organise une communication sécurisée entre la couche d'abstraction de base de données et le contrôleur.)

###Réferences à `sqlalchemy`

Les références à `sqlalchemy` se trouvent dans `db.sqlalchemy.api`. De la même manière que pour `Nova`, nous avons copié/collé le code correspondant à l'API dans un nouveau package `db.discovery` et suivi la méthodologie suivante:

- Copier/coller le fichier `db.api.py` dans notre package `discovery`
- Exécuter les tests unitaires de l'API
- Modifier le code en fonction des erreurs rencontrées

Nous avions décidé que, puisque `Nova` est plus gros en terme de code que `Glance`, il était fort probable que toutes les requêtes à la base de données dont a besoin `Glance` soient déjà implémentée dans `ROME`. Cependant il fallait tester toutes les méthodes de l'API et ajouter les reqûetes manquantes à `ROME` s'il y en avait.

###Procédure de tests
Puisque nous travaillons sur l'API de la base de données de Glance, nous avons décidé de travailler sur tous les tests présents dans `tests.unit.v2.test_registry_api.py`.  
Dans tous ces tests, des données factices sont créées et toutes les fonctionnalités (opérations CRUD) de l'API sont testéesen envoyant des reqûetes en utilisant le protocole RPC.  
Pour effectuer ces tests nous utilisions un environnement Windows ou Mac avec PyCharm.  
Nous avons établi des tests unitaires "critiques" qui devaient absolument passer avant de passer aux tests d'intégration. Nous avons donc choisi les tests effectuant les opérations suivantes :

- création d'image
- mise à jour d'image
- suppression d'image
- récupération d'image (simple, c'est à dire sans filtre particulier)

Nous avons donc mis de cotés les autres tests présents qui étaient des tests de récupération d'image avec des filtres (par type, avec une pagination etc.)  

###Tests d'intégration
Une fois les tests unitaires critiques validés, nous avons travaillé sur les tests d'intégration.  
Pour cela nous avons installé Devstack sur une machine virtuelle Ubuntu et remplacé le composant Glance par le nôtre (cela se fait simplement en modifiant l'URL de la source dans le fichier `~/devstack/stackrc`. On peut ensuite installer Devstack en lançant le script d'installation `stack.sh`.

##Travail effectué
###Glance
###ROME
###Difficultés majeures