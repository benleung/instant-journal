MINT ?= /usr/local/bin/mint
MINT_PATH = ./.mint/lib
MINT_LINK_PATH = ./.mint/bin

bootstrap: mint-bootstrap carthage-bootstrap

mint-bootstrap: $(MINT)
	MINT_PATH=$(MINT_PATH) MINT_LINK_PATH=$(MINT_LINK_PATH) \
	$(MINT) bootstrap

carthage-bootstrap: $(MINT)
	MINT_PATH=$(MINT_PATH) MINT_LINK_PATH=$(MINT_LINK_PATH) \
	$(MINT) run carthage bootstrap --use-xcframeworks --platform ios

carthage-update: $(MINT)
	MINT_PATH=$(MINT_PATH) MINT_LINK_PATH=$(MINT_LINK_PATH) \
	$(MINT) run carthage update $(PACKAGE) --use-xcframeworks --platform ios

/usr/local/bin/mint:
	brew install mint
