// RUN: not %target-swift-frontend -emit-ir %s -enable-library-evolution -enable-experimental-feature Embedded 2>&1 | %FileCheck %s
// RUN: not %target-swift-frontend -emit-ir %s -enable-resilience -enable-experimental-feature Embedded 2>&1 | %FileCheck %s

// CHECK: error: Library evolution cannot be enabled with embedded Swift.
