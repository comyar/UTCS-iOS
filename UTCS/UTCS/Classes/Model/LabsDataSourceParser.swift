import SwiftyJSON

class LabsDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        let parsed: [String: Lab]? = parseValues(values)
        return parsed
    }

    func parseValues(values: JSON) -> [String: Lab]? {
        guard let thirdData = values[0, "machines"].array,
            basementData = values[1, "machines"].array else {
                return nil
        }

        return ["third": parseFloor(thirdData, labName: "third"),
                "basement": parseFloor(basementData, labName: "basement")]
    }

    private func parseFloor(floor: [JSON], labName: String) -> [String: LabMachine] {
        let machines = floor.map{LabMachine(json: $0, lab: labName)}.flatMap{$0}
        var floor = [String: LabMachine]()
        for machine in machines {
            floor[machine.name] = machine
        }
        return floor
    }
}
