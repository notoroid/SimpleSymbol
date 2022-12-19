//
//  ContentView.swift
//  SimpleSymbol
//
//  Created by 能登 要 on 2022/12/19.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @Binding var document: SimpleSymbolDocument
    static let symbols: [Symbol] = [.circle, .diamond, .rectangle, .triangle, .doughnut]
    
    @State private var showingPlainTextExporter = false
    @State private var contentType = UTType.plainText
    
    @State var dropText: String = "ここにドラッグ可能"
    @State var dropImage: Image = .init(systemName: "questionmark.app.fill")
    var body: some View {
        GeometryReader { proxy in
            HStack {
                VStack {
                    List(Self.symbols) { symbol in
                        Button(symbol.title) {
                            document.symbol = symbol
                            
                            let image = document.makeImage(size: .init(width: 320, height: 320))!
                            document.temporaryData = image.pngData()!
                        }
                    }.frame(width: proxy.size.width * 0.4)
                    
                    Text("ドロップアイテム")
                        .draggable("テスト")

                    RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                        .fill(Color.gray)
                        .overlay(content: {
                            Text(dropText)
                                .foregroundColor(Color.white)
                        })
                        .frame(width: proxy.size.width * 0.4, height: 100)
                        .dropDestination(for: Symbol.self) { symbols, location in
                            dropText = symbols.first!.title
                            return true
                        }
                    
                    RoundedRectangle(cornerSize: .init(width: 10, height: 10))
                        .fill(Color.gray)
                        .overlay {
                            dropImage
                                .resizable()
                                .frame(width: proxy.size.height * 0.05,
                                       height: proxy.size.height * 0.05)
                        }
                        .frame(width: proxy.size.width * 0.4, height: proxy.size.height * 0.1 )
                        .dropDestination(for: Image.self) { images, location in
                            dropImage = images.first!
                            return true
                        }
                }
                
                VStack(alignment: .center) {
                    Menu {
                        Button {
                            contentType = .png
                            showingPlainTextExporter = true
                        } label: {
                            Text("export to image")
                        }
                        Button {
                            contentType = .plainText
                            showingPlainTextExporter = true
                        } label: {
                            Text("export to plane text")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                    
                    Spacer()
                    document.symbol.view(
                        width: proxy.size.width * 0.5,
                        height: proxy.size.width * 0.5
                    )
                    .draggable(
                        document.draggableItem()
                    ){
                        document.symbol.view(width: proxy.size.width * 0.2,
                                             height: proxy.size.width * 0.2)
                    }
                    
                    Spacer()
                }.frame(width: proxy.size.width * 0.6)
            }
            .fileExporter(isPresented: $showingPlainTextExporter, document: document, contentType: .png, defaultFilename: document.symbol.rawValue) { result in
                    switch result {
                    case .success(let url):
                        print("Saved to \(url)")
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
            }
            .task {
                let image = document.makeImage(size: .init(width: 320, height: 320))!
                document.temporaryData = image.pngData()!

            }

        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(SimpleSymbolDocument()))
    }
}
