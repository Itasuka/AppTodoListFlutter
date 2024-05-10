# My todo

Ce document présente une application développée dans le cadre d'un projet de Master 1, 
réalisé en collaboration avec Maxime Badet et Nicolas Schivre.

## Comment lancer l'application

Pour lancer l'application sur Android et iOS, vous aurez seulement besoin de Flutter ainsi que de 
Visual Studio ou Android Studio. Cependant, pour la compilation sur Windows, l'extension  
"Desktop development with C++" de Visual Studio est nécessaire car la base de données dépend de 
cette extension.

## Différences avec le sujet

Bien que l'application suive globalement le projet, nous avons effectué un choix différent 
par rapport au sujet. En effet, le sujet mentionnait qu'un simple clic sur une tâche 
permettrait de la proposer à la modification, tandis que nous avons opté pour l'affichage des 
détails lors du clic sur une tâche, en ajoutant un bouton d'édition pour chaque tâche. 
Nous avons pris cette décision pour des raisons d'ergonomie.

## Ajout par rapport au sujet

- Possibilité de balayer les tâches pour les ajouter aux favoris.
- Mise en place d'une base de données pour conserver les tâches.
- Utilisation de SharedPreferences pour enregistrer les préférences utilisateur.
- Ajout d'un séparateur pour masquer les tâches terminées, offrant un affichage plus propre.
- Option pour afficher la carte en plein écran grâce à un bouton dédié.
- Utilisation d'une API pour trouver des adresses spécifiques.
- Intégration d'un bouton pour utiliser les données GPS afin d'ajouter une adresse à une tâche.
- Animation de l'icône météo.
- Changement de couleur de l'icône météo selon l'heure à l'adresse choisie (couleur jour entre 7h et 21h, couleur nuit le reste du temps).
- Possibilité de passer à un thème sombre dans les options.

## Dépendances 

- intl: Pour définir un format d'affichage des dates utilisé dans l'application.
- http: Pour effectuer des requêtes vers le web et obtenir des informations depuis différentes APIs.
- lottie: Gestion des icônes animées pour les prévisions météo.
- flutter_map: Fournit des widgets pour afficher la carte dans les détails des tâches avec adresse ainsi que en mode plein écran.
- sqflite: Base de données qui fonctionne nativement sur Android et iOS.
- sqflite_common_ffi et sqflite_common_ffi_web: Permettent de faire fonctionner la base de données sur Windows et sur une application web.
- path: Facilite la récupération du chemin de la base de données dans ce projet.
- shared_preferences: Pour enregistrer des données simples (booléens, entiers, etc.) localement.
- osm_nominatim: Permet de récupérer des coordonnées à partir d'une adresse ou inversement.
- geolocator: Fournit des fonctionnalités de géolocalisation pour les applications Flutter.

## Limitations 

L'application peut parfois être lente car certaines APIs, comme osm_nominatim, sont très lentes à répondre. 
Pour contourner ce problème, l'utilisation des APIs de Google, bien que payantes, pourrait être envisagée. 
Nous avions également l'intention d'ajouter une fonctionnalité d'autocomplétion pour les adresses, 
mais cette option est uniquement proposée par Google (également payante).

Nous avons utilisé la base de données recommandée dans le cours, mais malheureusement, 
elle n'est pas disponible sur Windows et sur le web. Nous avons examiné plusieurs autres bases de 
données qui offraient une compatibilité multiplateforme avec Flutter, mais cela aurait nécessité de s'écarter du contenu du cours. 
Nous avons donc opté pour l'utilisation de sqflite_common_ffi et sqflite_common_ffi_web, 
qui sont moins efficaces mais résolvent le problème de compatibilité.

## Perspectives

- Ajouter une autocompletion pour les adresses
- Proposition d'un hébergement en ligne des tâches avec un serveur pour permettre la récupération des tâches sur n'importe quelle plateforme.
- Investissement dans des APIs payantes mais plus efficaces.
- Révision du design avec un spécialiste du domaine.
- Proposition de plus d'options de personnalisation pour les tâches ou pour le tri de ces dernières.