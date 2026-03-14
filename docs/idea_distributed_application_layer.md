# Forge — Distributed Application Layer (Ideas)

**Status:** Ideas only. Not a spec. Captured for future development.

**Core thesis:** The application code, the infrastructure, the deployment, and the observability are all the same language with the same primitives. `<-` and `|>` work the same whether the thing is local, in another thread, or on another machine.

---

## The Big Idea

Today building distributed applications requires: application code (Go/Python/etc), infrastructure code (Terraform/Pulumi), deployment config (Docker/K8s YAML), observability setup (Datadog/Grafana), and API integration glue (OpenAPI clients). Five different languages/tools for one system.

Forge collapses all of these into one language. Not by being a framework on top of a language — the language itself understands services, networking, deployment, and monitoring as primitives.

Nobody is doing this. Closest attempts: Darklang (too locked in, died), Wing/Winglang (cloud-oriented but limited), Pulumi (infra-as-code but separate from app code), SST (deployment layer, not a language).

---

## Local-to-Remote Transparency

The code doesn't change between local development and production. Only the config changes.

```forge
// Local development — everything in one process
queue orders {}
orders <- { item: "widget" }

// Production — queue is on the network
queue orders { host "queue.prod:5672" }
orders <- { item: "widget" }    // identical code
```

When a component has a `host` config, the runtime transparently handles serialization, networking, retries, timeouts. The `<-` operator, `|>` pipes, and function calls all work across machine boundaries.

---

## Remote Services

Services on other machines are addressable as typed objects:

```forge
use @std.service

remote users_api = service("users.internal:3000")
remote billing_api = service("billing.internal:3001")

server :8080 {
  POST /signup -> (req) {
    let user = users_api.create_user(req.body)?
    billing_api.create_account(user.id)?
    { user: user }
  }
}
```

`users_api.create_user()` is a remote call but reads like a local function. The `remote` keyword tells Forge this is a network boundary — it handles serialization, retries, timeouts, circuit breaking.

---

## Channels as Network Glue

Channels span machines. They become the universal event bus:

```forge
// Channels that span the network
let events = channel<Event>("events.internal:9092")

remote orders = service("orders.internal:3000")
remote inventory = service("inventory.internal:3001")
remote notifications = service("notifications.internal:3002")

// The orchestration IS the code
events
  |> filter(it.type == "order.created")
  |> each(event -> {
    inventory.reserve(event.items)?
    notifications.send(event.user, "Order confirmed")
  })

events
  |> filter(it.type == "order.failed")
  |> each(event -> {
    inventory.release(event.items)
    notifications.send(event.user, "Order failed: ${event.reason}")
  })
```

Fan-in from multiple sources, fan-out to multiple consumers, filter/transform in the middle — all with the same `|>` and `<-` syntax used for local channels.

---

## Cross-Service Event Flow

Queues, HTTP, cron all feed the same channels across services:

```forge
queue orders { host "queue.internal:5672" }

server :8080 {
  POST /order -> (req) {
    orders <- req.body
    { accepted: true }
  }
}

// On a completely different machine:
queue orders { host "queue.internal:5672" }

orders
  |> filter(it.total > 100)
  |> each(fulfill_priority(it))

orders
  |> filter(it.total <= 100)
  |> each(fulfill_standard(it))
```

---

## Deploy Component

A `deploy` block describes the entire system topology. Pluggable backends.

```forge
use @std.deploy

deploy {
  service gateway {
    source "./gateway"
    replicas 3
    port 8080
    public true
  }

  service users_api {
    source "./users"
    replicas 2
    port 3000
  }

  service billing_api {
    source "./billing"
    replicas 1
    port 3001
  }

  queue orders {
    provider "rabbitmq"
    host "queue.internal"
  }

  channel events {
    provider "nats"
    host "events.internal"
  }
}
```

`forge deploy` reads this and stands up the infrastructure.

