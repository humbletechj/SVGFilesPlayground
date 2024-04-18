//MARK: Lab01

//import Foundation
//
//// Protocol for the Shape component
//protocol Shape {
//    var svgDescription: String { get }
//}
//
//// Concrete leaf shapes implementing the Shape protocol
//class Circle: Shape {
//    let cx: Int
//    let cy: Int
//    let r: Int
//    let fill: String
//    let strokeWidth: Int
//    let stroke: String
//
//    init(cx: Int, cy: Int, r: Int, fill: String, strokeWidth: Int, stroke: String) {
//        self.cx = cx
//        self.cy = cy
//        self.r = r
//        self.fill = fill
//        self.strokeWidth = strokeWidth
//        self.stroke = stroke
//    }
//
//    // Generates the SVG representation of the circle
//    var svgDescription: String {
//        return "<circle cx=\"\(cx)\" cy=\"\(cy)\" r=\"\(r)\" fill=\"\(fill)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\"/>"
//    }
//}
//
//class Rectangle: Shape {
//    let x: Int
//    let y: Int
//    let width: Int
//    let height: Int
//    let fill: String
//    let strokeWidth: Int
//    let stroke: String
//
//    init(x: Int, y: Int, width: Int, height: Int, fill: String, strokeWidth: Int, stroke: String) {
//        self.x = x
//        self.y = y
//        self.width = width
//        self.height = height
//        self.fill = fill
//        self.strokeWidth = strokeWidth
//        self.stroke = stroke
//    }
//
//    // Generates the SVG representation of the rectangle
//    var svgDescription: String {
//        return "<rect x=\"\(x)\" y=\"\(y)\" width=\"\(width)\" height=\"\(height)\" fill=\"\(fill)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\"/>"
//    }
//}
//
//class Polygon: Shape {
//    let points: String
//    let fill: String
//    let strokeWidth: Int
//    let stroke: String
//
//    init(points: String, fill: String, strokeWidth: Int, stroke: String) {
//        self.points = points
//        self.fill = fill
//        self.strokeWidth = strokeWidth
//        self.stroke = stroke
//    }
//
//    // Generates the SVG representation of the polygon
//    var svgDescription: String {
//        return "<polygon points=\"\(points)\" fill=\"\(fill)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\"/>"
//    }
//}
//
//class ShapeGroup: Shape {
//    private(set) var shapes: [Shape] = []
//
//    // Adds a shape to the group (Composite pattern method)
//    func addShape(_ shape: Shape) {
//        shapes.append(shape)
//    }
//
//    // Generates the SVG representation of the shape group
//    var svgDescription: String {
//        var svgStrings = [String]()
//        for shape in shapes {
//            svgStrings.append(shape.svgDescription)
//        }
//        return svgStrings.joined(separator: "\n")
//    }
//}
//
//// Function to create and open an SVG file
//func createSVGFile(shapes: [Shape], width: Int, height: Int, fileName: String) {
//    let svgHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(width)\" height=\"\(height)\">\n"
//    let svgFooter = "</svg>"
//
//    let svgContent = shapes.map { $0.svgDescription }.joined(separator: "\n")
//    let svgString = svgHeader + "\n" + svgContent + "\n" + svgFooter
//
//    // Print the SVG string for debugging
//    print("SVG String:\n\(svgString)")
//
//    let fileURL = URL(fileURLWithPath: fileName)
//
//    do {
//        // Write the SVG string to the file using FileManager
//        try svgString.write(to: fileURL, atomically: true, encoding: .utf8)
//        print("SVG file created successfully.")
//
//        // Open the created file
//        let openCommand = "open \(fileURL.path)"
//        let process = Process()
//        process.executableURL = URL(fileURLWithPath: "/bin/bash")
//        process.arguments = ["-c", openCommand]
//        process.launch()
//        process.waitUntilExit()
//
//    } catch {
//        print("Error creating SVG file: \(error)")
//    }
//}
//
//
//
//
//// Example usage
//let group = ShapeGroup()
//
//let circle1 = Circle(cx: 205, cy: 205, r: 200, fill: "green", strokeWidth: 5, stroke: "rgb(150,110,200)")
//let rectangle1 = Rectangle(x: 55, y: 70, width: 300, height: 200, fill: "orange", strokeWidth: 2, stroke: "rgb(0,0,0)")
//let circle2 = Circle(cx: 110, cy: 125, r: 50, fill: "green", strokeWidth: 5, stroke: "rgb(150,110,200)")
//let rectangle2 = Rectangle(x: 165, y: 75, width: 100, height: 100, fill: "red", strokeWidth: 5, stroke: "rgb(0,0,0)")
//let polygon1 = Polygon(points: "270,150 320,75 340,160", fill: "green", strokeWidth: 5, stroke: "rgb(0,0,0)")
//
//// Add leaf shapes to the composite object (Composite pattern method)
//group.addShape(circle1)
//group.addShape(rectangle1)
//group.addShape(circle2)
//group.addShape(rectangle2)
//group.addShape(polygon1)
//
//// Create and open the SVG file with the composite object and leaf shapes
//createSVGFile(shapes: [group], width: 500, height: 500, fileName: "supersvg.svg")
//
//


