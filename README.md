# Domain Driven Hexagonal/Clean Architecture

This project is an exploration of what it would look like to implement the guts of an application without a user interface or persistence layer. The application follows a hexagonal (or clean) architecture. And, everything is test-driven for my sanity.

## Organization

The project is organized as follows:

* Domain - contains all the core domain classes
  * Entities
  * Repositories
  * Use Cases
* Lib - contains bits that could be a framework
* Spec - contains tests

## Learnings so far...

1. There is no need for working entities and repositories to create a use case. Everything can be mocked and spied upon.
2. The entity base class is a neat little bit of code to dynamically load data from a hash into an entity with attr_accessors.
3. The validations module is another fun piece of code. At first, I chose a case statement with hard coded validators. I've since refactored it using Industrialist so that it can be extended by adding additional validator classes, without modifying the validations module itself (other than the require statement).
4. The use case classes should only work with other domain objects: entities and repositories. Passing raw parameters into the use case adds tons of complexity that hides the actual business logic.

## Open questions:

1. Should the repository be injected into the use cases? Would be good to test with an in memory persistence layer for now.
2. Are the repositories supposed to contain raw SQL? Or, do the call out to a gateway?
3. What does the service boundary look like between the UI and the domain logic. Something needs to convert the data from strings in a params object into entities.