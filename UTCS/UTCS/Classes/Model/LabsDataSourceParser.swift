import SwiftyJSON

class LabsDataSourceParser: DataSourceParser {

    func parseValues(values: JSON) -> AnyObject? {
        let thirdData = values[0, "machines"].array
        let basementData = values[1, "machines"].array
        return ["third": parseFloor(thirdData!, labName: "third"),
            "basement": parseFloor(basementData!, labName: "basement")]
    }

    private func parseFloor(floor: [JSON], labName: String) -> [String: UTCSLabMachine] {
        var machines = [String: UTCSLabMachine]()
        for machineData in floor {
            let name = machineData["name"].string!
            let load = Double(machineData["load"].float!)
            let occupied = machineData["occupied"].bool!
            let status = machineData["up"].bool!
            let uptime = machineData["uptime"].string!
            
            let machine = UTCSLabMachine(lab: labName, name: name, uptime: uptime, status: status, occupied: occupied, load: load)
            machines[machine!.name] = machine
        }
        return machines
    }
}
