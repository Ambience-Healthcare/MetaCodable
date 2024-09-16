//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Collections open source project
//
// Copyright (c) 2022 - 2024 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

// #############################################################################
// #                                                                           #
// #            DO NOT EDIT THIS FILE; IT IS AUTOGENERATED.                    #
// #                                                                           #
// #############################################################################

// In single module mode, we need these declarations to be internal,
// but in regular builds we want them to be public. Unfortunately
// the current best way to do this is to duplicate all definitions.
#if COLLECTIONS_SINGLE_MODULE
    /// True if consistency checking is enabled in the implementation of the
    /// Swift Collections package, false otherwise.
    ///
    /// Documented performance promises are null and void when this property
    /// returns true -- for example, operations that are documented to take
    /// O(1) time might take O(*n*) time, or worse.
    @inlinable @inline(__always)
    var _isCollectionsInternalCheckingEnabled: Bool {
        #if COLLECTIONS_INTERNAL_CHECKS
            return true
        #else
            return false
        #endif
    }
#else // !COLLECTIONS_SINGLE_MODULE
    /// True if consistency checking is enabled in the implementation of the
    /// Swift Collections package, false otherwise.
    ///
    /// Documented performance promises are null and void when this property
    /// returns true -- for example, operations that are documented to take
    /// O(1) time might take O(*n*) time, or worse.
    @inlinable @inline(__always)
    public var _isCollectionsInternalCheckingEnabled: Bool {
        #if COLLECTIONS_INTERNAL_CHECKS
            return true
        #else
            return false
        #endif
    }
#endif // COLLECTIONS_SINGLE_MODULE
