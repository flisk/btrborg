.PHONY: all install
all:
install:
	install -Dt $(DESTDIR)/etc/btrborg -m 644 bindmount exclude
	install -t $(DESTDIR)/etc/btrborg -m 600 profile
	install -Dt $(DESTDIR)/usr/bin btrborg-create btrborg-borg
