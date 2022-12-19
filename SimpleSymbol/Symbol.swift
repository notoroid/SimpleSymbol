//
//  Symbol.swift
//  SimpleSymbol
//
//  Created by 能登 要 on 2022/12/19.
//

import Foundation
import SwiftUI

enum Symbol: String ,Identifiable {
    case circle = "Circle"
    case diamond = "diamond"
    case rectangle = "rectAngle"
    case triangle = "triangle"
    case doughnut = "doughnut"
    
    var id: String {
        self.rawValue
    }
}

extension Symbol {
    var title: String {
        switch self {
        case .circle: return "円"
        case .diamond: return "ダイア"
        case .rectangle: return "四角"
        case .triangle: return "三角"
        case .doughnut: return "ドーナツ"
        }
    }
}

extension Symbol: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(contentType: .utf8PlainText) { symbol in
            symbol.rawValue.data(using: .utf8)!
        } importing: { data in
            .init(rawValue:
                String(data: data, encoding: .utf8)!
            )!
        }
   }
}

extension Symbol {
    func view(width: CGFloat, height: CGFloat) -> some View {
        switch self {
        case .circle:
            return Path { path in
                path.addEllipse(in:
                        .init(x: width * 0.1,
                              y: height * 0.1,
                              width: width * 0.8,
                              height: height * 0.8)
                )
            }
            .fill(.blue)
            .background(Color.white)
            .frame(width: width, height: height)
        case .diamond:
            return Path { path in
                path.addLines([
                    .init(
                        x: width * 0.5,
                        y: height * 0.0
                    ),
                    .init(
                        x: width * 1.0,
                        y: height * 0.5
                    ),
                    .init(
                        x: width * 0.5,
                        y: height * 1.0
                    ),
                    .init(
                        x: width * 0.0,
                        y: height * 0.5
                    ),
                ])
                path.closeSubpath()
            }.fill(.green)
            .background(Color.white)
            .frame(width: width, height: height)
        case .rectangle:
            return Path { path in
                path.addLines([
                    .init(
                        x: width * 0.1,
                        y: height * 0.1
                    ),
                    .init(
                        x: width * 0.9,
                        y: height * 0.1
                    ),
                    .init(
                        x: width * 0.9,
                        y: height * 0.9
                    ),
                    .init(
                        x: width * 0.1,
                        y: height * 0.9
                    ),
                ])
                path.closeSubpath()
            }.fill(.red)
            .background(Color.white)
            .frame(width: width, height: height)
        case .triangle:
            return Path { path in
                path.addLines([
                    .init(
                        x: width * 0.5,
                        y: height * 0.1
                    ),
                    .init(
                        x: width * 1.0,
                        y: height * 0.9
                    ),
                    .init(
                        x: width * 0.0,
                        y: height * 0.9
                    ),
                ])
                path.closeSubpath()
            }.fill(.orange)
            .background(Color.white)
            .frame(width: width, height: height)
        case .doughnut:
            return Path { path in
                let curves1: [(to: CGPoint, control1: CGPoint, control2: CGPoint)] = [
                    (to: .init(x: width * 0.37, y: height * 0.23), control1: .init(x: width * 0.45, y: height * 0.2), control2: .init(x: width * 0.41, y: height * 0.21)),
                    (to: .init(x: width * 0.2, y: height * 0.5), control1: .init(x: width * 0.27, y: height * 0.28), control2: .init(x: width * 0.2, y: height * 0.38)),
                    (to: .init(x: width * 0.5, y: height * 0.8), control1: .init(x: width * 0.2, y: height * 0.67), control2: .init(x: width * 0.33, y: height * 0.8)),
                    (to: .init(x: width * 0.8, y: height * 0.5), control1: .init(x: width * 0.67, y: height * 0.8), control2: .init(x: width * 0.8, y: height * 0.67)),
                    (to: .init(x: width * 0.5, y: height * 0.2), control1: .init(x: width * 0.8, y: height * 0.33), control2: .init(x: width * 0.67, y: height * 0.2))
                ]
                
                path.move(to: CGPoint(x: width * 0.5, y: height * 0.2))
                for curve in curves1 {
                    path.addCurve(to: curve.to, control1: curve.control1, control2: curve.control2)
                }
                path.closeSubpath()
                
                let curves2: [(to: CGPoint, control1: CGPoint, control2: CGPoint)] = [
                    (to: CGPoint(x: width * 0.5, y: height * 1), control1: CGPoint(x: width * 1, y: height * 0.78), control2: CGPoint(x: width * 0.78, y: height * 1)),
                    (to: CGPoint(x: width * 0, y: height * 0.5), control1: CGPoint(x: width * 0.22, y: height * 1), control2: CGPoint(x: width * 0, y: height * 0.78)),
                    (to: CGPoint(x: width * 0.2, y: height * 0.1), control1: CGPoint(x: width * 0, y: height * 0.34), control2: CGPoint(x: width * 0.08, y: height * 0.19)),
                    (to: CGPoint(x: width * 0.5, y: height * 0), control1: CGPoint(x: width * 0.28, y: height * 0.04), control2: CGPoint(x: width * 0.39, y: height * 0)),
                    (to: CGPoint(x: width * 1, y: height * 0.5), control1: CGPoint(x: width * 0.78, y: height * 0), control2: CGPoint(x: width * 1, y: height * 0.22))
                ]
                
                path.move(to: CGPoint(x: width * 1, y: height * 0.5))
                for curve in curves2 {
                    path.addCurve(to: curve.to, control1: curve.control1, control2: curve.control2)
                }
                path.closeSubpath()
            }
            .fill(.brown)
            .background(Color.white)
            .frame(width: width, height: height)
        }
    }
}
