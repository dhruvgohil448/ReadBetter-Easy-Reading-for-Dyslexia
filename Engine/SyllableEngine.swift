import Foundation

struct SyllableEngine {
    // Demo mode helper
    static func getSyllables(for word: String) -> [String] {
        // Extract the first "word-like" run of letters to avoid empty/whitespace crashes
        // and weird syllables from punctuation/phrases.
        let token = word.split(whereSeparator: { !$0.isLetter }).first.map(String.init) ?? ""
        let lower = token.lowercased()
        guard !lower.isEmpty else { return [] }
        switch lower {
        case "fantastic": return ["fan", "tas", "tic"]
        case "butterfly": return ["but", "ter", "fly"]
        case "momentum": return ["mo", "men", "tum"]
        case "school": return ["school"]
        case "computer": return ["com", "pu", "ter"]
        case "dinosaur": return ["di", "no", "saur"]
        case "elephant": return ["el", "e", "phant"]
        default:
            // Fallback to a naive split or just return the word if too hard
            return naiveSplit(token)
        }
    }
    
    private static func isVowel(_ char: Character) -> Bool {
        return "aeiouyAEIOUY".contains(char)
    }
    
    private static func naiveSplit(_ word: String) -> [String] {
        guard !word.isEmpty else { return [] }
        // Improved naive syllable splitting algorithm
        // Basic pattern: Vowel-Consonant-Vowel (VCV) splits
        var syllables: [String] = []
        var currentSyllable = ""
        var previousWasVowel = false
        
        for (index, char) in word.enumerated() {
            let isV = isVowel(char)
            
            currentSyllable.append(char)
            
            // If we hit a vowel after a consonant, check if we should split
            if isV && !previousWasVowel && !currentSyllable.isEmpty && currentSyllable.count > 1 {
                // Look ahead to see if there's a consonant after this vowel
                let nextIndex = word.index(word.startIndex, offsetBy: index + 1)
                if nextIndex < word.endIndex {
                    let nextChar = word[nextIndex]
                    let nextIsVowel = isVowel(nextChar)
                    
                    // If next is consonant, we might split after current vowel
                    if !nextIsVowel {
                        // Check if there's another vowel coming after the consonant
                        let afterNextIndex = word.index(nextIndex, offsetBy: 1)
                        if afterNextIndex < word.endIndex {
                            let afterNextIsVowel = isVowel(word[afterNextIndex])
                            if afterNextIsVowel {
                                // VCV pattern - split before the consonant
                                let syllable = String(currentSyllable.dropLast())
                                if !syllable.isEmpty {
                                    syllables.append(syllable)
                                    currentSyllable = String(char)
                                }
                            }
                        }
                    }
                }
            }
            
            previousWasVowel = isV
        }
        
        // Add the last syllable
        if !currentSyllable.isEmpty {
            syllables.append(currentSyllable)
        }
        
        // If we couldn't split meaningfully, return the word as a single syllable
        let cleaned = syllables
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        return cleaned.isEmpty || cleaned.count == 1 ? [word] : cleaned
    }
}