### Pluggable Backends

The deploy component doesn't know about AWS or Docker. Backend packages do:

```forge
use @deploy.docker
use @deploy.aws
use @deploy.hetzner
use @deploy.gcp

deploy {
  backend docker {
    registry "ghcr.io/myorg"
  }

  // OR
  backend aws {
    region "us-east-1"
    vpc "vpc-123"
  }

  // OR
  backend hetzner {
    datacenter "fsn1"
    server_type "cx21"
  }

  // Services defined the same regardless of backend
  service api {
    source "./api"
    replicas 2
  }
}
```

Same service definitions, swap the backend line. Each backend package knows how to translate the deploy block into its platform's primitives (Docker Compose, ECS tasks, Hetzner servers, GKE pods, etc).

### Docker Support

```forge
deploy {
  backend docker {
    registry "ghcr.io/myorg"
  }

  service api {
    source "./api"
    port 8080
    
    docker {
      base_image "debian:slim"
      env {
        DATABASE_URL secret("db-url")
        REDIS_HOST "redis:6379"
      }
      volumes ["/data:/app/data"]
      health_check "/health"
    }
  }

  service redis {
    image "redis:7-alpine"
    port 6379
  }
}
```

`forge deploy` generates Dockerfiles, builds images, pushes to registry, generates docker-compose or k8s manifests.

---

## External API Integration (OpenAPI)

Pull an OpenAPI spec and get a typed Forge interface automatically:

```forge
use @std.api

// Generate types from OpenAPI spec
remote stripe = api.from_openapi("https://raw.githubusercontent.com/stripe/openapi/master/openapi/spec3.json") {
  base_url "https://api.stripe.com/v1"
  auth bearer(env("STRIPE_SECRET_KEY"))
}

// Fully typed — Forge knows the parameters and return types
let customer = stripe.customers.create({
  email: "alice@test.com",
  name: "Alice",
})?

let charge = stripe.charges.create({
  amount: 2000,
  currency: "usd",
  customer: customer.id,
})?
```

The `api.from_openapi()` call generates typed functions at compile time. Autocomplete works. Type errors catch API misuse before runtime.

For APIs without OpenAPI specs, manual definition:

```forge
remote slack = api("https://slack.com/api") {
  auth bearer(env("SLACK_TOKEN"))

  fn post_message(channel: string, text: string) -> {ok: bool, ts: string} {
    POST /chat.postMessage { channel, text }
  }

  fn get_channel(id: string) -> Channel {
    GET /conversations.info { channel: id }
  }
}
```

---

## Observability as Language Feature

Not bolted on — the compiler instruments automatically.

### Automatic Tracing

Every `remote` call, every `<-` send, every channel operation gets a trace span automatically:

```forge
server :8080 {
  POST /order -> (req) {
    // Forge auto-generates trace spans:
    //   → POST /order (incoming)
    //     → users_api.get_user (remote call, 12ms)
    //     → orders <- (channel send, 1ms)
    //     → billing_api.charge (remote call, 45ms)
    
    let user = users_api.get_user(req.user_id)?
    orders <- { user: user, items: req.items }
    billing_api.charge(user.id, req.total)?
    
    { order_id: new_id() }
  }
}
```

You don't write tracing code. The compiler knows the network boundaries and instruments them.

### Metrics Built In

```forge
deploy {
  observe {
    provider "prometheus"    // or datadog, grafana, etc
    
    // Auto-collected for every service:
    // - request rate, latency, error rate
    // - channel depth, throughput
    // - queue backlog, consumer lag
    // - memory, CPU per service
  }
}
```

### Log Aggregation

```forge
deploy {
  logs {
    provider "loki"          // or cloudwatch, datadog, etc
    
    // All println() and term.* output automatically tagged with:
    // - service name
    // - trace ID
    // - timestamp
  }
}
```

### Health Checks

