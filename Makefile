.PHONY: ntr install uninstall
.SILENT:

# Exposed Variables
DEST_FOLDER = /usr/local

# Not Exposed Variables
override FOLDER = $(DEST_FOLDER)/bin
override INSTALL = install -m 755 $(IFLAGS)

ntr:

install:
	$(INSTALL) ntr.sh "$(FOLDER)/ntr"
	$(INSTALL) ntr-ls.sh "$(FOLDER)/ntr-ls"
	$(INSTALL) ntr-rm.sh "$(FOLDER)/ntr-rm"

uninstall:
	rm "$(FOLDER)/ntr"
	rm "$(FOLDER)/ntr-ls"
	rm "$(FOLDER)/ntr-rm"
