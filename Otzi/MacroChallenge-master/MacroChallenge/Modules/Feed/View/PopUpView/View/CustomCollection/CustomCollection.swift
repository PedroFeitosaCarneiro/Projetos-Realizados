//
//  CollectionCustom.swift
//  MacroChallenge
//
//  Created by Lelio Jorge Junior on 14/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit



@objc public enum Alignment: Int {
    case left
    case center
    case right
    case leading
    case trailing
}

/// Desenvolvida para subistituir a collection view defult, CustomView limitasse a apresentar apenas tags com text.
class CustomCollection: UIView {
    
    private var tags: [TagView] = [TagView]()
    
    private var numberOfRowsCollection: Int = 0
    
    var alignment: Alignment = .left {
        didSet {
            rearrangeViews()
        }
    }
    
    var textColor: UIColor = .white {
        didSet{
            rearrangeViews()
        }
    }
    
    var corneRadius: CGFloat = 5 {
        didSet {
            rearrangeViews()
        }
    }
    
    var backgroundColorTag: UIColor = .gray{
        didSet{
            rearrangeViews()
        }
    }
    
    var font: UIFont = .systemFont(ofSize: 12) {
        didSet {
            rearrangeViews()
        }
    }
    
    private var width: CGFloat!
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        width = self.bounds.width
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Implementa chamda de creação de tag passanum tiltte, addTagView passando o retorno da tagView gerada e rearranja o array de tags.
    /// - Parameter title: String
    /// - Returns: TagView\
    @discardableResult
    public func addTag(_ title: String) -> TagView{
        defer { rearrangeViews() }
        return addTagView(createTagView(title))
    }
    
    /// Adiciona tagView no array de tags.
    /// - Parameter tagView: TagView
    /// - Returns: descriptionTagView
    @discardableResult
    private func addTagView(_ tagView: TagView) -> TagView {
        tags.append(tagView)
        return tagView
    }
    
    
    /// Cria uma tagView.
    /// - Parameter tittle: String
    /// - Returns: TagView
    private func createTagView(_ tittle: String) -> TagView{
        let tagView = TagView()
        
        tagView.setTitle(tittle, for: .normal)
        tagView.titleLabel?.textColor = textColor
        tagView.textFont = font
        tagView.backgroundColor = backgroundColorTag
        tagView.layer.cornerRadius = corneRadius
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)

        return tagView
    }
    
    
    /// Configura o tamanho e possição de cada tagVIew no array de tags.
    private func rearrangeViews() {
        let views = tags as [UIView] + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)

        var isRtl: Bool = false
        
        if #available(iOS 10.0, tvOS 10.0, *) {
            isRtl = effectiveUserInterfaceLayoutDirection == .rightToLeft
        }
        else if let shared = UIApplication.value(forKey: "sharedApplication") as? UIApplication {
            isRtl = shared.userInterfaceLayoutDirection == .leftToRight
        }
        
        var alignment = self.alignment
        
        if alignment == .leading {
            alignment = isRtl ? .right : .left
        }
        else if alignment == .trailing {
            alignment = isRtl ? .left : .right
        }
        
        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0
        let frameWidth = frame.width
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width

        
        let directionTransform = isRtl
            ? CGAffineTransform(scaleX: -1.0, y: 1.0)
            : CGAffineTransform.identity
        
        for tagView in tags {
            tagView.frame.size = tagView.intrinsicContentSize
            if tagView.titleLabel?.text != "+" {
                tagView.frame.size.width += screenWidth * 0.0234375

            }
            else {
                tagView.frame.size.width -= screenWidth * 0.0234375 / 2

            }
            tagView.frame.size.height = screenHeight * 0.0234375
            tagViewHeight = tagView.frame.height
    
            if currentRowTagCount == 0 || currentRowWidth + tagView.frame.width > frameWidth {
                currentRow += 1
                numberOfRowsCollection = currentRow
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.transform = directionTransform
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + 6)
                
                rowViews.append(currentRowView)
                addSubview(currentRowView)
                
                tagView.frame.size.width = min(tagView.frame.size.width , frameWidth)
            }
            
            tagView.frame.origin = CGPoint(
            x: currentRowWidth,
            y: 0)
            currentRowView.addSubview(tagView)
            
            currentRowTagCount += 1
            currentRowWidth += tagView.frame.width + screenWidth * 0.0234375

            
            switch alignment {
            case .leading: fallthrough
            case .left:
                currentRowView.frame.origin.x = 0
            case .center:
                currentRowView.frame.origin.x = (frameWidth - (currentRowWidth - screenWidth * 0.0234375)) / 2
            case .trailing: fallthrough
            case .right:
                currentRowView.frame.origin.x = frameWidth - (currentRowWidth - screenWidth * 0.0234375)
            }
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow
        
        invalidateIntrinsicContentSize()
    }
    
    /// Action caso seja precionado um botão.
    /// - Parameter sender: TagView
    @objc private func tagPressed(_ sender: TagView!) {
           sender.onTap?()
    }
    
    
    /// Remove todos os itens do array tags.
    public func removeTags() {
        tags.removeAll()
    }
    
    
    /// Informa o numero de itens no array.
    /// - Returns: Int
    private func numberOfItems() -> Int {
        return tags.count
    }
    
    /// Informa o numero de rows na collection.
    /// - Returns: Int
    func numberOfRows() -> Int {
        return numberOfRowsCollection
    }
}

