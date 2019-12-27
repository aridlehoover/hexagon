# Domain Driven Hexagonal/Clean Architecture

This project is an exploration of what it would look like to implement the guts of an application without a user interface or persistence layer. The application follows a hexagonal (or clean) architecture. And, everything is test-driven.

Hexagonal architecture isolates domain logic from externalities. Domain logic represents what is unique about your application. Externalities are interfaces to the outside world: user interfaces, application programming interfaces, queues, databases, third-party services, and more.

## Domain Logic

Domain (business) logic is the heart of an application. It includes entities, repositories, and use cases. Entities are the nouns of your application. They describe the "things" in your application. Repositories are interfaces that can be implemented by adapters to store and retrieve entites. And, use cases are the verbs of your application. They describe the actions the software can perform.

## Ports & Adapters

Hexagonal architecture is also known as the Ports & Adapters pattern. In it, your domain logic exposes ports which adapters plug into to provide the channel between your domain logic and the tools and systems around your application. In strongly typed languages like Java or C#, ports are typically exposed as interfaces defined and used in the domain logic, but implemented by the adapters.

For example, the domain logic uses repositories to fetch and store entities. But, the repositories are merely an interface that is implemented in an adapter. Multiple different adapters can implement the same interface. So, you could use an in-memory database when running your tests, and a more persistent database in production.

## Primary and Secondary Adapters

Adapters come in two varieties: primary and secondary. A primary adapter drives the application to do something. Examples include user interfaces (UI), application programming interfaces (API), and queues. The application uses secondary adapters to drive some other system, usually a database, logs, monitoring, email, or other third-party services.

## Project Organization

The project is organized as follows:

* Adapters
  * Primary - interfaces that drive the application
  * Secondary - interfaces that are driven by the application
* Domain
  * Entities
  * Repositories
  * Use Cases
* Lib
* Spec

## Learnings

1. Domain logic should not reference anything outside the domain.
2. Adapters that satisfy a port's interface may be injected into the domain objects, allowing the domain to interact with them.
3. Use cases should be initialized with entities, not raw parameters. Passing raw parameters to a use case significantly increases complexity.

## Interesting Code

1. The entity base class dynamically loads data from a hash into an entity with attr_accessors.
2. The validations module started off as a case statement with hard coded conditionals. I refactored it using Industrialist so that it can be extended by adding additional validator classes, without modifying the module itself.

## Open Questions

1. Should the repository be injected into the use cases? Would be good to test with an in memory persistence layer for now. Use Industrialist to instantiate repositories with keys like: { user_repository: :in_memory } or { user_repository: :db }.
2. Are the repositories supposed to contain raw SQL? Or, do the call out to a gateway? (No. The repositories are interfaces that whatever database adapter needs to implement.)
3. What does the service boundary look like between the UI and the domain logic. Something needs to convert the data from strings in a params object into entities.
4. How do you structure the UI and persistence layers around the domain layer in a way that does not obscure the domain logic?



