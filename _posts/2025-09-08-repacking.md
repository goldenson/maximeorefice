---
layout: post
title: "📦 Repacking"
date: 2025-09-08
image: "/assets/images/posts/pg-repack.png"
---

![pg-repack](/assets/images/posts/pg-repack.png)

## Table Bloat

This week I've been dealing with PostgreSQL table bloat issues with some production data. When tables accumulate dead tuples from frequent updates and deletes, they can become severely bloated, impacting query performance.

I explored [pg_repack](https://github.com/reorg/pg_repack/), a powerful extension that reorganizes tables online without holding exclusive locks.

## Why pg_repack?

Unlike `VACUUM FULL`, pg_repack allows concurrent reads and writes during the reorganization process. This makes it perfect for production environments where downtime isn't an option.

The tool works by creating a new table copy, applying all changes via triggers, and then swapping the tables atomically.

> pg_repack removes bloat from tables and indexes, and optionally restores the physical order of clustered indexes.

### How to run it?

Note: This was tested on macOS with a local PostgreSQL instance.

First we installed pg_repack using the PostgreSQL Extension Network client:

```shell
$ brew install pgxnclient
$ cd /path/to/development-kit
$ pgxn install pg_repack
```

Then we enabled the extension in our target database:

```sql
CREATE EXTENSION IF NOT EXISTS pg_repack;
```

Finally we ran pg_repack on a specific partitioned table that was experiencing heavy bloat:

```sql
$ pg_repack \
  --dbname="postgresql://user:pass@127.0.0.1:5432/development_db" \
  --table='gitlab_partitions_dynamic.ci_builds' \
  --jobs=4 \
  --no-order \
  --wait-timeout=36000 \
  -w \
  --echo \
  2>&1 | ts '[%Y-%m-%d %H:%M:%S]' | tee -a "pg_repack_ci_builds_$(date +%Y%m%d_%H%M%S).log"
```

The `--echo` flag shows all SQL commands being executed, which is helpful for understanding what pg_repack is doing behind the scenes.

The entire repack of our 500GB partition completed in 3 hours, achieving a 30% reduction in table size.

### Links

- [pg_repack documentation](https://reorg.github.io/pg_repack/)
- [PostgreSQL bloat explained](https://www.postgresql.org/docs/current/routine-vacuuming.html)
- [PGXN - PostgreSQL Extension Network](https://pgxn.org/)
- [Understanding MVCC and bloat](https://www.postgresql.org/docs/current/mvcc.html)
