# Zippy 🤐

Zip function.

# `zip` on Optional 

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

## Optional API

If you want to streamline working with Optionals in Swift then please checkout [OptionalAPI Swift Package](https://github.com/sloik/OptionalAPI). It has rich documentation and tests to show how it can be used.

# 🐇🕳 Rabbit Hole

This project is part of the [🐇🕳 Rabbit Hole Packages Collection](https://github.com/sloik/RabbitHole)
