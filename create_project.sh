#!/bin/bash
set -e

PROJECT_NAME="epubTTS"
PROJECT_DIR="."

# Create basic project structure
mkdir -p "$PROJECT_NAME.xcodeproj"
mkdir -p "$PROJECT_NAME.xcodeproj/xcuserdata"
mkdir -p "$PROJECT_NAME.xcodeproj/xcshareddata/xcschemes"

# Create project.pbxproj (simplified version)
cat > "$PROJECT_NAME.xcodeproj/project.pbxproj" << 'EOF'
// !$*UTF8*$!
{
    archiveVersion = 1;
    classes = {
    };
    objectVersion = 56;
    objects = {
        /* Begin PBXBuildFile section */
        /* End PBXBuildFile section */
        
        /* Begin PBXFileReference section */
        /* End PBXFileReference section */
        
        /* Begin PBXFrameworksBuildPhase section */
        /* End PBXFrameworksBuildPhase section */
        
        /* Begin PBXGroup section */
        /* End PBXGroup section */
        
        /* Begin PBXNativeTarget section */
        /* End PBXNativeTarget section */
        
        /* Begin PBXProject section */
        /* End PBXProject section */
        
        /* Begin PBXSourcesBuildPhase section */
        /* End PBXSourcesBuildPhase section */
        
        /* Begin XCBuildConfiguration section */
        /* End XCBuildConfiguration section */
        
        /* Begin XCConfigurationList section */
        /* End XCConfigurationList section */
    };
    rootObject = 00000000000000000000000000000001;
}
EOF

echo "✅ Basic Xcode project structure created"
