default: build

.PHONY: help

help:
	@echo "Available commands:"
	@echo "  help		Prints this message"
	@echo "  build		Compiles profiles"
	@echo "  install	Overwrites karabiner.json"
	@echo "  clean		Clean build artifacts"

build: dist/output.json

dist/output.json: karabiner.ts utils.ts layers/*.ts rules/*.ts
	deno run --allow-env --allow-read --allow-write karabiner.ts ./dist/output.json

install: karabiner.json

karabiner.json: dist/output.json
	cp dist/output.json karabiner.json

.PHONY: clean
clean:
	rm -rf dist/
