.PHONY: dev build typst-install deploy clean

dev:
	zola serve -i 0.0.0.0 -u localhost -p 3000 &
	typst watch ./cv.typ ./static/cv.pdf &
	tailwindcss -i ./input.css -o ./static/output.css --watch

build:
	typst compile ./cv.typ ./static/cv.pdf
	tailwindcss -i ./input.css -o ./static/output.css --minify
	zola build

tailwind-install:
	@if ! command -v tailwindcss >/dev/null 2>&1; then \
		npm install -g tailwindcss; \
	fi	

typst-install:
	@if ! command -v typst >/dev/null 2>&1; then \
		mkdir -p "$$HOME/.local/bin"; \
		curl -fsSL "https://github.com/typst/typst/releases/download/v0.13.1/typst-x86_64-unknown-linux-musl.tar.xz" | tar -xJ -C /tmp; \
		cp /tmp/typst-x86_64-unknown-linux-musl/typst "$$HOME/.local/bin/"; \
		chmod +x "$$HOME/.local/bin/typst"; \
	fi

deploy: typst-install tailwind-install build

clean:
	rm -rf public static/cv.pdf static/output.css target
