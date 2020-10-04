SUBDIRS := $(filter-out build/, $(wildcard */))

all: $(SUBDIRS)

$(SUBDIRS):
	@ make -C $@

.PHONY: all $(SUBDIRS)