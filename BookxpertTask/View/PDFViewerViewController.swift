//
//  PDFViewerViewController.swift
//  BookxpertTask
//
//  Created by Alyx on 10/04/25.
//

import UIKit
import PDFKit

class PDFViewerViewController: UIViewController {
    
    let pdfURL: URL
    
    init(pdfURL: URL) {
        self.pdfURL = pdfURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "WhiteColor")
        setupPDF()
    }
    
    func setupPDF() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            guard let document = PDFDocument(url: self.pdfURL) else {
                print("Failed to load PDF.")
                return
            }
            
            DispatchQueue.main.async {
                let pdfView = PDFView(frame: self.view.bounds)
                pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                pdfView.autoScales = true
                pdfView.document = document
                self.view.addSubview(pdfView)
            }
        }
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
