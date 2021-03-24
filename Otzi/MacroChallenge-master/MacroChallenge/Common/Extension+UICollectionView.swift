//
//  Extension+UICollectionView.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 25/09/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    
    /// Método auxiliar para deselecionar todos as células
    /// - Parameter animated: Bool - Indicando se ação vai ser animado ou não
    func deselectAllItems(animated: Bool) {
        guard let selectedItems = indexPathsForSelectedItems else { return }
        for indexPath in selectedItems { deselectItem(at: indexPath, animated: animated) }
    }
}
