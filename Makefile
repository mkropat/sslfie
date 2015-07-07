PREFIX = /usr/local

BIN	= $(DESTDIR)/$(PREFIX)/bin
MAN	= $(DESTDIR)/$(PREFIX)/share/man

VERSION			= 0.3
PACKAGE_DIR		= sslfie-$(VERSION)
PACKAGE_FILE		= sslfie_$(VERSION).tar.bz2
PACKAGE_ORIG_FILE	= sslfie_$(VERSION).orig.tar.bz2

AUTHOR	= Michael Kropat <mail@michael.kropat.name>
DATE	= Jul 3, 2015
FILES	= README.md LICENSE.txt Makefile sslfie

.PHONY: all
all: sslfie.1

sslfie.1: README.man.md
	@hash pandoc 2>/dev/null || { echo "ERROR: can't find pandoc. Have you installed it?" >&2; exit 1; }
	pandoc --from=markdown --standalone --output="$@" "$<"

README.man.md: README.md
	echo '% sslfie(1) sslfie | $(VERSION)' >"$@"
	echo '% $(AUTHOR)' >>"$@"
	echo '% $(DATE)' >>"$@"
	perl -ne 's/^##/#/; print if ! (/^# Installation/ ... /^# /) || /^# (?!Installation)/' "$<" >>"$@"

.PHONY: install
install:
	mkdir -p "$(BIN)"
	cp sslfie "$(BIN)"

	mkdir -p "$(MAN)/man1"
	cp sslfie.1 "$(MAN)/man1/"

.PHONY: uninstall
uninstall:
	-rm -f "$(BIN)/sslfie"
	-rm -f "$(MAN)/man1/sslfie.1"

.PHONY: clean
clean:
	-rm -f README.man.md
	-rm -f sslfie.1


##### make dist #####

.PHONY: dist
dist: $(PACKAGE_FILE)

$(PACKAGE_FILE): $(FILES)
	tar --transform 's,^,$(PACKAGE_DIR)/,S' -cjf "$@" $^

.PHONY: distclean
distclean: clean
	-rm -f sslfie*.tar.bz2 sslfie*.changes sslfie*.deb sslfie*.rpm


### make deb* ###

.PHONY: deb
deb: sslfie_$(VERSION)-1_all.deb

sslfie_$(VERSION)-1_all.deb: $(PACKAGE_FILE) debian/copyright
	@hash dpkg-buildpackage 2>/dev/null || { \
		echo "ERROR: can't find dpkg-buildpackage. Did you run \`sudo apt-get install debhelper devscripts\`?" >&2; exit 1; \
	}
	dpkg-buildpackage -b -tc -uc -us
	mv "../$@" .
	mv ../sslfie_$(VERSION)-1_*.changes .

.PHONY: deb-src
deb-src: sslfie_$(VERSION)-1_source.changes

sslfie_$(VERSION)-1_source.changes: $(PACKAGE_FILE) $(PACKAGE_ORIG_FILE) debian/copyright
	@hash dpkg-buildpackage 2>/dev/null || { echo "ERROR: can't find debuild. Did you run \`sudo apt-get install debhelper devscripts\`?" >&2; exit 1; }
	tar xf "$<"
	cp -r debian "$(PACKAGE_DIR)"
	(cd "$(PACKAGE_DIR)"; debuild -S)

$(PACKAGE_ORIG_FILE): $(PACKAGE_FILE)
	cp "$<" "$@"

debian/copyright: LICENSE.txt
	cp "$<" "$@"

.PHONY: deb-clean
deb-clean:
	-debian/rules clean
	-rm -f *.build *.changes *.dsc *.debian.tar.gz *.orig.tar.bz2
	-rm -rf $(PACKAGE_DIR)
	-rm -f debian/copyright

.PHONY: deb-deploy
deb-deploy: sslfie_$(VERSION)-1_source.changes
	dput ppa:mkropat/ppa "$<"

ubuntu-%:
	vagrant up ubuntu
	vagrant ssh -c 'cd /vagrant; make $*' ubuntu


### make rpm ###

.PHONY: rpm
rpm: $(PACKAGE_FILE)
	@hash rpmbuild 2>/dev/null || { echo "ERROR: can't find rpmbuild. Did you run \`yum install rpmdevtools\`?" >&2; exit 1; }
	@test -d "$$HOME/rpmbuild" || { echo "ERROR: ~/rpmbuild does not exist. Did you run \`rpmdev-setuptree\`?" >&2; exit 1; }
	cp "$<" ~/rpmbuild/SOURCES/
	sed s/%{VERSION}/$(VERSION)/ sslfie.spec >~/rpmbuild/SPECS/sslfie.spec
	rpmbuild -ba ~/rpmbuild/SPECS/sslfie.spec
	mv ~/rpmbuild/RPMS/noarch/sslfie-$(VERSION)-1.*.noarch.rpm .
	mv ~/rpmbuild/SRPMS/sslfie-$(VERSION)-1.*.src.rpm .

centos-%:
	vagrant up centos
	vagrant ssh -c 'cd /vagrant; make $*' centos
