TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME=rootless
THEOS_DEVICE_IP = 192.168.1.30
THEOS_DEVICE_PORT = 22
SDK_PATH = $(THEOS)/sdks/iPhoneOS16.5.sdk/
SYSROOT = $(SDK_PATH)

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HideDots

HideDots_FILES = Tweak.x
HideDots_CFLAGS = -fobjc-arc
HideDots_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += HideDotsPrefs
include $(THEOS_MAKE_PATH)/aggregate.mk
