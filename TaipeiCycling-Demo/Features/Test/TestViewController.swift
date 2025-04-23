//
//  TestViewController.swift
//  TaipeiCycling-Demo
//
//  Created by 鄭勝文 on 2025/4/23.
//

import UIKit
import SwiftUI

struct TestView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TestViewController {
        return TestViewController()
    }

    func updateUIViewController(_ uiViewController: TestViewController, context: Context) {
        // 如果有需要更新資料的話可寫在這裡

    }
}

class TestViewController: UIViewController {

    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblCount: UILabel!

    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func onCliced(_ sender: UIButton) {
        if sender == btnReset{
            count = 0
            lblCount.text = String(count)
        }

        if sender == btnAdd{
            count += 1
            lblCount.text = String(count)
        }
    }
}
