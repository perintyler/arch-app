import Foundation
import UIKit
import SkyFloatingLabelTextField

// rename to create event controller
class CreateEventController: UIViewController {
    
    var input_info = [String: Any]()
    
    let uploadImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.white
        label.font = UIFont.Theme.smallTitleLabel
        label.text = "Add a Cover Image"
        label.textAlignment = .center
        return label
    }()
    
    let imgView: UIImageView = {
        let image_view = UIImageView()
        image_view.translatesAutoresizingMaskIntoConstraints = false
        image_view.isUserInteractionEnabled = true
        image_view.clipsToBounds = true
        image_view.image = UIImage(named: "plus")?.withRenderingMode(.alwaysTemplate)
        image_view.tintColor = UIColor.Theme.teal
        image_view.contentMode = .scaleAspectFit
        return image_view
    }()
    
    let descField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter a description"
        textField.font = UIFont(name: "HelveticaNeue", size: 20)
        textField.textColor = UIColor.white
        textField.title = "description"
        return textField
    }()

    let nameField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "HelveticaNeue", size: 20)
        textField.textColor = UIColor.white
        textField.placeholder = "Enter a name"
        textField.title = "name"
        return textField
    }()
    
    let next_button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(CreateEventController.create_event), for: .touchUpInside)
        button.backgroundColor = UIColor.Theme.green
        button.setTitle("Create Event", for: .normal)
        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        button.titleLabel!.textColor = UIColor.white
        button.roundCorners(radius: 16)
        return button
    }()
    
    let imageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.edgesForExtendedLayout = []

        self.view.backgroundColor = UIColor.Theme.gray
        self.nameField.delegate = self
        self.descField.delegate = self
        
        self.imgView.addGestureRecognizer(UITapGestureRecognizer(target: self,action: #selector(uploadImageForGroup)))
    }
    
    private func navigate_to_event(_ event: Event) {
        let eventController = EventController()
        eventController.event = event
        self.navigationController?.pushViewController(eventController, animated: true)
    }
    
    @objc func create_event(){
        
        // check to see if the inputted data is valid
        if (self.nameField.text?.count == 0) {
            self.alert_invalid_input()
            return
        }

        // set all the post fields in input_info
        self.input_info["name"] = self.nameField.text!
        
        // only store the description if it's not nil and not an empty string
        if let desc = self.descField.text, desc.isEmpty == false {
            self.input_info["desc"] = desc
        }
        
        // get image if it exists and remove it from the input info that gets sent to rest api
        let event_image: UIImage?  = self.input_info.removeValue(forKey: "image") as? UIImage
        
        // set a value to let the back-end know if the event has a custom image
        self.input_info["has_image"] = event_image != nil

        // show indicator and shut off user interaction before make rest call
        let indicator = self.show_and_get_indicator()
        
        // create the event with the input fields
        Event.create(fields: self.input_info) { event in
            
            // if there is an image, upload it to firebase storage
            if let image = event_image {
                // upload the image to firebase storage which can be retrieved later with an event id
                upload_image(image, path: "event", file_name: "\(event.id)")
            }
            

            DispatchQueue.main.async {

                // create an event controller using the created event
                let eventController = EventController()
                eventController.event = event
                
                // stop indicating, then go to the new event page
                self.stop_indicating(indicator: indicator)
                self.navigationController?.pushViewController(eventController, animated: true)
            }
        }
        
    }
    
    /*
     * Alert the user that their inputted event information is valid. The only non-optional
     * field is the name field
     */
    private func alert_invalid_input() {
        let alertController = UIAlertController(title: "Invalid Name", message: "Please insert a group name", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(action)
        self.present(alertController,animated: true,completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let image_container = UIView()
        image_container.layer.borderColor = UIColor.Theme.darkGray.cgColor
        image_container.layer.borderWidth = 2
        image_container.layer.cornerRadius = 8
        image_container.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubviews(self.uploadImageLabel, self.nameField, self.descField, self.next_button, image_container, self.imageLabel)
        
        self.view.addConstraintsWithFormat(format: "V:|-74-[v0]-30-[v1(120)]-50-[v2(50)]-20-[v3(50)]", views: self.imageLabel, image_container, self.nameField, self.descField)
        self.view.addConstraintsWithFormat(format: "V:[v0]-[v1]", views: self.uploadImageLabel, image_container)

        self.view.addConstraintsWithFormat(format: "V:[v0(65)]-|", views: self.next_button)
        
        self.view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: self.nameField)
        self.view.addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: self.descField)
        self.view.addConstraintsWithFormat(format: "H:[v0(120)]", views: image_container)
        self.view.centerHorizontally(child: image_container)
        self.view.centerHorizontally(child: self.imageLabel)
        self.view.centerHorizontally(child: self.uploadImageLabel)
        self.view.addConstraintsWithFormat(format: "H:|-[v0]-|", views: self.next_button)
        
        
        image_container.addSubview(self.imgView)
        image_container.addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: self.imgView)
        image_container.addConstraintsWithFormat(format: "V:|-16-[v0]-16-|", views: self.imgView)
    }
}


/*
 * This allows the keyboard to be closed when return or anywhere outside the keyboard area
 * is pressed
 */
extension CreateEventController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

/*
 * This is where the code is for custom image picking from photos
 */
extension CreateEventController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func uploadImageForGroup(){
        let picker = UIImagePickerController()
        picker.delegate = self
        
        picker.allowsEditing = true
        
        self.present(picker,animated: true,completion: nil)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = editedImage as? UIImage
        }else if let originalImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            DispatchQueue.main.async {
                self.imgView.image = selectedImage
                self.input_info["image"] = selectedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
}



