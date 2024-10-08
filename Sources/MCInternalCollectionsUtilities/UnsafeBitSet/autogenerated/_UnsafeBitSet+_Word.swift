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
    extension _UnsafeBitSet {
        @frozen @usableFromInline
        struct _Word {
            @usableFromInline
            var value: UInt

            @inlinable
            @inline(__always)
            init(_ value: UInt) {
                self.value = value
            }

            @inlinable
            @inline(__always)
            init(upTo bit: UInt) {
                assert(bit <= _Word.capacity)
                self.init((1 << bit) &- 1)
            }

            @inlinable
            @inline(__always)
            init(from start: UInt, to end: UInt) {
                assert(start <= end && end <= _Word.capacity)
                self = Self(upTo: end).symmetricDifference(Self(upTo: start))
            }
        }
    }

    extension _UnsafeBitSet._Word: CustomStringConvertible {
        @usableFromInline
        var description: String {
            String(value, radix: 16)
        }
    }

    extension _UnsafeBitSet._Word {
        /// Returns the `n`th member in `self`.
        ///
        /// - Parameter n: The offset of the element to retrieve. This value is
        ///    decremented by the number of items found in this `self` towards the
        ///    value we're looking for. (If the function returns non-nil, then `n`
        ///    is set to `0` on return.)
        /// - Returns: If this word contains enough members to satisfy the request,
        ///    then this function returns the member found. Otherwise it returns nil.
        @inline(never)
        func nthElement(_ n: inout UInt) -> UInt? {
            let c = UInt(bitPattern: count)
            guard n < c else {
                n &-= c
                return nil
            }
            let m = Int(bitPattern: n)
            n = 0
            return value._bit(ranked: m)!
        }

        @inline(never)
        func nthElementFromEnd(_ n: inout UInt) -> UInt? {
            let c = UInt(bitPattern: count)
            guard n < c else {
                n &-= c
                return nil
            }
            let m = Int(bitPattern: c &- 1 &- n)
            n = 0
            return value._bit(ranked: m)!
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        static func wordCount(forBitCount count: UInt) -> Int {
            // Note: We perform on UInts to get faster unsigned math (shifts).
            let width = UInt(bitPattern: Self.capacity)
            return Int(bitPattern: (count + width - 1) / width)
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        static var capacity: Int {
            return UInt.bitWidth
        }

        @inlinable
        @inline(__always)
        var count: Int {
            value.nonzeroBitCount
        }

        @inlinable
        @inline(__always)
        var isEmpty: Bool {
            value == 0
        }

        @inlinable
        @inline(__always)
        var isFull: Bool {
            value == UInt.max
        }

        @inlinable
        @inline(__always)
        func contains(_ bit: UInt) -> Bool {
            assert(bit >= 0 && bit < UInt.bitWidth)
            return value & (1 &<< bit) != 0
        }

        @inlinable
        @inline(__always)
        var firstMember: UInt? {
            value._lastSetBit
        }

        @inlinable
        @inline(__always)
        var lastMember: UInt? {
            value._firstSetBit
        }

        @inlinable
        @inline(__always)
        @discardableResult
        mutating func insert(_ bit: UInt) -> Bool {
            assert(bit < UInt.bitWidth)
            let mask: UInt = 1 &<< bit
            let inserted = value & mask == 0
            value |= mask
            return inserted
        }

        @inlinable
        @inline(__always)
        @discardableResult
        mutating func remove(_ bit: UInt) -> Bool {
            assert(bit < UInt.bitWidth)
            let mask: UInt = 1 &<< bit
            let removed = (value & mask) != 0
            value &= ~mask
            return removed
        }

        @inlinable
        @inline(__always)
        mutating func update(_ bit: UInt, to value: Bool) {
            assert(bit < UInt.bitWidth)
            let mask: UInt = 1 &<< bit
            if value {
                self.value |= mask
            } else {
                self.value &= ~mask
            }
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        mutating func insertAll(upTo bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            let mask: UInt = (1 as UInt &<< bit) &- 1
            value |= mask
        }

        @inlinable
        @inline(__always)
        mutating func removeAll(upTo bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            let mask = UInt.max &<< bit
            value &= mask
        }

        @inlinable
        @inline(__always)
        mutating func removeAll(through bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            var mask = UInt.max &<< bit
            mask &= mask &- 1 // Clear lowest nonzero bit.
            value &= mask
        }

        @inlinable
        @inline(__always)
        mutating func removeAll(from bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            let mask: UInt = (1 as UInt &<< bit) &- 1
            value &= mask
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        static var empty: Self {
            Self(0)
        }

        @inline(__always)
        static var allBits: Self {
            Self(UInt.max)
        }
    }

    // _Word implements Sequence by using a copy of itself as its Iterator.
    // Iteration with `next()` destroys the word's value; however, this won't cause
    // problems in normal use, because `next()` is usually called on a separate
    // iterator, not the original word.
    extension _UnsafeBitSet._Word: Sequence, IteratorProtocol {
        @inlinable @inline(__always)
        var underestimatedCount: Int {
            count
        }

        /// Return the index of the lowest set bit in this word,
        /// and also destructively clear it.
        @inlinable
        mutating func next() -> UInt? {
            guard value != 0 else { return nil }
            let bit = UInt(truncatingIfNeeded: value.trailingZeroBitCount)
            value &= value &- 1 // Clear lowest nonzero bit.
            return bit
        }
    }

    extension _UnsafeBitSet._Word: Equatable {
        @inlinable
        static func == (left: Self, right: Self) -> Bool {
            left.value == right.value
        }
    }

    extension _UnsafeBitSet._Word: Hashable {
        @inlinable
        func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable @inline(__always)
        func complement() -> Self {
            Self(~value)
        }

        @inlinable @inline(__always)
        mutating func formComplement() {
            value = ~value
        }

        @inlinable @inline(__always)
        func union(_ other: Self) -> Self {
            Self(value | other.value)
        }

        @inlinable @inline(__always)
        mutating func formUnion(_ other: Self) {
            value |= other.value
        }

        @inlinable @inline(__always)
        func intersection(_ other: Self) -> Self {
            Self(value & other.value)
        }

        @inlinable @inline(__always)
        mutating func formIntersection(_ other: Self) {
            value &= other.value
        }

        @inlinable @inline(__always)
        func symmetricDifference(_ other: Self) -> Self {
            Self(value ^ other.value)
        }

        @inlinable @inline(__always)
        mutating func formSymmetricDifference(_ other: Self) {
            value ^= other.value
        }

        @inlinable @inline(__always)
        func subtracting(_ other: Self) -> Self {
            Self(value & ~other.value)
        }

        @inlinable @inline(__always)
        mutating func subtract(_ other: Self) {
            value &= ~other.value
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        func shiftedDown(by shift: UInt) -> Self {
            assert(shift >= 0 && shift < Self.capacity)
            return Self(value &>> shift)
        }

        @inlinable
        @inline(__always)
        func shiftedUp(by shift: UInt) -> Self {
            assert(shift >= 0 && shift < Self.capacity)
            return Self(value &<< shift)
        }
    }
#else // !COLLECTIONS_SINGLE_MODULE
    public extension _UnsafeBitSet {
        @frozen
        struct _Word {
            public var value: UInt

            @inlinable
            @inline(__always)
            public init(_ value: UInt) {
                self.value = value
            }

            @inlinable
            @inline(__always)
            public init(upTo bit: UInt) {
                assert(bit <= _Word.capacity)
                self.init((1 << bit) &- 1)
            }

            @inlinable
            @inline(__always)
            public init(from start: UInt, to end: UInt) {
                assert(start <= end && end <= _Word.capacity)
                self = Self(upTo: end).symmetricDifference(Self(upTo: start))
            }
        }
    }

    extension _UnsafeBitSet._Word: CustomStringConvertible {
        // @usableFromInline
        public var description: String {
            String(value, radix: 16)
        }
    }

    extension _UnsafeBitSet._Word {
        /// Returns the `n`th member in `self`.
        ///
        /// - Parameter n: The offset of the element to retrieve. This value is
        ///    decremented by the number of items found in this `self` towards the
        ///    value we're looking for. (If the function returns non-nil, then `n`
        ///    is set to `0` on return.)
        /// - Returns: If this word contains enough members to satisfy the request,
        ///    then this function returns the member found. Otherwise it returns nil.
        @inline(never)
        func nthElement(_ n: inout UInt) -> UInt? {
            let c = UInt(bitPattern: count)
            guard n < c else {
                n &-= c
                return nil
            }
            let m = Int(bitPattern: n)
            n = 0
            return value._bit(ranked: m)!
        }

        @inline(never)
        func nthElementFromEnd(_ n: inout UInt) -> UInt? {
            let c = UInt(bitPattern: count)
            guard n < c else {
                n &-= c
                return nil
            }
            let m = Int(bitPattern: c &- 1 &- n)
            n = 0
            return value._bit(ranked: m)!
        }
    }

    public extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        static func wordCount(forBitCount count: UInt) -> Int {
            // Note: We perform on UInts to get faster unsigned math (shifts).
            let width = UInt(bitPattern: Self.capacity)
            return Int(bitPattern: (count + width - 1) / width)
        }
    }

    public extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        static var capacity: Int {
            return UInt.bitWidth
        }

        @inlinable
        @inline(__always)
        var count: Int {
            value.nonzeroBitCount
        }

        @inlinable
        @inline(__always)
        var isEmpty: Bool {
            value == 0
        }

        @inlinable
        @inline(__always)
        var isFull: Bool {
            value == UInt.max
        }

        @inlinable
        @inline(__always)
        func contains(_ bit: UInt) -> Bool {
            assert(bit >= 0 && bit < UInt.bitWidth)
            return value & (1 &<< bit) != 0
        }

        @inlinable
        @inline(__always)
        var firstMember: UInt? {
            value._lastSetBit
        }

        @inlinable
        @inline(__always)
        var lastMember: UInt? {
            value._firstSetBit
        }

        @inlinable
        @inline(__always)
        @discardableResult
        mutating func insert(_ bit: UInt) -> Bool {
            assert(bit < UInt.bitWidth)
            let mask: UInt = 1 &<< bit
            let inserted = value & mask == 0
            value |= mask
            return inserted
        }

        @inlinable
        @inline(__always)
        @discardableResult
        mutating func remove(_ bit: UInt) -> Bool {
            assert(bit < UInt.bitWidth)
            let mask: UInt = 1 &<< bit
            let removed = (value & mask) != 0
            value &= ~mask
            return removed
        }

        @inlinable
        @inline(__always)
        mutating func update(_ bit: UInt, to value: Bool) {
            assert(bit < UInt.bitWidth)
            let mask: UInt = 1 &<< bit
            if value {
                self.value |= mask
            } else {
                self.value &= ~mask
            }
        }
    }

    extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        mutating func insertAll(upTo bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            let mask: UInt = (1 as UInt &<< bit) &- 1
            value |= mask
        }

        @inlinable
        @inline(__always)
        mutating func removeAll(upTo bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            let mask = UInt.max &<< bit
            value &= mask
        }

        @inlinable
        @inline(__always)
        mutating func removeAll(through bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            var mask = UInt.max &<< bit
            mask &= mask &- 1 // Clear lowest nonzero bit.
            value &= mask
        }

        @inlinable
        @inline(__always)
        mutating func removeAll(from bit: UInt) {
            assert(bit >= 0 && bit < Self.capacity)
            let mask: UInt = (1 as UInt &<< bit) &- 1
            value &= mask
        }
    }

    public extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        static var empty: Self {
            Self(0)
        }

        @inline(__always)
        static var allBits: Self {
            Self(UInt.max)
        }
    }

    // _Word implements Sequence by using a copy of itself as its Iterator.
    // Iteration with `next()` destroys the word's value; however, this won't cause
    // problems in normal use, because `next()` is usually called on a separate
    // iterator, not the original word.
    extension _UnsafeBitSet._Word: Sequence, IteratorProtocol {
        @inlinable @inline(__always)
        public var underestimatedCount: Int {
            count
        }

        /// Return the index of the lowest set bit in this word,
        /// and also destructively clear it.
        @inlinable
        public mutating func next() -> UInt? {
            guard value != 0 else { return nil }
            let bit = UInt(truncatingIfNeeded: value.trailingZeroBitCount)
            value &= value &- 1 // Clear lowest nonzero bit.
            return bit
        }
    }

    extension _UnsafeBitSet._Word: Equatable {
        @inlinable
        public static func == (left: Self, right: Self) -> Bool {
            left.value == right.value
        }
    }

    extension _UnsafeBitSet._Word: Hashable {
        @inlinable
        public func hash(into hasher: inout Hasher) {
            hasher.combine(value)
        }
    }

    public extension _UnsafeBitSet._Word {
        @inlinable @inline(__always)
        func complement() -> Self {
            Self(~value)
        }

        @inlinable @inline(__always)
        mutating func formComplement() {
            value = ~value
        }

        @inlinable @inline(__always)
        func union(_ other: Self) -> Self {
            Self(value | other.value)
        }

        @inlinable @inline(__always)
        mutating func formUnion(_ other: Self) {
            value |= other.value
        }

        @inlinable @inline(__always)
        func intersection(_ other: Self) -> Self {
            Self(value & other.value)
        }

        @inlinable @inline(__always)
        mutating func formIntersection(_ other: Self) {
            value &= other.value
        }

        @inlinable @inline(__always)
        func symmetricDifference(_ other: Self) -> Self {
            Self(value ^ other.value)
        }

        @inlinable @inline(__always)
        mutating func formSymmetricDifference(_ other: Self) {
            value ^= other.value
        }

        @inlinable @inline(__always)
        func subtracting(_ other: Self) -> Self {
            Self(value & ~other.value)
        }

        @inlinable @inline(__always)
        mutating func subtract(_ other: Self) {
            value &= ~other.value
        }
    }

    public extension _UnsafeBitSet._Word {
        @inlinable
        @inline(__always)
        func shiftedDown(by shift: UInt) -> Self {
            assert(shift >= 0 && shift < Self.capacity)
            return Self(value &>> shift)
        }

        @inlinable
        @inline(__always)
        func shiftedUp(by shift: UInt) -> Self {
            assert(shift >= 0 && shift < Self.capacity)
            return Self(value &<< shift)
        }
    }
#endif // COLLECTIONS_SINGLE_MODULE
