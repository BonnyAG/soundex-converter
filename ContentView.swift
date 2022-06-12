import SwiftUI

struct ContentView: View {
    @State private var surname: String = ""
    @State private var codedSurname: String = ""
    
    /* SOUNDEX LOGIC
     --- REMOVE LETTERS ---
     * 1a. The first letter of a surname should be the start of the soundex code.
     * 1b. If the 1st and 2nd letter are have the same code ignore the second letter
     * 2. Remove skipped consonants
     * 3. Remove duplicate letters
     * 4. Remove letters with the same code that are not separated by a vowel
     * 5. Remove vowels
     --- CODE THE REMAINING LETTERS ---
     * 6. Code the remaining three letters using the soundex coding chart
     * 7. If there's not three letters, fill whatever was left with 0s
     */
    
    // Soundex Coding Chart
    let soundexCoding = [
        "b": 1, "p": 1, "f": 1, "v": 1,
        "c": 2, "s": 2, "k": 2, "g": 2, "j": 2, "q": 2, "x": 2, "z": 2,
        "d": 3, "t": 3,
        "l": 4,
        "m": 5, "n": 5,
        "r": 6
    ]
    
    // Defines invalid letters for sounded coding.
    let skippedConsonants:[Character] = ["W", "H", "Y"]
    let vowels:[Character] = ["A", "O", "E", "I", "U"]
    
    // Remove invalid consonants for step 2
    func removeInvalidConsonants(surname: String) -> String {
        // Create an array from the surname
        let surnameChars = Array(surname.uppercased())
        // Create the export variable
        var exportedLetters: String = ""
        
        // Loop over each character in the surname
        for surnameChar in surnameChars {
            var counter = 1
            // Loop over each invalid Consonant
            for skippedConsonant in skippedConsonants {
                // Check if the current character is a skipped consonant
                if (surnameChar != skippedConsonant && counter == 3) {
                    // If the character is not a skipped consonant and you've looped over the 3 invalid consonants, export the current character
                    exportedLetters += String(surnameChar)
                } else if (surnameChar != skippedConsonant){
                    // If the character is an invalid consonant but you haven't looped over all 3 invalid consonants, increase the counter
                    counter += 1
                }
            }
        }
        
        return exportedLetters
    }
    
    // Remove duplicate numbers
    func removeDuplicateLetters(surname: String) -> String {
        // Create an array from the surname
        let surnameChars = Array(surname.uppercased())
        // Create the export variable
        var exportedLetters: String = ""
        // Create the skip step variable
        var skipNextStep: Bool = false
        
        // Loop over each character in the surname
        for i in 0...surnameChars.count - 1 {
            // Skip if skip step variable is true
            if (skipNextStep) {
                skipNextStep = false
                continue
            } else {
                // Add the current character to the export variable
                exportedLetters += String(surnameChars[i])
                // Check if i has reached the max value to avoid an out of bounds error 
                if(i != surnameChars.count - 1) {
                    // If the current character is the same as the next character, skip the next step
                    if(surnameChars[i] == surnameChars[i+1]) {
                        skipNextStep = true 
                    }
                }
            }
        }
        return exportedLetters
    }
    
    // Check if a letter is a vowel
    func isLetterVowel(char: Character) -> Bool {
        var isVowel = false
        
        // Check if the current character is a vowel
        for vowel in vowels {
            if (char == vowel) {
                isVowel = true
                break
            }
        }
        
        return isVowel
    }
    
