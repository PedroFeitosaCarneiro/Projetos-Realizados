//
//  StrokeText.swift
//  IvyLeeStudy
//
//  Created by Guilherme Martins Dalosto de Oliveira on 21/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI

struct StrokeText: View {
    let text: String
    let width: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            ZStack{
                Text(text).offset(x:  width, y:  width)
                Text(text).offset(x: -width, y: -width)
                Text(text).offset(x: -width, y:  width)
                Text(text).offset(x:  width, y: -width)
            }
            .foregroundColor(color)
            Text(text)
        }
    }
}
