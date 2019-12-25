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
3. The validations module is another fun piece of code. I refactored it using Industrialist so that it no longer violates the Open/Closed principle.
4. The use case classes should only work with other domain objects: entities and repositories. Passing raw parameters into the use case adds tons of complexity that hides the actual business logic.

## Open questions:

1. The use case's perform methods are quite complex. Does all that complexity belong there? (The test setup makes me think that the complexity may belong elsewhere.)
2. Should the use case objects accept primitives like user_id? Or, should they accept actual user instances? That would require moving the validation logic elsewhere.
3. I wonder if industrialist could be used to make the valid? method in the validations module Open/Closed.