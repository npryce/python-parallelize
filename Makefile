
# Which version of python are we using?
ifndef python
python=3.2
endif

PROJECT=python-parallelize

SRCDIR=parallelize

ARCHITECTURE:=$(shell uname -m)
PYTHON_ENV=$(PWD)/python$(python)-$(ARCHITECTURE)
PYTHON_EXE=$(PYTHON_ENV)/bin/python
PIP=$(PYTHON_ENV)/bin/pip
PYTHON_BUILDDIR=$(PYTHON_ENV)/build
PYTHON_LIBDIR=$(PYTHON_ENV)/lib/python$(python)/site-packages


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
	PYTHONPATH=$(SRCDIR):$(PYTHON_LIBDIR) $(PYTHON_ENV)/bin/py.test test/

.PHONY: clean
clean:
	rm -rf output/ dist/ build/ MANIFEST README.rst
	find . -name '*.pyc' -o -name '*~' | xargs -r rm

.PHONY: again
again: clean all

