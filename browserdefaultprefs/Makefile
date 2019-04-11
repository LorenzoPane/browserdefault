include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = BrowserDefaultPrefs
BrowserDefaultPrefs_FILES = BDPRootListController.m
BrowserDefaultPrefs_INSTALL_PATH = /Library/PreferenceBundles
BrowserDefaultPrefs_FRAMEWORKS = UIKit
BrowserDefaultPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BrowserDefaultPrefs.plist$(ECHO_END)
