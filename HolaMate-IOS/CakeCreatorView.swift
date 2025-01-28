import SwiftUI
import RealityKit

struct CakeCreatorView: View {
    @State private var cakeLayers: [CakeLayer] = []
    @State private var selectedShape: CakeShape = .round
    @State private var selectedFlavor: CakeFlavor = .vanilla
    @State private var selectedFrosting: Frosting = .buttercream
    @State private var selectedDecoration: Decoration = .sprinkles

    var body: some View {
        VStack {
            // 3D Cake Canvas
            Cake3DView()
                .frame(height: 300)
                .padding()
                .background(Color.darkGray.opacity(0.1)) // Dark background for cake canvas
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)

            // Customization Options
            ScrollView {
                VStack(spacing: 20) {
                    CustomizationSection(title: "Shape", options: CakeShape.allCases, selectedOption: $selectedShape)
                    CustomizationSection(title: "Flavor", options: CakeFlavor.allCases, selectedOption: $selectedFlavor)
                    CustomizationSection(title: "Frosting", options: Frosting.allCases, selectedOption: $selectedFrosting)
                    CustomizationSection(title: "Decoration", options: Decoration.allCases, selectedOption: $selectedDecoration)
                }
                .padding()
            }

            // Add Layer Button
            Button(action: addCakeLayer) {
                Text("Add Layer")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple) // Accent button color
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
            }
            .padding()
        }
        .background(Color.darkBackground) // Dark overall background
        .navigationTitle("Cake Creator")
    }

    private func addCakeLayer() {
        let newLayer = CakeLayer(shape: selectedShape, flavor: selectedFlavor, frosting: selectedFrosting, decoration: selectedDecoration)
        cakeLayers.append(newLayer)
    }
}

// 3D Cake View
struct Cake3DView: UIViewRepresentable {
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        // Load the 3D cake model
        if let cakeModel = try? Entity.load(named: "Cakes.usdz") {
            // Create an anchor entity and add the cake model to it
            let anchorEntity = AnchorEntity(world: [0, 0, -1]) // Position the cake in front of the camera
            anchorEntity.addChild(cakeModel)

            // Add the anchor entity to the scene
            arView.scene.addAnchor(anchorEntity)
        }

        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        // Update the view if needed
    }
}

// Customization Section (unchanged)
struct CustomizationSection<T: Hashable & CaseIterable & RawRepresentable>: View where T.RawValue == String {
    let title: String
    let options: T.AllCases
    @Binding var selectedOption: T

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.white) // Light text for dark background

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(options.map { $0 }, id: \.self) { option in
                        Button(action: {
                            selectedOption = option
                        }) {
                            Text(option.rawValue.capitalized)
                                .padding(10)
                                .background(selectedOption == option ? Color.purple : Color.purple.opacity(0.2))
                                .foregroundColor(selectedOption == option ? .white : .black)
                                .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
}

// Data Models (unchanged)
struct CakeLayer {
    let shape: CakeShape
    let flavor: CakeFlavor
    let frosting: Frosting
    let decoration: Decoration
}

enum CakeShape: String, CaseIterable {
    case round, square, heart

    var image: Image {
        switch self {
        case .round: return Image("round_cake") // Custom image for round cake
        case .square: return Image("square_cake") // Custom image for square cake
        case .heart: return Image("heart_cake") // Custom image for heart-shaped cake
        }
    }
}

enum CakeFlavor: String, CaseIterable {
    case vanilla, chocolate, strawberry

    var color: Color {
        switch self {
        case .vanilla: return Color.pastelYellow
        case .chocolate: return Color.pastelBrown
        case .strawberry: return Color.pastelRed
        }
    }
}

enum Frosting: String, CaseIterable {
    case buttercream, chocolate, creamCheese

    var color: Color {
        switch self {
        case .buttercream: return Color.pastelWhite
        case .chocolate: return Color.pastelBrown
        case .creamCheese: return Color.pastelOrange
        }
    }
}

enum Decoration: String, CaseIterable {
    case sprinkles, fruits, flowers

    var image: Image {
        switch self {
        case .sprinkles: return Image(systemName: "sparkles")
        case .fruits: return Image(systemName: "leaf.fill")
        case .flowers: return Image(systemName: "flower")
        }
    }
}

// Color Extensions (unchanged)
extension Color {
    static let pastelPink = Color(red: 1.0, green: 0.8, blue: 0.9)
    static let pastelYellow = Color(red: 1.0, green: 1.0, blue: 0.8)
    static let pastelBrown = Color(red: 0.8, green: 0.6, blue: 0.4)
    static let pastelRed = Color(red: 1.0, green: 0.6, blue: 0.6)
    static let pastelWhite = Color(red: 1.0, green: 1.0, blue: 1.0)
    static let pastelOrange = Color(red: 1.0, green: 0.8, blue: 0.6)
    static let darkGray = Color(red: 0.2, green: 0.2, blue: 0.2) // Dark gray for cake canvas
    static let darkBackground = Color(red: 0.1, green: 0.1, blue: 0.1) // Dark overall background
}

// Preview (unchanged)
struct CakeCreatorView_Previews: PreviewProvider {
    static var previews: some View {
        CakeCreatorView()
            .preferredColorScheme(.dark) // Use the dark color scheme for the preview
    }
}
