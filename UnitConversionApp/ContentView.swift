import SwiftUI

struct ContentView: View {
    @State var selectedUnit: String = "Length"
    @State private var currentSelectionFrom: String = "Meter"
    @State private var currentSelectionTo: String = "Kilometer"
    @State private var currentSelectionValue: Decimal = 0
    @State private var convertedValue: Decimal = 0

    var selectedUnitConversion: String {
        "Convert \(selectedUnit)"
    }

    var selectedUnitArray: [String] {
        switch selectedUnit {
        case "Temperature":
            return temperatures
        case "Length":
            return lengths
        case "Time":
            return times
        case "Volume":
            return volumes
        default:
            return lengths
        }
    }

    let units: [String] = ["Temperature", "Length", "Time", "Volume"]
    let temperatures: [String] = ["Celsius", "Fahrenheit", "Kevin"]
    let lengths: [String] = ["Meter", "Kilometer", "Feet", "Yards", "Miles"]
    let volumes: [String] = ["Milliliter", "Liter", "Cups", "Pints", "Gallons"]
    let times: [String] = ["Second", "Minute", "Hour", "Days"]

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Form {
                    Section("Select Unit Conversion") {
                        Picker("Select Unit", selection: $selectedUnit) {
                            ForEach(units, id: \.self) { unit in
                                Text(unit)
                            }
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: selectedUnit) { _ in
                            // Reset selections and recalculate
                            currentSelectionFrom = selectedUnitArray.first ?? ""
                            currentSelectionTo = selectedUnitArray[1]
//                            currentSelectionValue = 0
//                            convertedValue = 0
                            convertUnits()
                        }
                    }

                    Section(selectedUnitConversion) {
                        HStack {
                            Picker("From", selection: $currentSelectionFrom) {
                                ForEach(selectedUnitArray, id: \.self) { unit in
                                    Text(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: currentSelectionFrom) { _ in
                                convertUnits()
                            }

                            Picker("To", selection: $currentSelectionTo) {
                                ForEach(selectedUnitArray, id: \.self) { unit in
                                    Text(unit)
                                }
                            }
                            .pickerStyle(.menu)
                            .onChange(of: currentSelectionTo) { _ in
                                convertUnits()
                            }
                        }
                    }

                    Section("Enter Value") {
                        TextField("Value", value: $currentSelectionValue, format: .number)
                            .keyboardType(.decimalPad)
                            .onChange(of: currentSelectionValue) { _ in
                                convertUnits()
                            }

                        Text("\(currentSelectionValue) \(currentSelectionFrom) is \(convertedValue) \(currentSelectionTo)")
                    }
                }
            }
        }
    }

    func convertUnits() {
        switch selectedUnit {
        case "Temperature":
            convertedValue = convertTemperature(from: currentSelectionFrom, to: currentSelectionTo, value: currentSelectionValue)
        case "Length":
            convertedValue = convertLength(from: currentSelectionFrom, to: currentSelectionTo, value: currentSelectionValue)
        case "Time":
            convertedValue = convertTime(from: currentSelectionFrom, to: currentSelectionTo, value: currentSelectionValue)
        case "Volume":
            convertedValue = convertVolume(from: currentSelectionFrom, to: currentSelectionTo, value: currentSelectionValue)
        default:
            convertedValue = currentSelectionValue
        }
    }

    func convertTemperature(from: String, to: String, value: Decimal) -> Decimal {
        let doubleValue = Double(truncating: value as NSNumber)
        switch (from, to) {
        case ("Celsius", "Fahrenheit"):
            return Decimal(doubleValue * 9/5 + 32)
        case ("Fahrenheit", "Celsius"):
            return Decimal((doubleValue - 32) * 5/9)
        case ("Celsius", "Kevin"):
            return Decimal(doubleValue + 273.15)
        case ("Kevin", "Celsius"):
            return Decimal(doubleValue - 273.15)
        default:
            return value
        }
    }

    func convertLength(from: String, to: String, value: Decimal) -> Decimal {
        let conversions: [String: Double] = [
            "Meter": 1,
            "Kilometer": 1000,
            "Feet": 0.3048,
            "Yards": 0.9144,
            "Miles": 1609.34
        ]
        let doubleValue = Double(truncating: value as NSNumber)
        if let fromFactor = conversions[from], let toFactor = conversions[to] {
            return Decimal(doubleValue * fromFactor / toFactor)
        }
        return value
    }

    func convertTime(from: String, to: String, value: Decimal) -> Decimal {
        let conversions: [String: Double] = [
            "Second": 1,
            "Minute": 60,
            "Hour": 3600,
            "Days": 86400
        ]
        let doubleValue = Double(truncating: value as NSNumber)
        if let fromFactor = conversions[from], let toFactor = conversions[to] {
            return Decimal(doubleValue * fromFactor / toFactor)
        }
        return value
    }

    func convertVolume(from: String, to: String, value: Decimal) -> Decimal {
        let conversions: [String: Double] = [
            "Milliliter": 1,
            "Liter": 1000,
            "Cups": 240,
            "Pints": 473.176,
            "Gallons": 3785.41
        ]
        let doubleValue = Double(truncating: value as NSNumber)
        if let fromFactor = conversions[from], let toFactor = conversions[to] {
            return Decimal(doubleValue * fromFactor / toFactor)
        }
        return value
    }
}

#Preview {
    ContentView()
}
