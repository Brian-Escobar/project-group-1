//
//  MQViewController.swift
//  ataglance
//
//  Created by y41 on 3/9/22.
//

import UIKit

class MQViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // initiate MQ db and mgr
        mqMgr = MotivationalQuotesMgr()
        updateQuote()
    }
    
    var mqMgr: MotivationalQuotesMgr?
    @IBOutlet var quoteText: UILabel!
    @IBOutlet var authorText: UILabel!
    @IBOutlet var quoteImage: UIImageView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func pressNextQuote(_ sender: Any) {
        updateQuote()
    }
    
    func updateQuote() {
        mqMgr?.nextQuoteAPI { (info) in
            DispatchQueue.main.async {
                let quote = info?[0]["q"]
                let author = info?[0]["a"]
                self.quoteText.text = (quote as! String)
                self.authorText.text = (author as! String)
                self.mqMgr?.getQuoteImageURL { (info) in
                    DispatchQueue.main.async {
                        if let imgURL = info["urls"] as? NSDictionary {
                            let URL = URL(string: (imgURL["regular"] as! String).components(separatedBy: "?")[0])
                            self.mqMgr?.getQuoteImage(imgURL: URL!) {
                                (image) -> Void in
                                DispatchQueue.main.async {
                                    self.quoteImage.image = image
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}
