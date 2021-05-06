// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend -emit-module -enable-experimental-concurrency -enable-library-evolution -emit-module-path=%t/resilient_actor.swiftmodule -module-name=resilient_actor %S/Inputs/resilient_actor.swift
// RUN: %target-swift-frontend -I %t -emit-ir -enable-experimental-concurrency -enable-library-evolution %s | %IRGenFileCheck %s
// REQUIRES: concurrency

// CHECK: @"$s13default_actor1ACMn" = hidden constant
//   0x81800050: 0x01800000 IsActor + IsDefaultActor
//   0x81810050: the same, but using a singleton metadata initialization
// CHECK-SAME: i32 {{-2122317744|-2122252208}},

import resilient_actor

// CHECK-LABEL: define hidden swiftcc void @"$s13default_actor1ACfD"(%T13default_actor1AC* swiftself %0)
// CHECK-NOT: ret void
// CHECK:     call swiftcc void @swift_defaultActor_deallocate(
// CHECK:     ret void
actor A {}
