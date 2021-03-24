//
//  SquaredImage.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI

struct SquaredImage: View {
    var image: Image
    
    var body: some View {
        image
        .frame(width: 74, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white,lineWidth: 0))
        
    }
}

struct SquaredImage_Previews: PreviewProvider {
    static var previews: some View {
        SquaredImage(image: Image("GuiProfile"))
    }
}
