---
layout: post
title: "⚡️ Application Performance"
date: 2020-03-18
---

In this course we learned what are the most common mistakes that lead to poor performance. Let's see how we can avoid those mistakes and how to fix them.

## Week 1 - Assessment

### Prerequisite

This is a mandadory step that will help us to understand what is going on with our application.

You want to have all kind of metrics that will tell you how your app behaves.

You can use some of these tools or build your own monitoring tools.

- [New Relic](https://newrelic.com/)
- [Scout](https://scoutapm.com/)
- [Skylight](https://www.skylight.io/)

### Identify the problem

- `95th percentiles` common metric that will give you an overall data point.
- [Apdex](https://docs.newrelic.com/docs/apm/new-relic-apm/apdex/apdex-measure-user-satisfaction): measuring user satisfaction

### Benchmarking

#### Apache benchmark

This software is doing load testing to understand how your application is responding with a number of requests performed for a given time.

`ab -n 1000 -t 30 http://127.0.0.1:3000/`

> Perform 1000 requests for 30 seconds

#### Benchmark-ips

This is useful for analyzing performance with ruby application. It generates a report of your **previous vs new code**.

```ruby
# Gemfile
gem "benchmark-ips"

# benchmark.rb
Benchmark.ips do |x|
  x.report("addition") { 1 + 2 }
  x.report("addition2", "1 + 2")
  x.compare!
end
```

### Reading

- [Time Consumed](https://mailchi.mp/railsspeed/what-the-heck-is-time-consumed-in-my-new-relic-or-scout-dashboard)
- [Memory Metrics](https://mailchi.mp/railsspeed/one-ruby-performance-metric-you-should-be-paying-attention-to)
- [New Relic Ruby](https://mailchi.mp/railsspeed/whats-new-relics-ruby-vm-tab-for)
- [Building your own Ruby dashboard](https://mailchi.mp/railsspeed/understanding-ruby-vm-stats-part-two-now-what-to-do-about-it)

## Week 2 - Profiling

### Prerequisite

Install the following gems in you `Gemfile`.

```ruby
gem "rack-mini-profiler"
gem "flamegrah"
gem "memory_profiler"
gem "stackprof"
```

### Profiling

**80% of the time**, there is a problem with the database so we need to improve our SQL queries.

These tools added above will help us identify where the problem is coming from.

### Reading a flamegraph

- Prefer `JSON` format for `stackprof`
- Look for long flat section, it usually means a long running method.
- Add URL params: `?pp=flamegrah&flamegraph_sample_rate=0.1`
- It's not relevant with multi threaded servers.

> [speedscope.app](http://speedscope.app) is a great tool for visualization

### Reading a memory graph

- Add the URL param `?pp=profile-memory`
- Allocated = Object has been created
- Retained = After a controller performed an action, it still has references to it

### Reading

- [Reading a flamegraph](https://mailchi.mp/railsspeed/how-to-read-flamegraphs-and-profiling-results)

## Week 3 - SQL

### Prerequisite

Install the [TestProf](https://test-prof.evilmartians.io/#/) gem in you `Gemfile`.

```ruby
gem "test-prof"
```

This is a powerful tool that helps us to track perfomance regressions which is hard to detect with our human brains.

### Database tricks

- [Bullet Gem](https://github.com/flyerhzm/bullet): Avoid `N+1` calls
- Enable: `config.active_record.verbose_query_logs = true`
- Use `includes` most of the time
- Don't use count, prefer `counter_cache` or `.load.size`

### Reading

- [ActiveRecord Mistakes](https://www.speedshop.co/2019/01/10/three-activerecord-mistakes.html)

## Week 4 - Scaling

This section help us to understand resources efficiency. How many `CPU/memory` do I need for my system to perform well? What are the breaking points of our system?

### Queueing System

The [Amdahl's law](https://en.wikipedia.org/wiki/Amdahl%27s_law) is an interesting formula which gives the theoretical speedup in latency of the execution of a task at fixed workload that can be expected of a system.

#### [Kendall's notation](https://en.wikipedia.org/wiki/Kendall%27s_notation)

There are 2 existing contributions:

- Constant distribution : `D/D/1`
- Poisson distribution : `M/M/C` (big spike with long tail)

1. Arrival Rate (eg: 600 RPS)
2. Service Time (eg: 0.3 S/R)
3. Number of Servers (eg: 180 processes)

What is a good range for **utilization**?

> As high as possible without adding exessive queue time (50-80%).

- Web Request: queue time <= 10-20% service time, 300ms 30-60s
- Background jobs: queue time <= 60-90% service time, sla dependent

Background jobs are cheaper to run than web requests.

Let's take a look a some companies and their numbers:

#### Twitter

- Carried = 600 \* 0.3 = 180
- Utilization = 180/180 = 1 = 100%

If Utilization > 100%, queue time is growing at the time requests are arriving.

#### Shopify

(833 \* 0,072/1172) = 0.051174061 = 5%

Why `5%` is acceptable ? Flash Sale so they need to anticipate a lot!

#### Scaling things up

Ruby threads are running ruby code concurrently which means **only 1 thread runs ruby code at once.**

> [Understanding Ruby Threads](https://thoughtbot.com/blog/untangling-ruby-threads)

Puma with ~5 threads and ~25% IO will inreases offered traffic per process by 1.3x.

CPU LOAD = The number of active CPU tasks = Carried Traffic for CPUs = AVG in system

## Conclusion

1. Analyze metrics
2. Identify problem code areas with a profiler
3. Establish benchmark
4. Iterate on solution

This workshop was given by **Nate Berkopoc**, [register on his website](https://www.speedshop.co) if you want to learn more about it.
