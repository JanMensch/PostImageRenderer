import SwiftUI

/// Wraps your view and shows an "export" button. Saves the image to given `fileUrl` when button pressed.
public struct ExporterView<TargetView: View, BackgroundView: View>: View {

    let targetView: TargetView
    let backgroundView: BackgroundView
    let exportSize: CGSize
    let fileUrl: URL
    let scale: CGFloat
    let idealPreviewSize: CGFloat

    @State private var exportSuccessful = false

    /// Creates an `ExporterView`.
    /// - Parameter targetView: The content of the view that should be exported to an image
    /// - Parameter backgroundView: The background view of the image.
    /// - Parameter exportSize: The size in pixels that the exported image should have.
    /// - Parameter fileUrl: The path to which you want to export the image to. Should be `.png`.
    /// - Parameter scale: The scale to use to export the image. Will effectively multiply the `exportSize` and export will be of *way* higher quality. You can manually scale the image back down later to get a crisp result image. Defaults to `3`.
    /// - Parameter idealPreviewSize: Use this to scale the Playgrounds preview to match your screen size. Defaults to 600 px.
    public init(
        targetView: TargetView,
        backgroundView: BackgroundView,
        exportSize: CGSize,
        fileUrl: URL,
        scale: CGFloat = 3,
        idealPreviewSize: CGFloat = 600
    ) {
        self.targetView = targetView
        self.backgroundView = backgroundView
        self.exportSize = exportSize
        self.fileUrl = fileUrl
        self.scale = scale
        self.idealPreviewSize = idealPreviewSize
    }

    public var body: some View {
        VStack {
            Button("Render to image") {
                let renderer = ImageRenderer(content: sizedTargetView)
                renderer.scale = scale
                if let image = renderer.cgImage {
                    saveImage(image)
                }
            }
            sizedTargetView
                .border(Color.purple, width: 2)
                .scaleEffect(previewScale)
                .clipped()
                .overlay {
                    if exportSuccessful {
                        Text("👍 Export successful 👍")
                            .padding()
                            .glassEffect(.regular)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                                    exportSuccessful = false
                                }
                            }
                    }
                }
        }
        .animation(.snappy, value: exportSuccessful)
    }

    var sizedTargetView: some View {
        targetView
            .frame(width: exportSize.width, height: exportSize.height)
            .background(backgroundView)
            .clipped()
    }

    var previewScale: CGSize {
        if exportSize.width > idealPreviewSize || exportSize.height > idealPreviewSize {
            let largerDimension = max(exportSize.width, exportSize.height)
            let ratioToScaleToThreshold = idealPreviewSize / largerDimension
            return .init(width: ratioToScaleToThreshold, height: ratioToScaleToThreshold)
        } else {
            return .init(width: 1, height: 1)
        }
    }

    private func saveImage(_ image: CGImage) {
        Task { @concurrent in
            guard let destination = CGImageDestinationCreateWithURL(fileUrl as CFURL, kUTTypePNG, 1, nil) else {
                return
            }
            CGImageDestinationAddImage(destination, image, nil)
            if CGImageDestinationFinalize(destination) {
                Task { @MainActor in
                    exportSuccessful = true
                }
            }
        }
    }
}
