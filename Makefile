include .bingo/Variables.mk

CONFIGURATION_DIR ?= ./configuration
WEBSITE_DIR ?= website
WEBSITE_BASE_URL ?= https://observatorium.io

all: generate validate

.PHONY: fmt
fmt:
	@$(MAKE) -C $(CONFIGURATION_DIR) fmt

.PHONY: lint
lint:
	@$(MAKE) -C $(CONFIGURATION_DIR) lint

.PHONY: generate
generate:
	@$(MAKE) -C $(CONFIGURATION_DIR) generate

$(CONFIGURATION_DIR)/tests/manifests:
	@$(MAKE) -C $(CONFIGURATION_DIR) tests/manifests

.PHONY: validate
validate:
	@$(MAKE) -C $(CONFIGURATION_DIR) validate

.PHONY: vendor
vendor:
	@$(MAKE) -C $(CONFIGURATION_DIR) vendor

# TODO(bwplotka): This is no longer needed, remove when netlify job will be updated.
web-theme:

$(WEBSITE_DIR)/node_modules:
	@git submodule update --init --recursive
	cd $(WEBSITE_DIR)/themes/doks/ && npm install && rm -rf content

.PHONY: web
web: $(WEBSITE_DIR)/node_modules $(HUGO)
	cd $(WEBSITE_DIR) && $(HUGO) -b $(WEBSITE_BASE_URL)

.PHONY: web-serve
web-serve: $(WEBSITE_DIR)/node_modules $(HUGO)
	@cd $(WEBSITE_DIR) && $(HUGO) serve
