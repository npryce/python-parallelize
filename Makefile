
# Which version of python are we using?
ifndef python
python=3.2
endif

PROJECT=python-parallelize

SRCDIR=.

ARCHITECTURE:=$(shell uname -m)
PYTHON_ENV=$(PWD)/python$(python)-$(ARCHITECTURE)
PYTHON_EXE=$(PYTHON_ENV)/bin/python
PIP=$(PYTHON_ENV)/bin/pip
PYTHON_BUILDDIR=$(PYTHON_ENV)/build


.PHONY: all
all: check

.PHONY: env
env: env-base env-libs

.PHONY: env-base
env-base:
	mkdir -p $(dir $(PYTHON_ENV))
	tools/virtualenv --python=python$(python) $(PYTHON_ENV)
	rm -f distribute-*.tar.gz

.PHONY: env-libs
env-libs:
	$(PIP) install pytest

.PHONY: env-clean
env-clean:
	rm -rf $(PYTHON_ENV)/

.PHONY: env-again
env-again: env-clean env

.PHONY: check
check:
	PYTHONPATH=$(SRCDIR) $(PYTHON_ENV)/bin/py.test test/

check-install: dist
	$(MAKE) PYTHON_ENV=build/test-$(python)-$(ARCHITECTURE) env-again
	build/test-$(python)-$(ARCHITECTURE)/bin/python$(python) setup.py install
	$(MAKE) PYTHON_ENV=build/test-$(python)-$(ARCHITECTURE) SRCDIR=test check
.PHONY: check-install

build/test-$(python)-$(ARCHITECTURE):
	mkdir -p $(dir $@)
	cp -R $(PYTHON_ENV) $@

dist/$(PROJECT)-$(VERSION).tar.gz: setup.py Makefile README.txt check
	$(PYTHON_EXE) setup.py sdist

README.txt: README.md
	pandoc --from=markdown --to=rst $^ > $@

dist: dist/$(PROJECT)-$(VERSION).tar.gz
.PHONY: dist

clean:
	rm -rf output/ dist/ build/ MANIFEST README.txt
	find . -name '*.pyc' -o -name '*~' | xargs -r rm -f
.PHONY: clean

.PHONY: again
again: clean all



SCANNED_FILES=$(shell find $(SRCDIR) -type d) $(shell find test/ -type d) Makefile setup.py

.PHONY: continually
continually:
	@while true; do \
	  clear; \
	  if not make check; \
	  then \
	      notify-send --icon=error --category=build --expire-time=250 "$(PROJECT) build broken"; \
	  fi; \
	  date; \
	  inotifywait -r -qq -e modify -e delete $(SCANNED_FILES); \
	done
