//
//  TaskCell.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    //MARK: - Attributes
    private var customView: UIView = UIView()
    private var background: UIImageView = UIImageView()
    private var nameLabel: UILabel = UILabel()
    private var completeLineTask: UIView = UIView()
    private var leadingSwipeView: UIView = UIView()
    private var leadingLabel: UILabel = UILabel()
    private var trailingSwipeView: UIView = UIView()
    private var trailingLabel: UILabel = UILabel()
    
    public var task: Task!
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    /// This function is to set the layout of the cell based on the task status
    /// - Parameter task: The task that cells represent
    /// - Author: Antônio Carlos
    public func setLayout(task: Task, deviceName: String, tableView: UITableView) {
        self.task = task
        
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.setLeadingSwipeView()
        self.setTraillingSwipeView()
        self.setCustomView()
        self.setBackgroundImageView(idCategory: task.id_category, deviceName: deviceName, tableViewSize: tableView.frame.size)
        self.setNameLabel(idPriority: task.id_priority, taskName: task.name)
        self.setCompletedLineTask()
        self.setAlphaOfCell(alpha: 1.0)
        
        if task.completed {
            self.completeLineTask.isHidden = false
        } else {
            self.completeLineTask.isHidden = true
        }
        
    }
    
    public func animateSwipeHint() {
        slideInFromRight()
    }
    
    private func slideInFromRight() {
        UIView.animate(withDuration: 0.7, delay: 0.3, options: .curveEaseOut, animations: {
            self.customView.transform = CGAffineTransform(translationX: -self.trailingSwipeView.frame.width, y: 0)
            self.trailingLabel.transform = CGAffineTransform(translationX: -self.trailingSwipeView.frame.width, y: 0)
        }) { (success) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.customView.transform = .identity
                self.trailingLabel.transform = .identity
            }) { (success) in
                self.slideInFromLeft()
            }
        }
    }
    
    private func slideInFromLeft() {
        UIView.animate(withDuration: 0.7, delay: 0.3, options: .curveEaseOut, animations: {
            self.customView.transform = CGAffineTransform(translationX: self.leadingSwipeView.frame.width, y: 0)
            self.leadingLabel.transform = CGAffineTransform(translationX:  self.leadingSwipeView.frame.width, y: 0)
        }) { (success) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
                self.customView.transform = .identity
                self.leadingLabel.transform = .identity
            }, completion: nil)
        }
    }
    
    public func setAlphaOfCell(alpha: CGFloat) {
        self.background.alpha = alpha
        self.nameLabel.alpha = alpha
        self.completeLineTask.alpha = alpha
    }
    
    private func setCustomView() {
        self.customView.frame = self.contentView.frame
        self.customView.backgroundColor = UIColor(named: "BackgroundWhite")
        self.contentView.addSubview(self.customView)
    }
    
    private func setLeadingSwipeView() {
        self.leadingSwipeView.frame = CGRect(x: 0, y: 0, width: self.contentView.frame.width*0.15, height: self.contentView.frame.height)
        self.leadingSwipeView.backgroundColor = UIColor(rgb: 0x65DB9C)
        
        self.leadingLabel.text = NSLocalizedString("complete", comment: "")
        self.leadingLabel.textColor = .white
        self.leadingLabel.sizeToFit()
        self.leadingLabel.frame = CGRect(x: -self.leadingSwipeView.frame.width*1.25, y: self.leadingSwipeView.frame.height*0.35, width: self.leadingLabel.frame.width, height: self.leadingLabel.frame.height)
        
        self.leadingSwipeView.addSubview(self.leadingLabel)
        
        self.contentView.addSubview(leadingSwipeView)
    }
    
    private func setTraillingSwipeView() {
        self.trailingSwipeView.frame = CGRect(x: self.contentView.frame.width - (self.contentView.frame.width*0.15), y: 0, width: self.contentView.frame.width*0.15, height: self.contentView.frame.height)
        self.trailingSwipeView.backgroundColor = UIColor(rgb: 0xC63E40)
        
        self.trailingLabel.text = NSLocalizedString("giveUp", comment: "")
        self.trailingLabel.textColor = .white
        self.trailingLabel.sizeToFit()
        self.trailingLabel.frame = CGRect(x: self.trailingSwipeView.frame.width*1.2, y: self.trailingSwipeView.frame.height*0.35, width: self.trailingLabel.frame.width, height: self.trailingLabel.frame.height)
        
        self.trailingSwipeView.addSubview(self.trailingLabel)
        
        self.contentView.addSubview(trailingSwipeView)
    }
    
    private func setBackgroundImageView(idCategory: CategoryTaskType, deviceName: String, tableViewSize: CGSize) {
        switch idCategory {
            case .Work:
                self.background.image = UIImage(named: "work-cell-\(deviceName)")
            case .Health:
                self.background.image = UIImage(named: "health-cell-\(deviceName)")
            case .Others:
                self.background.image = UIImage(named: "others-cell-\(deviceName)")
            case .Recreation:
                self.background.image = UIImage(named: "recreation-cell-\(deviceName)")
            case .Studies:
                self.background.image = UIImage(named: "study-cell-\(deviceName)")
        }
        
        self.background.contentMode = .scaleAspectFit
        self.background.frame = CGRect(x: 0, y: 0, width: tableViewSize.width, height: tableViewSize.height*0.1175)
        self.customView.addSubview(self.background)
    }
    
    private func setNameLabel(idPriority: PriorityType, taskName: String) {
        
        self.nameLabel.text = taskName
        
        switch idPriority {
            case .High:
                self.nameLabel.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 18)
            case .Medium:
                self.nameLabel.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 18)
            case .Low:
                self.nameLabel.font = UIFont(name: FontName.SFProDisplayThin.rawValue, size: 18)
        }
        
        self.nameLabel.sizeToFit()
        self.nameLabel.adjustsFontSizeToFitWidth = true
        self.customView.addSubview(self.nameLabel)
        
        self.nameLabel.frame = CGRect(x: self.background.frame.width*0.07, y: (self.background.frame.height-self.nameLabel.frame.height)/2, width: self.background.frame.width*0.8, height: self.nameLabel.frame.height)
        
    }
    
    private func setCompletedLineTask() {
        
        self.completeLineTask.frame = CGRect(x: self.background.frame.width*0.04, y: self.background.frame.height*0.5, width: self.background.frame.width*0.8, height: self.background.frame.height*0.035)
        self.completeLineTask.backgroundColor = .black
        
        self.customView.addSubview(completeLineTask)
        
        self.completeLineTask.translatesAutoresizingMaskIntoConstraints = false
    }
}
