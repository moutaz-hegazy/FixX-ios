import UIKit
import Photos
import iOSDropDown

class CustomizeOrderViewController:
        UIViewController,
        UINavigationControllerDelegate,
        UIImagePickerControllerDelegate,
        UICollectionViewDelegate,
        UICollectionViewDataSource,
        UICollectionViewDelegateFlowLayout{
    

    //Order details
    var orderLocation: String?
    var orderImages: [UIImage]?
    var orderDate: String?
    var orderStartTime: String?
    var orderEndTime: String?
    var orderDescription: String?
    
    
    var imagePickerController = UIImagePickerController()
    var datePicker: UIDatePicker?
    var startTimePicker: UIDatePicker?
    var endTimePicker: UIDatePicker?
    

    //outlets
    @IBOutlet weak var selectLocationMenu: DropDown!
    @IBOutlet weak var imageAdder: UIImageView!
    @IBOutlet weak var orderImagesCollectionView: UICollectionView!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var startTimeButton: UIButton!
    @IBOutlet weak var endTimeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var selectTechnicianButton: UIButton!
    @IBOutlet weak var publishOrderButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLocationMenu.optionArray = ["Alexandria", "Cairo", "Suez", "Luxor", "Aswan"]
        selectLocationMenu.optionIds = [1,2,3,4,5]
        orderImages = [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]
        //        selectLocationMenu.didSelect{(selectedText, index, id) in
        //            self.valueLabel.text = "Selected String: \(selected)"
        //        }
        imagePickerController.delegate = self
        let tapImageAdder = UITapGestureRecognizer(target: self, action: #selector(CustomizeOrderViewController.imageTapped(gesture:)))
        imageAdder.addGestureRecognizer(tapImageAdder)
        imageAdder.isUserInteractionEnabled = true
        
        
        //        let holdToDelete = UITapGestureRecognizer(target: self, action: #selector(CustomizeOrderViewController.displayDeleteImageActionSheet))
        //        if(orderImages != nil){
        //            for image in orderImages!{
        //            }
        //        }
        
        
        let holdImageToDelete = UILongPressGestureRecognizer(target: self, action: #selector(handleHoldToDelete(gestureRecognizer:)))
           holdImageToDelete.minimumPressDuration = 0.5
           //holdImageToDelete.delegate = self
           holdImageToDelete.delaysTouchesBegan = true
           orderImagesCollectionView?.addGestureRecognizer(holdImageToDelete)
        
        
        checkImagePermissions()
    }
    
    
    @objc func handleHoldToDelete(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {return}
        let position = gestureRecognizer.location(in: orderImagesCollectionView)
        if let indexPath = orderImagesCollectionView?.indexPathForItem(at: position) {
            print("Long press at item: \(indexPath.row)")
            displayDeleteImageActionSheet(position: indexPath.row)
        }
    }
    
    
    
    
    @objc func displayDeleteImageActionSheet(position:Int){
        let optionsMenu = UIAlertController(title: "Action Required", message: "Delete this image?", preferredStyle: .alert)
        let chooseDeleteAction = UIAlertAction(title: "Ok", style: .default){_ in
            DispatchQueue.main.async {
                self.orderImages?.remove(at: position)
                self.orderImagesCollectionView?.reloadData()
            }}
        let chooseCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionsMenu.addAction(chooseDeleteAction)
        optionsMenu.addAction(chooseCancelAction)
        self.present(optionsMenu, animated: true, completion: nil)
    }
    
    

    
    //Mark: Image adding functions
    @objc func imageTapped(gesture: UITapGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            displayActionSheet()
        }
    }
    
    
    
    
    //Mark: Image adding functions
    func displayActionSheet(){
        //Since Simulator has no camera, app crashes and an exception is thrown...
        //Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: 'Source type 1 not available'
        let optionsMenu = UIAlertController(title: "Action Required", message: "Add images via", preferredStyle: .actionSheet)
        let chooseCameraAction = UIAlertAction(title: "Camera", style: .default){_ in self.openCamera()}
        let choosePhotosAction = UIAlertAction(title: "Photos", style: .default){_ in self.openPhotos()}
        let chooseCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //let cameraIcon = UIImage(named: "ios_camera.png")
        //let photosIcon = UIImage(named: "ios_photos.png")
        //chooseCameraAction.setValue(cameraIcon?.withRenderingMode(.alwaysOriginal), forKey: "camera")
        //chooseCameraAction.setValue(photosIcon?.withRenderingMode(.alwaysOriginal), forKey: "photos")
        optionsMenu.addAction(chooseCameraAction)
        optionsMenu.addAction(choosePhotosAction)
        optionsMenu.addAction(chooseCancelAction)
        self.present(optionsMenu, animated: true, completion: nil)
    }
    
    
    
    
    //Mark: Image adding functions
    func checkImagePermissions(){
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization({(status: PHAuthorizationStatus) -> Void in ()
            })
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            //Nothing to do here
        }else{
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    
    
    
    //Mark: Image adding functions
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("AUTHORZIED")
        }else{
            print("NOT AUTHORZIED")
        }
    }
    
    
    
    
    //Mark: Image adding functions
    func openCamera(){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    
    
    
    //Mark: Image adding functions
    func openPhotos(){
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if imagePickerController.sourceType == .camera{
            var cameraImage = UIImage()
            cameraImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
            orderImages?.append(cameraImage)
        }else{
            var galleryImage = UIImage()
            galleryImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            orderImages?.append(galleryImage)
        }
        self.orderImagesCollectionView.reloadData()
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderImages?.count ?? 0
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.attachedImage.image = orderImages?[indexPath.row] as? UIImage
        //cell.addSubview(attachedImage)
        cell.attachedImage.contentMode = UIView.ContentMode.scaleAspectFit
        return cell
    }
    
    
    
    
    //Mark: Date picker
    @IBAction func pickDate(_ sender: UIButton) {
        showDatePicker()
        print("Date is selected")
    }
    
    
    
    
    //Mark: Time picker
    @IBAction func pickStartTime(_ sender: UIButton) {
        showStartTimePicker()
        print("Start time is set")
    }
    
    
    
    
    //Mark: Time picker
    @IBAction func pickEndTime(_ sender: UIButton) {
        showEndTimePicker()
        print("End time is set")
    }
    
    
    
    
    //Mark: Date picker
    func showDatePicker(){
        datePicker = UIDatePicker()
        let datePickerSize: CGSize = datePicker!.sizeThatFits(CGSize.zero)
        datePicker?.date = Date()
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = Date()
        datePicker?.locale = .current
        datePicker?.backgroundColor = UIColor.white
        datePicker?.frame = CGRect(x: 10.0, y: 350.0, width:self.view.frame.width, height: datePickerSize.height)
        datePicker?.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        self.view.addSubview(datePicker!)
    }
    
    
    
    
    //Mark: Date picker
    @objc func dueDateChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let selectedDate = dateFormatter.string(from: sender.date)
        print(selectedDate)
        dateLabel.text = selectedDate
        datePicker?.isHidden = true
    }
    
    
    
    
    //Mark: Time picker
    func showStartTimePicker(){
        startTimePicker = UIDatePicker()
        let timePickerSize: CGSize = startTimePicker!.sizeThatFits(CGSize.zero)
        startTimePicker?.datePickerMode = .time
        startTimePicker?.locale = .current
        startTimePicker?.backgroundColor = UIColor.white
        startTimePicker?.frame = CGRect(x: 10.0, y: 350.0, width:self.view.frame.width, height: timePickerSize.height)
        startTimePicker?.addTarget(self, action: #selector(dueStartTimeChanged(sender:)), for: .valueChanged)
        self.view.addSubview(startTimePicker!)
    }
    
    
    
    
    //Mark: Time picker
    @objc func dueStartTimeChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeStyle = .short
        let selectedStartTime = dateFormatter.string(from: sender.date)
        print(selectedStartTime)
        startTimeLabel.text = selectedStartTime
        startTimePicker?.isHidden = true
    }
    
    
    
    
    //Mark: Time picker
    func showEndTimePicker(){
        endTimePicker = UIDatePicker()
        let timePickerSize: CGSize = endTimePicker!.sizeThatFits(CGSize.zero)
        endTimePicker?.datePickerMode = .time
        endTimePicker?.locale = .current
        endTimePicker?.backgroundColor = UIColor.white
        endTimePicker?.frame = CGRect(x: 10.0, y: 350.0, width:self.view.frame.width, height: timePickerSize.height)
        endTimePicker?.addTarget(self, action: #selector(dueEndTimeChanged(sender:)), for: .valueChanged)
        self.view.addSubview(endTimePicker!)
    }
    
    
    
    
    //Mark: Time picker
    @objc func dueEndTimeChanged(sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.timeStyle = .short
        let selectedEndTime = dateFormatter.string(from: sender.date)
        print(selectedEndTime)
        endTimeLabel.text = selectedEndTime
        endTimePicker?.isHidden = true
    }
    
    
    
    
    @IBAction func selectTechnician(_ sender: UIButton) {
        print("Select Technician")
    }
    
    
    
    @IBAction func publishOrder(_ sender: UIButton) {
        print("Publish Order")
        getOrderData()
    }
    
    
    func getOrderData(){
        orderLocation = selectLocationMenu.text
        orderDate = dateLabel.text
        orderStartTime = startTimeLabel.text
        orderEndTime = endTimeLabel.text
        orderDescription = descriptionTextField.text
        print(orderLocation!)
        print(orderDate!)
        print(orderStartTime!)
        print(orderEndTime!)
        print(orderDescription!)
    }
}