```forge
service api {
  source "./api"
  
  health {
    endpoint "/health"
    interval 10s
    timeout 3s
    
    on unhealthy {
      notifications.send("ops-channel", "API health check failed")
    }
  }
}
```

---

## Scaling

### Replicas and Auto-scaling

```forge
deploy {
  service api {
    source "./api"
    replicas 2..10           // min 2, max 10
    
    scale {
      metric cpu
      target 70%             // scale up when CPU > 70%
      cooldown 60s
    }
  }
  
  service worker {
    source "./worker"
    replicas 1..20
    
    scale {
      metric queue_depth("orders")
      target 0                // scale to keep queue near empty
      cooldown 30s
    }
  }
}
```

### Load Balancing

```forge
deploy {
  service api {
    source "./api"
    replicas 3
    
    load_balance {
      strategy round_robin    // or least_connections, ip_hash
      sticky_sessions false
    }
  }
}
```

### Blue/Green and Canary

```forge
deploy {
  service api {
    source "./api"
    
    rollout canary {
      steps [10%, 25%, 50%, 100%]
      interval 5m
      
      rollback_if {
        error_rate > 1%
        latency_p99 > 500ms
      }
    }
  }
}
```

---

## Escape Hatches

Always available. Forge shouldn't trap you.

### Raw Docker

```forge
service legacy {
  // Skip Forge entirely — just run a Docker image
  image "myorg/legacy-service:v2.3"
  port 3000
  env {
    DATABASE_URL secret("db-url")
  }
}
```

### Shell Hooks

```forge
deploy {
  service api {
    source "./api"
    
    on before_deploy {
      $"./scripts/migrate.sh"
      $"./scripts/warm-cache.sh"
    }
    
    on after_deploy {
      $"./scripts/smoke-test.sh"
    }
  }
}
```

### Raw Kubernetes YAML

```forge
deploy {
  backend k8s {
    // Merge custom YAML for anything Forge doesn't cover
    extra_manifests "./k8s/custom/"
  }
}
```

### Eject

```bash
forge deploy --eject
# Generates plain Docker Compose / K8s YAML / Terraform
# You take over from there. No lock-in.
```

---

## Thinking About Scope

### Layers (build in order, each independently useful):

**Layer 1: Language primitives**
Channels, components, `<-`, `|>`. Work locally. Already in progress.

**Layer 2: Runtime boundary**
When a component has `host` config, runtime handles networking transparently. Same code local and remote. This is the key architectural decision.

**Layer 3: Deploy component**
Describes topology. Pluggable backends (Docker, AWS, GCP, Hetzner). `forge deploy` stands up infrastructure.

**Layer 4: Observability**
Compiler auto-instruments network boundaries. Tracing, metrics, logs as language features not libraries.

**Layer 5: External APIs**
OpenAPI → typed interfaces. Third-party services feel like local services.

**Layer 6: Scaling and operations**
Auto-scaling, load balancing, canary deploys, health checks, rollbacks.

Each layer builds on the previous. Ship Layer 1 without Layer 6. Each layer is independently useful.

### Key Design Principle

**The deploy/infra layer is always packages, never hardcoded.** AWS support is `@deploy/aws`. Docker support is `@deploy/docker`. Hetzner is `@deploy/hetzner`. The core language provides the component interface — backends implement it. This means the community can add packages for any platform without touching the language.

### Open Questions

- How does type checking work across remote service boundaries? Do you generate shared type packages?
- How do secrets/credentials flow? `secret("key")` needs a secrets manager backend.
- How does local development simulate the full distributed topology? Something like `forge dev` that runs everything in one process?
- How do you debug across service boundaries? Distributed tracing needs correlation IDs.
- How does versioning work when Service A and Service B expect different message shapes?
- What's the migration story? How do you adopt this incrementally in an existing system?
- Rate limiting, circuit breaking, backpressure — where do these live?
- Multi-region deployments?
