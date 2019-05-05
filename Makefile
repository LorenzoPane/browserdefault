ARCHS = armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = BrowserDefault
BrowserDefault_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"

SUBPROJECTS += browserdefaultprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
