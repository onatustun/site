.PHONY: dev build deploy clean

dev:
	zola serve -i 0.0.0.0 -u localhost -p 3000 &
	tailwindcss -i ./input.css -o ./static/output.css --watch

build:
	mkdir -p ./static
	typst compile ./cv.typ ./static/cv.pdf
	tailwindcss -i ./input.css -o ./static/output.css --minify
	zola build

deploy:
	@if ! command -v typst >/dev/null 2>&1; then \
		mkdir -p "$$HOME/.local/bin"; \
		curl -L "https://github.com/typst/typst/releases/download/v0.13.1/typst-x86_64-unknown-linux-musl.tar.xz" | tar -xJ -C /tmp; \
		cp /tmp/typst-x86_64-unknown-linux-musl/typst "$$HOME/.local/bin/"; \
		chmod +x "$$HOME/.local/bin/typst"; \
		export PATH="$$HOME/.local/bin:$$PATH"; \
		"$$HOME/.local/bin/typst" --version; \
	fi
	mkdir -p ./static
	typst compile ./cv.typ ./static/cv.pdf
	tailwindcss -i ./input.css -o ./static/output.css --minify
	zola build

clean:
	rm -rf public/
	rm -rf static/output.css
	rm -rf static/cv.pdf
