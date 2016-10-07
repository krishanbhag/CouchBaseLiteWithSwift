//
//  LoginViewController.swift
//  CBOperationDemo
//
//  Copyright © 2016 Wirecamp Interactive. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField
import UITextField_Blocks
final class LoginViewController: UIViewController {
    
    var loginSuccess: ((LoginViewController) -> Void)?
    
    @IBOutlet fileprivate weak var tableView: UITableView! {
        didSet {
            if let headerView = Bundle.main.loadNibNamed("LoginTableHeaderView", owner: self, options: nil)?.first as? UIView {
                headerView.layoutIfNeeded()
                tableView.tableHeaderView = headerView
            }
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet fileprivate weak var nextButton: UIButton! {
        didSet {
            updateNextButtonState()
        }
    }
    @IBAction private func nextButtonClicked(_ sender: UIButton) {
        triggerNextAction()
    }
    fileprivate var name = ""
    fileprivate var phoneNumber = ""
    fileprivate var resendViewHidden = true
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let headerView = tableView.tableHeaderView {
            let height: CGFloat = 350.0
            var headerFrame = headerView.frame
            //Comparison necessary to avoid infinite loop
            if height != headerFrame.size.height {
                headerFrame.size.height = height
                headerView.frame = headerFrame
                tableView.tableHeaderView = headerView
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let techPorfiles = UserDetailModel.retrieveTechnicianUsers()
        for techProfObj in techPorfiles {
            //Remove all exising users
            UserDetailModel.deleteTechnicianObject(Object: techProfObj)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func triggerAutorizationApi() -> Void {
        
        self.verificationSuccess()
    }
    
    func verificationSuccess() -> Void {
        let userDetail = UserDetailModel(forNewDocumentIn:CouchBaseDataManager.sharedInstance.database)
        userDetail.name = self.name
        userDetail.phoneNumber = self.phoneNumber
        UserDetailModel.saveTechnicianInfoIfNotExists(Object: userDetail)
        self.loginSuccess?(self)
    }
}
extension LoginViewController {
    class func initializeViewController() -> LoginViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as? LoginViewController
    }
}

extension LoginViewController : UITableViewDelegate, UITableViewDataSource {
    
    enum CellType: Int {
        case name = 0
        case phone
        case none // Always keep this at last as we use this in number of rows in section
        static var count: Int { return CellType.none.rawValue}
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch CellType(rawValue: indexPath.row) ?? .none {
        case .name:
            return fetchNameCell(tableView: tableView, indexPath: indexPath)
        case .phone:
            return fetchPhoneCell(tableView: tableView, indexPath: indexPath)
        default:
            return UITableViewCell()
        }
    }
    private func fetchNameCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogingTableViewCell.cellIndentifier, for: indexPath) as? LogingTableViewCell ?? LogingTableViewCell()
        cell.iconImageView.image = #imageLiteral(resourceName: "NameImage")
        cell.textField.setCustomCBOperationDemoCustomStylePlaceholderText(text: "NAME", isMandatory: true)
        cell.textField.text = name
        cell.textField.didEndEditingBlock = { [weak self]
            txtField in
            self?.name = txtField?.text ?? ""
            self?.updateNextButtonState()
        }
        return cell
    }
    private func fetchPhoneCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LogingTableViewCell.cellIndentifier, for: indexPath) as? LogingTableViewCell ?? LogingTableViewCell()
        cell.iconImageView.image = #imageLiteral(resourceName: "PhoneImage")
        cell.textField.setCustomCBOperationDemoCustomStylePlaceholderText(text: "PHONE NUMBER", isMandatory: true)
        cell.textField.keyboardType = .numberPad
        cell.textField.text = self.phoneNumber
        cell.textField.didEndEditingBlock = { [weak self]
            txtField in
            self?.phoneNumber = txtField?.text ?? ""
            self?.updateNextButtonState()
        }
        cell.textField.shouldChangeCharactersInRangeBlock = {
            textField, range, txt in
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = txt!.components(separatedBy:aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            
            if (txt == numberFiltered) {
//                let formatter = NBAsYouTypeFormatter(regionCode: strongSelf.regionCode)
//                textField?.text = formatter?.inputString(tFText)
            }
        
            return (txt == numberFiltered)
        }
        return cell
    }
    fileprivate func updateNextButtonState() -> Void {
        if isNameValid() && isPhoneNumberValid() {
            nextButton.isEnabled = true
            nextButton.backgroundColor = UIStyleUtility.FMThemeColor
            nextButton.setTitleColor(UIStyleUtility.FMButtonActiveTextColor, for: .normal)
        } else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = UIStyleUtility.FMLightGrey
            nextButton.setTitleColor(UIStyleUtility.FMButtonDisableTextColor, for: .normal)
        }
    }
    private func isNameValid() -> Bool {
        return name.characters.count > 0
    }
    private func isPhoneNumberValid() -> Bool {
        
        if phoneNumber.characters.count == 10 {
        return true
        }
        else {
        return false
        }
    }
    
    fileprivate func triggerNextAction() -> Void {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // in a minute...
        }
        triggerAutorizationApi()
    }
}

//MARK: Custom Cell
final class LogingTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: JVFloatLabeledTextField! {
        didSet {
            textField.addCBOperationDemoCustomStyle()
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!
    static let cellIndentifier = "LogingTableViewCell"
}
