1. Add arithmetic operators (add, subtract, multiply, divide) to make the following expressions true. You can use any parentheses you’d like.

`((3 + 1)/ 3) * 9 = 12`

2. Write a function/method utilizing Swift to determine whether two strings are anagrams or not (examples of anagrams: debit card/bad credit, ~~punishments/nine thumps~~, etc.)

  according to anagram definition:
  > both strings must contain the same exact letters in the same exact frequency

nine thumps is not anagrams of punishments. because it has only **one** `s` character. while punishments has **two** `s`

```swift
func checkAnagrams(string1: String, string2: String) -> Bool {
   
    // first remove white space and newlines
    let string1 = string1.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
    let string2 = string2.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "")
  
    // second rule of being anagrams is having equal length
    guard string2.count == string1.count else {
        return false
    }
    
    var mainStringCharDic = [Character: Int]()
    
    string1.forEach { char in
        if mainStringCharDic[char] == nil {
            mainStringCharDic[char] = 1
        } else {
            mainStringCharDic[char]! += 1
        }
    }
    
    for char in string2 {
        if mainStringCharDic[char] == nil {
            return false
        } else {
            let charCount = mainStringCharDic[char]!
            if charCount == 1 {
                mainStringCharDic[char] = nil
            } else {
                mainStringCharDic[char]! = charCount - 1
            }
        }
    }
   
    return mainStringCharDic.count == 0 ?  true :  false
}
```

3. Write a method in Swift to generate the nth Fibonacci number (1, 1, 2, 3, 5, 8, 13, 21, 34) 

A. recursive approach

```swift
func recuresiveFibonacci(_ number: Int) -> Int {
    
    guard number > 2 else {
        return 1
    }
    
    return recuresiveFibonacci(number - 1) + recuresiveFibonacci(number - 2)
}
```

B. iterative approach

```swift
func iterativeFibonacci(_ number: Int) -> Int {
    
    guard number > 2 else {
        return 1
    }
    
    var fibNminus2 = 1
    var fibNminus1 = 1
    
    var fibonacci = 0
    var counter = 3
    
    while counter <= number {
        fibonacci = fibNminus1 + fibNminus2
        
        fibNminus2 = fibNminus1
        fibNminus1 = fibonacci
        
        counter += 1
    }
    
    return fibonacci
}
```
