**Creer une image Docker avec une application Python Hellow World avec Pyspark integre.**  

Le l'app.py utilise FastAPI et Pyspark pour creer une application web qui execute une tache Spark et me retourne le resultat via une API WEB.  

En résumé, ce script crée une API web simple qui, lorsqu'elle est accédée via une requête GET à la racine (par exemple, http://localhost:4040/ si l'application est exécutée localement), exécute une tâche Spark qui parallélise la chaîne "Hello World", la collecte, puis retourne le résultat.

Prerequis:
- Installer Docker.
  https://docs.docker.com/engine/install/

**Build de l'image**  

Cloner le projet   
```
git clone git@github.com:p2zbar/ECF-Activite2.git
```

Build l'image
```
docker build -t pyspark .
```

Pour la lancer  
```
docker run -d -p 4040:4040 pyspark
```
L'app sera accessible sur http://localhost:4040  

Le buildspec.yml est utilse pour une CI/CD par les outils AWS.
