//
//  TaskCell.swift
//  quarto-mini-challenge
//
//  Created by Antonio Carlos on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class TaskCellEditing: UITableViewCell {
    
    //MARK: - Attributes
    private var background: UIImageView = UIImageView()
    private var nameLabel: UILabel = UILabel()
    private var completeLineTask: UIView = UIView()
    private var customBackgroundView: UIView = UIView()
    
    public var task: Task!
    
    //MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Make the cell's `contentView` as big as the entire cell.
        self.contentView.frame = self.bounds
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: false)
        if !editing {
            return
        }

        // Find the reorder control in the cell's subviews.
        for view in subviews {
            let className = String(describing: type(of:view))
            if className == "UITableViewCellReorderControl" {

                // Remove its subviews so that they don't mess up
                // your own content's appearance.
                for subview in view.subviews {
                    subview.removeFromSuperview()
                }
                
                view.frame = self.bounds

                break
            }
        }
    }

    
    /// This function is to set the layout of the cell based on the task status
    /// - Parameter task: The task that cells represent
    /// - Author: Antônio Carlos
    public func setLayout(task: Task, deviceName: String, tableView: UITableView, cellSpacingHeight: CGFloat) {
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.task = task
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setCustomBackgroundView(tableViewSize: tableView.frame.size, cellSpacingHeight: cellSpacingHeight)
        self.setBackgroundImageView(idCategory: task.id_category, deviceName: deviceName, tableViewSize: tableView.frame.size)
        self.setNameLabel(idPriority: task.id_priority, taskName: task.name)
        self.setCompletedLineTask()
        
        if task.completed {
            self.completeLineTask.isHidden = false
        } else {
            self.completeLineTask.isHidden = true
        }
        
    }
    
    private func setCustomBackgroundView(tableViewSize: CGSize, cellSpacingHeight: CGFloat) {
        self.customBackgroundView.frame = CGRect(x: 0, y: 0, width: tableViewSize.width, height: self.contentView.frame.height-cellSpacingHeight)
        
        self.customBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.customBackgroundView.isUserInteractionEnabled = true
        
        self.contentView.addSubview(customBackgroundView)
        
//        self.customBackgroundView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.customBackgroundView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.customBackgroundView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.customBackgroundView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: cellSpacingHeight/2).isActive = true
        self.customBackgroundView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: cellSpacingHeight/2).isActive = true
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
        
        self.background.contentMode = .scaleAspectFill
        self.background.frame = CGRect(x: 0, y: 0, width: tableViewSize.width, height: tableViewSize.height*0.1175)
        self.customBackgroundView.addSubview(self.background)
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
        self.customBackgroundView.addSubview(self.nameLabel)
        
        self.nameLabel.frame = CGRect(x: self.background.frame.width*0.07, y: (self.background.frame.height-self.nameLabel.frame.height)/2, width: self.background.frame.width*0.8, height: self.nameLabel.frame.height)
        
    }
    
    private func setCompletedLineTask() {
        
        self.completeLineTask.frame = CGRect(x: self.background.frame.width*0.04, y: self.background.frame.height*0.5, width: self.background.frame.width*0.8, height: self.background.frame.height*0.035)
        self.completeLineTask.backgroundColor = .black
        
        self.customBackgroundView.addSubview(completeLineTask)
        
        self.completeLineTask.translatesAutoresizingMaskIntoConstraints = false
    }
}
