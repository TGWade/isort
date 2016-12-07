TOPDIR := $(shell pwd)

BUILDDIR := $(TOPDIR)/BUILD
BUILDDIRS := $(BUILDDIR)
TARDIR := $(shell cd ../..; pwd)
TARPATH := $(lastword $(wildcard $(TARDIR)/isort-*.tar.gz))

ISORT_REV := 4.2.5

all: clean tar-url src rpm

rpm: 
	@[ $$USER == 'root' ] || (echo "ERROR: must be run by root"; exit 1) 
	( cd $(BUILDDIR); export HOME=$(BUILDDIR) ; python setup.py bdist_rpm ) 

src: $(BUILDDIR)
	@[ -f $(BUILDDIR)/*.tar.gz ] || (echo "ERROR: not tar.gz file"; exit 1)
	tar -C $(BUILDDIR) --strip-components=1 -xvf $(BUILDDIR)/*.tar.gz
	ln pydistutils.cfg $(BUILDDIR)/.pydistutils.cfg

tar-local: $(BUILDDIR)
	ln $(TARPATH) $(BUILDDIR)

tar-url: $(BUILDDIR)
	cd $(BUILDDIR) ; wget https://github.com/timothycrosley/isort/archive/$(ISORT_REV).tar.gz

clean::
	rm -rf $(BUILDDIR)

$(BUILDDIRS):
	mkdir -p $@
