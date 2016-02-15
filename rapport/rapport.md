# Rapport technique
## Contexte et sujet
Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud distribué.  
Notre travail doit faire suite à celui effectué par Jonathan Pastor qui a créé un ORM NoSQL appelé [`ROME`](github.com/badock/rome) pour remplacer `sqlalchemy` utilisé par les différentes API de l'application open-source [Devstack](http://docs.openstack.org/developer/devstack/). Il a aussi modifié l'API composant Nova (qui s'occupe de la gestion des unités de calcul) pour qu'elle puisse au choix utiliser `sqlalchemy`ou `ROME`.

## Cahier des charges
Le travail que nous avions à faire était de modifier de la même manière, l'API du composant Glance (chargé de la gestion des images virtuelles) pour qu'elle puisse aussi utilisé les deux ORM.  

## Méthodologie organisationnelle
Nous avons organisé notre groupe autour d'un chef de projet. Il proposait les réunions et séances de travail. Il récupérait les comptes-rendus des différents membres de l'équipe. Il organisait le partage des tâches en proposant les différentes pistes évoquées par les tuteurs.
N'importe quel membre de l'équipe pouvait entrer en contact avec les tuteurs pour surmonter des difficultés techniques.

## Méthodologie technique

Nous avons utilisé un dépôt git en forkant à partir du projet officiel Openstack pour Glance, et du projet de Jonathan Pastor pour ROME. Puis nous avons travaillé sur une branche créée à partir de master.
Nous avons créé dans glance/db un répertoire "discovery" dans lequel nous avons concentré toutes nos modifications, de manière à réaliser un code non instrusif tant que cela était possible.
Nous échangions avec Jonathan Pastor pour l'intégration de nos modifications de ROME et la découverte de bugs.
Notre environnement de travail était Ubuntu 14.04 sur VirtualBox.
Afin de nous familiariser avec l'environnement Linux, Python et Openstack, nous avons commencé par travailler sur l'installation et le démarrage de Devstack, la version de développement d'Openstack.
Puis nous avons lancé le projet sur Glance et ROME.

## Workflow

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

### Architecture du code

![alt text](../schema2.jpeg)

(Glance registry est une couche optionnelle qui organise une communication sécurisée entre la couche d'abstraction de base de données et le contrôleur.)

### Réferences à `sqlalchemy`

Les références à `sqlalchemy` se trouvent dans `db.sqlalchemy.api`. De la même manière que pour `Nova`, nous avons copié/collé le code correspondant à l'API dans un nouveau package `db.discovery` et suivi la méthodologie suivante:

- Copier/coller le fichier `db.api.py` dans notre package `discovery`
- Exécuter les tests unitaires de l'API
- Modifier le code en fonction des erreurs rencontrées

Nous avions décidé que, puisque `Nova` est plus gros en terme de code que `Glance`, il était fort probable que toutes les requêtes à la base de données dont a besoin `Glance` soient déjà implémentée dans `ROME`. Cependant il fallait tester toutes les méthodes de l'API et ajouter les reqûetes manquantes à `ROME` s'il y en avait.

### Procédure de tests
#### Tests unitaires
Puisque nous travaillons sur l'API de la base de données de Glance, nous avons décidé de travailler sur tous les tests présents dans `tests.unit.v2.test_registry_api.py`.  
Dans tous ces tests, des données factices sont créées et toutes les fonctionnalités (opérations CRUD) de l'API sont testéesen envoyant des reqûetes en utilisant le protocole RPC.  
Pour effectuer ces tests nous utilisions un environnement Windows ou Mac avec PyCharm.  
Nous avons établi des tests unitaires "critiques" qui devaient absolument passer avant de passer aux tests d'intégration. Nous avons donc choisi les tests effectuant les opérations suivantes :

- création d'image
- mise à jour d'image
- suppression d'image
- récupération d'image (simple, c'est à dire sans filtre particulier)

Nous avons donc mis de cotés les autres tests présents qui étaient des tests de récupération d'image avec des filtres (par type, avec une pagination etc.)  

#### Tests d'intégration
Une fois les tests unitaires critiques validés, nous avons travaillé sur les tests d'intégration.  
Pour cela nous avons installé Devstack sur une machine virtuelle Ubuntu et remplacé le composant Glance par le nôtre (cela se fait simplement en modifiant l'URL de la source dans le fichier `~/devstack/stackrc`. On peut ensuite installer Devstack en lançant le script d'installation `stack.sh`.  
L'installation est validée lorsque le script se termine et que l'on peut démarrer Horizon et créer, modifier, supprimer, récupérer des images.

## Travail effectué
### Glance

- Remplacé les imports de `Query`, `Session`, opérateurs `or_` et `and_` qui étaient issus de `sqlalchemy` par ceux de `ROME`.
- Retiré la classe `GlanceBase` par celle implémentée dans `ROME`.
- Modifié la fonction `get_session`. La nôtre retourne simplement une instance de `RomeSession()`.
- Nous avons remarqué que la méthode `Query.one()` de `sqlalchemy` s'appelle `Query.first()` dans `ROME`, nous avons donc fait cette modification.
- Ajouté l'annotation `@global_scope` aux classes réprésentant les modèles dans `db.discovery.models`.
- Dans l'API de Glance, la fonction `_image_update`, il manquait les appels suivants: `session.add(image_ref)` et `session.flush()` requis par l'implémentation de `ROME` pour ajouter une image modifiée dans une session et pour nettoyer la session après la mise à jour.


Nous avons aussi rencontrés les problèmes suivants :

- Dans certains cas, les images de la liste d'images retournées en faisant l'appel `query.all()` étaient en fait une liste d'image. (Exemple: `query.all() = [[a,b], [c,d]]`). Nous avions corrigé ça de manière temporaire en ne récupérant que le premier élément mais Jonathan a corrigé ce bug plus tard dans une nouvelle version de ROME.
- Obligés de caster les id des images en `string`.

Tous ces changements et problèmes ont été découvert et effectués lors de l'exécution des tests unitaires.

### ROME
- Problèmes de packages
- hard_delete
- query.limit
- update functionr return number of results
- image_update où updated=false
- paginate_query
- query.union

### Déploiement avec script
### Difficultés majeures
