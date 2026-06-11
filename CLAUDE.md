# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal website at https://maximeorefice.com, built with **Jekyll** (Ruby 3.4.1) and deployed as a static site. The repo also contains standalone Ruby scripts that run as scheduled GitLab CI jobs (Telegram bots), unrelated to the website's HTTP serving.

## Commands

```bash
bundle install                       # install gems
bundle exec jekyll serve             # local dev server with live reload (http://localhost:4000)
bundle exec jekyll build             # generate static site into _site/
bundle exec rake generate_cover_name # rename assets/images/covers/1.jpg to match the first book in _data/books.yml

ruby scripts/db_setup.rb             # (re)create the trainings table in _data/database.sqlite
bundle exec ruby scripts/daily_birthday.rb  # run the birthday Telegram bot locally (needs env vars)
```

There is no test suite.

## Architecture

### Jekyll site
- **Content** lives in `_posts/` (blog posts, `YYYY-MM-DD-slug.md` with `layout: post` front matter), and top-level `*.markdown` pages (`index`, `present`, `books`, `post`). Permalinks use the `pretty` style.
- **Layouts** in `_layouts/` (`default`, `home`, `page`, `post`, `book`), partials in `_includes/`, styles in `_sass/`. The `book` layout renders `_data/books.yml`.
- **Plugins** (see `_config.yml`): sitemap, seo-tag, relative-links, target-blank, last-modified-at, and **`jekyll_sqlite`**.

### SQLite-backed data (the non-obvious part)
The CrossFit training heatmap is driven by a SQLite database, not a YAML file:
- `_data/database.sqlite` holds a `trainings` table (`date`, `showup`). Schema is defined in `scripts/db_setup.rb`.
- The `jekyll_sqlite` plugin runs the query in `_config.yml`'s `sqlite:` block at build time and exposes the rows as `site.data.trainings`.
- `_includes/crossfit-graph.html` reads `site.data.trainings` to render the year-by-year heatmap.
- Rows are written by `telegram/crossfit_bot.rb`, which directly INSERTs/UPDATEs into the same `.sqlite` file based on a daily Telegram yes/no prompt. So the DB is the shared source of truth between the bot and the site build — committing an updated `database.sqlite` is what publishes new training data.

### Telegram bots (`telegram/`, `scripts/`)
Standalone Ruby scripts, each a class configured entirely via `ENV` (loaded with `dotenv` locally, GitLab CI variables in CI):
- `birthday_bot.rb` — reads `_data/_birthdays.yml`, posts daily/monthly birthday messages (`TELEGRAM_TOKEN`, `GROUP_ID`).
- `crossfit_bot.rb` — interactive bot writing to `database.sqlite`.
- `scripts/*.rb` are thin entrypoints wrapping the bot classes.

`.gitlab-ci.yml` runs `birthday_job` only on `schedule` pipelines — never on push. It is a scheduled cron task, not part of building or deploying the site.

## Deployment
- `bundle exec jekyll build` produces `_site/`.
- The `Dockerfile` copies `_site/` into an `nginx` image.
- **Kamal** (`config/deploy.yml`) deploys that image (`goldenson/maximeorefice`, pushed to the GitLab registry) to the production server with Let's Encrypt SSL. Secrets come from `.env` / `.kamal/secrets`.
