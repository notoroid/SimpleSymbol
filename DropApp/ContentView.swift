//
//  ContentView.swift
//  DropApp
//
//  Created by 能登 要 on 2022/12/19.
//

import SwiftUI

struct ContentView: View {
    @State var dragImage: Image = .init(systemName: "questionmark.app.fill")
    @State var data: Data?
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                Spacer()
                
                HStack {
                    Spacer()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: proxy.size.width * 0.4,
                               height: proxy.size.width * 0.4
                        )
                        .overlay {
                            dragImage
                                .resizable()
                                .frame(width: proxy.size.width * 0.2,
                                       height: proxy.size.width * 0.2
                                )
                        }
//                        .dropDestination(for: Image.self) { images, location in
//                            image = images.first!
//                            return true
//                        }
                        .dropDestination(for: Data.self) { dataCollection, location in
                            guard let image = UIImage( data: dataCollection.first!) else {
                                return false
                            }
                            dragImage = Image(uiImage: image)
                            return true
                        }
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
