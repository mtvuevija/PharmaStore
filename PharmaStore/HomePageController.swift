//
//  ViewController.swift
//  PharmaStore

import UIKit
import Firebase

class HomePageController: UIViewController, UITableViewDataSource {
    var name = ""
    var mainView: UITableView?
    var medname: [String] = []
    var meddosage: [String] = []
    let cellReuseIdentifier = "cell"
    
    override func viewDidLoad() {
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            else {
                for document in querySnapshot!.documents {
                    if uid! == document.get("ID") as! String {
                        self.name = document.get("Name") as! String
                        self.medname = document.get("MedName") as! [String]
                        self.meddosage = document.get("MedDosage") as! [String]
                        self.mainView!.dataSource = self
                        self.mainView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                        self.mainView!.reloadData()
                        print("test")
                    }
                }
            }
        }
        super.viewDidLoad()
        view.backgroundColor = .white
        
        self.mainView = UITableView()
        self.mainView!.translatesAutoresizingMaskIntoConstraints = false
        self.mainView!.backgroundColor = .white
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        let horStackView = UIStackView()
        horStackView.translatesAutoresizingMaskIntoConstraints = false
        horStackView.axis = .horizontal
        horStackView.alignment = .leading
        
        let image = UIImageView(image: UIImage(named: "pill"))
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 15
        image.contentMode = .scaleAspectFit
        image.heightAnchor.constraint(equalToConstant: 40).isActive = true
        image.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        let header = UILabel()
        header.font = UIFont.boldSystemFont(ofSize: 36)
        header.text = "Pharma-Store"
        header.numberOfLines = 1
        header.textColor = .black
        
        let logoutButton = UIButton()
        logoutButton.setTitle("LogOut", for: .normal)
        logoutButton.setTitleColor(.red, for: .normal)
        logoutButton.addTarget(self, action: #selector(logOut), for: .touchUpInside)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        logoutButton.titleLabel?.numberOfLines = 1
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        horStackView.addArrangedSubview(image)
        horStackView.addArrangedSubview(header)
        horStackView.addArrangedSubview(logoutButton)
        horStackView.setCustomSpacing(10, after: image)
        horStackView.setCustomSpacing(10, after: header)
        image.leftAnchor.constraint(equalTo: horStackView.leftAnchor, constant: 10).isActive = true
        //header.rightAnchor.constraint(equalTo: horStackView.rightAnchor, constant: -10).isActive = true
        logoutButton.rightAnchor.constraint(equalTo: horStackView.rightAnchor, constant: -10).isActive = true
        
        
        let addButton = UIButton(type: .custom)
        addButton.setTitle("Add Prescription", for: .normal)
        addButton.addTarget(self, action: #selector(addNew), for: .touchUpInside)
        addButton.backgroundColor = UIColor(red: 121 / 255, green: 83 / 255, blue: 179 / 255, alpha: 1)
        addButton.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        addButton.layer.cornerRadius = 25
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        addButton.titleLabel?.numberOfLines = 1
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let buttonWrapper = UIView()
        buttonWrapper.translatesAutoresizingMaskIntoConstraints = false
        buttonWrapper.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: buttonWrapper.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: buttonWrapper.bottomAnchor),
            addButton.centerXAnchor.constraint(equalTo: buttonWrapper.centerXAnchor)
        ])
        
        stackView.addArrangedSubview(horStackView)
        stackView.addArrangedSubview(mainView!)
        stackView.addArrangedSubview(buttonWrapper)
        
        NSLayoutConstraint.activate([
            horStackView.topAnchor.constraint(equalTo: stackView.safeAreaLayoutGuide.topAnchor),
            buttonWrapper.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        stackView.setCustomSpacing(10, after: horStackView)
        stackView.setCustomSpacing(20, after: mainView!)
        
    }
    
    @objc func addNew() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(AddNewController(), animated: true)
        print("test")
    }
    
    @objc func logOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                self.navigationController?.pushViewController(LogInController(), animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        print("logout")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.medname.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.imageView?.tintColor = .blue
        cell.imageView?.image = imageWithImage(image: UIImage(named: "PharmaStore")!, scaledToSize: CGSize(width: 40, height: 40))
        /*cell.imageView?.contentMode = .scaleAspectFit
        cell.imageView?.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cell.imageView?.widthAnchor.constraint(equalToConstant: 40).isActive = true*/
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.text = "Medicine Name:\n" + medname[indexPath.row] + "\n\n" + "Medicine Dosage:\n" + meddosage[indexPath.row]
        cell.backgroundColor = .white
        return cell
    }
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
    }
}

