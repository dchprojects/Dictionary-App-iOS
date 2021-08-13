//
//  AuthorizationViewController.swift
//  MyDictionary_App_Swift
//
//  Created Dmytro Chumakov on 12.08.2021.

import UIKit

final class AuthorizationViewController: UIViewController {
    
    fileprivate let presenter: AuthorizationPresenterInputProtocol
    
    fileprivate let defaultLineViewHeight: CGFloat = 0.5
      
    fileprivate let nicknameTextFieldHeight: CGFloat = 40
    fileprivate let nicknameTextFieldTopOffset: CGFloat = 56
    fileprivate let nicknameTextField: UITextField = {
        let textField: UITextField = .init()
        textField.placeholder = KeysForTranslate.nickname.localized
        textField.autocorrectionType = .no
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        textField.font = AppStyling.Font.default
        textField.textColor = ConfigurationAppearanceController.labelTextColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .next
        textField.tag = AuthTextFieldTag.nickname.rawValue
        return textField
    }()
    
    fileprivate let nicknameTextFieldBottomLineView: UIView = {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppStyling.Color.light_Gray_0.color()
        return view
    }()
    
    fileprivate let passwordTextFieldHeight: CGFloat = 40
    fileprivate let passwordTextFieldTopOffset: CGFloat = 16
    fileprivate let passwordTextField: UITextField = {
        let textField: UITextField = .init()
        textField.placeholder = KeysForTranslate.password.localized
        textField.autocorrectionType = .no
        textField.textAlignment = .center
        textField.clearButtonMode = .whileEditing
        textField.font = AppStyling.Font.default
        textField.textColor = ConfigurationAppearanceController.labelTextColor()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.returnKeyType = .go
        textField.tag = AuthTextFieldTag.password.rawValue
        return textField
    }()
    
    fileprivate let passwordTextFieldBottomLineView: UIView = {
        let view: UIView = .init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = AppStyling.Color.light_Gray_0.color()
        return view
    }()
    
    fileprivate let loginButtonHeight: CGFloat = 56
    fileprivate let loginButton: UIButton = {
        let button: UIButton = .init()
        button.backgroundColor = ConfigurationAppearanceController.buttonBackgroundColor()
        button.setTitle(KeysForTranslate.login.localized, for: .normal)
        button.setTitleColor(ConfigurationAppearanceController.buttonTextColor(), for: .normal)
        button.titleLabel?.font = AppStyling.Font.default
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(presenter: AuthorizationPresenterInputProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        debugPrint(#function, Self.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        addViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addConstraints()
    }
    
}

// MARK: - AuthorizationPresenterOutputProtocol
extension AuthorizationViewController: AuthorizationPresenterOutputProtocol {
    
    func makePasswordFieldActive() {
        self.passwordTextField.becomeFirstResponder()
    }
    
    func hideKeyboard() {
        self.hideKeyboardFunc()
    }
    
    func showValidationError(_ error: Error) {
        UIAlertController.showAlertWithOkAction(title: KeysForTranslate.error.localized,
                                                message: error.localizedDescription,
                                                presenter: self)
    }
    
}

// MARK: - Add Views
fileprivate extension AuthorizationViewController {
    
    func addViews() {
        addNicknameTextField()
        addNicknameTextFieldBottomLineView()
        addPasswordTextField()
        addPasswordTextFieldBottomLineView()
        addLoginButton()
    }
    
    func addNicknameTextField() {
        nicknameTextField.delegate = presenter.textFieldDelegate
        nicknameTextField.addTarget(self, action: #selector(nicknameTextFieldEditingDidChangeAction), for: .editingChanged)
        view.addSubview(nicknameTextField)
    }
    
    func addNicknameTextFieldBottomLineView() {
        view.addSubview(nicknameTextFieldBottomLineView)
    }
    
    func addPasswordTextField() {
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldEditingDidChangeAction), for: .editingChanged)
        passwordTextField.delegate = presenter.textFieldDelegate
        view.addSubview(passwordTextField)
    }
    
    func addPasswordTextFieldBottomLineView() {
        view.addSubview(passwordTextFieldBottomLineView)
    }
    
    func addLoginButton() {
        loginButton.addTarget(self, action: #selector(loginButtonAction), for: .touchUpInside)
        view.addSubview(loginButton)
    }
    
}

// MARK: - Add Constraints
fileprivate extension AuthorizationViewController {
    
    func addConstraints() {
        addNicknameTextFieldConstraints()
        addNicknameTextFieldBottomLineViewConstraints()
        addPasswordTextFieldConstraints()
        addPasswordTextFieldBottomLineViewConstraints()
        addLoginButtonConstraints()
    }
    
    func addNicknameTextFieldConstraints() {
        NSLayoutConstraint.addEqualConstraintAndActivate(item: self.nicknameTextField,
                                                         attribute: .top,
                                                         toItem: self.navigationController!.navigationBar,
                                                         attribute: .bottom,
                                                         constant: self.nicknameTextFieldTopOffset)        
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.nicknameTextField,
                                                             toItem: self.view,
                                                             constant: 0)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.nicknameTextField,
                                                              toItem: self.view,
                                                              constant: 0)
        
        NSLayoutConstraint.addEqualHeightConstraintAndActivate(item: self.nicknameTextField,
                                                               constant: self.nicknameTextFieldHeight)
    }
    
