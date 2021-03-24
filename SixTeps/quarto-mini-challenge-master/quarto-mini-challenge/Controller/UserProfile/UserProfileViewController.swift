//
//  UserProfileViewController.swift
//  quarto-mini-challenge
//
//  Created by Pedro Paulo Feitosa Rodrigues Carneiro on 08/05/20.
//  Copyright © 2020 Panterimar. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    //USER DEFAULT
    var UD = UserDefaultLogic()
    
    // USER
    let user_Reference = User()
    
    // BACKGROUND VIEWS
    let view_BackGroundLastView = UIImageView()
    
    let view_BackGroundView = UIView()

    // IMAGE VIEWS
    let imageView_Profile = UIImageView()
    let imageView_Rank = UIImageView()
    let label_ProfileName = UILabel()
    let label_Rank = UILabel()
    let label_Tasks = UILabel()
    let label_Level = UILabel()
    let label_TasksDone = UILabel()
    let label_LevelNumber = UILabel()
    
    // COLLECTION VIEW
    let layout = UICollectionViewFlowLayout()
    var view_CollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let cellId = "cellId"
    
    //PROGRESS BAR AREA
    //WORK
    let image_Work = UIImageView()
    let progress_Work = UIProgressView()
    let label_Work = UILabel()
    //STUDIES
    let image_Studies = UIImageView()
    let progress_Studies = UIProgressView()
    let label_Studies = UILabel()
    //HEALTH
    let image_Health = UIImageView()
    let progress_Health = UIProgressView()
    let label_Health = UILabel()
    //RECREATION
    let image_Recreation = UIImageView()
    let progress_Recreation = UIProgressView()
    let label_Recreation = UILabel()
    //OTHERS
    let image_Others = UIImageView()
    let progress_Others = UIProgressView()
    let label_Others = UILabel()

    //SHARING INSTANCE
    private let instagramShare = SocialSharing()
    
    //NAVBAR TITLE
    private var navbarTitleLabel = UIOutlinedLabel()
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.subviews.forEach({ (subView) in
            subView.removeFromSuperview()
        })
        
        if let _ = UserDefaultLogic().userId {
            User().updateUserCK {}
        }
        
        setSettingsButtonItem(navBar: self.navigationController!.navigationBar)
        setShareButtonItem(navBar: self.navigationController!.navigationBar)
        
        switch AutoLayout.getDeviceNameBasedOnProportion(viewSize: CGSize(width: self.view.frame.width, height: self.view.frame.height)) {
        case "iphoneX":
            layoutSetupIphoneX()
            break
        case "iphone8":
            layoutSetupIphone8()
            break
        case "iPad":
            break
        default:
            break
        }
        updateUserData()
        setNavbarTitleImage()
    }
    
    private func setNavbarTitleImage() {
//        let deviceName = AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size)
        guard let navBar = self.navigationController?.navigationBar else {return}
        
        self.navbarTitleLabel.text = NSLocalizedString("progressTitle", comment: "")
        self.navbarTitleLabel.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 32)
        self.navbarTitleLabel.sizeToFit()
        self.navbarTitleLabel.textColor = .white
        self.navbarTitleLabel.draw(self.navbarTitleLabel.frame)
        navBar.addSubview(self.navbarTitleLabel)
        self.navigationItem.title = ""
        
        self.navbarTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.navbarTitleLabel.leadingAnchor.constraint(equalTo: navBar.leadingAnchor, constant: navBar.frame.width*0.048).isActive = true
        self.navbarTitleLabel.bottomAnchor.constraint(equalTo: navBar.bottomAnchor, constant: -navBar.frame.height*0.09).isActive = true
        
    }
    
    func updateUserData(){
         
         label_LevelNumber.text = "\(user_Reference.getLevel())"
         progress_Work.progress = user_Reference.levelCategories[0].getLevelProgress().1
         progress_Studies.progress = user_Reference.levelCategories[1].getLevelProgress().1
         progress_Health.progress = user_Reference.levelCategories[2].getLevelProgress().1
         progress_Recreation.progress = user_Reference.levelCategories[3].getLevelProgress().1
         progress_Others.progress = user_Reference.levelCategories[4].getLevelProgress().1
        if user_Reference.username != nil {
            label_ProfileName.text = user_Reference.username
            label_Rank.text = DivisionType.init(rawValue: Int16(user_Reference.getDivision()))?.getName
        } else {
            label_ProfileName.text = UD.userName
            label_Rank.text = DivisionType.Estagiário.getName
        }
        
        if user_Reference.profilePic != nil {
            imageView_Profile.image = UIImage(data: user_Reference.profilePic!)
            imageView_Profile.contentMode = .scaleAspectFill
            
        }
        
         
        if user_Reference.backgroundPhoto != nil {
            let maskView = UIImageView(image: UIImage(data: user_Reference.backgroundPhoto!))
            maskView.contentMode = .scaleAspectFill
            
            view_BackGroundLastView.image = maskView.image!
            view_BackGroundLastView.mask = maskView
            view_BackGroundLastView.contentMode = .scaleAspectFill
        }
        
        imageView_Rank.image = UIImage(named: "division_\(user_Reference.getDivision())")
         
     }
    
    func sizeW_X(_ v: CGFloat) -> CGFloat{
        
        switch self.view.frame.size.width {
        case 414:
            return v
        case 375:
            return v * 375/414
        default:
            return 0
        }
        
        
    }
    func sizeH_X(_ v: CGFloat) -> CGFloat{
        
        switch self.view.frame.size.height {
        case 896:
            return v
        case 812:
            return v * 812/896
        default:
            return 0
        }
        
        
    }
    
    func sizeW_8(_ v: CGFloat) -> CGFloat{
        
        switch self.view.frame.size.width {
        case 375:
            return v
        case 414:
            return v * 414/375
        default:
            return 0
        }
        
        
    }
    func sizeH_8(_ v: CGFloat) -> CGFloat{
        
        switch self.view.frame.size.height {
        case 667:
            return v
        case 736:
            return v * 736/667
        default:
            return 0
        }
        
        
    }
    
    
    private func setSettingsButtonItem(navBar: UINavigationBar) {
        //Creates The button
        let rankingButton = UIButton(type: .system)
        rankingButton.setBackgroundImage(UIImage(named: "settings_Item"), for: .normal)
        rankingButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        //Adds the button to the navbar
        navBar.addSubview(rankingButton)
        
        //Sets the constraint of button
        
        if AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size) == "iphoneX"{
            rankingButton.anchor(top: navBar.topAnchor, leading: nil, bottom: nil, trailing: navBar.trailingAnchor, padding: .init(top: sizeH_X(15), left: 0, bottom: 0, right: sizeW_X(30)),size: .init(width: 25, height: 24))
        } else {
            rankingButton.anchor(top: navBar.topAnchor, leading: nil, bottom: nil, trailing: navBar.trailingAnchor, padding: .init(top: sizeH_8(15), left: 0, bottom: 0, right: sizeW_8(20)), size: .init(width: 25, height: 24))
        }
        
    }
    
    @objc func settingsButtonTapped() {
        let settingsST = UIStoryboard(name: "Settings", bundle: nil)
        let SettingsVC = settingsST.instantiateInitialViewController() as! SettingsViewController
        SettingsVC.settingsPictureDelegate = self
        self.navigationController?.pushViewController(SettingsVC, animated: true)
    }
    
    
    private func setShareButtonItem(navBar: UINavigationBar) {
        //Creates The button
        let shareButton = UIButton(type: .system)
        shareButton.setBackgroundImage(UIImage(named: "share_Item"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        
        //Adds the button to the navbar
        navBar.addSubview(shareButton)
        
        //Sets the constraint of button∫
        
        if AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size) == "iphoneX"{
            shareButton.anchor(top: navBar.topAnchor, leading: nil, bottom: nil, trailing: navBar.trailingAnchor, padding: .init(top: sizeH_X(14), left: 0, bottom: 0, right: sizeW_X(63)),size: .init(width: 26, height: 24))
        } else {
            shareButton.anchor(top: navBar.topAnchor, leading: nil, bottom: nil, trailing: navBar.trailingAnchor, padding: .init(top: sizeH_8(14), left: 0, bottom: 0, right: sizeW_8(53)), size: .init(width: 26, height: 24))
        }
        
    }
    
    
    
    @objc func shareButtonTapped(){
        instagramShare.shareToInstagram(image: self.view.screenShot())
    }
    
    
}






