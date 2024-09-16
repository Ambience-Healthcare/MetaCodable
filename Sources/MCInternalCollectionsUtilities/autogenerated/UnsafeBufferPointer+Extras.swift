//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Collections open source project
//
// Copyright (c) 2021 - 2024 Apple Inc. and the Swift project authors
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
    extension UnsafeBufferPointer {
        @inlinable
        @inline(__always)
        func _ptr(at index: Int) -> UnsafePointer<Element> {
            assert(index >= 0 && index < count)
            return baseAddress.unsafelyUnwrapped + index
        }
    }
#else // !COLLECTIONS_SINGLE_MODULE
    public extension UnsafeBufferPointer {
        @inlinable
        @inline(__always)
        func _ptr(at index: Int) -> UnsafePointer<Element> {
            assert(index >= 0 && index < count)
            return baseAddress.unsafelyUnwrapped + index
        }
    }
#endif // COLLECTIONS_SINGLE_MODULE
