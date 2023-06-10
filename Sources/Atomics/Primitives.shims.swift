#if !ATOMICS_NATIVE_BUILTINS
import _AtomicsShims

@_alwaysEmitIntoClient
@_transparent
internal func _atomicMemoryFence(
  ordering: AtomicUpdateOrdering
) {
  switch ordering {
    case .relaxed:
      break
  case .acquiring:
      _sa_thread_fence_acquire()
  case .releasing:
      _sa_thread_fence_release()
  case .acquiringAndReleasing:
      _sa_thread_fence_acq_rel()
  case .sequentiallyConsistent:
      _sa_thread_fence_seq_cst()
    default:
      fatalError("Unsupported ordering")
  }
}

extension UnsafeMutablePointer where Pointee == _AtomicInt8Storage {
  /// Atomically loads a word starting at this address with the specified
  /// memory ordering.
  @_semantics("atomics.requires_constant_orderings")
  @_alwaysEmitIntoClient
  @_transparent // Debug performance
  @usableFromInline
  internal func _atomicLoad(ordering: AtomicLoadOrdering) -> Int8 {
    switch ordering {
    case .relaxed:
      return _sa_load_relaxed_Int8(self)
    case .acquiring:
      return _sa_load_acquire_Int8(self)
    case .sequentiallyConsistent:
      return _sa_load_seq_cst_Int8(self)
    default:
      fatalError("Unsupported ordering")
    }
  }

  /// Atomically stores the specified value starting at the memory referenced by
  /// this pointer, with the specified memory ordering.
  @_semantics("atomics.requires_constant_orderings")
  @_alwaysEmitIntoClient
  @_transparent // Debug performance
  @usableFromInline
  internal func _atomicStore(
    _ desired: Int8,
    ordering: AtomicStoreOrdering
  ) {
    switch ordering {
    case .relaxed:
      _sa_store_relaxed_Int8(self, desired)
    case .releasing:
      _sa_store_release_Int8(self, desired)
    case .sequentiallyConsistent:
      _sa_store_seq_cst_Int8(self, desired)
    default:
      fatalError("Unsupported ordering")
    }
  }

  // @_semantics("atomics.requires_constant_orderings")
  // @_alwaysEmitIntoClient
  // @_transparent // Debug performance
  // public func _atomicCompareExchange(
  //   expected: Int8,
  //   desired: Int8,
  //   ordering: AtomicUpdateOrdering
  // ) -> (exchanged: Bool, original: Int8) {
  //   var expected = expected
  //   let exchanged: Bool
  //   switch ordering {
  //   case .relaxed:
  //     exchanged = _sa_cmpxchg_strong_relaxed_relaxed_Int8(
  //       self, &expected, desired)
  //   case .acquiring:
  //     exchanged = _sa_cmpxchg_strong_acquire_acquire_Int8(
  //       self, &expected, desired)
  //   case .releasing:
  //     exchanged = _sa_cmpxchg_strong_release_relaxed_Int8(
  //       self, &expected, desired)
  //   case .acquiringAndReleasing:
  //     exchanged = _sa_cmpxchg_strong_acq_rel_acquire_Int8(
  //       self, &expected, desired)
  //   case .sequentiallyConsistent:
  //     exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Int8(
  //       self, &expected, desired)
  //   default:
  //     fatalError("Unsupported ordering")
  //   }
  //   return (exchanged, expected)
  // }

  // @_semantics("atomics.requires_constant_orderings")
  // @_alwaysEmitIntoClient
  // @_transparent // Debug performance
  // public func _atomicCompareExchange(
  //   expected: Int8,
  //   desired: Int8,
  //   successOrdering: AtomicUpdateOrdering,
  //   failureOrdering: AtomicLoadOrdering
  // ) -> (exchanged: Bool, original: Int8) {
  //   // FIXME: LLVM doesn't support arbitrary ordering combinations
  //   // yet, so upgrade the success ordering when necessary so that it
  //   // is at least as "strong" as the failure case.
  //   var expected = expected
  //   let exchanged: Bool
  //   switch (successOrdering, failureOrdering) {
  //   case (.relaxed, .relaxed):
  //     exchanged = _sa_cmpxchg_strong_relaxed_relaxed_Int8(
  //       self, &expected, desired)
  //   case (.relaxed, .acquiring):
  //     exchanged = _sa_cmpxchg_strong_acquire_acquire_Int8(
  //       self, &expected, desired)
  //   case (.relaxed, .sequentiallyConsistent):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Int8(
  //       self, &expected, desired)
  //   case (.acquiring, .relaxed):
  //     exchanged = _sa_cmpxchg_strong_acquire_relaxed_Int8(
  //       self, &expected, desired)
  //   case (.acquiring, .acquiring):
  //     exchanged = _sa_cmpxchg_strong_acquire_acquire_Int8(
  //       self, &expected, desired)
  //   case (.acquiring, .sequentiallyConsistent):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Int8(
  //       self, &expected, desired)
  //   case (.releasing, .relaxed):
  //     exchanged = _sa_cmpxchg_strong_release_relaxed_Int8(
  //       self, &expected, desired)
  //   case (.releasing, .acquiring):
  //     exchanged = _sa_cmpxchg_strong_acq_rel_acquire_Int8(
  //       self, &expected, desired)
  //   case (.releasing, .sequentiallyConsistent):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Int8(
  //       self, &expected, desired)
  //   case (.acquiringAndReleasing, .relaxed):
  //     exchanged = _sa_cmpxchg_strong_acq_rel_relaxed_Int8(
  //       self, &expected, desired)
  //   case (.acquiringAndReleasing, .acquiring):
  //     exchanged = _sa_cmpxchg_strong_acq_rel_acquire_Int8(
  //       self, &expected, desired)
  //   case (.acquiringAndReleasing, .sequentiallyConsistent):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Int8(
  //       self, &expected, desired)
  //   case (.sequentiallyConsistent, .relaxed):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_relaxed_Int8(
  //       self, &expected, desired)
  //   case (.sequentiallyConsistent, .acquiring):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_acquire_Int8(
  //       self, &expected, desired)
  //   case (.sequentiallyConsistent, .sequentiallyConsistent):
  //     exchanged = _sa_cmpxchg_strong_seq_cst_seq_cst_Int8(
  //       self, &expected, desired)
  //   default:
  //     preconditionFailure("Unsupported orderings")
  //   }
  //   return (exchanged, expected)
  // }