extension UserProfileViewController {
    
    // IPHONE X LAYOUT
    func layoutSetupIphoneX(){
            
            // BACKGROUND IMAGES AND COLLECTIONVIEW
            
            
            view_BackGroundView.backgroundColor = UIColor(named: "BackgroundWhite")
            
            
            
            // PROFILE PICS AND PROFILE STATS
            
            imageView_Profile.image = UIImage(named: "userProfilePic")
            imageView_Profile.clipsToBounds = true
            imageView_Profile.layer.cornerRadius = 27
            imageView_Profile.layer.borderWidth = 5
            imageView_Profile.layer.borderColor = UIColor.white.cgColor
            imageView_Profile.layer.masksToBounds = true
            
            
            imageView_Rank.image = UIImage(named: "division_\(user_Reference.getDivision())")
            
          let profileNameString = NSAttributedString(
                string: "laramatos",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: FontName.SFProDisplayBold.rawValue, size: 14) ?? "Arial"
                ]
            )
            label_ProfileName.attributedText = profileNameString
            label_ProfileName.textAlignment = .center
            label_ProfileName.textColor = UIColor(named: "FontBlackWhite")
            
            
            let rankString = NSAttributedString(
                string: "\(DivisionType.init(rawValue: Int16(user_Reference.getLevel()))?.getName ?? "")",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 12) ?? "Arial"
                ]
            )
            
            

            label_Rank.attributedText = rankString
            label_Rank.adjustsFontSizeToFitWidth = true
            label_Rank.textAlignment = .center
            label_Rank.textColor = UIColor(named: "FontBlackWhite")
            
            let taskString = NSAttributedString(
                string: NSLocalizedString("Tasks", comment: ""),
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 12) ?? "Arial"
                ]
            )
            
            label_Tasks.attributedText = taskString
            label_Tasks.adjustsFontSizeToFitWidth = true
            label_Tasks.textAlignment = .center
            label_Tasks.textColor = UIColor(named: "FontBlackWhite")
            
            
            let levelString = NSAttributedString(
                string: NSLocalizedString("Level", comment: ""),
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 12) ?? "Arial"
                ]
            )
            
            label_Level.attributedText = levelString
            label_Level.textAlignment = .center
            label_Level.textColor = UIColor(named: "FontBlackWhite")
            
            
            let labelTaskDone_String = NSAttributedString(
                string: "\(user_Reference.amountTasksPerformed)",
                attributes: [
                    NSAttributedString.Key.font: UIFont(name: FontName.SFProDisplayBold.rawValue, size: 28) ?? "Arial"
                ]
            )
            label_TasksDone.attributedText = labelTaskDone_String
            label_TasksDone.textColor = UIColor(named: "FontBlackWhite")
            label_TasksDone.textAlignment = .center
            
            
        label_LevelNumber.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 26)
            label_LevelNumber.font = UIFont.boldSystemFont(ofSize: 26)
            label_LevelNumber.textColor = UIColor(named: "FontBlackWhite")
            label_LevelNumber.textAlignment = .center
            label_LevelNumber.text = "\(user_Reference.getLevel())"
            // PROFILE PICS AND PROFILE STATS
            
            
            // CATEGORY STATS, BARS AND LABELS
            
            image_Work.image = UIImage(named: "iphoneX-Work")
            label_Work.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 14)
            label_Work.textColor = UIColor(named: "FontBlackWhite")
            label_Work.text = NSLocalizedString("Work", comment: "")
            
            
            image_Studies.image = UIImage(named: "iphoneX-Studies")
            label_Studies.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 13)
            label_Studies.textColor = UIColor(named: "FontBlackWhite")
            label_Studies.text = NSLocalizedString("Studies", comment: "")
            
            
            image_Health.image = UIImage(named: "iphoneX-Health")
            label_Health.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 14)
            label_Health.textColor = UIColor(named: "FontBlackWhite")
            label_Health.text = NSLocalizedString("Health", comment: "")
            
            
            image_Recreation.image = UIImage(named: "iphoneX-Recreation")
            label_Recreation.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 14)
            label_Recreation.textColor = UIColor(named: "FontBlackWhite")
            label_Recreation.text = NSLocalizedString("Entertainment", comment: "")
            
            
            image_Others.image = UIImage(named: "iphoneX-Others")
            label_Others.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 13)
            label_Others.textColor = UIColor(named: "FontBlackWhite")
            label_Others.text = NSLocalizedString("Others", comment: "")
            // CATEGORY STATS, BARS AND LABELS
            
            //COLLECTION VIEW LAYOUT
            
            layout.scrollDirection = .horizontal
            view_CollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
            view_CollectionView.translatesAutoresizingMaskIntoConstraints = false
            view_CollectionView.isScrollEnabled = true
            view_CollectionView.backgroundColor = UIColor(named: "BackgroundWhite")
            layout.sectionInset = .init(top: 0, left: sizeW_X(10), bottom: 0, right: sizeW_X(10))
            layout.minimumLineSpacing = sizeW_X(11)
            
            
            //INITIALIZATION
            [view_BackGroundLastView, imageView_Profile, imageView_Rank, label_TasksDone, label_LevelNumber, view_BackGroundView, image_Work, progress_Work, label_Work, image_Studies, progress_Studies, label_Studies, image_Health, progress_Health, label_Health, image_Recreation, progress_Recreation, label_Recreation, image_Others, progress_Others, label_Others, label_ProfileName, label_Rank, label_Tasks, label_Level, view_CollectionView].forEach {view.addSubview($0)}
            
            // COLLECTION VIEW DELEGATE
            view_CollectionView.delegate = self
            view_CollectionView.dataSource = self
            view_CollectionView.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
            view_CollectionView.reloadData()
            
            // LAST BACKGROUND VIEW
            view_BackGroundLastView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: sizeH_X(896 - 410), right: 0), size: .init(width: sizeW_X(414), height: sizeH_X(410)))
            
            //BACKGROUND VIEW 355 - 300
            view_BackGroundView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: sizeH_X(100), left: 0, bottom: 0, right: 0), size: .init(width: sizeW_X(414), height: sizeH_X(640)))
            
            
            // COLLECTION VIEW 297 - 325
            
            view_CollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(343), left: sizeW_X(23), bottom: 0, right: 0), size: .init(width: sizeW_X(391), height: sizeH_X(119)))
            
            
            //PROFILE IMAGE
            imageView_Profile.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top:sizeH_X(211), left: sizeW_X(25), bottom: 0, right: 0), size: .init(width:sizeW_X(94), height: sizeH_X(88)))
            imageView_Profile.layer.zPosition = 2

            //RANK IMAGE
            imageView_Rank.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: sizeH_X(272), left: sizeW_X(163), bottom: 0, right: 0) ,size: .init(width: sizeW_X(27), height: sizeH_X(25)))
            imageView_Rank.layer.zPosition = 2

            //TASKS LABEL NUMBER
            label_TasksDone.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(270), left: sizeW_X(239), bottom: 0, right: 0), size: .init(width: sizeW_X(56), height: sizeH_X(31)))
            label_TasksDone.layer.zPosition = 2

            //USER LEVEL NUMBER
            label_LevelNumber.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(270), left: sizeW_X(336.87), bottom: 0, right: 0), size: .init(width: sizeW_X(34), height: sizeH_X(31)))
            label_LevelNumber.layer.zPosition = 2

    //        // PROFILE NAME TEXT
            label_ProfileName.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(300), left: sizeW_X(27), bottom: 0, right: 0), size: .init(width: sizeW_X(90), height: sizeH_X(21)))

    //        // RANK TEXT
            label_Rank.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(304), left: sizeW_X(151), bottom: 0, right: 0), size: .init(width: sizeW_X(51), height: sizeH_X(15)))

    //        // TASKS DONE TEXT
            label_Tasks.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(304), left: sizeW_X(246), bottom: 0, right: 0), size: .init(width: sizeW_X(41), height: sizeH_X(14)))
            label_Tasks.layer.zPosition = 2
            
            
    //        //LEVEL TEXT
            label_Level.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(304), left: sizeW_X(341), bottom: 0, right: 0), size: .init(width: sizeW_X(33), height: sizeH_X(14)))
            label_Level.layer.zPosition = 2
            
            //PROGRESS BARS
            // WORK
            image_Work.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(485), left: sizeW_X(51.96), bottom: 0, right: 0), size: .init(width: sizeW_X(39.98), height: sizeH_X(37.91)))
            
            progress_Work.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(499), left: sizeW_X(111), bottom: 0, right: 0), size: .init(width: sizeW_X(267), height: sizeH_X(15)))
            progress_Work.progressTintColor = UIColor(red: 41, green: 82, blue: 86)
            progress_Work.clipsToBounds = true
            progress_Work.layer.cornerRadius = 7
            
            label_Work.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(478), left: sizeW_X(110), bottom: 0, right: 0), size: .init(width: sizeW_X(100), height: sizeH_X(16)))
            
            
            // STUDY
            image_Studies.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(564), left: sizeW_X(51.96), bottom: 0, right: 0), size: .init(width: sizeW_X(41.31), height: sizeH_X(31)))
            
            progress_Studies.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(575.19), left: sizeH_X(111.36), bottom: 0, right: 0), size: .init(width: sizeW_X(267.59), height: sizeH_X(15.26)))
            progress_Studies.progressTintColor = UIColor(red: 103, green: 158, blue: 198)
            progress_Studies.clipsToBounds = true
            progress_Studies.layer.cornerRadius = 7
            
            label_Studies.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(558), left: sizeH_X(110.36), bottom: 0, right: 0), size: .init(width: sizeW_X(100), height: sizeH_X(15)))
            
            // HEALTH
            image_Health.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(642.62), left: sizeH_X(50.59), bottom: 0, right: 0), size: .init(width: sizeW_X(44.53), height: sizeH_X(36.18)))
            
            progress_Health.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(655), left: sizeH_X(111.36), bottom: 0, right: 0), size: .init(width: sizeW_X(267.59), height: sizeH_X(15.26)))
            progress_Health.progressTintColor = UIColor(red: 245, green: 73, blue: 105)
            progress_Health.clipsToBounds = true
            progress_Health.layer.cornerRadius = 7
        
            
            label_Health.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(634), left: sizeH_X(110.36), bottom: 0, right: 0), size: .init(width: sizeW_X(100), height: sizeH_X(16)))
            
            //RECREATION
            image_Recreation.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(716), left: sizeH_X(52.13), bottom: 0, right: 0), size: .init(width: sizeW_X(32), height: sizeH_X(33)))
            
            progress_Recreation.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(735), left: sizeH_X(111.36), bottom: 0, right: 0), size: .init(width: sizeW_X(267.59), height: sizeH_X(15.26)))
            progress_Recreation.progressTintColor = UIColor(red: 255, green: 170, blue: 170)
            progress_Recreation.clipsToBounds = true
            progress_Recreation.layer.cornerRadius = 7
        
            label_Recreation.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(714), left: sizeH_X(110.36), bottom: 0, right: 0), size: .init(width: sizeW_X(100), height: sizeH_X(16)))
            
            //OTHERS
            image_Others.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(799), left: sizeH_X(51.23), bottom: 0, right: 0), size: .init(width: sizeW_X(43.09), height: sizeH_X(44.02)))
            
            progress_Others.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(813), left: sizeH_X(111.36), bottom: 0, right: 0), size: .init(width: sizeW_X(267.59), height: sizeH_X(15.26)))
            progress_Others.progressTintColor = UIColor(red: 160, green: 160, blue: 160)
            progress_Others.clipsToBounds = true
            progress_Others.layer.cornerRadius = 7
            
            label_Others.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_X(793), left: sizeH_X(110.35), bottom: 0, right: 0), size: .init(width: sizeW_X(100), height: sizeH_X(15)))
            
            
        }
    
    // IPHONE 8
    func layoutSetupIphone8(){
        
        
        
        // BACKGROUND IMAGES AND COLLECTIONVIEW
        
//        view_BackGroundView.image = UIImage(named: "iphone8-customBackGround")
        view_BackGroundView.backgroundColor = UIColor(named: "BackgroundWhite")
        
        // PROFILE PICS AND PROFILE STATS
        
        imageView_Profile.image = UIImage(named: "userProfilePic")
        imageView_Profile.clipsToBounds = true
        imageView_Profile.layer.cornerRadius = 27
        imageView_Profile.layer.borderWidth = 5
        imageView_Profile.layer.borderColor = UIColor.white.cgColor
        imageView_Profile.layer.masksToBounds = true
        
        print(user_Reference.getDivision())
        imageView_Rank.image = UIImage(named: "division_\(user_Reference.getDivision())")
        
        label_TasksDone.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 23)
        label_TasksDone.textColor = UIColor(named: "FontBlackWhite")
        label_TasksDone.textAlignment = .center
        label_TasksDone.text = "\(user_Reference.amountTasksPerformed)"
        
        label_LevelNumber.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 23)
        label_LevelNumber.textColor = UIColor(named: "FontBlackWhite")
        label_LevelNumber.textAlignment = .center
        label_LevelNumber.text = "\(user_Reference.getLevel())"
        
        label_ProfileName.font = UIFont(name: FontName.SFProDisplayBold.rawValue, size: 18)
        label_ProfileName.adjustsFontSizeToFitWidth = true
        label_ProfileName.text = "laramatos"
        label_ProfileName.textAlignment = .center
        label_ProfileName.textColor = UIColor(named: "FontBlackWhite")
        
        label_Rank.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 12)
