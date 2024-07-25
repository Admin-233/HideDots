TARGET := iphone:clang:latest:15.0
SDK_PATH = $(THEOS)/sdks/iPhoneOS16.5.sdk/
SYSROOT = $(SDK_PATH)

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = HideDotsPrefs

HideDotsPrefs_FILES = adRootListController.m
HideDotsPrefs_FRAMEWORKS = UIKit
HideDotsPrefs_INSTALL_PATH = /Library/PreferenceBundles
HideDotsPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