    // Remove letters with the same code
    func removeSameCodeLetters (surname: String) -> String {
        // Create an array from the surname
        let surnameChars = Array(surname.lowercased())
        // Set the maximum value before going out of bounds
        let max = surnameChars.count - 1
        // Variables
        var exportedLetters: String = ""
        var currLetterCode = 0
        var nextLetterCode = 0
        var skipNextStep = false
        
        // Loop over each character
        for i in 0...surnameChars.count - 1 {
            // Skip next step if the skip step variable is set to true
            if (skipNextStep) {
                skipNextStep = false
                continue
            } else {
                // Check if the current character is a vowel, if so skip it
                if (isLetterVowel(char: Character(surnameChars[i].uppercased()))) {
                    continue
                } else if (i != max) {
                    // Check if the next character is a vowel
                    if (isLetterVowel(char: Character(surnameChars[i+1].uppercased()))) {
                        // If so, export current character
                        exportedLetters += String(surnameChars[i])
                    } else {
                        // Calculate the soundex codes of the current and next character
                        currLetterCode = soundexCoding[surnameChars[i].lowercased()]!
                        nextLetterCode = soundexCoding[surnameChars[i+1].lowercased()]!
                        
                        // Check if the current character has the same code as the next one
                        if(currLetterCode == nextLetterCode) {
                            // If so, skip the next character
                            skipNextStep = true
                        }
                        // Export the current character
                        exportedLetters += String(surnameChars[i])
                    }
                } else {
                    exportedLetters += String(surnameChars[i])
                }
            }
        }
        return exportedLetters
    }
    
    // Code the remaining letters
    func codeLetters(letters: String) -> String {
        // Create an array based on the remaining letters
        let lettersToCode = Array(letters.lowercased())
        // Variables
        var exportedCode: String = ""
        
        // Loop over each letter
        for letter in lettersToCode {
            // Replace the letter with the corresponding code
            exportedCode += String(soundexCoding[String(letter)]!)
        }
        
        // If there's less than three coded letters
        if(exportedCode.count < 3) {
            // Calculate how many missing spots there are for the code
            let missingSpots: Int = 3 - exportedCode.count
            
            // Fill those spots with a 0
            for _ in 0...missingSpots - 1 {
                exportedCode += String(0)
            }
        } 
        // Check if there's more than 3 coded letters
        else if (exportedCode.count > 3) {
            // Temporary variables
            let tempArray = Array(exportedCode)
            var tempExport = ""
            
            // Export the first three letters of the code
            for i in 0...2 {
                tempExport += String(tempArray[i])
            }
            exportedCode = tempExport
        }
        return exportedCode
    }
    
    public func soundexCoding(surname: String) -> String {
        // Starting Variables
        var codedSurname: String = "";
        var lettersToCode: String = ""
        //let surname: String = "Robertson"
        
        // STEP 1B - Add the first letter to the coded surname
        codedSurname += surname.prefix(1).uppercased()
        
        // STEP 1B - If the 1st and 2nd letter are have the same code ignore the second letter
        // Find soundex code for the 1st letter
        let firstLetterCode: Int? = soundexCoding[surname.prefix(1).lowercased()] 
        // Find soundex code for the 2nd letter
        let secondLetter = surname.prefix(2) 
        let secondLetterCode: Int? = soundexCoding[secondLetter.suffix(1).lowercased()]
        
        // Check if the code is the same between the first and the second letter
        if (firstLetterCode == secondLetterCode) {
            // If so, ignore the second letter
            lettersToCode = surname.suffix(surname.count-2).lowercased()
        } else {
            // Otherwise, use all of the remaining letters
            lettersToCode = surname.suffix(surname.count-1).lowercased()
        } 
        
        // STEP 2 - Remove invalid consonants
        lettersToCode = removeInvalidConsonants(surname: lettersToCode)
        
        // STEP 3 - Remove duplicate adjacent letters 
        lettersToCode = removeDuplicateLetters(surname: lettersToCode)
        
        // STEP 4 & 5 -  Remove letters with the same code that are not separated by a vowel and remove vowels
        lettersToCode = removeSameCodeLetters(surname: lettersToCode)
        
        // STEP 6 & 7 - Code the remaining letters
        codedSurname += codeLetters(letters: lettersToCode)
        print("Surname: \(surname)\nCoded Surname: \(codedSurname)")
        
        return codedSurname
    }
    
    var body: some View {
        VStack {
            Text("Family History Toolbox").font(.title.bold()).padding(12)
            Divider()
            Section {
                Form {
                    Section {
                        Text("Soundex Converter").font(Font.system(size: 16).italic())
                        TextField("Enter a Surname", text: $surname)
                        Button("Convert") {
                            codedSurname = soundexCoding(surname: surname)
                        }
                    }
                }
                Text("Coded Surname: \(codedSurname)").frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
