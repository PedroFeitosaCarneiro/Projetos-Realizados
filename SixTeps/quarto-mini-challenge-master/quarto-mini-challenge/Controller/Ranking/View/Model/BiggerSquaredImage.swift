//
//  BiggerSquaredImage.swift
//  quarto-mini-challenge
//
//  Created by Guilherme Martins Dalosto de Oliveira on 11/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import SwiftUI

struct BiggerSquaredImage: View {
    var image: Image
    
    var body: some View {
        image
        .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.white,lineWidth: 0))
        
    }
}

struct BiggerSquaredImage_Previews: PreviewProvider {
    static var previews: some View {
        SquaredImage(image: Image("GuiProfile"))
    }
}
