import _AtomicsShims

extension Bool: AtomicValue {
  @frozen
  public struct AtomicRepresentation {
    public typealias Value = Bool

    @usableFromInline
    internal typealias _Storage = _AtomicInt8Storage

    @usableFromInline
    internal var _storage: _Storage

    @inline(__always) @_alwaysEmitIntoClient
    public init(_ value: Bool) {
      _storage = _sa_prepare_Int8(value._atomicValue)
    }
  }

  @_alwaysEmitIntoClient @inline(__always)
  internal var _atomicValue: Int8 {
    self ? 1 : 0
  }
}

// extension Int8 {
//   @_alwaysEmitIntoClient @inline(__always)
//   internal var _atomicBoolValue: Bool {
//     (self & 1) != 0
//   }
// }

extension Bool.AtomicRepresentation: AtomicStorage {
}

