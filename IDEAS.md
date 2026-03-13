Claude, DO NOT TOUCH THIS FILE under penalty of death
# TODO
- Move "provider" naming to "package"
- Move channel to core, not as a std
# Std libs
- @std/config
- @std/mobile
  - Use Forge to build mobile apps
- @std/ui
  - Sane defaults and components for UI crud apps/dashboards/etc
  - Model driven architecture + some light configuration for UI components
  - Break out at any point
  - Maybe integrate with @std/mobile so UI can be used across all architectures 
- @std/analytics
- @std/observability

# Compiler
- Single output compiler
- Remove all rust (self hosted)

# Tooling
- Test Coverage
- forge inspect "how does this thing do the thing?"
  - Uses an LLM + forge docs to expain features and inner workings

# Marketing / Community / Docs
- Example grid generator:
  - Take 2/3 features of the Language and generate an inspiring example. expose this as a dropdown on the homepage 
- Package registry (install from registry or github like go)
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
