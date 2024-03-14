
import UIKit

// MARK: Strings are not arrays

let name = "Taylor"
for letter in name {
    print("Give me a \(letter)")
}
//print(name[3]) can't read individual letters from strings
let letter = name[name.index(name.startIndex, offsetBy: 3)]
print(letter)

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
} // with this extension we can read individual letters from strings
let letter2 = name[3]


// MARK: Working with strings in Swift

let password = "123456"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
password.deletingPrefix("1")
password.deletingSuffix("6")



let weather = "it's going to rain"
print(weather.capitalized)
print(weather.uppercased())

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}
print(weather.capitalizedFirst)



let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Phyton", "Ruby", "Swift"]
languages.contains("Swift")

extension String {
    func containsAny(of array: [String]) -> Bool {
        for item in array {
            if self.contains(item) {
                return true
            }
        }
        return false
    }
}
input.containsAny(of: languages)
languages.contains(where: input.contains) // does same work as extension


// MARK: Formatting strings with NSAttributedString

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]
let attributedString = NSAttributedString(string: string, attributes: attributes)

let attributedString2 = NSMutableAttributedString(string: string)
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 8),
                               range: NSRange(location: 0, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 16),
                               range: NSRange(location: 5, length: 2))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 24),
                               range: NSRange(location: 8, length: 1))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 32),
                               range: NSRange(location: 10, length: 4))
attributedString2.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))


// MARK: Challenges Day81


extension String {
    func withPrefix(_ prefix: String) -> String {
        if self.hasPrefix(prefix) { return self }
        
        return (prefix + self)
    }
}
let someStr = "pet"
someStr.withPrefix("car")
someStr.withPrefix("pe")


extension String {
    func isNumeric() -> Bool {
        for letter in self {
            if Int(letter.lowercased()) != nil { return true}
        }
        
        return false
    }
}
let numericString = "Smallest prime number is 2"
let nonNumericString = "It is a non numeric string"
numericString.isNumeric()
nonNumericString.isNumeric()


extension String {
    var lines: [String] {
        let lines = self.components(separatedBy: " ")
        
        return lines
    }
}
let test = "This is a test"
print(test.lines)

