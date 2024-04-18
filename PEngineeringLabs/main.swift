import Foundation

// Protocol for the Shape component
protocol Shape {
    var svgDescription: String { get }
}

// Concrete leaf shapes implementing the Shape protocol
class Circle: Shape {
    let cx: Int
    let cy: Int
    let r: Int
    let fill: String
    let strokeWidth: Int
    let stroke: String

    init(cx: Int, cy: Int, r: Int, fill: String, strokeWidth: Int, stroke: String) {
        self.cx = cx
        self.cy = cy
        self.r = r
        self.fill = fill
        self.strokeWidth = strokeWidth
        self.stroke = stroke
    }

    // Generates the SVG representation of the circle
    var svgDescription: String {
        return "<circle cx=\"\(cx)\" cy=\"\(cy)\" r=\"\(r)\" fill=\"\(fill)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\"/>"
    }
}

class Rectangle: Shape {
    let x: Int
    let y: Int
    let width: Int
    let height: Int
    let fill: String
    let strokeWidth: Int
    let stroke: String

    init(x: Int, y: Int, width: Int, height: Int, fill: String, strokeWidth: Int, stroke: String) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.fill = fill
        self.strokeWidth = strokeWidth
        self.stroke = stroke
    }

    // Generates the SVG representation of the rectangle
    var svgDescription: String {
        return "<rect x=\"\(x)\" y=\"\(y)\" width=\"\(width)\" height=\"\(height)\" fill=\"\(fill)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\"/>"
    }
}

class Polygon: Shape {
    let points: String
    let fill: String
    let strokeWidth: Int
    let stroke: String

    init(points: String, fill: String, strokeWidth: Int, stroke: String) {
        self.points = points
        self.fill = fill
        self.strokeWidth = strokeWidth
        self.stroke = stroke
    }

    // Generates the SVG representation of the polygon
    var svgDescription: String {
        return "<polygon points=\"\(points)\" fill=\"\(fill)\" stroke-width=\"\(strokeWidth)\" stroke=\"\(stroke)\"/>"
    }
}

class ShapeGroup: Shape {
    private(set) var shapes: [Shape] = []

    // Adds a shape to the group (Composite pattern method)
    func addShape(_ shape: Shape) {
        shapes.append(shape)
    }

    // Generates the SVG representation of the shape group
    var svgDescription: String {
        var svgStrings = [String]()
        for shape in shapes {
            svgStrings.append(shape.svgDescription)
        }
        return svgStrings.joined(separator: "\n")
    }
}

// Function to create and open an SVG file
func createSVGFile(shapes: [Shape], width: Int, height: Int, fileName: String) {
    let svgHeader = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>\n<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\(width)\" height=\"\(height)\">\n"
    let svgFooter = "</svg>"

    let svgContent = shapes.map { $0.svgDescription }.joined(separator: "\n")
    let svgString = svgHeader + "\n" + svgContent + "\n" + svgFooter

    // Print the SVG string for debugging
    print("SVG String:\n\(svgString)")

    let fileURL = URL(fileURLWithPath: fileName)

    do {
        // Write the SVG string to the file using FileManager
        try svgString.write(to: fileURL, atomically: true, encoding: .utf8)
        print("SVG file created successfully.")

        // Open the created file
        let openCommand = "open \(fileURL.path)"
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/bash")
        process.arguments = ["-c", openCommand]
        process.launch()
        process.waitUntilExit()

    } catch {
        print("Error creating SVG file: \(error)")
    }
}




// Example usage
let group = ShapeGroup()

let circle1 = Circle(cx: 205, cy: 205, r: 200, fill: "green", strokeWidth: 5, stroke: "rgb(150,110,200)")
let rectangle1 = Rectangle(x: 55, y: 70, width: 300, height: 200, fill: "orange", strokeWidth: 2, stroke: "rgb(0,0,0)")
let circle2 = Circle(cx: 110, cy: 125, r: 50, fill: "green", strokeWidth: 5, stroke: "rgb(150,110,200)")
let rectangle2 = Rectangle(x: 165, y: 75, width: 100, height: 100, fill: "red", strokeWidth: 5, stroke: "rgb(0,0,0)")
let polygon1 = Polygon(points: "270,150 320,75 340,160", fill: "green", strokeWidth: 5, stroke: "rgb(0,0,0)")

// Add leaf shapes to the composite object (Composite pattern method)
group.addShape(circle1)
group.addShape(rectangle1)
group.addShape(circle2)
group.addShape(rectangle2)
group.addShape(polygon1)

// Create and open the SVG file with the composite object and leaf shapes
createSVGFile(shapes: [group], width: 500, height: 500, fileName: "supersvg.svg")


