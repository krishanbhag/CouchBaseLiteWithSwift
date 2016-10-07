//
//  ProfileInfoViewController.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import IQKeyboardManagerSwift

class ProfileInfoViewController: UIViewController {
    @IBOutlet fileprivate weak var tableView: UITableView!
    @IBOutlet fileprivate weak var footerButton: UIButton! {
        didSet {
            prePopulateProfileInfo()
            updateFooterState()
        }
    }
    
    var nextHandler: ((ProfileInfoViewController) -> Void)?
    
    @IBAction private func footerButtonClicked(_ sender: UIButton) {
        if footerButton.titleLabel?.text == "NEXT" {
        } else {
            saveProfileInfo()
            let alertVc = UIAlertController(title: "Success", message: "Please check your configured database for the updated data", preferredStyle: .alert)
            alertVc.addAction(UIAlertAction (title: "sync to server", style: .default, handler: { (UIAlertAction) in
                CouchBaseDataManager.sharedInstance.startReplication()
            }))
            alertVc.addAction(UIAlertAction (title: "Cancel", style: .default, handler: { (UIAlertAction) in
                
            }))

            self.present(alertVc, animated: true, completion: {
                
            })
            nextHandler?(self)
        }
    }
    var modelObject : UserDetailModel?
    var email: String?
    var homeAddress: String?
    var skills: String?
    var profileImage: UIImage?
    
}
extension ProfileInfoViewController {
    class func initializeViewController() -> ProfileInfoViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? ProfileInfoViewController
    }
}
extension ProfileInfoViewController: UITableViewDelegate, UITableViewDataSource {
    enum CellType: Int {
        case homeAddress = 0
        case email
        case profilePicture
        case none // Always keep this at last as we use this in number of rows in section
        static var count: Int { return CellType.none.rawValue}
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch CellType(rawValue: indexPath.row) ?? .none {
        case .profilePicture:
            return 230
        default:
            return 80
        }
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row) ?? .none {
        case .homeAddress:
            return fetchHomeAddressCell(tableView: tableView, indexPath: indexPath)
        case .email:
            return fetchEmailCell(tableView: tableView, indexPath: indexPath)
        case .profilePicture:
            return fetchProfilePictureCell(tableView: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }

    private func fetchHomeAddressCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoSingleFieldCell.cellIndentifier, for: indexPath) as? ProfileInfoSingleFieldCell ?? ProfileInfoSingleFieldCell()
        cell.textField.setCustomCBOperationDemoCustomStylePlaceholderText(text: "HOME ADDRESS", isMandatory: true)
        cell.textField.text = homeAddress
        cell.textField.didEndEditingBlock = { [weak self]
            txtField in
            self?.homeAddress = txtField?.text
            self?.modelObject?.homeAddress = txtField?.text
            self?.updateFooterState()
        }
        return cell
    }
    private func fetchEmailCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoSingleFieldCell.cellIndentifier, for: indexPath) as? ProfileInfoSingleFieldCell ?? ProfileInfoSingleFieldCell()
        cell.textField.setCustomCBOperationDemoCustomStylePlaceholderText(text: "EMAIL", isMandatory: true)
        cell.textField.text = email
        cell.textField.didEndEditingBlock = { [weak self]
            txtField in
            self?.email = txtField?.text
            self?.modelObject?.emailId = txtField?.text
            self?.updateFooterState()
        }
        return cell
    }
    private func fetchProfilePictureCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoImageCell.cellIndentifier, for: indexPath) as? ProfileInfoImageCell ?? ProfileInfoImageCell()
        cell.customImageView.image = profileImage ?? #imageLiteral(resourceName: "ProfileImagePlaceholder")
        cell.titleLabel?.text = "UPLOAD A PROFILE PIC"
        cell.profilePictureHandler = { [weak self]
            cell in
            guard let strongSelf = self else {return;}
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = strongSelf
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary
                strongSelf.present(imagePicker, animated: true, completion: nil)
            }
        }
        return cell
    }
    func updateFooterState() -> Void {

        if isDataValid() {
            footerButton.setTitle("SAVE", for: .normal)
            footerButton.backgroundColor = UIStyleUtility.FMThemeColor
            footerButton.setTitleColor(UIColor.white, for: .normal)

        } else {
            footerButton.setTitle("NEXT", for: .normal)
            footerButton.backgroundColor = UIStyleUtility.FMLightGrey
            footerButton.setTitleColor(UIStyleUtility.FMButtonInActiveTextColor, for: .normal)

        }

    }
    func isDataValid() -> Bool {
        if (!isValidEmail(testStr: email ?? "")) {
            return false
        }
        if (homeAddress?.characters.count ?? 0) <= 0 {
            return false
        }
        return true
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func saveProfileInfo() -> Void {
        // Save profile info from db
        if self.modelObject != nil {
            if let imageV = profileImage {
                let imageData = UIImageJPEGRepresentation(imageV, 0.75)
                if imageData != nil {
                    self.modelObject?.setAttachmentNamed("profileImage", withContentType: "image/jpeg", content: imageData!)
                }
            }
            UserDetailModel.saveTechnicianInfoIfNotExists(Object: self.modelObject!)
        }
    }
    func prePopulateProfileInfo() -> Void {
        // Fetch profile info from db
        let techPorfiles = UserDetailModel.retrieveTechnicianUsers()
        if techPorfiles.first != nil  {
            let model = techPorfiles.first
            self.modelObject = model
        }
        else {
           self.modelObject = UserDetailModel(forNewDocumentIn:CouchBaseDataManager.sharedInstance.database)
        }
    }
}
extension ProfileInfoViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            profileImage = pickedImage
        }
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
}

final class ProfileInfoSingleFieldCell: UITableViewCell {
    @IBOutlet weak var textField: JVFloatLabeledTextField! {
        didSet {
            textField.addCBOperationDemoCustomStyle()
        }
    }
    
    static let cellIndentifier = "ProfileInfoSingleFieldCell"
    func datePickerSelected() -> Void {
        
    }
}

final class ProfileInfoSingleFieldPickerCell: UITableViewCell {
    @IBOutlet weak var textField: JVFloatLabeledTextField! {
        didSet {
            textField.addCBOperationDemoCustomStyle()
        }
    }
    static let cellIndentifier = "ProfileInfoSingleFieldPickerCell"
}

final class ProfileInfoImageCell: UITableViewCell {
    @IBOutlet weak var customImageView: UIImageView! {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileInfoImageCell.tapProfilePic(gesture:)))
            customImageView.addGestureRecognizer(tapGesture)
            customImageView.isUserInteractionEnabled = true
            customImageView.contentMode = .scaleAspectFit
        }
    }
    @IBOutlet weak var titleLabel: UILabel?
    static let cellIndentifier = "ProfileInfoImageCell"
    
    var profilePictureHandler: ((ProfileInfoImageCell) -> Void)?
    
    func tapProfilePic(gesture: UITapGestureRecognizer) -> Void {
        profilePictureHandler?(self)
    }
}
