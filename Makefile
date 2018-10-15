.PHONY: all install
all:
install:
	install -D -t $(DESTDIR)/usr/bin btrborg-create btrborg-borg
	install -D -t $(DESTDIR)/etc/btrborg bindmount exclude
	install -t $(DESTDIR)/etc/btrborg -m 600 profile
