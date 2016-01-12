protocol Binnable {
    func shouldBeSeparated(from: Self) -> Bool
}

extension Array where Element: Binnable {

    func createSectionedRepresentation() -> [[Element]] {
        var newSections = [[Element]]()
        if count == 0 {
            return newSections
        }

        var currentSection = 0
        var comparisonIndex = 0
        var comparison = self[comparisonIndex]
        var newSection = [Element]()
        newSection.append(comparison)
        newSections.append(newSection)
        for var i = 1; i < count; i++ {
            let current = self[i]
            if current.shouldBeSeparated(comparison) {
                currentSection++
                var newSection = [Element]()
                newSection.append(current)
                newSections.append(newSection)
                comparisonIndex = i
                comparison = self[comparisonIndex]

            } else {
                newSections[currentSection].append(current)
            }
        }
        return newSections
    }
}