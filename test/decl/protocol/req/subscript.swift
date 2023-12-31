// RUN: %target-typecheck-verify-swift

protocol P1 {
  subscript (i: Int) -> Int { get } // expected-note{{protocol requires subscript with type '(Int) -> Int'}}
}

class C1 : P1 {
  subscript (i: Int) -> Int {
    get {
      return i
    }
    set {}
  }
}

struct S1 : P1 {
  subscript (i: Int) -> Int {
    get {
      return i
    }
    set {}
  }
}

struct S1Error : P1 { // expected-error{{type 'S1Error' does not conform to protocol 'P1'}}
  subscript (i: Int) -> Double { // expected-note{{candidate has non-matching type '(Int) -> Double'}}
    get {
      return Double(i)
    }
    set {}
  }
}


//===----------------------------------------------------------------------===//
// Get-only subscript requirements
//===----------------------------------------------------------------------===//


protocol SubscriptGet {
  subscript(a : Int) -> Int { get } // expected-note {{protocol requires subscript with type '(Int) -> Int'; add a stub for conformance}}
}

class SubscriptGet_Get : SubscriptGet {
  subscript(a : Int) -> Int { return 0 }  // ok
  // for static cross-conformance test below: expected-note@-1 {{candidate operates on an instance, not a type as required}}
}

class SubscriptGet_GetSet : SubscriptGet {
  subscript(a : Int) -> Int { get { return 42 } set {} }  // ok
}


//===----------------------------------------------------------------------===//
// Get-set subscript requirements
//===----------------------------------------------------------------------===//


protocol SubscriptGetSet {
  subscript(a : Int) -> Int { get set }   // expected-note {{protocol requires subscript with type '(Int) -> Int'}}
}

class SubscriptGetSet_Get : SubscriptGetSet {  // expected-error {{type 'SubscriptGetSet_Get' does not conform to protocol 'SubscriptGetSet'}}
  subscript(a : Int) -> Int { return 0 }   // expected-note {{candidate is not settable, but protocol requires it}}
}

class SubscriptGetSet_GetSet : SubscriptGetSet {
  subscript(a : Int) -> Int { get { return 42 } set {} }  // ok
}

//===----------------------------------------------------------------------===//
// Generic subscript requirements
//===----------------------------------------------------------------------===//

protocol Initable {
  init()
}

protocol GenericSubscriptProtocol {
  subscript<T : Initable>(t: T.Type) -> T { get set }
  // expected-note@-1 {{protocol requires subscript with type '<T> (T.Type) -> T'; add a stub for conformance}}
}

struct GenericSubscriptWitness : GenericSubscriptProtocol {
  subscript<T : Initable>(t: T.Type) -> T {
    get {
      return t.init()
    }

    set { }
  }
}

struct GenericSubscriptNoWitness : GenericSubscriptProtocol {}
// expected-error@-1 {{type 'GenericSubscriptNoWitness' does not conform to protocol 'GenericSubscriptProtocol'}}

//===----------------------------------------------------------------------===//
// Static subscript requirements
//===----------------------------------------------------------------------===//

protocol StaticSubscriptGet {
  static subscript(a : Int) -> Int { get } // expected-note {{protocol requires subscript with type '(Int) -> Int'; add a stub for conformance}}
}

class StaticSubscriptGet_Get : StaticSubscriptGet {
  static subscript(a : Int) -> Int { return 0 }  // ok
  // for static cross-conformance test below: expected-note@-1 {{candidate operates on a type, not an instance as required}}
}

class StaticSubscriptGet_GetSet : StaticSubscriptGet {
  static subscript(a : Int) -> Int { get { return 42 } set {} }  // ok
}

protocol StaticSubscriptGetSet {
  static subscript(a : Int) -> Int { get set }   // expected-note {{protocol requires subscript with type '(Int) -> Int'}}
}

class StaticSubscriptGetSet_Get : StaticSubscriptGetSet {  // expected-error {{type 'StaticSubscriptGetSet_Get' does not conform to protocol 'StaticSubscriptGetSet'}}
  static subscript(a : Int) -> Int { return 0 }   // expected-note {{candidate is not settable, but protocol requires it}}
}

class StaticSubscriptGetSet_GetSet : StaticSubscriptGetSet {
  static subscript(a : Int) -> Int { get { return 42 } set {} }  // ok
}

extension SubscriptGet_Get: StaticSubscriptGet {} // expected-error {{type 'SubscriptGet_Get' does not conform to protocol 'StaticSubscriptGet'}}
extension StaticSubscriptGet_Get: SubscriptGet {} // expected-error {{type 'StaticSubscriptGet_Get' does not conform to protocol 'SubscriptGet'}}
