
.PHONY: all
all:
	$(MAKE) -C lib/github.com/diku-dk/sml-hashtable all

.PHONY: test
test:
	$(MAKE) -C lib/github.com/diku-dk/sml-hashtable test

.PHONY: clean
clean:
	$(MAKE) -C lib/github.com/diku-dk/sml-hashtable clean
	rm -rf MLB *~
