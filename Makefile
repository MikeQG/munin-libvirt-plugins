VERSION=0.0.5
PACKAGE=munin-libvirt-plugins
SBINDIR=/usr/sbin
PLUGINDIR=/usr/share/munin/plugins
MUNINCONFDIR=/etc/munin

PLUGINS=libvirt-cputime \
	libvirt-blkstat \
	libvirt-ifstat  \
	libvirt-mem

DETECT=$(PACKAGE)-detect
PYFILES=$(patsubst %,%.py,$(PLUGINS) $(DETECT))

all: $(DETECT)

install: build
	install -d  $(DESTDIR)$(PLUGINDIR)
	install -m 755 $(PLUGINS) $(DESTDIR)$(PLUGINDIR)
	install -m 755 $(DETECT) $(DESTDIR)$(SBINDIR)

$(DETECT): $(DETECT).in
	sed -e "s,::MUNINCONFDIR::,$(MUNINCONFDIR),"\
            -e "s,::PLUGINDIR::,$(PLUGINDIR),"      \
            -e "s,::VERSION::,$(VERSION),"          \
            < $< > $@ 

%.py: %
	ln -s $< $@
	pychecker -q -e Error $@

check: $(DETECT) $(PYFILES)

clean:
	rm -f *.py *.pyc $(DETECT)

dist: clean check
	git-archive --format=tar --prefix=$(PACKAGE)-$(VERSION)/ HEAD | gzip -c > ../$(PACKAGE)-$(VERSION).tar.gz

.PHONY: clean check dist install build
