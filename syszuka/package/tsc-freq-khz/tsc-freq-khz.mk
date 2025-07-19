################################################################################
#
# tsc-freq-khz
#
################################################################################

TSC_FREQ_KHZ_VERSION = 1.0.0
TSC_FREQ_KHZ_SITE = $(call github,Aniruddha-Deb,tsc_freq_khz,v$(TSC_FREQ_KHZ_VERSION))
TSC_FREQ_KHZ_LICENSE = Apache-2.0
TSC_FREQ_KHZ_LICENSE_FILES = LICENSE
TSC_FREQ_KHZ_DEPENDENCIES = linux

define TSC_FREQ_KHZ_BUILD_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D) modules
endef

define TSC_FREQ_KHZ_INSTALL_TARGET_CMDS
	$(MAKE) $(LINUX_MAKE_FLAGS) -C $(LINUX_DIR) M=$(@D) \
		INSTALL_MOD_PATH=$(TARGET_DIR) modules_install
endef

$(eval $(kernel-module))
$(eval $(generic-package))