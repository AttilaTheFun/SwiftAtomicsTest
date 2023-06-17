#!/bin/sh

# Exit when any command fails:
set -e

# Creating Directories

echo "Creating Directories"

mkdir -p .build/aarch64-unknown-linux-gnu/release/Atomics.build
mkdir -p .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build

# Creating Files

# echo "Creating Files"

# touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.ast
touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.o
# touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.ast
touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.o
# touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.ast
touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.o
touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/Atomics.autolink
# touch .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTest_objs/SwiftAtomicsTestMain.swift.ast
touch .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTestMain.swift.o
touch .build/aarch64-unknown-linux-gnu/release/Atomics.build/SwiftAtomicsTest.autolink
# touch .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTest.swiftmodule

# Copying Output File Maps

echo "Creating Output File Maps"

cp shell-swift/Atomics.output_file_map.json .build/aarch64-unknown-linux-gnu/release/Atomics.build/output-file-map.json

cp shell-swift/SwiftAtomicsTest.output_file_map.json .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/output-file-map.json

# Compiling Swift Module Atomics

echo "Compiling Swift Module Atomics"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swiftc \
-module-name \
Atomics \
-incremental \
-emit-dependencies \
-emit-module \
-emit-module-path \
.build/aarch64-unknown-linux-gnu/release/Atomics.swiftmodule \
-output-file-map \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/output-file-map.json \
-parse-as-library \
-whole-module-optimization \
-num-threads \
2 \
-c \
Sources/Atomics/AtomicBool.swift \
Sources/Atomics/AtomicValue.swift \
Sources/Atomics/ManagedAtomic.swift \
-I \
.build/aarch64-unknown-linux-gnu/release \
-target \
aarch64-unknown-linux-gnu \
-swift-version \
5 \
-O \
-g \
-j2 \
-DSWIFT_PACKAGE \
-module-cache-path \
.build/aarch64-unknown-linux-gnu/release/ModuleCache \
-parseable-output \
-parse-as-library \
-v

# echo "Compiling Swift Module Atomics -- Frontend"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-frontend \
-frontend \
-c \
Sources/Atomics/AtomicBool.swift \
Sources/Atomics/AtomicValue.swift \
Sources/Atomics/ManagedAtomic.swift \
# -supplementary-output-file-map \
# /tmp/TemporaryDirectory.NXPY08/supplementaryOutputs-1 \
-target \
aarch64-unknown-linux-gnu \
-Xllvm \
-aarch64-use-tbi \
-disable-objc-interop \
-I \
.build/aarch64-unknown-linux-gnu/release \
-g \
-module-cache-path \
.build/aarch64-unknown-linux-gnu/release/ModuleCache \
-swift-version \
5 \
-O \
-D \
SWIFT_PACKAGE \
-new-driver-path \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-driver \
-empty-abi-descriptor \
-resource-dir \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib/swift \
-module-name \
Atomics \
-enable-default-cmo \
-parse-as-library \
-num-threads \
2 \
-o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.o \
-o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.o \
-o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.o

# Extracting autolink data for Swift module Atomics

echo "Extracting autolink data for Swift module Atomics"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-autolink-extract \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.o \
-o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/Atomics.autolink

# Compiling Swift module SwiftAtomicsTest

echo "Compiling Swift module SwiftAtomicsTest"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swiftc \
-module-name \
SwiftAtomicsTest \
-incremental \
-emit-dependencies \
-emit-module \
-emit-module-path \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.swiftmodule \
-output-file-map \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/output-file-map.json \
-whole-module-optimization \
-num-threads \
2 \
-c \
Sources/SwiftAtomicsTest/SwiftAtomicsTestMain.swift \
-I \
.build/aarch64-unknown-linux-gnu/release \
-target \
aarch64-unknown-linux-gnu \
-swift-version \
5 \
-O \
-g \
-j2 \
-DSWIFT_PACKAGE \
-module-cache-path \
.build/aarch64-unknown-linux-gnu/release/ModuleCache \
-parseable-output \
-Xfrontend \
-entry-point-function-name \
-Xfrontend \
SwiftAtomicsTest_main \
-parse-as-library \
-v

echo "Compiling Swift module SwiftAtomicsTest -- Frontend"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-frontend \
-frontend \
-c \
Sources/SwiftAtomicsTest/SwiftAtomicsTestMain.swift \
-emit-module-path \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.swiftmodule \
# -emit-module-doc-path \
# .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.swiftdoc \
# -emit-module-source-info-path \
# .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.swiftsourceinfo \
# -emit-dependencies-path \
# .build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTest.d \
-target \
aarch64-unknown-linux-gnu \
-Xllvm \
-aarch64-use-tbi \
-disable-objc-interop \
-I \
.build/aarch64-unknown-linux-gnu/release \
-g \
-module-cache-path \
.build/aarch64-unknown-linux-gnu/release/ModuleCache \
-swift-version \
5 \
-O \
-D \
SWIFT_PACKAGE \
-new-driver-path \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-driver \
-entry-point-function-name \
SwiftAtomicsTest_main \
-empty-abi-descriptor \
-resource-dir \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib/swift \
-module-name \
SwiftAtomicsTest \
-enable-default-cmo \
-parse-as-library \
-num-threads \
2 \
-o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTestMain.swift.o

# Extracting autolink data for Swift module SwiftAtomicsTest

echo "Extracting autolink data for Swift module SwiftAtomicsTest"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-autolink-extract \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTestMain.swift.o \
-o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTest.autolink

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swiftc \
-g \
-L \
.build/aarch64-unknown-linux-gnu/release \
-o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest \
-module-name \
SwiftAtomicsTest \
-emit-executable \
-Xlinker \
--gc-sections \
-Xlinker \
--defsym \
-Xlinker \
main=SwiftAtomicsTest_main \
-Xlinker \
'-rpath=$ORIGIN' \
# @.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.product/Objects.LinkFileList \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTestMain.swift.o \
-target \
aarch64-unknown-linux-gnu \
-v \
-L \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/swift-autolink-extract \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTestMain.swift.o \
-o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/SwiftAtomicsTest.autolink

# Linking Sources/SwiftAtomicsTest/SwiftAtomicsTest

echo "Linking Sources/SwiftAtomicsTest/SwiftAtomicsTest"

/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/bin/clang \
-fuse-ld=gold \
-pie \
-Xlinker \
-rpath \
-Xlinker \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib/swift/linux \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib/swift/linux/aarch64/swiftrt.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicBool.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/AtomicValue.swift.o \
.build/aarch64-unknown-linux-gnu/release/Atomics.build/ManagedAtomic.swift.o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest.build/SwiftAtomicsTestMain.swift.o \
@.build/aarch64-unknown-linux-gnu/release/Atomics.build/SwiftAtomicsTest.autolink \
-L \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib/swift/linux \
-lswiftCore \
--target=aarch64-unknown-linux-gnu \
-v \
-L \
.build/aarch64-unknown-linux-gnu/release \
-L \
/home/ubuntu/swift-5.8-RELEASE-ubuntu20.04-aarch64/usr/lib \
-Xlinker \
--gc-sections \
-Xlinker \
--defsym \
-Xlinker \
main=SwiftAtomicsTest_main \
-Xlinker \
'-rpath=$ORIGIN' \
-o \
.build/aarch64-unknown-linux-gnu/release/SwiftAtomicsTest
