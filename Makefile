.PHONY: prepare build run watch

prepare:
	cat config.common.toml configs/config.en.toml configs/config.fa.toml > config.toml

build: prepare
	rm -rf public
	./hugow --theme coder $(filter-out $@,$(MAKECMDGOALS))

run: prepare
	./hugow server --theme coder --disableFastRender --buildDrafts $(filter-out $@,$(MAKECMDGOALS))

watch:
	while true; do \
		inotifywait --recursive -e modify,create,delete \
			config.common.toml \
			configs \
		&& $(MAKE) prepare; \
	done

%:
	@:
