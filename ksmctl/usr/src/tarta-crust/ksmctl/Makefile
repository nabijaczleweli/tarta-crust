CARGO := cargo
PREFIX := /usr/sbin/


.PHONY: all build install clean


all: build install clean


build: target/release/ksmctl
install: $(PREFIX)ksmctl

clean:
	rm -rf Cargo.lock target


target/release/ksmctl : main.rs Cargo.toml
	$(CARGO) build --release
	strip --strip-all --remove-section=.comment --remove-section=.note "$@"

$(PREFIX)ksmctl : target/release/ksmctl
	@mkdir -p $(dir $@)
	cp "$<" "$@"
