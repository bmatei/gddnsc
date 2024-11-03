SYSTEMD_CONF=etc/systemd/system
BIN_DIR=usr/bin
BUILD_PREFIXES=$(SYSTEMD_CONF) $(BIN_DIR)
BUILD=$(BUILD_DIR)/$(SYSTEMD_CONF)/gddnsc.service\
$(BUILD_DIR)/$(SYSTEMD_CONF)/gddnsc.timer\
$(BUILD_DIR)/$(BIN_DIR)/gddnsc.sh

include build_rules/templates/conf.mk
include build_rules/features/deploy/debian.mk
