MLCOMP ?= mlkit

.PHONY: all
all:
	$(MLCOMP) hash.mlb
	$(MLCOMP) table.mlb
	$(MLCOMP) mono_table.mlb
	$(MLCOMP) string_table.mlb

.PHONY: test
test:
	$(MLCOMP) hash.mlb
	$(MLCOMP) table.mlb
	$(MLCOMP) mono_table.mlb
	$(MLCOMP) string_table.mlb

.PHONY: clean
clean:
	rm -rf MLB *~ run
