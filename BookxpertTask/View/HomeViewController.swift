//
//  HomeViewController.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private let viewModel = APIDataViewModel()
    private var tableView = UITableView()
    private var sideMenuTableView = UITableView()
    private let sideMenuWidth: CGFloat = 250
    private var isSideMenuVisible = false
    private var menuContainer = UIView()
    private var menuItems = ["PDF Viewer", "Image Picker", "Notification Settings"]
    
    private let notificationSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = false
        return toggle
    }()
   

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Home"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        
        // Setup left bar button item
        let galleryIcon = UIImage(systemName: "line.3.horizontal")
        let galleryButton = UIBarButtonItem(image: galleryIcon, style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = galleryButton
        
        notificationSwitch.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        notificationSwitch.addTarget(self, action: #selector(didToggleNotificationSwitch(_:)), for: .valueChanged)
        
        setupTableView()
       
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        viewModel.fetchFromAPI {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        // Side Menu
        sideMenuTableView.frame = CGRect(x: -250, y: 0, width: 250, height: view.frame.height)
        sideMenuTableView.register(UITableViewCell.self, forCellReuseIdentifier: "menu")
        sideMenuTableView.delegate = self
        sideMenuTableView.dataSource = self
        sideMenuTableView.backgroundColor = .systemGray6
        view.addSubview(sideMenuTableView)
        
    }
    
    func setupSideMenuToggle() {
        let menuButton = UIBarButtonItem(title: "Menu", style: .plain, target: self, action: #selector(toggleSideMenu))
        navigationItem.leftBarButtonItem = menuButton
    }
    
    @objc func toggleSideMenu() {
        UIView.animate(withDuration: 0.3) {
            self.isSideMenuVisible.toggle()
            self.sideMenuTableView.frame.origin.x = self.isSideMenuVisible ? 0 : -250
        }
    }
    
    @objc func didToggleNotificationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            requestNotificationPermission()
        } else {
            UserDefaults.standard.set(false, forKey: "notificationsEnabled")
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                UserDefaults.standard.set(granted, forKey: "notificationsEnabled")
                if granted {
                    self.scheduleTestNotification()
                } else {
                    self.notificationSwitch.setOn(false, animated: true)
                }
            }
        }
    }
    
    func scheduleTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Test"
        content.body = "Notifications are enabled."
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - TableView Delegates

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == sideMenuTableView ? menuItems.count : viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == sideMenuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "menu", for: indexPath)
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = menuItems[indexPath.row]
            if indexPath.row == 2 {
                cell.accessoryView = notificationSwitch
            }
            return cell
        }
        let item = viewModel.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = item.name
        cell.backgroundColor = .white
        return cell
    }
    
    // Swipe to Delete
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let item = viewModel.items[indexPath.row]
//            viewModel.deleteItem(item)
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == sideMenuTableView {
            toggleSideMenu()
            guard let pdfURL = URL(string: Constants.pdfUrl) else {
                print("PDF not found")
                return
            }
            switch indexPath.row {
            case 0:
                navigationController?.pushViewController(PDFViewerViewController(pdfURL: pdfURL), animated: true)
            case 1:
                navigationController?.pushViewController(ImagePickerViewController(), animated: true)
            default:
                break
            }
        }
    }
    
    // MARK: - Swipe to Delete with Alert Confirmation

       func tableView(_ tableView: UITableView,
                      trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
       -> UISwipeActionsConfiguration? {

           let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in

               guard let self = self else { return }

               // Show confirmation alert
               let alert = UIAlertController(title: "Confirm Delete",
                                             message: "Are you sure you want to delete \"\(self.viewModel.items[indexPath.row].name ?? "")\"?",
                                             preferredStyle: .alert)

               alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                   completionHandler(false)
               }))

               alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                   let item = self.viewModel.items[indexPath.row]
                   self.viewModel.deleteItem(item)
                   DispatchQueue.main.async {
                       self.tableView.reloadData()
                   }
                   completionHandler(true)
               }))

               self.present(alert, animated: true)
           }

           return UISwipeActionsConfiguration(actions: [deleteAction])
       }
}
