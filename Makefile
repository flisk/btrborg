.PHONY: all install
all:
install:
	install -Dt $(DESTDIR)/etc/btrborg -m 644 exclude
	install -t $(DESTDIR)/etc/btrborg -m 600 profile
	install -Dt $(DESTDIR)/usr/bin btrborg
	install -Dt $(DESTDIR)/lib/systemd/system -m 644 \
	  systemd/btrborg.service systemd/btrborg.timer

check:
	shellcheck btrborg
