VERSION=0.0.1
PKG=munin-libvirt-plugins

PLUGINS=libvirt-cputime \
	libvirt-blkstat \
	libvirt-ifstat

ALL=$(PLUGINS) Makefile COPYING
PYFILES=$(patsubst %,%.py,$(PLUGINS))

install: $(PLUGINS)
	install -d  $(DESTDIR)/usr/share/munin/plugins/
	install -m 755 $(PLUGINS) $(DESTDIR)/usr/share/munin/plugins

%.py: %
	ln -s $< $@
	pychecker -q -e Error $@

check: $(PYFILES)

clean:
	rm -f *.py *.pyc

dist:
	git-archive --format=tar --prefix=$(PKG)-$(VERSION)/ HEAD | gzip -c > ../$(PKG)-$(VERSION).tar.gz
