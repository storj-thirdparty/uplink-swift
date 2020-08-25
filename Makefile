# Go parameters
GOCMD=go
GOBUILD=$(GOCMD) build
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
# Uplink-c
GIT_REPO=https://github.com/storj/uplink-c
UPLINKC_NAME=uplink-c
LIBRARY_NAME=libuplinkc.dylib
COPY_LIBRARY_FILE=libuplinkc.dylib libuplinkc.h uplink_definitions.h
UPLINKC_VERSION=v1.0.5
# Swift parameters
SOURCE_DIR_NAME=Sources
CLIBUPLINK_DIR_NAME=$(SOURCE_DIR_NAME)/libuplink
CLIBUPLINK_INCLUDE_FOLDER_NAME=$(CLIBUPLINK_DIR_NAME)/include
CLIBUPLINK_FILENAME=$(CLIBUPLINK_DIR_NAME)/libuplink.c
#Color
RED_COLOR=\033[31m
GREEN_COLOR=\033[32m
RESET_COLOR=\033[0m
build:
	if test ! -d $(SOURCE_DIR_NAME); then echo ' $(RED_COLOR) \n Build Failed : Directory $(SOURCE_DIR_NAME) does not exists $(RESET_COLOR)\n' && exit 1; fi
	if test ! -d $(CLIBUPLINK_DIR_NAME); then echo '$(RED_COLOR) \nBuild Failed : Directory $(CLIBUPLINK_DIR_NAME) does not exits\n$(RESET_COLOR)' && exit 1; fi
	if test ! -f $(CLIBUPLINK_FILENAME); then echo '$(RED_COLOR) \n Build Failed : File $(CLIBUPLINK_FILENAME) does not exits\n$(RESET_COLOR)\n' && exit 1; fi
	if test ! -d $(CLIBUPLINK_INCLUDE_FOLDER_NAME); then mkdir $(CLIBUPLINK_INCLUDE_FOLDER_NAME); fi
	if test ! -d $(UPLINKC_NAME); then git clone -b $(UPLINKC_VERSION) $(GIT_REPO); fi
	cd uplink-c;$(GOBUILD) -o $(LIBRARY_NAME) -buildmode=c-shared;mv $(COPY_LIBRARY_FILE) ../$(CLIBUPLINK_INCLUDE_FOLDER_NAME);
	rm -rf $(UPLINKC_NAME);
	echo ' $(GREEN_COLOR) \n Successfully build $(RESET_COLOR)';
clean:
	$(GOCLEAN)
	if test -d $(CLIBUPLINK_INCLUDE_FOLDER_NAME); then rm -rf $(CLIBUPLINK_INCLUDE_FOLDER_NAME); fi
	if test -d $(SOURCE_DIR_NAME); then rm -rf $(UPLINKC_NAME); fi
	echo ' $(GREEN_COLOR) \n Successfully cleaned $(RESET_COLOR)';