// MARK: Lab02

import Foundation
import AppKit

// Протокол Observer
protocol Observer: AnyObject {
    func update()
}

// Модель
class Model {
    var data: [String: Double] = ["a": 50, "b": 30, "c": 20]
    var observers: [AnyObject] = [] // Изменяем тип на [AnyObject]

    func addObserver(_ observer: Observer) {
        observers.append(observer)
    }

    func removeObserver(_ observer: Observer) {
        observers = observers.filter { $0 !== observer }
    }

    func notifyObservers() {
        for observer in observers { // Приводим тип к протоколу Observer
            (observer as? Observer)?.update()
        }
    }

    func updateData(_ newData: [String: Double]) {
        data = newData
        notifyObservers()
    }
}


// Базовый класс View
class View: NSObject, Observer {
    var model: Model
    var x: CGFloat = 0
    var y: CGFloat = 0
    var height: CGFloat = 0
    var width: CGFloat = 0

    init(model: Model) {
        self.model = model
        super.init()
        model.addObserver(self)
    }

    func update() {
        // Переопределить в подклассах
    }

    func createSVG() -> String {
        // Переопределить в подклассах
        return ""
    }

    deinit {
        // no memory leak HAHA
        model.removeObserver(self)
    }
}

// Класс CompositeView
class CompositeView: View {
    var views: [View] = []

    func addView(_ view: View) {
        views.append(view)
    }

    override func update() {
        let svg = createSVG()
        writeSVGToFile(svg: svg, fileName: "composite")
    }

    override func createSVG() -> String {
        let svgHeader = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"800\" height=\"600\">\n"
        let svgFooter = "</svg>\n"

        var svgElements = ""

        for view in views {
            svgElements += view.createSVG()
        }

        let svg = svgHeader + svgElements + svgFooter

        return svg
    }
}

// Класс TableView
class TableView: View {
    override func update() {
        let svg = createSVG()
//        writeSVGToFile(svg: svg, fileName: "table")
    }

    override func createSVG() -> String {
        var svg = "<g transform=\"translate(\(x), \(y))\">\n"
        svg += "<text x=\"20\" y=\"30\">Name</text>\n"
        svg += "<text x=\"120\" y=\"30\">Value</text>\n"

        var y = 50

        for (name, value) in model.data {
            svg += "<text x=\"20\" y=\"\(y)\">\(name)</text>\n"
            svg += "<text x=\"120\" y=\"\(y)\">\(value)</text>\n"
            y += 30
        }

        svg += "</g>\n"

        return svg
    }
}

// Класс BarChartView
class BarChartView: View {
    override func update() {
        let svg = createSVG()
//        writeSVGToFile(svg: svg, fileName: "barchart")
    }

    override func createSVG() -> String {
        var svg = "<g transform=\"translate(\(x), \(y))\">\n"

        var maxValue: CGFloat = 0
        for value in model.data.values {
            maxValue = max(maxValue, value)
        }

        var y: CGFloat = 0
        for (_, value) in model.data {
            let height = (value / maxValue) * 100
            let bar = "<rect x=\"0\" y=\"\(y)\" width=\"100\" height=\"\(height)\" fill=\"blue\"/>\n"
            svg += bar
            y += height + 2
        }

        svg += "</g>\n"

        return svg
    }
}

