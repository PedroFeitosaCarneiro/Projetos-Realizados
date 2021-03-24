//
//  PreFeedSectionHeader.swift
//  MacroChallenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 19/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import Foundation
import UIKit

class SectionHeaderReusableView: UICollectionReusableView, AnimatableView {
    
    
    static var reuseIdentifier: String {
        return String(describing: SectionHeaderReusableView.self)
    }
    
    var presenter: PreFeedPresenterToView?
    var sections : [PreFeedSection] = []
    
    
    var isAnimated: Bool = false
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Coolvetica", size: 18)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal)
        return label
    }()
    
    lazy var searchButton: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Helvetica", size: 15)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal)
        label.text = "See more"
        return label
    }()
    
    @objc func tapFunction() {
        var text = self.titleLabel.text!
        text = text.replacingOccurrences(of: "#", with: "")
        guard let sections = presenter?.view?.sections else {return}
        
        for item in sections{
            if item.hashtagTittle ==  text{
                presenter?.goToFeed(with: [HashtagSuggest(text: text)],with: item)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        addSubview(searchButton)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        searchButton.isUserInteractionEnabled = true
        searchButton.addGestureRecognizer(tap)

            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.trailingAnchor),
//                searchButton.leadingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
//                searchButton.trailingAnchor.constraint(lessThanOrEqualTo: readableContentGuide.leadingAnchor)
                
                
                
                
            ])
        
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            searchButton.topAnchor.constraint(equalTo: topAnchor,constant: 10),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

