//
//  ViewController.swift
//  ImageStrech
//
//  Created by 庞首伟 on 2020/7/30.
//  Copyright © 2020 因未来. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        
        let image = UIImage(named: "guoqing")
        var strech1 = ImageStrecher.StrechRange()
        strech1.cropFrom = 50
        strech1.croplength = 1
        strech1.renderLength = 201
        let diff1 = strech1.renderLength-strech1.croplength

        
        var strech2 = ImageStrecher.StrechRange()
        strech2.cropFrom = 520
        strech2.croplength = 1
        strech2.renderLength = 300
        let diff2 = strech2.renderLength-strech2.croplength
        
//        var strech3 = ImageStrecher.StrechRange()
//        strech3.cropFrom = 1000
//        strech3.croplength = 1
//        strech3.renderLength = 300
//        let diff3 = strech3.renderLength-strech3.croplength
        
        let width: CGFloat = 300
        let height = width*(2208.0+diff1+diff2)/1208.0
        let strectImage = ImageStrecher().strech(image: image!, streches: [strech1, strech2], direction: .vertical)
        imageView.frame = CGRect(x: 40, y: 100, width: width, height: height)
        imageView.image = strectImage

        view.addSubview(imageView)
        
        let button = UIButton()
        button.setTitle("跳转", for: .normal)
        button.backgroundColor = .purple
        view.addSubview(button)
        button.frame = CGRect(x: 100, y: imageView.frame.maxY+50, width: 100, height: 40)
        button.addTarget(self, action: #selector(tapJump), for: .touchUpInside)
        
        
    }

    
    @objc private func tapJump() {
        navigationController?.pushViewController(ViewController(), animated: true)
    }

}

