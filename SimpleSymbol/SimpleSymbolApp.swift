//
//  SimpleSymbolApp.swift
//  SimpleSymbol
//
//  Created by 能登 要 on 2022/12/19.
//

import SwiftUI

@main
struct SimpleSymbolApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: SimpleSymbolDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
