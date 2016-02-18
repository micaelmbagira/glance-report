# Rapport technique
## Contexte et sujet
Ce projet d'option s'inscrit dans le cadre du projet de recherche [DISCOVERY, Beyond the Clouds](http://beyondtheclouds.github.io/) mené par l'École des Mines de Nantes dont le but est d'étudier les possibilités d'un Cloud distribué.  
Notre travail doit faire suite à celui effectué par Jonathan Pastor qui a créé un ORM NoSQL appelé [ROME](github.com/badock/rome) pour remplacer SQLAlchemy utilisé par les différentes API de l'application open-source [Devstack](http://docs.openstack.org/developer/devstack/). Il a aussi modifié l'API composant Nova (qui s'occupe de la gestion des unités de calcul) pour qu'elle puisse au choix utiliser SQLAlchemy ou ROME.

## Cahier des charges
Le travail que nous avions à faire était de modifier de la même manière, l'API du composant Glance (chargé de la gestion des images virtuelles) pour qu'elle puisse aussi utiliser les deux ORMs.  


## Méthodologie technique

Nous avons utilisé un dépôt git en faisant un fork à partir du projet officiel Openstack pour Glance, et du projet de Jonathan Pastor pour ROME. Puis nous avons travaillé sur une branche créée à partir de master.  
Nous avons créé dans `glance/db` un répertoire `discovery` dans lequel nous avons concentré toutes nos modifications, de manière à réaliser un code non instrusif tant que cela était possible.
Nous échangions avec Jonathan Pastor pour l'intégration de nos modifications de ROME et la découverte de bugs.  
Notre environnement de travail était Ubuntu 14.04 sur VirtualBox.
Afin de nous familiariser avec l'environnement Linux, Python et Openstack, nous avons commencé par travailler sur l'installation et le démarrage de Devstack, la version de développement d'Openstack.
Puis nous avons lancé le projet sur Glance et ROME.

## Workflow

1. Installer et démarrer Glance, puis ajouter ROME
2. S'assurer que Glance utilise ROME.
  - Recherche sur les tests unitaires
  - S'assurer que la librairie utilisée par Glance est bien ROME et non pas SQLAlchemy
3. Rendre ROME fonctionnel : Installer toutes les dépendances.
4. Faire fonctionner les tests unitaires critiques pour un fonctionnement minimal.
5. Intégrer notre Glance dans Devstack
  - Travail sur les autres tests unitaires.
  - Régler des problèmes dans ROME critiques pour le lancement de Devstack.
6. Finaliser le projet
  - Réaliser un script pour forcer Devstack à utiliser notre version de Glance après lancement.
  - Rédiger et/ou finaliser les rapports.

### Architecture du code

![alt text](../schema2.jpeg)

(Glance registry est une couche optionnelle qui organise une communication sécurisée entre la couche d'abstraction de base de données et le contrôleur.)

### Réferences à SQLAlchemy

Les références à SQLAlchemy se trouvent dans `db.SQLAlchemy.api`. De la même manière que pour `Nova`, nous avons copié/collé le code correspondant à l'API dans un nouveau package `db.discovery` et suivi la méthodologie suivante:

- Copier/coller le fichier `db.api.py` dans notre package `discovery`
- Exécuter les tests unitaires de l'API
- Modifier le code en fonction des erreurs rencontrées

Nous avions décidé que, puisque `Nova` est plus gros en terme de code que `Glance`, il était fort probable que toutes les requêtes à la base de données dont a besoin `Glance` soient déjà implémentée dans ROME. Cependant il fallait tester toutes les méthodes de l'API et ajouter les reqûetes manquantes à ROME s'il y en avait.

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

## Travail effectué dans Glance

- Remplacé les imports de `Query`, `Session`, opérateurs `or_` et `and_` qui étaient issus de SQLAlchemy par ceux de ROME.
- Retiré la classe `GlanceBase` par celle implémentée dans ROME.
- Modifié la fonction `get_session`. La nôtre retourne simplement une instance de `RomeSession()`.
- Nous avons remarqué que la méthode `Query.one()` de SQLAlchemy s'appelle `Query.first()` dans ROME, nous avons donc fait cette modification.
- Ajouté l'annotation `@global_scope` aux classes réprésentant les modèles dans `db.discovery.models`.
- Dans l'API de Glance, la fonction `_image_update`, il manquait les appels suivants: `session.add(image_ref)` et `session.flush()` requis par l'implémentation de ROME pour ajouter une image modifiée dans une session et pour nettoyer la session après la mise à jour.

## Retour d'expérience
###Glance

Nous avons aussi rencontrés les problèmes suivants :

- Dans certains cas, les images de la liste d'images retournées en faisant l'appel `query.all()` étaient en fait une liste d'image. (Exemple: `query.all() = [[a,b], [c,d]]`). Nous avions corrigé ça de manière temporaire en ne récupérant que le premier élément mais Jonathan a corrigé ce bug plus tard dans une nouvelle version de ROME.
- Obligés de caster les id des images en `string`.
- Dans le fichier requirements.txt il faut changer des lignes `Routes!=2.0,!=2.1,>=1.12.3;python_version=='2.7'` et `Routes!=2.0,>=1.12.3;python_version!='2.7'` 
sur `Routes!=2.0,!=2.1,>=1.12.3#;python_version=='2.7'` et faire pareil pour le fichier test-requirements.txt, sinon nous avons une erreur de parsing lors de l'installation des requirements via pip. 

Tous ces changements et problèmes ont été découvert et effectués lors de l'exécution des tests unitaires.


### ROME

Lors des tests unitaires nous avons aussi rencontrés des problèmes liés à ROME : 

- Lors de l'installation, nous avons du changer les imports de type `
from oslo.db.SQLAlchemy...` par `from oslo_db.SQLAlchemy...`. Après en avoir parlé avec Jonathan, il se trouve que la version de `oslo` qu'utilise Glance (datant de 3 mois environ) est différente de celle qu'utilise Nova (datant d'1 an environ) et le nom de l'import a changé. Pour résoudre ce problème, Jonathan a pris en compte les 2 cas dans ROME.
- Résolution d'un bug de ROME concernant la suppression : SQLAlchemy propose deux types de suppression: `hard_delete` et `soft_delete`. Or ROME avec `Query.delete` produisait un soft_delete, c'est-à-dire que les données étaient marquées supprimées mais non écrasées, à l'inverse du comportement `hard_delete` attendu par les tests unitaires de Glance.
- Ajout d'une fonction `query.limit` à ROME, qui limite le nombre de résultats renvoyés.
- Nous avions trouvé un bug dans la fonction `query.update`. Contrairement à l'implémentation de SQLAlchemy, cette fonction ne retournait rien. Ce bug a depuis été réparé.
- Pendant plusieurs semaines, nous avions été bloqués le problème suivant. Lors de l'installation de Devstack, un test unitaire était chargé de ajouter une image mais l'installation s'interrompait à cause d'une erreur `410 Gone`. L'erreur venait de la fonction `image_update` où la fonction `query.update` retournait le mauvais nombre de résultats récupérés. Cette erreur a aussi été corrigée dans ROME.
- Vers la fin de l'installation, un test était chargé de lister les images existantes dans la base de données. Ce test tournait sans s'arrêter et bloquait l'installation. Jonathan a découvert que Devstack attendait des des résultats faisant appel à la fonction `paginate_query` qui est dans `glance.db.discovery.api`. L'erreur venait de `query.order_by` et a été corrigée par Jonathan.
- Enfin, la méthode `query.union` de ROME n'avait pas été implémentée, nous avions regardé le principe d'implémentation de la [méthode dans SQLAlchemy](http://docs.SQLAlchemy.org/en/latest/orm/query.html#SQLAlchemy.orm.query.Query.union) mais cela semblait un peu compliqué pour nous. L'implémentation a été faite depuis par Jonathan.
- Pour que ROME fonctionne bien, il faut copier le fichier de configuration de ROME `rome/etc/rome.conf` dans  le répértoire `/etc/rome.conf`. Si non, on va obtenir une erreur.


### Déploiement avec script

Après l'installation de Devstack, nous avons écrit un script en shell qui permet de changer la version de Glance après déploiement et sans relancer l'installation complète.

script.sh

````bash
ps aux | grep glance | grep -v "grep" | awk '{print $2}' | xargs kill -9
pushd /opt/stack
rm -rf glance
git clone https://github.com/beyondtheclouds/glance -b discovery
pushd glance
sudo python setup.py install
popd
popd
screen -S "g-api" -dm bash start-glance-api.sh
screen -S "g-reg" -dm bash start-glance-registry.sh
````

start-glance-api.sh

````bash
/usr/local/bin/glance-api --config-file=/etc/glance/glance-api.conf
````

start-glance-registry.sh

````bash
/usr/local/bin/glance-registry --config-file=/etc/glance/glance-registry.conf
````

###Calcul des performances

Nous avons mesuré le temps mis par des requêtes élémentaires telles que create, get_all ou delete utilisant la librairie ROME ou la libraire de SQLAlchemy et les comparer. Les mesures ont été prises sur une machine virtuelle ainsi ils ne sont pas représentatif d'un environnement tournant normalement sous Ubuntu, cependant ces mesures peuvent être utilisées à titre comparatif. 

Pour relever ces mesures, nous avons utilisés les tests unitaires présents dans le projet glance. Ces tests sont accessibles au chemin suivant 

````
glance/glance/tests/unit/v2/test_registry_api.py
````

L'IDE PyCharm de JetBrains mesure et renvoie le temps pris par chaque test pour s'exécuter. Les temps relevés sont donc les temps mesurés par PyCharm sur les tests unitaires de glance.

| Requête                 | Temps SQLAlchemy | Temps ROME |
| ----------------------- |:----------------:| ----------:|
| ``image_get``           | right-aligned    | $1600      |
| ``image_get_all``       | centered         |   $12      |
| ``image_create``        | are neat         |    $1      |
| ``image_update``        | right-aligned    | $1600      |
| ``image_destroy``       | right-aligned    | $1600      |
| ``image_member_find``   | centered         |   $12      |
| ``image_tag_create``    | are neat         |    $1      |


##Annexes
###Composition des tests
####Test get
* ``test_show : cmd = image_get``
* ``test_show_unknown : cmd = image_get``
* ``test_get_index : cmd = image_get_all``
* ``test_get_index_marker : cmd = image_get_all && image_create(x3)``
* ``test_get_index_marker_and_name_asc : cmd = image_get_all && image_create``
* ``test_get_index_marker_and_name_desc : cmd = image_get_all && image_create``
* ``test_get_index_marker_and_disk_format_asc : cmd = image_get_all && image_create``
* ``test_get_index_marker_and_disk_format_desc : cmd = image_get_all & image_create``
* ``test_get_index_marker_and_container_format_asc : cmd = image_get_all && image_create``
* ``test_get_index_marker_and_container_format_desc : cmd = image_get_all & image_create``
* ``test_get_index_unknown_marker : cmd = image_get_all``
* ``test_get_index_limit : cmd = image_get_all && image_create(x2)``
* ``test_get_index_limit_marker : cmd = image_get_all && image_create(x2)``
* ``test_get_index_filter_on_user_defined_properties : cmd = image_get_all(x8) && image_create``
* ``test_get_index_sort_default_created_at_desc: cmd = image_get_all && image_create(x3)``
* ``test_get_index_sort_name_asc: cmd = get_all && image_create(x3)``
* ``test_get_index_sort_status_desc: cmd = image_get_all && image_create(x2)``
* ``test_get_index_sort_disk_format_asc: cmd = image_get_all && image_create(x2)``
* ``test_get_index_sort_container_format_desc: cmd = image_get_all && image_create(x2)``
* ``test_get_index_sort_size_asc: cmd = image_get_all && image_create(x2)``
* ``test_get_index_sort_created_at_asc: cmd = image_get_all && image_create(x2)``
* ``test_get_index_sort_updated_at_desc: cmd = image_get_all && image_create(x2)``
* ``test_get_index_sort_multiple_keys_one_sort_dir: cmd = image_get_all(x2) && image_create(x3)``
* ``test_get_index_sort_multiple_keys_multiple_sort_dirs: cmd = image_get_all(x4) && image_create(x3)``
* ``test_get_image_members: cmd = image_member_find``

####Test create
* ``test_create_image: cmd = image_create``
* ``test_create_image_with_min_disk: cmd = image_create``
* ``test_create_image_with_min_ram: cmd = image_create``
* ``test_create_image_with_min_ram_default: cmd = image_create``
* ``test_create_image_with_min_disk_default: cmd = image_create``
* ``test_create_image_bad_name: cmd = image_create``
* ``test_create_image_bad_location: cmd = image_create``
* ``test_create_image_bad_property: cmd = image_create(x2)``

####Test update
* ``test_update_image: cmd = image_update``
* ``test_update_image_bad_tag: cmd = image_tag_create``
* ``test_update_image_bad_name: cmd = image_update``
* ``test_update_image_bad_location: cmd = image_update``
* ``test_update_image_bad_property: cmd = image_update(x2)``

####Test delete
* ``test_delete_image: cmd = image_get_all(x2) && image_destroy``
* ``test_delete_image_response: cmd = image_destroy``

