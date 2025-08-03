################################################################################
#
# libpfc
#
################################################################################

LIBPFC_VERSION = 1.0.0
LIBPFC_SITE = $(call github,Aniruddha-Deb,libpfc,v$(LIBPFC_VERSION))
LIBPFC_LICENSE = Apache-2.0
LIBPFC_LICENSE_FILES = LICENSE
LIBPFC_DEPENDENCIES = linux

define LIBPFC_BUILD_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D)/kmod modules
endef

define LIBPFC_INSTALL_TARGET_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D)/kmod \
		INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
endef

$(eval $(kernel-module))
$(eval $(generic-package))
