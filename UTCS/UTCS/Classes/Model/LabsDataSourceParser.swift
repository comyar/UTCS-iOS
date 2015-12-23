import SwiftyJSON

class LabsDataSourceParser: DataSourceParser {
    var parsedMachines: [String: [String: UTCSLabMachine]] {
    get {
        return parsed as? [String: [String: UTCSLabMachine]] ?? [String: [String: UTCSLabMachine]]()
    }
    }
    override func parseValues(values: JSON) {
        let thirdData = values[0, "machines"].array
        let basementData = values[1, "machines"].array
        parsed = ["third": parseFloor(thirdData!, labName: "third"),
            "basement": parseFloor(basementData!, labName: "basement")]
    }

    private func parseFloor(floor: [JSON], labName: String) -> [String: UTCSLabMachine] {
        var machines = [String: UTCSLabMachine]()
        for machineData in floor {
            let machine = UTCSLabMachine()
            machine.lab = labName
            machine.name = machineData["name"].string
            machine.load = CGFloat(machineData["load"].float!)
            machine.occupied = machineData["occupied"].bool!
            machine.status = machineData["up"].bool!
            machine.uptime = machineData["uptime"].string
            machines[machine.name] = machine
        }
        return machines
    }
}
