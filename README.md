[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/Validated.svg?style=flat-square)](https://cocoapods.org/pods/Validated) [![Platform support](https://img.shields.io/badge/platform-ios%20%7C%20osx%20%7C%20tvos%20%7C%20watchos-lightgrey.svg?style=flat-square)](https://github.com/Ben-G/Validated/blob/master/LICENSE.md)[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![License MIT](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://github.com/Ben-G/Validated/blob/master/LICENSE.md)


#Validated

Validated is a μ-library (~50 Source Lines of Code) that allows you make better use of Swift's type system by providing tools for easily generating new types with built-in guarantees.

Validated allows you to use the type system to verify properties of your values, providing a new level of compile time guarantees.

Using validators you can define new types that add guarantees to existing types:

```swift
// Create a new string type that can never be empty
typealias NonEmptyString = Validated<String, NonEmptyStringValidator>
```

##Example

You might have a function in your code that only knows how to work with a `User` value when the user is logged in. Usually you will implement this requirement in code & add documentation, but you don't have an easy way of expressing this invariant in the type signature:

```swift
/// Please ever only call with a logged-in user!
func performTaskWithUser(user: User) {
    precondition(
    	user.loggedIn, 
    	"It is illegal to call this method with a logged out user!"
    )

	// ...
}
```

Using Validated you can quickly create a new type that describes this requirement in the type system. That makes it impossible to call the function with a logged-out user and it makes the method signature express your invariant (instead of relying on documentation):

```swift
func performTaskWithUser(user: LoggedInUser) {
	// ...
}
```

**So how is this new `LoggedInUser` type created?**

First, you need to implement a validator:

```swift
struct LoggedInValidator: Validator {

    static func validate(value: User) -> Bool {
        return value.loggedIn
    }

}
```
A `Validator` needs to implement the `validate` function that takes the type that this validator can validate (in this case a `User`). The funtion returns a `Bool`. Return `true` if the requirements are fulfilled and `false` if not.

With the `Validator` in place we can create our new type like this:

```swift
typealias LoggedInUser = Validated<User, LoggedInValidator>
```

Note, that it is not required to provide a typealias, but for most cases it is recommended.

**And that's it!**

`LoggedInUser` now has a failable initializer that takes a `User`. If the passed in `User` fulfills the logged-in requirement you will have a `LoggedInUser`, otherwise `nil`. Additionally `LoggedInUser` provides a throwing initializer, in case you prefer to handle failed validations as errors instead of `nil` values.

The underlying value (the full `User` value) is stored in the `.value` property of `LoggedInUser`.

##Beyond the Basics

Validated provides some further features that might be non-obvious.

###Composing Validators with Logical Operators

Validated offers `Validator` types for logical operations that allow you to require multiple validations in different combinations. E.g. you can use the `And` validator to require that two requirements must be met for your type to intializer:

```swift
typealias AllCapsNonEmptyString =
            Validated<String, And<NonEmptyStringValidator, AllCapsLatinStringValidator>>
```
`Or` and `Not` are provided as additional validators. You can take a look at the specs for additional examples.

###Generic Validators

A `Validator` can itself be generic. This is useful if you want to provide verifications for a whole category of types. The example validator `NonEmptyCollectionValidator` can be applied to all validator types by using a generic requirement:

```swift
struct NonEmptyCollectionValidator<T: CollectionType>: Validator {
    static func validate(value: T) -> Bool {
        if !value.isEmpty {
            return true
        } else {
            return false
        }
    }
}
```
However, when using this validator to create a type, you will have to specify the exact type of collection you want to validate:

```swift
typealias NonEmptyListOfStrings = Validated<[String], NonEmptyCollectionValidator<[String]>>
```

# Does this Library Enable Dependent Types?

No, not really. Dependent types would allow us to define types, solely based on values. This library only allows us to validate if a type is of a specified type `<T>` based on its value and a validator. The value itself doesn't change the type information. 

Truely dependent types would create the following results:
```swift
[1, 2, 3] // type = Array<count:3 type:Int>
[1, 2, 3, 4] // type = Array<count:4 type:Int>
```

Using Validated we can only verify if a type falls into one of our statically defined categories:
```swift
ListOf3([1,2,3]) // type = ListOf3<Array<Int>
ListOf3([1,2,3,4]) // type = nil
```

However, these statically provided checks can still add a lot of value to your code; see the examples above.

#Installation

Validated is available via the usual suspects.

## CocoaPods

You can install Validated via CocoaPods by adding it to your `Podfile`:

	use_frameworks!

	source 'https://github.com/CocoaPods/Specs.git'
	platform :ios, '8.0'

	pod 'Validated'

And run `pod install`.

## Carthage

You can install Validated via Carthage by adding the following line to your Cartfile:

    github "Ben-G/Validated"


# Get in touch

If you have any questions, you can find me on twitter [@benjaminencz](https://twitter.com/benjaminencz).