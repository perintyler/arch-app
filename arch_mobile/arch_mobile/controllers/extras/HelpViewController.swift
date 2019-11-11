import Foundation
import UIKit

class HelpViewController: UIPageViewController, UIScrollViewDelegate {
    
    let scrollView: UIScrollView = {
        let scroll_view = UIScrollView()
        scroll_view.translatesAutoresizingMaskIntoConstraints = false
        scroll_view.isUserInteractionEnabled = false
        return scroll_view
    }()
    
    let pageControl: UIPageControl = {
        let page_control = UIPageControl()
        page_control.translatesAutoresizingMaskIntoConstraints = false
        return page_control
    }()
    
    var onboarding: Bool = false
    
    
    let eventView: Slide = {
        let slide = Slide()
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.header.text = "Create an Event"
        slide.imageView.image = #imageLiteral(resourceName: "event-icon-blue")
        
        let attributedString = NSMutableAttributedString.init(string: "Pick a venue, create an event, and invite your group of friends!")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = 2
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        slide.details.attributedText = attributedString
        
        return slide
    }()
    
    let discountView: Slide = {
        let slide = Slide()
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.header.text = "Reach Discount Tiers"
        slide.imageView.image = UIImage(named: "discount-icon")
        
        
        let attributedString = NSMutableAttributedString.init(string: "Reach discount tiers depending on your group size and the selected venue. The more friends you go out with, the more money you'll save.")

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        slide.details.attributedText = attributedString

        return slide
    }()
    
    let claimDiscount: Slide = {
        let slide = Slide()
        slide.translatesAutoresizingMaskIntoConstraints = false
        slide.header.text = "Claim Discounts"
        slide.imageView.image = UIImage(named: "logo-icon")
        
        
        let attributedString = NSMutableAttributedString.init(string: "Press 'Claim Discount' in your Event page,  then show the bartender your flashing discount ticket to redeem.")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        paragraphStyle.lineSpacing = 2
        
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        slide.details.attributedText = attributedString
        
        return slide
    }()
    
    let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.Theme.green
        button.addTarget(self, action: #selector(HelpViewController.nextSlide), for: .touchUpInside)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("Next", for: .normal)
        return button
    }()
    
    lazy var slides: [Slide] = {
        return [eventView, discountView, claimDiscount]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.Theme.gray
        
        self.setupScrollView()
        self.setupPageControl()
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func setupScrollView() {
        let screen_width = UIScreen.main.bounds.width
        
        let scroll_width = screen_width * CGFloat(self.slides.count)
        self.view.addSubview(self.scrollView)
        self.view.addConstraintsWithFormat(format: "H:|[v0(\(scroll_width))]", views: self.scrollView)
        self.view.addConstraintsWithFormat(format: "V:|[v0]-100-|", views: self.scrollView)

        self.scrollView.showsHorizontalScrollIndicator = false
        
        for i in 0 ..< self.slides.count {
            let slide = self.slides[i]
            self.scrollView.addSubview(slide)
            
            let margin_left: CGFloat = screen_width * CGFloat(i)
            let margin_right = screen_width * CGFloat(slides.count - i) //need to set both margins relative to super view so scroll view knows relative size
            
            self.scrollView.addConstraintsWithFormat(format: "H:|-\(margin_left)-[v0(\(screen_width))]-\(margin_right)-|", views: slide)
            self.scrollView.addConstraintsWithFormat(format: "V:|[v0]|", views: slide)
        }
        
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        
    }
    
    @objc func nextSlide() {
        let page = self.pageControl.currentPage + 1
        let screen_width = UIScreen.main.bounds.width
        let y_scroll_offset = self.scrollView.contentOffset.y
        self.scrollView.contentOffset = CGPoint(x: screen_width * CGFloat(page), y: y_scroll_offset)
        self.pageControl.currentPage = page

        if page == 2 {
            self.nextButton.setTitle("Done", for: .normal)
            self.nextButton.removeTarget(nil, action: nil, for: .allEvents)
            let completionSelector = self.onboarding == true ? #selector(self.navigate_to_tabs) : #selector(self.go_back)
            self.nextButton.addTarget(self, action: completionSelector, for: .touchUpInside)
            self.animate_logo()
        }
    }
    
    @objc func go_back() {
        self.navigationController?.popViewController(animated: true)
    }

    @objc func navigate_to_tabs() {
        // present the tab bar controller
        self.present(TabBarController(), animated: false, completion: nil)
    }
    
    func setupPageControl() {

        self.view.addSubviews(self.pageControl, self.nextButton)
        self.view.addConstraintsWithFormat(format: "V:[v0(20)]-[v1(70)]|", views: self.pageControl, self.nextButton)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.pageControl)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: self.nextButton)

        self.pageControl.numberOfPages = self.slides.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.init(red: 73/255, green: 70/255, blue: 70/255, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = UIColor.init(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    }
    
    //detect when user changes slide
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let screen_width = UIScreen.main.bounds.width
        let pageIndex = round(scrollView.contentOffset.x / screen_width)
        self.pageControl.currentPage = Int(pageIndex)
    }
    
    func animate_logo() {
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat], animations: {
            self.slides[2].imageView.alpha = 0.4
        }, completion: nil)
    }
 
}
