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
    extension RandomAccessCollection {
        @_alwaysEmitIntoClient @inline(__always)
        func _index(at offset: Int) -> Index {
            index(startIndex, offsetBy: offset)
        }

        @_alwaysEmitIntoClient @inline(__always)
        func _offset(of index: Index) -> Int {
            distance(from: startIndex, to: index)
        }

        @_alwaysEmitIntoClient @inline(__always)
        subscript(_offset offset: Int) -> Element {
            self[_index(at: offset)]
        }
    }
#else // !COLLECTIONS_SINGLE_MODULE
    public extension RandomAccessCollection {
        @_alwaysEmitIntoClient @inline(__always)
        func _index(at offset: Int) -> Index {
            index(startIndex, offsetBy: offset)
        }

        @_alwaysEmitIntoClient @inline(__always)
        func _offset(of index: Index) -> Int {
            distance(from: startIndex, to: index)
        }

        @_alwaysEmitIntoClient @inline(__always)
        subscript(_offset offset: Int) -> Element {
            self[_index(at: offset)]
        }
    }
#endif // COLLECTIONS_SINGLE_MODULE
