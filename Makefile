
# Find all directories in source/ whose name are not "shared".
ALL_VERSIONS := $(shell find source/* -maxdepth 0 -type d -not -path source/shared -not -path source/qdb | cut -d "/" -f 2)

# If VER hasn't been given by the user, make it ALL_VERSIONS
VER ?= $(ALL_VERSIONS)

BUILDDIR := build

JS_VER_LIST := $(foreach VERSION,$(VER),\'$(VERSION)\':\'$(VERSION)\')

default: help

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  html       to make standalone HTML files"
	@echo "  dirhtml    to make HTML files named index.html in directories"
	@echo "  singlehtml to make a single large HTML file"
	@echo "  pickle     to make pickle files"
	@echo "  json       to make JSON files"
	@echo "  htmlhelp   to make HTML files and a HTML help project"
	@echo "  qthelp     to make HTML files and a qthelp project"
	@echo "  devhelp    to make HTML files and a Devhelp project"
	@echo "  epub       to make an epub"
	@echo "  latex      to make LaTeX files, you can set PAPER=a4 or PAPER=letter"
	@echo "  latexpdf   to make LaTeX files and run them through pdflatex"
	@echo "  text       to make text files"
	@echo "  man        to make manual pages"
	@echo "  changes    to make an overview of all changed/added/deprecated items"
	@echo "  linkcheck  to check all external links for integrity"
	@echo "  doctest    to run all doctests embedded in the documentation (if enabled)"
	@echo ""
	@echo "By default, all versions are built. To build a specific version, pass VER=foldername, where foldername is a folder in source/."


html dirhtml singlehtml :
	@mkdir -p $(BUILDDIR)/$@
	@install -m 644 source/index.html $(BUILDDIR)/$@/index.html
	
	@# For each version...
	@# ... announce what we're building
	@# ... replace the html static path with the version switching static path
	@# ... replace the templates path with the version switching template path
	@# ... call "make <target>" on the version's folder
	@# ... copy the output to ./build/<target>/
	@# ... git checkout the conf.py file again so our version switch changes aren't saved
	@# ... update the index.html redirect to point to the latest version (the one we just built)
	@#
	@for VERSION in $(VER); do \
		echo "##teamcity[blockOpened name='Build $$VERSION']" ;\
		\
		sed -i "s;html_static_path = .*;html_static_path = \[\'../../shared/_static\'\];" source/$$VERSION/source/conf.py ;\
		sed -i "s;templates_path = .*;templates_path = \[\'../../shared/_templates\'\];" source/$$VERSION/source/conf.py ;\
		\
		$(MAKE) -C "source/$$VERSION" $@ ;\
		\
		mkdir -p "$(BUILDDIR)/$@/$$VERSION/" ;\
		cp -r "source/$$VERSION/build/$@/"* "$(BUILDDIR)/$@/$$VERSION/" ;\
		\
		command -v git >/dev/null 2>&1 || git -C "source/$$VERSION" checkout -- source/conf.py ;\
		\
		sed -i "s;https://doc.quasardb.net/[0-9].[0-9].*/\";https://doc.quasardb.net/$$VERSION/\";" $(BUILDDIR)/$@/index.html ;\
		\
		echo "##teamcity[blockClosed name='Build $$VERSION']" ;\
	done
	
	@echo
	@echo "Build finished. The files in $(BUILDDIR)/$@."


pickle json htmlhelp qthelp devhelp epub latex latexpdf text man changes linkcheck doctest :
	@mkdir -p $(BUILDDIR)/$@
	
	# For each version...
	# ... announce what we're building
	# ... call "make <target>" on the version's folder
	# ... copy the output to ./build/<target>/
	@for VERSION in $(VER); do \
		echo "##teamcity[blockOpened name='Build $$VERSION']" ;\
		\
		$(MAKE) -C source/$$VERSION $@ ;\
		\
		mkdir -p "$(BUILDDIR)/$@/$$VERSION/" ;\
		cp -r "source/$$VERSION/build/$@/"* "$(BUILDDIR)/$@/$$VERSION/" ;\
		\
		echo "##teamcity[blockClosed name='Build $$VERSION']" ;\
	done
	
	@echo
	@echo "Build finished. The files in $(BUILDDIR)/$@."


clean:
	@rm -r $(BUILDDIR)
