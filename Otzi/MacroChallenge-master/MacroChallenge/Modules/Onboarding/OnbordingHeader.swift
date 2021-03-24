//
//  OnbordingHeader.swift
//  MacroChallenge
//
//  Created by Rangel Cardoso Dias on 25/10/20.
//  Copyright © 2020 macro.com. All rights reserved.
//

import UIKit


class OnbordingHeader: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: OnbordingHeader.self)
    }
    
    //MARK: -> Views
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Coolvetica", size: 24)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 2
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .vertical)
        return label
    }()
    
    lazy var secundaryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.init(name: "Helvetica", size: 15)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(
            .defaultHigh,
            for: .horizontal)
        return label
    }()

    lazy var backLayer: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
        return view
    }()


    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: -> ViewCoding
extension OnbordingHeader: ViewCoding{
    func buildViewHierarchy() {
//        contentView.addSubview(backLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(secundaryLabel)
    }
    
    func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
        secundaryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            secundaryLabel.topAnchor.constraint(equalTo:  self.titleLabel.bottomAnchor, constant: 10),
            secundaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            secundaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
        
    
    }
    
    func setupAdditionalConfiguration() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }
    
    /// Método para configurar a cell header
    /// - Parameters:
    ///   - title: texto da titleLabel
    ///   - subTitle: texto da subTitleLabel
    func config(title:String, subTitle: String?){
        DispatchQueue.main.async {
            self.titleLabel.text = title
            self.secundaryLabel.text = subTitle
        }
    }
    
}
