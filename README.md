# PostImageRenderer

You are an iOS developer and want to make social media or blog post images that look like right out of an app?

Use this playground! All you need is your knowledge of SwiftUI. Build a view, provide the desired image dimensions, preview it via Xcode Playgrounds, press export. 🎉

![Example image](media/example-image.png)

## How to use

First off, when opening the playground, on the top of the "Results Canvas" in Xcode, there is a "Live View" tab. Head there to see the view preview instead of code execution details.

Build a SwiftUI view to your heart's content and use the export button. You can specify the desired image dimensions and file path at the bottom of the main code block.

## Known issues

Now there are things that do not work exactly as desired. Apple probably didn't intend Liquid Glass effects to be rendered to a PNG and it seems they have missed a few things on that front.

- Using `.glassEffect(.clear.tint(Color.black.opacity(0.1)))` will look fine in the preview, but not in the exported image. Use `.glasEffect(.clear).background(Color.black.opacity(0.1))` instead. There is an example usage in the playground code that includes a clip shape.
- Some times when combining views in an `HStack` and then applying a `.glassEffect` will look fine in preview, but the only thing rendered is the glass capsule, not the content. This however can easily be fixed by adding the content a second time as an overlay.

## Contribute

This is just a small helper for myself, but feel free to add functionality and make PRs!

## Share what you made!

I'm curious to see what use case you come up with! Send pics :)