  @_semantics("atomics.requires_constant_orderings")
  @_alwaysEmitIntoClient
  @_transparent // Debug performance
  @usableFromInline
  internal
  func _atomicLoadThenWrappingDecrement(
    by operand: Int8,
    ordering: AtomicUpdateOrdering
  ) -> Int8 {
    switch ordering {
    case .relaxed:
      return _sa_fetch_sub_relaxed_Int8(
        self, operand)
    case .acquiring:
      return _sa_fetch_sub_acquire_Int8(
        self, operand)
    case .releasing:
      return _sa_fetch_sub_release_Int8(
        self, operand)
    case .acquiringAndReleasing:
      return _sa_fetch_sub_acq_rel_Int8(
        self, operand)
    case .sequentiallyConsistent:
      return _sa_fetch_sub_seq_cst_Int8(
        self, operand)
    default:
      preconditionFailure("Unsupported ordering")
    }
  }
  /// Perform an atomic bitwise AND operation and return the new value,
  /// with the specified memory ordering.
  ///
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_alwaysEmitIntoClient
  @_transparent // Debug performance
  @usableFromInline
  internal
  func _atomicLoadThenBitwiseAnd(
    with operand: Int8,
    ordering: AtomicUpdateOrdering
  ) -> Int8 {
    switch ordering {
    case .relaxed:
      return _sa_fetch_and_relaxed_Int8(
        self, operand)
    case .acquiring:
      return _sa_fetch_and_acquire_Int8(
        self, operand)
    case .releasing:
      return _sa_fetch_and_release_Int8(
        self, operand)
    case .acquiringAndReleasing:
      return _sa_fetch_and_acq_rel_Int8(
        self, operand)
    case .sequentiallyConsistent:
      return _sa_fetch_and_seq_cst_Int8(
        self, operand)
    default:
      preconditionFailure("Unsupported ordering")
    }
  }
  /// Perform an atomic bitwise OR operation and return the new value,
  /// with the specified memory ordering.
  ///
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_alwaysEmitIntoClient
  @_transparent // Debug performance
  @usableFromInline
  internal
  func _atomicLoadThenBitwiseOr(
    with operand: Int8,
    ordering: AtomicUpdateOrdering
  ) -> Int8 {
    switch ordering {
    case .relaxed:
      return _sa_fetch_or_relaxed_Int8(
        self, operand)
    case .acquiring:
      return _sa_fetch_or_acquire_Int8(
        self, operand)
    case .releasing:
      return _sa_fetch_or_release_Int8(
        self, operand)
    case .acquiringAndReleasing:
      return _sa_fetch_or_acq_rel_Int8(
        self, operand)
    case .sequentiallyConsistent:
      return _sa_fetch_or_seq_cst_Int8(
        self, operand)
    default:
      preconditionFailure("Unsupported ordering")
    }
  }
  /// Perform an atomic bitwise XOR operation and return the new value,
  /// with the specified memory ordering.
  ///
  /// - Returns: The original value before the operation.
  @_semantics("atomics.requires_constant_orderings")
  @_alwaysEmitIntoClient
  @_transparent // Debug performance
  @usableFromInline
  internal
  func _atomicLoadThenBitwiseXor(
    with operand: Int8,
    ordering: AtomicUpdateOrdering
  ) -> Int8 {
    switch ordering {
    case .relaxed:
      return _sa_fetch_xor_relaxed_Int8(
        self, operand)
    case .acquiring:
      return _sa_fetch_xor_acquire_Int8(
        self, operand)
    case .releasing:
      return _sa_fetch_xor_release_Int8(
        self, operand)
    case .acquiringAndReleasing:
      return _sa_fetch_xor_acq_rel_Int8(
        self, operand)
    case .sequentiallyConsistent:
      return _sa_fetch_xor_seq_cst_Int8(
        self, operand)
    default:
      preconditionFailure("Unsupported ordering")
    }
  }
}

#endif // ATOMICS_NATIVE_BUILTINS
