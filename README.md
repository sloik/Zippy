![Main](https://github.com/sloik/Zippy/actions/workflows/swift.yml/badge.svg?branch=main)
![Nightly](https://github.com/sloik/Zippy/actions/workflows/nightly.yml/badge.svg)

# Zippy 🤐

Zip function.

# `zip`and `zipWith` on Optional 

Zip function is defined on sequences in Swift. This is a nice extension to have it on Optional. 

Let say you have some computations or values that are optional. It might be tedious to `if let` them. Using `zip` you just flip the container inside out (check out how type is transformed in this [documentation on zip in haskell](https://hoogle.haskell.org/?hoogle=zip)) and `map` on the result. 

```swift
let userName: String? 
let userLast: String?
let userAge: Int? 

zip(userName, userLast, userAge)
    .map{ (name: String, last: String, age: Int) in 
        // Working with not optional values
     }
```

# `asyncZip`

Allaws for calling multiple async functions concurently to get tuple of results.


```swift

let (name, age) = await asyncZip(
        await asyncGetUserName(), 
        await asyncGetUserAge()
    )

let user = User(name: name, age: age)

```

# `asyncZipWith`

The same as `asyncZip` but the last argument is a function that can transform this tuple into a instance of some type.

```swift

struct User {
    let name: String
    let age: Int
}

let user: User = asyncZip(
        await asyncGetUserName(), 
        await asyncGetUserAge(),
        with: User.init
    )

```

In this example you can just write `User.init` as the compiler will match to the correct function. But you can use a closure together with trailing syntax to do whatever you need.

```swift

struct User {
    let name: String
    let age: Int
}

let user: User = asyncZip(
        await asyncGetUserName(), 
        await asyncGetUserAge()
    ) { (fetchedName: String, fetchedAge: Int) in
        User(name: fetchedName, age: fetchedAge)
    }
```

# `zip`and `zipWith` on [Either](https://github.com/sloik/EitherSwift)

`Either` is a more general type than `Optional` or `Result` and it also has the `zip` function defined for it (as it has map). If you want to see more about Either then check this respository: [EitherSwift Swift Package](https://github.com/sloik/EitherSwift)
 
```swift
let userName: Either<Int,String> = getUserNameOrErrorCode()
let userLastName: Either<Int,String> = getUserLastNameOrErrorCode()

zip(userName, userLastName)
    .map { (name: String, last: String) in 
        // When all are .right cases then you have the values here
     }
```

## `zipWith`

Many times you run your code to do smething with values that are returned. To stramline that you can pass a function to `zipWith`.

```swift

func validateName    (_ s: String) -> Either<Int,String> { ... }
func validateLastName(_ s: String) -> Either<Int,String> { ... }

struct User { let name: String; let lastName: String }

// Given two Eithers when they both are right then returns User.
// Notice as this also returns an Either but luckely this type has a map.
let createUserWhenValid: Either<Int,String>,Either<Int,String>) -> Either<Int,User> = zip(with: User.init)   

createUserWhenValid(validateName, validateLastName) 
    .map { (user: User) in
        // Real instance of User type 😎
    }
    .mapLeft { (errorCodes: [Int]) in
        // error codes that were returned as left values
    }

```

## Optional API

If you want to streamline working with Optionals in Swift then please checkout [OptionalAPI Swift Package](https://github.com/sloik/OptionalAPI). It has rich documentation and tests to show how it can be used.

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)
