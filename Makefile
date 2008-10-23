VERSION=0.0.2
PKG=munin-libvirt-plugins
PLUGINDIR=/usr/share/munin/plugins/

PLUGINS=libvirt-cputime \
	libvirt-blkstat \
	libvirt-ifstat  \
	libvirt-mem

ALL=$(PLUGINS) Makefile COPYING INSTALL
PYFILES=$(patsubst %,%.py,$(PLUGINS))

install: $(PLUGINS)
	install -d  $(DESTDIR)$(PLUGINDIR)
	install -m 755 $(PLUGINS) $(DESTDIR)$(PLUGINDIR)

%.py: %
	ln -s $< $@
	pychecker -q -e Error $@

check: $(PYFILES)

clean:
	rm -f *.py *.pyc

dist:
	git-archive --format=tar --prefix=$(PKG)-$(VERSION)/ HEAD | gzip -c > ../$(PKG)-$(VERSION).tar.gz
