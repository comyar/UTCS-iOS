import SwiftyJSON

// Key for the person's first name
let firstNameKey = "fname"

// Key for the person's last name
let lastNameKey = "lname"

// Key for the person's full name
let fullNameKey = "name"

// Key for the person's office location
let officeKey = "location"

// Key for the person's phone number
let phoneKey = "phone"

// Key for the person's type
let typeKey = "title"

// Key for the person's image URL
let imageURLKey = "image"


class DirectoryDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> Any! {
        var directory = [DirectoryPerson]()
        for personData in values.arrayValue {
            let person = DirectoryPerson()
            person.firstName    = personData[firstNameKey].string
            person.lastName     = personData[lastNameKey].string
            person.fullName     = personData[fullNameKey].string
            person.office       = personData[officeKey].string
            person.phoneNumber  = personData[phoneKey].string
            person.type         = personData[typeKey].string
            person.imageURL     = personData[imageURLKey].URL
            directory.append(person)

        }
        return directory
    }
}