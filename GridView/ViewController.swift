//
//  ViewController.swift
//  GridView
//
//  Created by Taichi Yuki on 2024/04/22.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let vc = GridViewController()
    let nv = UINavigationController(rootViewController: vc)
    nv.modalPresentationStyle = .fullScreen
    present(nv, animated: true)
  }


}

