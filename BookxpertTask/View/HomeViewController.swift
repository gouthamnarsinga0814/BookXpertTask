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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Home"
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        // Setup right bar button item
        let pdfIcon = UIImage(systemName: "book")
        let pdfButton = UIBarButtonItem(image: pdfIcon, style: .plain, target: self, action: #selector(openPDF))
        navigationItem.rightBarButtonItem = pdfButton
        
        // Setup left bar button item
        let galleryIcon = UIImage(systemName: "folder.badge.plus")
        let galleryButton = UIBarButtonItem(image: galleryIcon, style: .plain, target: self, action: #selector(openGallery))
        navigationItem.leftBarButtonItem = galleryButton
        
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
    }
    
    @objc func openGallery() {
        let gallery = ImagePickerViewController()
        navigationController?.pushViewController(gallery, animated: true)
    }
    
    @objc func openPDF() {
        guard let pdfURL = URL(string: Constants.pdfUrl) else {
            print("PDF not found")
            return
        }
        
        let pdfVC = PDFViewerViewController(pdfURL: pdfURL)
        navigationController?.pushViewController(pdfVC, animated: true)
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
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
