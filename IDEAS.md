Claude, DO NOT TOUCH THIS FILE under penalty of death

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

- forge inspect "how does this thing do the thing?"
  - Uses an LLM + forge docs to expain features and inner workings


- @std/mobile
  - Use Forge to build mobile apps
- @std/ui
  - Sane defaults and components for UI crud apps/dashboards/etc
  - Model driven architecture + some light configuration for UI components
  - Break out at any point
  - Maybe integrate with @std/mobile so UI can be used across all architectures 


- Example grid generator:
  - Take 2/3 features of the Language and generate an inspiring example. expose this as a dropdown on the homepage 
