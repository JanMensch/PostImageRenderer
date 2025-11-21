import SwiftUI
import AppKit
import CoreGraphics
import PlaygroundSupport

/// Use this to "zoom" the preview to match your screen size. Playgrounds itself doesn't offer a zoom (yet).
let idealPreviewSize: CGFloat = 600

struct PostView: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Look iOS devs, I built a thing!")
                .font(.system(size: 50, weight: .thin))
                .padding(30)
                .glassEffect(.clear)
            Spacer()
            Text("Make images that look like iOS screenshots")
                .font(.system(size: 50, weight: .thin))
                .padding(30)
                .glassEffect(.regular)
                .padding(.bottom, 50)

            HStack(spacing: 20) {
                shareContent
            }
            .padding(30)
            .glassEffect(.clear)
            // Workaround for renderer not including actual content in image.
            // Add content again in overlay.
            .overlay {
                shareContent
            }

        }
        .padding(30)
        //.frame(maxWidth: .infinity)
        // Don't forget to explicitly set the color scheme.
        // The exporter will default to `.light`, even if your Mac is set to `.dark`!
        .colorScheme(.dark)
    }

    var shareContent: some View {
        HStack(spacing: 20) {
            Image(systemName: "square.and.arrow.up.circle")
                .resizable()
                .scaledToFit()
                .frame(height: 30)
            Text("Share this with fellow developers")
                .font(.system(size: 30))
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        // You can also use `Image(nsImage: )` and drag&drop an image file in :)
        MeshGradient(width: 3, height: 3, points: [
            .init(0, 0), .init(0.5, 0), .init(1, 0),
            .init(0, 0.5), .init(0.5, 0.5), .init(1, 0.5),
            .init(0, 1), .init(0.5, 1), .init(1, 1)
        ], colors: [
            .red, .purple, .indigo,
            .orange, .white, .blue,
            .yellow, .green, .mint
        ])

    }
}

let homeDirectory = FileManager.default.homeDirectoryForCurrentUser
let hostingVC = NSHostingController(
    rootView: ExporterView(
        targetView: PostView(),
        backgroundView: BackgroundView(),
        exportSize: .linkedInPost,
        fileUrl: homeDirectory.appending(path: "Documents/postImage.png"),
        idealPreviewSize: idealPreviewSize
    )

)
PlaygroundPage.current.setLiveView(hostingVC)
