---
layout: post
title: "🐘 Partitioning"
topic: "Tech & Dev"
date: 2022-09-05
---

### Qu'est-ce que le partitioning?

C'est une technique utilisée pour améliorer les performances d'une base de données.

On va découper nos tables en plusieurs petites tables. Cela va permettre
d'améliorer le temps de réponse des requêtes SQL car notre ensemble de données sera plus
petit et nous n'aurons plus besoin de parcourir des millions de données.

### Technique utilisée - Partitionnement par liste

Afin de partitionner une table, nous commençons par ajouter une nouvelle colonne contenant la clé de partitionnement. Cette colonne sera utilisée pour savoir dans quelle partition nos données se trouvent.

Ensuite nous nous assurons que chaque contrainte suivante inclut la clé de partitionnement:

- La clé primaire
- Toutes les clés étrangères référencent la table qui va être partitionnée
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

- Maintenance des index car ils sont plus petits et plus rapides
- Autovacuum tourne en parallèle avec un process pour chaque partition

### Liens

- [Postgres partitioning](https://www.postgresql.org/docs/current/ddl-partitioning.html)
- [CI Time decay](https://docs.gitlab.com/ee/architecture/blueprints/ci_data_decay/pipeline_partitioning.html)
- [postgres.fm](https://postgres.fm/episodes/partitioning)
- [PlanetScale](https://planetscale.com/learn/articles/sharding-vs-partitioning-whats-the-difference#what-is-partitioning-)
