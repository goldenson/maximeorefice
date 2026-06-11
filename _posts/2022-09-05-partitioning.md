---
layout: post
title: "🐘 Partitioning"
topic: "Tech & Dev"
date: 2022-09-05
---

### Qu'est ce que le partitioning?

C'est une technique utilisé pour améliorer les performances d'une base de donnée.

On va découper nos tables plusieurs petites tables. Cela va permettre
d'ameliorer le temps de réponse des requêtes SQL car notre emsemble de données sera plus
petit et nous n'aurons plus besoin de parcourir des millions de données.

### Technique utilisé - Partitionnement par liste

Afin de partitionner une table, nous commençons par ajouter une nouvelle colonne contenant la clé de partionnement. Cette colonne sera utilisé pour savoir dans quel partition nos données se trouvent.

Ensuite nous nous assurons que chaque contrainte suivantes inclus la clé de partionnement:

- La clé primaire
- Toutes les clés étrangères référencent la table qui va être partitionné
- Les contraintes d'unicité

### Désactiver un index

Nous désactivons dans un premier temps notre index avant de le supprimer afin de s'assurer de ne pas introduire de dégradation de performance.

```sql
-- Disable index: index_name_unique
UPDATE pg_index SET indisvalid = true
WHERE indexrelid = (
  SELECT oid FROM pg_class WHERE relname = 'index_name_unique'
);
```

### Avantages

- Index maintenance car les indexes sont plus petits et plus rapides
- Autovaccum run en parallel avec un process pour chaque partition

### Liens

- [Posgres partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
- [CI Time decay](https://docs.gitlab.com/ee/architecture/blueprints/ci_data_decay/pipeline_partitioning.html)
- [postgres.fm](https://postgres.fm/episodes/partitioning)
- [PlanetScale](https://planetscale.com/learn/articles/sharding-vs-partitioning-whats-the-difference#what-is-partitioning-)