    func addNicknameTextFieldBottomLineViewConstraints() {
        NSLayoutConstraint.addEqualConstraintAndActivate(item: self.nicknameTextFieldBottomLineView,
                                                         attribute: .top,
                                                         toItem: self.nicknameTextField,
                                                         attribute: .bottom,
                                                         constant: 0)
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.nicknameTextFieldBottomLineView,
                                                             toItem: self.view,
                                                             constant: 0)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.nicknameTextFieldBottomLineView,
                                                              toItem: self.view,
                                                              constant: 0)
        
        NSLayoutConstraint.addEqualHeightConstraintAndActivate(item: self.nicknameTextFieldBottomLineView,
                                                               constant: self.defaultLineViewHeight)
    }
    
    func addPasswordTextFieldConstraints() {
        NSLayoutConstraint.addEqualConstraintAndActivate(item: self.passwordTextField,
                                                         attribute: .top,
                                                         toItem: self.nicknameTextField,
                                                         attribute: .bottom,
                                                         constant: self.passwordTextFieldTopOffset)
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.passwordTextField,
                                                             toItem: self.view,
                                                             constant: 0)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.passwordTextField,
                                                              toItem: self.view,
                                                              constant: 0)
        
        NSLayoutConstraint.addEqualHeightConstraintAndActivate(item: self.passwordTextField,
                                                               constant: self.passwordTextFieldHeight)
    }
    
    func addPasswordTextFieldBottomLineViewConstraints() {
        NSLayoutConstraint.addEqualConstraintAndActivate(item: self.passwordTextFieldBottomLineView,
                                                         attribute: .top,
                                                         toItem: self.passwordTextField,
                                                         attribute: .bottom,
                                                         constant: 0)
        
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.passwordTextFieldBottomLineView,
                                                             toItem: self.view,
                                                             constant: 0)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.passwordTextFieldBottomLineView,
                                                              toItem: self.view,
                                                              constant: 0)
        
        NSLayoutConstraint.addEqualHeightConstraintAndActivate(item: self.passwordTextFieldBottomLineView,
                                                               constant: self.defaultLineViewHeight)
    }
    
    func addLoginButtonConstraints() {
        NSLayoutConstraint.addEqualLeftConstraintAndActivate(item: self.loginButton,
                                                             toItem: self.view,
                                                             constant: 0)
        
        NSLayoutConstraint.addEqualRightConstraintAndActivate(item: self.loginButton,
                                                              toItem: self.view,
                                                              constant: 0)
        
        NSLayoutConstraint.addEqualBottomConstraintAndActivate(item: self.loginButton,
                                                               toItem: self.view,
                                                               constant: 0)
        
        NSLayoutConstraint.addEqualHeightConstraintAndActivate(item: self.loginButton,
                                                               constant: self.loginButtonHeight)
    }
    
}

// MARK: - Configure UI
fileprivate extension AuthorizationViewController {
    
    func configureUI() {
        configureTitle()
        configureAppearance(fromAppearanceType: Appearance.current.appearanceType)
    }
    
    func configureTitle() {
        self.title = KeysForTranslate.authorization.localized
    }
     
}

// MARK: - Actions
fileprivate extension AuthorizationViewController {
    
    @objc func loginButtonAction() {
        presenter.loginButtonClicked()
    }
    
    @objc func nicknameTextFieldEditingDidChangeAction() {
        presenter.nicknameTextFieldEditingDidChangeAction(nicknameTextField.text)
    }
    
    @objc func passwordTextFieldEditingDidChangeAction() {
        presenter.passwordTextFieldEditingDidChangeAction(passwordTextField.text)
    }
    
}

// MARK: - Hide Keyboard
fileprivate extension AuthorizationViewController {
    
    func hideKeyboardFunc() {
        self.view.endEditing(true)
    }
    
}
