# Top-level dev tools. The compiler's Makefile lives in bootstrap/.

BEADS_UI_PORT ?= 7842
BEADS_UI_HOST ?= 0.0.0.0
BEADS_UI_PID  := /tmp/beads_ui.pid
BEADS_UI_LOG  := /tmp/beads_ui.log

.PHONY: beads-ui beads-ui-stop beads-ui-logs beads-ui-status

beads-ui: beads-ui-stop ## Start the beads UI server in background (binds 0.0.0.0)
	@python3 beads_ui/server.py --host $(BEADS_UI_HOST) --port $(BEADS_UI_PORT) \
		> $(BEADS_UI_LOG) 2>&1 & echo $$! > $(BEADS_UI_PID)
	@sleep 0.5
	@if ! kill -0 $$(cat $(BEADS_UI_PID)) 2>/dev/null; then \
		echo "failed to start; log:"; cat $(BEADS_UI_LOG); exit 1; \
	fi
	@echo "beads-ui  PID $$(cat $(BEADS_UI_PID))"
	@echo "  local:     http://127.0.0.1:$(BEADS_UI_PORT)/"
	@ts_ip=$$(tailscale ip -4 2>/dev/null | head -1); \
	  if [ -n "$$ts_ip" ]; then echo "  tailscale: http://$$ts_ip:$(BEADS_UI_PORT)/"; fi
	@echo "  logs: tail -f $(BEADS_UI_LOG)   stop: make beads-ui-stop"

beads-ui-stop: ## Stop the beads UI server
	@if [ -f $(BEADS_UI_PID) ]; then \
		kill $$(cat $(BEADS_UI_PID)) 2>/dev/null || true; \
		rm -f $(BEADS_UI_PID); \
	fi
	@# also catch any orphans still bound to the port
	@pids=$$(lsof -tiTCP:$(BEADS_UI_PORT) -sTCP:LISTEN 2>/dev/null); \
	  if [ -n "$$pids" ]; then kill $$pids 2>/dev/null || true; fi

beads-ui-logs: ## Tail the beads UI log
	@tail -f $(BEADS_UI_LOG)

beads-ui-status: ## Show beads UI server status
	@pids=$$(lsof -tiTCP:$(BEADS_UI_PORT) -sTCP:LISTEN 2>/dev/null); \
	  if [ -n "$$pids" ]; then echo "running (PID $$pids) on :$(BEADS_UI_PORT)"; else echo "not running"; fi
