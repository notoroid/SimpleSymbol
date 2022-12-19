//
//  SimpleSymbolDocument.swift
//  SimpleSymbol
//
//  Created by 能登 要 on 2022/12/19.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct SymbolDragItem: Transferable {
    let data: Data
    let image: Image
    let symbol: Symbol

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { combination in
            combination.data
        }
        ProxyRepresentation(exporting: \.image)
        ProxyRepresentation(exporting: \.symbol)
   }
}

struct SimpleSymbolDocument: FileDocument {
    var symbol: Symbol
    var temporaryData: Data? // for image export and drragable
    
    init(text: Symbol = .circle) {
        self.symbol = text
    }

    static var readableContentTypes: [UTType] { [.exampleText] }
    static var writableContentTypes: [UTType] { [.plainText, .png] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        symbol = Symbol.init(rawValue: string) ?? .circle
    }

    
    @MainActor func draggableItem() -> SymbolDragItem {
        return SymbolDragItem(
            data: temporaryData!,
            image: symbolImage(),
            symbol: symbol)
    }
    
    @MainActor func symbolImage() -> Image {
        Image( uiImage: UIImage(data: temporaryData!)! )
    }
    
    // from https://note.com/reality_eng/n/n662347337553
    @MainActor func makeImage(size: CGSize) -> UIImage? {
        let contentView = symbol.view(width: size.width, height: size.height)
        let imageRenderer = ImageRenderer(content: contentView)
        imageRenderer.scale = UIScreen.main.scale
        imageRenderer.proposedSize = ProposedViewSize(size)
        let uiGraphicsImageRenderer = UIGraphicsImageRenderer(size: size)
        let image = uiGraphicsImageRenderer.image { context in
            imageRenderer.render { _, uiGraphicsImageRenderer in
                let flipVerticalMatrix = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
                context.cgContext.concatenate(flipVerticalMatrix)
                uiGraphicsImageRenderer(context.cgContext)
            }
        }
        return image
    }
    
    @MainActor func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        if configuration.contentType == .png {
            return .init(regularFileWithContents: temporaryData!)
        }
        let data = symbol.rawValue.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
}