//        label_Rank.adjustsFontSizeToFitWidth = true
        label_Rank.text = "Estagiário"
        label_Rank.textAlignment = .center
        label_Rank.textColor = UIColor(named: "FontBlackWhite")
        
        
        label_Tasks.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 12)
        label_Tasks.text = NSLocalizedString("Tasks", comment: "")
//        label_Tasks.adjustsFontSizeToFitWidth = true
        label_Tasks.textAlignment = .center
        label_Tasks.textColor = UIColor(named: "FontBlackWhite")
        
        
        label_Level.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 12)
        label_Level.text = NSLocalizedString("Level", comment: "")
        label_Level.adjustsFontSizeToFitWidth = true
        label_Level.textAlignment = .center
        label_Level.textColor = UIColor(named: "FontBlackWhite")
        
        // CATEGORY STATS, BARS AND LABELS
        image_Work.image = UIImage(named: "iphone8-Work")
        label_Work.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 10)
        label_Work.textColor = UIColor(named: "FontBlackWhite")
        label_Work.text = NSLocalizedString("Work", comment: "")
        
        image_Studies.image = UIImage(named: "iphone8-Studies")
        label_Studies.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 10)
        label_Studies.textColor = UIColor(named: "FontBlackWhite")
        label_Studies.text = NSLocalizedString("Studies", comment: "")
        
        image_Health.image = UIImage(named: "iphone8-Health")
        label_Health.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 10)
        label_Health.textColor = UIColor(named: "FontBlackWhite")
        label_Health.text = NSLocalizedString("Health", comment: "")
        
        image_Recreation.image = UIImage(named: "iphone8-Recreation")
        label_Recreation.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 10)
        label_Recreation.textColor = UIColor(named: "FontBlackWhite")
        label_Recreation.text = NSLocalizedString("Entertainment", comment: "")
        
        image_Others.image = UIImage(named: "iphone8-Others")
        label_Others.font = UIFont(name: FontName.SFProDisplayRegular.rawValue, size: 10)
        label_Others.textColor = UIColor(named: "FontBlackWhite")
        label_Others.text = NSLocalizedString("Others", comment: "")
        
        
        // COLLECTION VIEW LAYOUT
        layout.scrollDirection = .horizontal
        view_CollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        view_CollectionView.translatesAutoresizingMaskIntoConstraints = false
        view_CollectionView.isScrollEnabled = true
        view_CollectionView.backgroundColor = UIColor(named: "BackgroundWhite")
        layout.sectionInset = .init(top: 0, left: sizeW_8(8), bottom: 0, right: sizeW_8(8))
        layout.minimumLineSpacing = sizeW_8(13)
        
        //INIT
        [view_BackGroundLastView, imageView_Profile, imageView_Rank, label_TasksDone, label_LevelNumber, view_BackGroundView, image_Work, progress_Work, label_Work, image_Studies, progress_Studies, label_Studies, image_Health, progress_Health, label_Health, image_Recreation, progress_Recreation, label_Recreation, image_Others, progress_Others, label_Others, label_ProfileName, label_Rank, label_Tasks, label_Level, view_CollectionView].forEach {view.addSubview($0)} //
        
        
        // COLLECTION VIEW DELEGATE
        view_CollectionView.delegate = self
        view_CollectionView.dataSource = self
        view_CollectionView.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        view_CollectionView.reloadData()
        
        
        
        //APLYING ANCHORS
        
        // LAST BACKGROUND VIEW
        view_BackGroundLastView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: sizeH_8(482), right: 0), size: .init(width: sizeW_8(375), height: sizeH_8(185)))
        
        //BACKGROUND VIEW
        view_BackGroundView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: sizeH_8(185), left: 0, bottom: 0, right: 0), size: .init(width: sizeW_8(375), height: sizeH_8(482)))
        
        
        //COLLECTIONVIEW
        view_CollectionView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(245), left: sizeW_8(25), bottom: 0, right: 0), size: .init(width: sizeW_8(350), height: sizeH_8(130)))
        
        //PROFILE IMAGE
        imageView_Profile.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top:sizeH_8(133), left: sizeW_8(24), bottom: 0, right: 0), size: .init(width:sizeW_8(94), height: sizeH_8(88)))
        imageView_Profile.layer.zPosition = 3

        //RANK IMAGE
        imageView_Rank.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil,padding: .init(top: sizeH_8(195), left: sizeW_8(147), bottom: 0, right: 0) ,size: .init(width: sizeW_8(27), height: sizeH_8(24.81)))
        imageView_Rank.layer.zPosition = 3

        //TASKS LABEL NUMBER
        label_TasksDone.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(193), left: sizeW_8(225.5), bottom: 0, right: 0), size: .init(width: sizeW_8(44), height: sizeH_8(28)))
        label_TasksDone.layer.zPosition = 3

        //USER LEVEL NUMBER
        label_LevelNumber.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(193), left: sizeW_8(317.36), bottom: 0, right: 0), size: .init(width: sizeW_8(14), height: sizeH_8(28)))
        label_LevelNumber.layer.zPosition = 3

        // PROFILE NAME TEXT
        label_ProfileName.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(223), left: sizeW_8(27), bottom: 0, right: 0), size: .init(width: sizeW_8(90), height: sizeH_8(21)))
        label_ProfileName.layer.zPosition = 3

        //PROFILE RANK TEXT
        label_Rank.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(228.5), left: sizeW_8(133), bottom: 0, right: 0), size: .init(width: sizeW_8(56), height: sizeH_8(14)))
        label_Rank.layer.zPosition = 3

        //PROFILE TASKS DONE TEXT
        label_Tasks.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(228.5), left: sizeW_8(227), bottom: 0, right: 0), size: .init(width: sizeW_8(41), height: sizeH_8(14)))
        label_Tasks.layer.zPosition = 3

        //PROFILE USER LEVEL TEXT
        label_Level.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(228.5), left: sizeW_8(309.87), bottom: 0, right: 0), size: .init(width: sizeW_8(29), height: sizeH_8(14)))
        label_Level.layer.zPosition = 3

        //PROGRESS BARS
        // WORK
        image_Work.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(376), left: sizeW_8(28), bottom: 0, right: 0), size: .init(width: sizeW_8(29), height: sizeH_8(28)))

        progress_Work.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(390), left: sizeW_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(269), height: sizeH_8(13)))
        progress_Work.progressTintColor = UIColor(red: 41, green: 82, blue: 86)
        progress_Work.clipsToBounds = true
        progress_Work.layer.cornerRadius = 6

        label_Work.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(371), left: sizeW_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(100), height: sizeH_8(12)))
        label_Work.layer.zPosition = 3

        // STUDY
        image_Studies.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(435), left: sizeW_8(25), bottom: 0, right: 0), size: .init(width: sizeW_8(34), height: sizeH_8(25)))

        progress_Studies.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(446), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(269), height: sizeH_8(13)))
        progress_Studies.progressTintColor = UIColor(red: 103, green: 158, blue: 198)
        progress_Studies.clipsToBounds = true
        progress_Studies.layer.cornerRadius = 6

        label_Studies.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(427), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(100), height: sizeH_8(12)))

        // HEALTH
        image_Health.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(495), left: sizeH_8(28), bottom: 0, right: 0), size: .init(width: sizeW_8(27), height: sizeH_8(23)))

        progress_Health.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(505), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(269), height: sizeH_8(13)))
        progress_Health.progressTintColor = UIColor(red: 245, green: 73, blue: 105)
        progress_Health.clipsToBounds = true
        progress_Health.layer.cornerRadius = 6

        label_Health.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(486), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(100), height: sizeH_8(12)))

        //RECREATION
        image_Recreation.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(545), left: sizeH_8(28), bottom: 0, right: 0), size: .init(width: sizeW_8(28), height: sizeH_8(32)))

        progress_Recreation.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(564), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(269), height: sizeH_8(13)))
        progress_Recreation.progressTintColor = UIColor(red: 255, green: 170, blue: 170)
        progress_Recreation.clipsToBounds = true
        progress_Recreation.layer.cornerRadius = 6

        label_Recreation.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(545), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(100), height: sizeH_8(12)))


        //OTHERS
        image_Others.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(608), left: sizeH_8(29), bottom: 0, right: 0), size: .init(width: sizeW_8(28.45), height: sizeH_8(28.45)))

        progress_Others.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(623), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(269), height: sizeH_8(13)))
        progress_Others.progressTintColor = UIColor(red: 160, green: 160, blue: 160)
        progress_Others.clipsToBounds = true
        progress_Others.layer.cornerRadius = 6

        label_Others.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: sizeH_8(608), left: sizeH_8(88), bottom: 0, right: 0), size: .init(width: sizeW_8(100), height: sizeH_8(12)))
        
    }
    
    
}


extension UserProfileViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
     }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = view_CollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfileCollectionViewCell
        
        cell.setLayout(deviceName: AutoLayout.getDeviceNameBasedOnProportion(viewSize: self.view.frame.size))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if AutoLayout.getDeviceNameBasedOnProportion(viewSize: .init(width: self.view.frame.width, height: self.view.frame.height)) == "iphoneX"{
            return CGSize(width: sizeW_X(86), height: sizeH_X(100))
        }
        return .init(width: sizeW_8(76), height: sizeH_8(87))
        
    }
    
    
}


extension UserProfileViewController : settingsPictureDelegate {
    
    func sendBackGroundProfilePic(image: UIImage){
        let maskView = UIImageView(image: image)
        maskView.contentMode = .scaleAspectFill
        view_BackGroundLastView.mask = maskView
    }
    
}
