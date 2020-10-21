SUBDIRS := $(filter-out build/, $(wildcard */))

all: $(SUBDIRS)

$(SUBDIRS):
	@ make -C $@

.PHONY: all $(SUBDIRS)

clean :
	cd build && find . ! -name .gitkeep -type f -delete