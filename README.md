# scala-bazel-graphql-example

## What is this?

This repo is a the start of a travel api aggregation service that uses a few public apis that it pulls together into a a single graphql api served over http.

More importantly though it is meant to serve as an example of combining several technologies together some of which are fairly sparsely documented or hard to use together.

This example leverages:
- **Tools**
    - Scala 2.12.8
    - Bazel for builds
        - scala-rules for scala support in bazel
        - bazel-deps for third party deps in scala / bazel
    - Metals for code completion in VSCode or similar
- **Scala Libraries**
    - Scalatest for tests
    - Sangria for the graphql implementation
    - Circe for JSON parsing
    - sttp for HTTP requests


## How to run it

Get api keys from WorldWeatherOnline and Triposo and populate them into `config.sample.yaml`. Then simply run:
```bash
bazel run :app $(pwd)/config.sample.yaml
```

This will serve graphql api on http://localhost:1337, you can then query it with a graphql client like Insomnia or Graphiql.

To run the tests simply run:
```bash
bazel run :tests
```

## Features

- Incremental builds with Bazel
- Custom Scala version in scala-rules
- Editor auto-complete with Metals
- Tests through Bazel with Scalatest and rules-scala
- Third party deps in Bazel with bazel-deps
- Circe autoderived {En,De}coders working under Bazel

## Questions

### Why does this have a `build.sbt` file if you are using bazel?

That's because Metals needs to import it in order to offer type-hinting etc.
