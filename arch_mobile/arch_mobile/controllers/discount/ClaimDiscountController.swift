import Foundation
import UIKit

class ClaimDiscountController: UIViewController {
    
    var leftEarly: Bool = false
    var discount: Discount!
    var backButton: UIBarButtonItem!
    var event: Event!
    
    var discountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.Theme.hugeTitle
        label.textColor = UIColor.white
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()

    let flashing_logo: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "logo-icon")
        view.alpha = 0
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = []
        self.view.backgroundColor = UIColor.Theme.gray
        self.navigationItem.title = "Claim Discount"
        
        self.setup_back_button()
        self.setup_views()

        self.animate_logo()
        
        self.event.claim(self.discount)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.start_timer()
        self.animate_logo()
    }
    
    private func start_timer() {
        Timer.scheduledTimer(withTimeInterval: 30.0, repeats: false) { _ in
            if(self.leftEarly == false) {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    private func setup_back_button() {
        self.backButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.goBack))
        self.navigationItem.leftBarButtonItem = self.backButton
    }
    
    private func setup_views() {
        self.view.addSubviews(self.flashing_logo, self.discountLabel)
        
//        self.view.addConstraintsWithFormat(format: "H:|-16-[v0(150)]", views: self.flashing_logo)
//        self.view.addConstraintsWithFormat(format: "V:|-16-[v0(150)]", views: self.flashing_logo)
//        self.view.fit(view: self.flashing_logo)
        self.view.fitWidth(subview: self.flashing_logo)
        self.view.centerVertically(child: self.flashing_logo)
        
        self.view.centerHorizontally(child: self.discountLabel)
        self.view.addConstraintsWithFormat(format: "V:|-50-[v0]", views: self.discountLabel)

        self.discountLabel.text = self.discount.formatted_string()
    }
    
    
    @objc func goBack() {
        let alert = UIAlertController(title: nil, message: "Did you claim your discount?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.leftEarly = true
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.popViewController(animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func animate_logo() {
        UIView.animate(withDuration: 1.5, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.flashing_logo.alpha = 0.5
        }, completion: nil)
    }
    
}