// Класс PieChartView
class PieChartView: View {
    override func update() {
        let svg = createSVG()
//        writeSVGToFile(svg: svg, fileName: "piechart")
    }

    override func createSVG() -> String {
        var svg = "<g transform=\"translate(\(x + 100), \(y + 100))\">\n"

        var totalValue: CGFloat = 0
        for value in model.data.values {
            totalValue += value
        }

        var startAngle: CGFloat = 0
        for (_, value) in model.data {
            let angle = (value / totalValue) * 360
            let path = "<path d=\"M 0 0 L \(100 * cos(startAngle.degreesToRadians)) \(100 * sin(startAngle.degreesToRadians)) A 100 100 0 \(angle > 180 ? 1 : 0) 1 \(100 * cos((startAngle + angle).degreesToRadians)) \(100 * sin((startAngle + angle).degreesToRadians)) Z\" fill=\"\(getRandomColor())\"/>\n"
            svg += path
            startAngle += angle
        }

        svg += "</g>\n"

        return svg
    }

    func getRandomColor() -> String {
        let red = CGFloat(Double(arc4random_uniform(256)) / 255.0)
        let green = CGFloat(Double(arc4random_uniform(256)) / 255.0)
        let blue = CGFloat(Double(arc4random_uniform(256)) / 255.0)

        return String(format: "#%02lX%02lX%02lX", lroundf(Float(red) * 255), lroundf(Float(green) * 255), lroundf(Float(blue) * 255))
    }
}

// Функция для записи SVG-разметки в файл и его открытия
func writeSVGToFile(svg: String, fileName: String) {
    let fileURL = URL(fileURLWithPath: "\(fileName).svg")

    // Print SVG content
    print("SVG content for \(fileName):")
    print(svg)

    do {
        try svg.write(to: fileURL, atomically: true, encoding: .utf8)
        print("SVG saved to file: \(fileName).svg")
        openFile(fileURL: fileURL) // Open the file after saving
    } catch {
        print("Error saving SVG to file: \(error)")
    }
}

// Функция для открытия файла
func openFile(fileURL: URL) {
    NSWorkspace.shared.open(fileURL) // Открываем файл с помощью NSWorkspace
}

// Создаем модель и виды
let model = Model()
let tableView = TableView(model: model)
let barChartView = BarChartView(model: model)
let pieChartView = PieChartView(model: model)

// Создаем CompositeView и добавляем в него виды
let compositeView = CompositeView(model: model)
compositeView.addView(tableView)
compositeView.addView(barChartView)
compositeView.addView(pieChartView)

// Устанавливаем координаты для каждого вида
tableView.x = 0
tableView.y = 0

barChartView.x = 0
barChartView.y = 200

pieChartView.x = 400
pieChartView.y = 0

// Изменяем данные модели
model.updateData(["a": 50, "b": 30, "c": 20])


extension CGFloat {
    var degreesToRadians: CGFloat {
        return self * .pi / 180
    }
}


// MARK: Lab03

//class BorderedView: View {
//    private let view: View
//    private let strokeWidth: CGFloat
//    private let strokeColor: String
//
//    init(view: View, strokeWidth: CGFloat = 2, strokeColor: String = "#0000FF") {
//        self.view = view
//        self.strokeWidth = strokeWidth
//        self.strokeColor = strokeColor
//    }
//
//    override func createSVG() -> String {
//        let viewSVG = view.createSVG()
//        let viewWidth = view.width
//        let viewHeight = view.height
//
//        let borderSVG = "<rect x=\"\(view.x - strokeWidth / 2)\" y=\"\(view.y - strokeWidth / 2)\" width=\"\(viewWidth + strokeWidth)\" height=\"\(viewHeight + strokeWidth)\" stroke=\"\(strokeColor)\" stroke-width=\"\(strokeWidth)\" fill=\"none\"/>\n"
//
//        return borderSVG + viewSVG
//    }
//
//    var width: CGFloat {
//        return view.width + strokeWidth
//    }
//
//    var height: CGFloat {
//        return view.height + strokeWidth
//    }
//}

