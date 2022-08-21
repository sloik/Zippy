# Zippy 🤐

Zip function.

# `zip` on Optional 

Zip function is defined on sequences in Swift. This is a nice extension to have it on Optional. 

Let say you have some computations or values that are optional. It might be tedious to `if let` them. Using `zip` you just flip the container inside out (check out how type is transormed in this [documentation on zip in haskell](https://hoogle.haskell.org/?hoogle=zip)) and `map` on the result. 

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

## Optional API

If you want to streamline working with Optionals in Swift then please checkout [OptionalAPI Swift Package](https://github.com/sloik/OptionalAPI). It has rich deocumentation and tests to show how it can be used.

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)
