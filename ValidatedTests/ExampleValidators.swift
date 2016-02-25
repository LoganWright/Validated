//
//  ExampleValidators.swift
//  Validated
//
//  Created by Benji Encz on 2/24/16.
//  Copyright © 2016 Benjamin Encz. All rights reserved.
//

@testable import Validated

struct _NonEmptyString: Validator {
    static func validate(value: String) -> Bool {
        if !value.isEmpty {
            return true
        } else {
            return false
        }
    }
}

struct _AllCapsLatinString: Validator {
    static func validate(value: String) -> Bool {
        return value.characters.reduce(true) { accu, character in
            return ("A"..."Z").contains(character)
        }
    }
}

struct _CountGreater10<T: CollectionType>: Validator {
    static func validate(value: T) -> Bool {
        if value.count > 10 {
            return true
        } else {
            return false
        }
    }
}

struct _SumLarger20: Validator {
    static func validate(value: [Int]) -> Bool {
        if value.reduce(0, combine: +) > 20 {
            return true
        } else {
            return false
        }
    }
}
