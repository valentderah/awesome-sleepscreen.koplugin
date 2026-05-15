PLUGIN_SLUG := sleepscreenwidgets
ZIP_ROOT := $(PLUGIN_SLUG).koplugin
DISTDIR := dist

PYTHON ?= python
VERSION := $(shell $(PYTHON) tools/read_version.py)

ZIP := $(DISTDIR)/$(PLUGIN_SLUG)-$(VERSION).zip

ARCHIVE_EXCLUDES := \
	":(exclude)tests" \
	":(exclude)assets" \
	":(exclude)Makefile" \
	":(exclude)tools" \
	":(exclude).gitignore"

.PHONY: prod pack clean

prod: pack

pack: $(ZIP)

$(ZIP): _meta.lua tools/read_version.py $(DISTDIR)
	git archive --format=zip --prefix="$(ZIP_ROOT)/" -o "$@" HEAD -- . $(ARCHIVE_EXCLUDES)

ifeq ($(OS),Windows_NT)
$(DISTDIR):
	@cmd /c "if not exist $(DISTDIR) mkdir $(DISTDIR)"
else
$(DISTDIR):
	@mkdir -p "$(DISTDIR)"
endif

ifeq ($(OS),Windows_NT)
clean:
	@cmd /c "if exist $(DISTDIR)\$(PLUGIN_SLUG)-*.zip del /q $(DISTDIR)\$(PLUGIN_SLUG)-*.zip & if exist $(DISTDIR) rmdir $(DISTDIR) 2>nul"
else
clean:
	rm -f "$(DISTDIR)"/$(PLUGIN_SLUG)-*.zip
	@-rmdir "$(DISTDIR)" 2>/dev/null || true
endif
