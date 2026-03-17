Claude, DO NOT TOUCH THIS FILE under penalty of death

- Forge as the operating layer for autonomous businesses
- Turn existing SAAS into just keywords (stripe, etc)
- app store for machine-generated infrastructure.
- "Joy machines" - Create things that lift human consciousness 

# Philosophy
Based on the ideas that:
1. AIs will be writing the majority of code, and humans will be reviewing them (for now) 
2. The future will be one language (no more fragmented toolchains, environments, languages) and should unify high and low level programming
3. Compilers should do ALL of the heavy lifting, and code should be as declarative as possible
4. Escape hatches built in to everything when you don't want magic
5. DX/Ergonomics is a feature, not an afterthought (errors, docs, tooling, etc) and optmized for LLMs

# TODO
- Move "provider" naming to "package"
- Move channel to core, not as a std

# Std libs
- @std/config
- @@std/logs
  - Pipe to service
std/mobile
  - Use Forge to build mobile apps
- @std/ui
  - Sane defaults and components for UI crud apps/dashboards/etc
  - Model driven architecture + some light configuration for UI components
  - Break out at any point
  - Maybe integrate with @std/mobile so UI can be used across all architectures 
- @std/analytics
- @std/observability
- @std.cli
  - Typed args based on sub commands

- # Compiler
- Single output compiler
- Remove all rust (self hosted)
  - Could remove everything except for inkwell, then just pass over from there (lexer/type check etc in forge)
  - Actually replacing inkwell seems feasible
- Better error system
  - Features register their own errors
  - Packages can also register errors that the compiler/type system is aware of
- shell feature could have better DX with channels etc
- components/subcomponents
  - @syntax should be removed and just part of component creation
### New compiler (forgec)
- new_thing/thing_new is an antipattern, we need a better init/constructor story

# Tooling
- Test Coverage
- forge inspect "how does this thing do the thing?"
  - Uses an LLM + forge docs to expain features and inner workings
- Sequence flow diagram for entire codebase
  - Understand how all your services/functions/etc work together
  - Include events, etc to show boundardies
- Admin dashboard for models (https://github.com/mr-fatalyst/oxyde)

# Marketing / Community / Docs
- Example grid generator:
  - Take 2/3 features of the Language and generate an inspiring example. expose this as a dropdown on the homepage 
- Package registry (install from registry or github like go)
- Version management and changelogs

# Deployment targets:
- Fly.io 
- Render
- AWS
- GCP
- Terraform

# Moonshots:
- Language operators to orchestrate networking communication between services
  - IE: Queues are deployed, and events sent of the network just from the Language
  - Integrate with channels/pipes to filter things
  - Pusedo code:
    queue1 { ... }
    service {
      push something to queue 1 # Queue 1 is on a different machine somewhere
    }
    logs = fs.new_file("log.txt")
    queue1 -> event {
      error -> log
      success -> notify_slack
    } 
- AI doctor:
  // Self heal errors. 
  // 3 different deployed resources that all are connected
  queue ai_doctor_queue { host "lambda somewhere" }
  agent ai_doctor {
    system_prompt {
      "You fix code"
    }
    tools checkout_repo() {
      $"git clone https://github.com/tristanmatthias/forge-lang"
    }
    tools other_stuff() {}
  }
  deploy {
    on error(err) {
      ai_doctor <- err
    }
  }

  ai_doctor
    |> ai_doctor.ask 
