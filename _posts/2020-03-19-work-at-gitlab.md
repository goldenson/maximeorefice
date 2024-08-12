---
layout: post
title: "🦊 Work at GitLab"
date: 2020-03-19
---

I'm working for the [biggest remote company](https://handbook.gitlab.com/handbook/company/culture/all-remote/) in the world! I'm grateful to be part of this adventure as [our values](https://handbook.gitlab.com/handbook/values/) perfectly fit with me.

[Explore](https://about.gitlab.com/company/team/) our worldwide team.

## Role

I'm currently a [Senior Backend Engineer](https://about.gitlab.com/job-families/engineering/backend-engineer/) working with `Ruby`.

I love designing new features and fixing bugs. Being all remote is challenging at first, but once you start it's difficult to come back to a regular office.

## Team

I'm part of the [Verify:Pipeline Security](https://handbook.gitlab.com/handbook/engineering/development/ops/verify/pipeline-security/) team.

Our goal is to make the CI experience easier for everybody. This means we create tools to help companies developping better and safer software:

- Maintain [Build Artifacts](https://docs.gitlab.com/ee/ci/jobs/job_artifacts.html)
- Manage [CI Variables](https://docs.gitlab.com/ee/ci/variables/)
- Secure pipeline with [CI Job Token](https://docs.gitlab.com/ee/ci/jobs/ci_job_token.html)
- Building [Gitlab Secrets Manager](https://gitlab.com/groups/gitlab-org/-/epics/10108)

## Project

You can follow [our roadmap](https://about.gitlab.com/direction/maturity/#verify), if you are curious to know what we are working on.

### Now

- Exploring how to build a [native secrets manager](https://docs.gitlab.com/ee/architecture/blueprints/secret_manager/) for `GitLab`

### Done

#### 2024 (July - September)

- Integrating [`openbao`](https://openbao.org/) within our [pdevelopment tooling](https://gitlab.com/groups/gitlab-org/-/epics/14406)

#### 2024 (January-June)

- Implement **CI Partition Management** framework, see [epic](https://gitlab.com/groups/gitlab-org/-/epics/11815), see all [MRs merged](https://gitlab.com/gitlab-org/gitlab/-/merge_requests?scope=all&state=merged&author_username=morefice&label_name[]=CI%20data%20partitioning) related to this project.

#### 2023

- Continue to scale the  `CI database` by partitioning more [tables](https://gitlab.com/groups/gitlab-org/-/epics/11811) and fixing a bunch of [broken queries](https://gitlab.com/groups/gitlab-org/-/epics/11812)

#### 2022

- Scaling `CI` database with partitioning strategy, see [epic](https://gitlab.com/groups/gitlab-org/-/epics/5417) and [architecture](https://docs.gitlab.com/ee/architecture/blueprints/ci_data_decay/pipeline_partitioning.html).

#### 2021

- Scaling `Ci::Build`, the biggest table of `GitLab`, see [epic](https://gitlab.com/groups/gitlab-org/-/epics/5909) and [architecture](https://docs.gitlab.com/ee/architecture/blueprints/ci_scale/#queuing-mechanisms-are-using-the-large-table)
- Set up the foundation of [merge request approval rule](https://docs.gitlab.com/ee/user/project/merge_requests/merge_request_approvals.html) for code coverage, see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/15765), [POC](https://gitlab.com/gitlab-org/gitlab/-/merge_requests/59698) and [demo](https://www.youtube.com/watch?v=IEQpZWyWKuQ)
- Replicate [PipelineArtifact](https://docs.gitlab.com/ee/ci/pipelines/pipeline_artifacts.html) with [Geo feature](https://docs.gitlab.com/ee/development/geo.html), see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/238464)
- Re-architect [Coverage Data analytics](https://docs.gitlab.com/ee/user/group/repositories_analytics), see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/293825)
- Implement [Code quality MR diff](https://docs.gitlab.com/ee/user/project/merge_requests/code_quality.html#code-quality-in-diff-view), see [epic](https://gitlab.com/groups/gitlab-org/-/epics/4609)
- Expose [Code coverage](https://docs.gitlab.com/ee/user/group/repositories_analytics/#repositories-analytics) to our `GraphQL API`, see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/231386)
- Implement [Code quality](https://docs.gitlab.com/ee/user/project/merge_requests/code_quality.html) processing in the backend, see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/271077)

#### 2020

- Implement [Code coverage GraphQL API](https://docs.gitlab.com/ee/user/group/repositories_analytics), see [epic](https://gitlab.com/groups/gitlab-org/-/epics/2838) or [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/231386)
- Improve the performance of our [Code coverage](https://docs.gitlab.com/ee/user/project/merge_requests/test_coverage_visualization.html) feature, see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/211410)
- Improve the performance of our [JUnit](https://docs.gitlab.com/ee/ci/unit_test_reports.html) feature, see [epic](https://gitlab.com/groups/gitlab-org/-/epics/3198)
- Display screenshots from a [JUnit XML report](https://docs.gitlab.com/ee/ci/junit_test_reports.html#viewing-junit-screenshots-on-gitlab), see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/6061)
- Display an [accessibility report](https://docs.gitlab.com/ee/user/project/merge_requests/accessibility_testing.html) on a `Merge Request`, see [issue](https://gitlab.com/gitlab-org/gitlab/-/issues/39425)

### Links

- [Ship small](https://dev.to/mscccc/how-we-use-ship-small-to-rapidly-build-new-features-at-github-5cl9)
- [How I work](https://gitlab.com/morefice/readme)
