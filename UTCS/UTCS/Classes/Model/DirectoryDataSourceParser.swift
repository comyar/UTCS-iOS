

// Key for the person's first name
let firstNameKey = "fName"

// Key for the person's last name
let lastNameKey = "lName"

// Key for the person's full name
let fullNameKey = "name"

// Key for the person's office location
let officeKey = "office"

// Key for the person's phone number
let phoneKey = "phone"

// Key for the person's type
let typeKey = "type"

// Key for the person's image URL
let imageURLKey = "image"


class DirectoryDataSourceParser: UTCSDataSourceParser {
    override func parseValues(values: AnyObject!) -> AnyObject! {
        let values = values as! [[AnyObject]]
        var directory = [DirectoryPerson]()
        for letter in values {
            for personData in letter {
                let person = DirectoryPerson()
                person.firstName    = personData[firstNameKey] as? String
                person.lastName     = personData[lastNameKey] as? String
                person.fullName     = personData[fullNameKey] as? String
                person.office       = personData[officeKey] as? String
                person.phoneNumber  = personData[phoneKey] as? String
                person.type         = personData[typeKey] as? String
                person.imageURL     = NSURL(string: personData[imageURLKey] as! String)
                directory.append(person)
            }
        }
        return directory
    }
}

