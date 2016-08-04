//
//  Quantity.swift
//  MKUnits
//
//  Copyright (c) 2016 Michal Konturek <michal.konturek@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public struct Quantity {
    public let amount: NSDecimalNumber
    public let unit: Unit

    public init(amount: NSNumber, unit: Unit) {
        self.amount = NSDecimalNumber(decimal: amount.decimalValue)
        self.unit = unit
    }

    public func converted(to: Unit) -> Quantity {
        assert(self.unit.isConvertible(to))
        let amount = self.unit.convert(self.amount, to: to)
        return Quantity(amount: amount, unit: to)
    }

    public func negative() -> Quantity {
        return self * -1
    }

    public func rounded(precision: Int16) -> Quantity {
        assert(precision >= 0)
        let rounded = self.amount.decimalNumberByRoundingAccordingToBehavior(
            NSDecimalNumberHandler(
                roundingMode: .RoundPlain,
                scale: precision,
                raiseOnExactness: false,
                raiseOnOverflow: false,
                raiseOnUnderflow: false,
                raiseOnDivideByZero: false
            )
        )
        return Quantity(amount: rounded, unit: self.unit)
    }
}

// MARK: - Arithmetic Operators

public func + (lhs: Quantity, rhs: Quantity) -> Quantity {
    assert(lhs.unit.isConvertible(rhs.unit))
    let converted = rhs.converted(lhs.unit).amount
    let amount = lhs.amount.decimalNumberByAdding(converted)
    return Quantity(amount: amount, unit: lhs.unit)
}

public func - (lhs: Quantity, rhs: Quantity) -> Quantity {
    assert(lhs.unit.isConvertible(rhs.unit))
    let converted = rhs.converted(lhs.unit).amount
    let amount = lhs.amount.decimalNumberBySubtracting(converted)
    return Quantity(amount: amount, unit: lhs.unit)
}

public func * (lhs: Quantity, rhs: Int) -> Quantity {
    let amount = lhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: rhs))
    return Quantity(amount: amount, unit: lhs.unit)
}

public func * (lhs: Quantity, rhs: Double) -> Quantity {
    let amount = lhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(double: rhs))
    return Quantity(amount: amount, unit: lhs.unit)
}

public func * (lhs: Quantity, rhs: Float) -> Quantity {
    let amount = lhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(float: rhs))
    return Quantity(amount: amount, unit: lhs.unit)
}

public func * (lhs: Quantity, rhs: NSNumber) -> Quantity {
    let amount = lhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(decimal: rhs.decimalValue))
    return Quantity(amount: amount, unit: lhs.unit)
}

public func * (lhs: Int, rhs: Quantity) -> Quantity {
    let amount = rhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(integer: lhs))
    return Quantity(amount: amount, unit: rhs.unit)
}

public func * (lhs: Double, rhs: Quantity) -> Quantity {
    let amount = rhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(double: lhs))
    return Quantity(amount: amount, unit: rhs.unit)
}

public func * (lhs: Float, rhs: Quantity) -> Quantity {
    let amount = rhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(float: lhs))
    return Quantity(amount: amount, unit: rhs.unit)
}

public func * (lhs: NSNumber, rhs: Quantity) -> Quantity {
    let amount = rhs.amount.decimalNumberByMultiplyingBy(NSDecimalNumber(decimal: lhs.decimalValue))
    return Quantity(amount: amount, unit: rhs.unit)
}

// MARK: - CustomStringConvertible

extension Quantity: CustomStringConvertible {
    public var description: String {
        return "\(self.amount) \(self.unit)"
    }
}

// MARK: - Equatable

extension Quantity: Equatable {
    public func equals(other: Quantity) -> Bool {
        if self.unit.isConvertible(other.unit) {
            let converted = other.converted(self.unit)
            return self.amount == converted.amount
        } else {
            return false
        }
    }
}
public func == (lhs: Quantity, rhs: Quantity) -> Bool {
    return lhs.equals(rhs)
}

// MARK: - Comparable

extension Quantity: Comparable {}
public func < (lhs: Quantity, rhs: Quantity) -> Bool {
    assert(lhs.unit.isConvertible(rhs.unit))
    let converted = lhs.converted(rhs.unit)
    return converted.amount.compare(rhs.amount) == .OrderedAscending
}

public func <= (lhs: Quantity, rhs: Quantity) -> Bool {
    assert(lhs.unit.isConvertible(rhs.unit))
    let converted = lhs.converted(rhs.unit)
    return converted.amount.compare(rhs.amount) != .OrderedDescending
}

public func > (lhs: Quantity, rhs: Quantity) -> Bool {
    assert(lhs.unit.isConvertible(rhs.unit))
    let converted = lhs.converted(rhs.unit)
    return converted.amount.compare(rhs.amount) == .OrderedDescending
}

public func >= (lhs: Quantity, rhs: Quantity) -> Bool {
    assert(lhs.unit.isConvertible(rhs.unit))
    let converted = lhs.converted(rhs.unit)
    return converted.amount.compare(rhs.amount) != .OrderedAscending
}