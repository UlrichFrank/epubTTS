#!/usr/bin/env python3
import os
import uuid

def create_pbxproj():
    """Create a minimal but valid Xcode project"""
    
    # UUIDs for objects
    project_id = "AAAAAAAAAAAAAAAAAAAA0001"
    target_id = "AAAAAAAAAAAAAAAAAAAA0002"
    config_list_id = "AAAAAAAAAAAAAAAAAAAA0003"
    build_config_id = "AAAAAAAAAAAAAAAAAAAA0004"
    target_config_id = "AAAAAAAAAAAAAAAAAAAA0005"
    target_config_list_id = "AAAAAAAAAAAAAAAAAAAA0006"
    frameworks_phase_id = "AAAAAAAAAAAAAAAAAAAA0007"
    sources_phase_id = "AAAAAAAAAAAAAAAAAAAA0008"
    main_group_id = "AAAAAAAAAAAAAAAAAAAA0009"
    products_group_id = "AAAAAAAAAAAAAAAAAAAA000A"
    
    pbxproj = f"""// !$*UTF8*$!
{{
archiveVersion = 1;
classes = {{
}};
objectVersion = 56;
objects = {{
/* Begin PBXBuildFile section */
/* End PBXBuildFile section */
/* Begin PBXContainerItemProxy section */
/* End PBXContainerItemProxy section */
/* Begin PBXFileReference section */
{products_group_id} /* epubTTS.app */ = {{isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = epubTTS.app; sourceTree = BUILT_PRODUCTS_DIR; }};
/* End PBXFileReference section */
/* Begin PBXFrameworksBuildPhase section */
{frameworks_phase_id} /* Frameworks */ = {{
isa = PBXFrameworksBuildPhase;
buildActionMask = 2147483647;
files = (
);
runOnlyForDeploymentPostprocessing = 0;
}};
/* End PBXFrameworksBuildPhase section */
/* Begin PBXGroup section */
{main_group_id} = {{
isa = PBXGroup;
children = (
{products_group_id},
);
sourceTree = "<group>";
}};
{products_group_id} = {{
isa = PBXGroup;
children = (
{products_group_id},
);
name = Products;
sourceTree = "<group>";
}};
/* End PBXGroup section */
/* Begin PBXNativeTarget section */
{target_id} /* epubTTS */ = {{
isa = PBXNativeTarget;
buildConfigurationList = {target_config_list_id};
buildPhases = (
{sources_phase_id},
{frameworks_phase_id},
);
buildRules = (
);
dependencies = (
);
name = epubTTS;
productName = epubTTS;
productReference = {products_group_id};
productType = "com.apple.product-type.application";
}};
/* End PBXNativeTarget section */
/* Begin PBXProject section */
{project_id} /* Project object */ = {{
isa = PBXProject;
attributes = {{
BuildIndependentTargetsInParallel = 1;
LastSwiftUpdateCheck = 1500;
LastUpgradeCheck = 1500;
TargetAttributes = {{
{target_id} = {{
CreatedOnToolsVersion = 15.0;
}};
}};
}};
buildConfigurationList = {config_list_id};
compatibilityVersion = "Xcode 14.0";
developmentRegion = en;
hasScannedForEncodings = 0;
knownRegions = (
en,
Base,
);
mainGroup = {main_group_id};
productRefGroup = {products_group_id};
projectDirPath = "";
projectRoot = "";
targets = (
{target_id},
);
}};
/* End PBXProject section */
/* Begin PBXSourcesBuildPhase section */
{sources_phase_id} /* Sources */ = {{
isa = PBXSourcesBuildPhase;
buildActionMask = 2147483647;
files = (
);
runOnlyForDeploymentPostprocessing = 0;
}};
/* End PBXSourcesBuildPhase section */
/* Begin XCBuildConfiguration section */
{build_config_id} /* Debug */ = {{
isa = XCBuildConfiguration;
buildSettings = {{
ALWAYS_SEARCH_USER_PATHS = NO;
CLANG_ANALYZER_NONNULL = YES;
CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
CLANG_CXX_LANGUAGE_DIALECT = "c++20";
CLANG_CXX_LIBRARY = "libc++";
CLANG_ENABLE_MODULES = YES;
CLANG_ENABLE_OBJC_ARC = YES;
CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
CLANG_WARN_BOOL_CONVERSION = YES;
CLANG_WARN_COMMA = YES;
CLANG_WARN_CONSTANT_CONVERSION = YES;
CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
CLANG_WARN_EMPTY_BODY = YES;
CLANG_WARN_ENUM_CONVERSION = YES;
CLANG_WARN_INFINITE_RECURSION = YES;
CLANG_WARN_INT_CONVERSION = YES;
CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
CLANG_WARN_STRICT_PROTOTYPES = YES;
CLANG_WARN_SUSPICIOUS_MOVE = YES;
CLANG_WARN_SUSPICIOUS_MOVES = YES;
CLANG_WARN_UNREACHABLE_CODE = YES;
CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
COPY_PHASE_STRIP = NO;
DEBUG_INFORMATION_FORMAT = dwarf;
ENABLE_STRICT_OBJC_MSGSEND = YES;
ENABLE_TESTABILITY = YES;
GCC_C_LANGUAGE_DIALECT = gnu99;
GCC_DYNAMIC_NO_PIC = NO;
GCC_NO_COMMON_BLOCKS = YES;
GCC_OPTIMIZATION_LEVEL = 0;
GCC_PREPROCESSOR_DEFINITIONS = (
"DEBUG=1",
"$(inherited)",
);
GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
GCC_WARN_UNDECLARED_SELECTOR = YES;
GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
GCC_WARN_UNUSED_FUNCTION = YES;
GCC_WARN_UNUSED_VARIABLE = YES;
IPHONEOS_DEPLOYMENT_TARGET = 15.0;
MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
MTL_FAST_MATH = YES;
ONLY_ACTIVE_ARCH = YES;
SDKROOT = iphoneos;
SWIFT_ACTIVE_COMPILATION_CONDITIONS = DEBUG;
SWIFT_OPTIMIZATION_LEVEL = "-Onone";
SWIFT_VERSION = 5.9;
}};
name = Debug;
}};
{build_config_id.replace('0004', '0010')} /* Release */ = {{
isa = XCBuildConfiguration;
buildSettings = {{
ALWAYS_SEARCH_USER_PATHS = NO;
CLANG_ANALYZER_NONNULL = YES;
CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
CLANG_CXX_LANGUAGE_DIALECT = "c++20";
CLANG_CXX_LIBRARY = "libc++";
CLANG_ENABLE_MODULES = YES;
CLANG_ENABLE_OBJC_ARC = YES;
CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
CLANG_WARN_BOOL_CONVERSION = YES;
CLANG_WARN_COMMA = YES;
CLANG_WARN_CONSTANT_CONVERSION = YES;
CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
CLANG_WARN_EMPTY_BODY = YES;
CLANG_WARN_ENUM_CONVERSION = YES;
CLANG_WARN_INFINITE_RECURSION = YES;
CLANG_WARN_INT_CONVERSION = YES;
CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
CLANG_WARN_STRICT_PROTOTYPES = YES;
CLANG_WARN_SUSPICIOUS_MOVE = YES;
CLANG_WARN_SUSPICIOUS_MOVES = YES;
CLANG_WARN_UNREACHABLE_CODE = YES;
CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
COPY_PHASE_STRIP = NO;
DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
ENABLE_NS_ASSERTIONS = NO;
ENABLE_STRICT_OBJC_MSGSEND = YES;
GCC_C_LANGUAGE_DIALECT = gnu99;
GCC_NO_COMMON_BLOCKS = YES;
GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
GCC_WARN_UNDECLARED_SELECTOR = YES;
GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
GCC_WARN_UNUSED_FUNCTION = YES;
GCC_WARN_UNUSED_VARIABLE = YES;
IPHONEOS_DEPLOYMENT_TARGET = 15.0;
MTL_ENABLE_DEBUG_INFO = NO;
MTL_FAST_MATH = YES;
SDKROOT = iphoneos;
SWIFT_COMPILATION_MODE = wholemodule;
SWIFT_OPTIMIZATION_LEVEL = "-O";
SWIFT_VERSION = 5.9;
VALIDATE_PRODUCT = YES;
}};
name = Release;
}};
{target_config_id} /* Debug */ = {{
isa = XCBuildConfiguration;
buildSettings = {{
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
CODE_SIGN_STYLE = Automatic;
CURRENT_PROJECT_VERSION = 1;
GENERATE_INFOPLIST_FILE = YES;
INFOPLIST_FILE = Info.plist;
INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
INFOPLIST_KEY_UILaunchScreen_Generation = YES;
INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLe ft UIInterfaceOrientationLandscapeRight";
IPHONEOS_DEPLOYMENT_TARGET = 15.0;
LD_RUNPATH_SEARCH_PATHS = (
"$(inherited)",
"@executable_path/Frameworks",
);
MARKETING_VERSION = 1.0;
PRODUCT_BUNDLE_IDENTIFIER = com.ulrichfrank.epubtts;
PRODUCT_NAME = "$(TARGET_NAME)";
SWIFT_EMIT_LOC_STRINGS = YES;
SWIFT_VERSION = 5.9;
TARGETED_DEVICE_FAMILY = "1,2";
}};
name = Debug;
}};
{target_config_id.replace('0005', '0011')} /* Release */ = {{
isa = XCBuildConfiguration;
buildSettings = {{
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
CODE_SIGN_STYLE = Automatic;
CURRENT_PROJECT_VERSION = 1;
GENERATE_INFOPLIST_FILE = YES;
INFOPLIST_FILE = Info.plist;
INFOPLIST_KEY_UIApplicationSceneManifest_Generation = YES;
INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents = YES;
INFOPLIST_KEY_UILaunchScreen_Generation = YES;
INFOPLIST_KEY_UISupportedInterfaceOrientations_iPad = "UIInterfaceOrientationPortrait UIInterfaceOrientationPortraitUpsideDown UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone = "UIInterfaceOrientationPortrait UIInterfaceOrientationLandscapeLeft UIInterfaceOrientationLandscapeRight";
IPHONEOS_DEPLOYMENT_TARGET = 15.0;
LD_RUNPATH_SEARCH_PATHS = (
"$(inherited)",
"@executable_path/Frameworks",
);
MARKETING_VERSION = 1.0;
PRODUCT_BUNDLE_IDENTIFIER = com.ulrichfrank.epubtts;
PRODUCT_NAME = "$(TARGET_NAME)";
SWIFT_EMIT_LOC_STRINGS = NO;
SWIFT_VERSION = 5.9;
TARGETED_DEVICE_FAMILY = "1,2";
}};
name = Release;
}};
/* End XCBuildConfiguration section */
/* Begin XCConfigurationList section */
{config_list_id} /* Build configuration list for PBXProject "epubTTS" */ = {{
isa = XCConfigurationList;
buildConfigurations = (
{build_config_id},
{build_config_id.replace('0004', '0010')},
);
defaultConfigurationIsVisible = 0;
defaultConfigurationName = Release;
}};
{target_config_list_id} /* Build configuration list for PBXNativeTarget "epubTTS" */ = {{
isa = XCConfigurationList;
buildConfigurations = (
{target_config_id},
{target_config_id.replace('0005', '0011')},
);
defaultConfigurationIsVisible = 0;
defaultConfigurationName = Release;
}};
/* End XCConfigurationList section */
}};
rootObject = {project_id};
}}
"""
    return pbxproj

# Create directories
os.makedirs("epubTTS.xcodeproj", exist_ok=True)
os.makedirs("epubTTS.xcodeproj/xcuserdata", exist_ok=True)
os.makedirs("epubTTS.xcodeproj/xcshareddata/xcschemes", exist_ok=True)

# Write pbxproj
with open("epubTTS.xcodeproj/project.pbxproj", "w") as f:
    f.write(create_pbxproj())

print("✅ Xcode project created: epubTTS.xcodeproj")
