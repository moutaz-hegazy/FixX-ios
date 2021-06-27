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
    
    var jobType : String?

    //Order details
    private var orderLocation: String?
    private var orderImages = [UIImage]()
    private var orderImagesUrls = [URL]()
    private var orderDate: String?
    private var orderStartTime: String?
    private var orderEndTime: String?
    private var orderDescription: String?
    
    
    private var imagePickerController = UIImagePickerController()
    private var datePicker: UIDatePicker?
    private var startTimePicker: UIDatePicker?
    private var endTimePicker: UIDatePicker?
    
    private lazy var currentDate : String = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("dd-MMM-yyyy")
        var datetime = formatter.string(from: Date())
        datetime.remove(at: datetime.firstIndex(of: ".")!)
        return datetime.replacingOccurrences(of: " ", with: "-")
    }()
    

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
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectLocationMenu.optionArray = getUserLocations()
        selectLocationMenu.optionArray += ["Add New location"]
        
        orderDate = getDateStringFormatted(for: Date())
        
        selectLocationMenu.didSelect { (loc, index, id) in
            if(index == self.selectLocationMenu.optionArray.count-1){
                if let addAddressVC = UIStoryboard(name: "AddAddress", bundle: nil)
                    .instantiateViewController(identifier: "addAddressVC")
                as? AddAddressViewController{
                    addAddressVC.onAddressAddedHandler = {
                        [weak self](address) in
                        self?.orderLocation = address
                        let subString = String(address[..<address.firstIndex(of: "%")!])
                        if(subString.isEmpty){
                            let loc = String(address[address.index(after: address.firstIndex(of: "%")!)...])
                            self?.selectLocationMenu.optionArray.insert(loc, at: (self?.selectLocationMenu.optionArray.count ?? 1) - 1)
                            self?.selectLocationMenu.text = loc
                        }else{
                            self?.selectLocationMenu.optionArray.insert(subString, at: (self?.selectLocationMenu.optionArray.count ?? 1) - 1)
                            self?.selectLocationMenu.text = subString
                        }
                    }
                    addAddressVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(addAddressVC, animated: true)
                }
            }else{
                self.orderLocation = HomeScreenViewController.USER_OBJECT?.locations?[index]
            }
        }

        imagePickerController.delegate = self
        let tapImageAdder = UITapGestureRecognizer(target: self, action: #selector(CustomizeOrderViewController.imageTapped(gesture:)))
        imageAdder.addGestureRecognizer(tapImageAdder)
        imageAdder.isUserInteractionEnabled = true
        
        navBarItem.title = "\(jobType!) Request"
        
        
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
                self.orderImages.remove(at: position)
                self.orderImagesCollectionView?.reloadData()
            }}
        let chooseCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionsMenu.addAction(chooseDeleteAction)
        optionsMenu.addAction(chooseCancelAction)
        self.present(optionsMenu, animated: true, completion: nil)
    }
    
    
    private func getUserLocations() -> [String]{
        return HomeScreenViewController.USER_OBJECT?.locations?.map({ (address)-> String in
            let subString = String(address[..<address.firstIndex(of: "%")!])
            if(subString.isEmpty){
                let loc = String(address[address.index(after: address.firstIndex(of: "%")!)...])
                return loc
            }else{
                return subString
            }
        }) ?? []
    }

    
    //MARK: -Image adding functions
    @objc func imageTapped(gesture: UITapGestureRecognizer){
        if (gesture.view as? UIImageView) != nil{
            displayActionSheet()
        }
    }
    
    
    
    
    //Mark: Image adding functions
    func displayActionSheet(){
        let optionsMenu = UIAlertController(title: "Action Required", message: "Add images via", preferredStyle: .actionSheet)
        let chooseCameraAction = UIAlertAction(title: "Camera", style: .default){_ in self.openCamera()}
        let choosePhotosAction = UIAlertAction(title: "Photos", style: .default){_ in self.openPhotos()}
        let chooseCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
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
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            present(imagePicker, animated: true)
        }else{
            print("NO CAMERA !!")
        }
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
            let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
            orderImagesUrls += [imgUrl]
            orderImages.append(cameraImage)
        }else{
            var galleryImage = UIImage()
            galleryImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as! URL
            orderImagesUrls += [imgUrl]
            
            orderImages.append(galleryImage)
        }
        self.orderImagesCollectionView.reloadData()
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return orderImages.count
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCell
        cell.attachedImage.image = orderImages[indexPath.row]
        cell.attachedImage.contentMode = UIView.ContentMode.scaleAspectFit
        return cell
    }
    
    
    
    
    //Mark: Date picker
    @IBAction func pickDate(_ sender: UIButton) {
        showDatePicker(from : sender)
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
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        
        presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    //Mark: Date picker
    func showDatePicker(from inview: UIView ){
        datePicker = UIDatePicker()
        //let datePickerSize: CGSize = view.bounds.size //datePicker!.sizeThatFits(CGSize.zero)
        datePicker?.date = Date()
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = Date()
        datePicker?.locale = .current
        datePicker?.backgroundColor = UIColor.white
        datePicker?.frame = CGRect(origin: inview.frame.origin, size: inview.frame.size)
        datePicker?.addTarget(self, action: #selector(dueDateChanged(sender:)), for: .valueChanged)
        self.view.addSubview(datePicker!)
    }
    
    
    
    
    //Mark: Date picker
    @objc func dueDateChanged(sender: UIDatePicker){
        let dateForm = getDateStringFormatted(for: sender.date)
        dateLabel.text = dateForm
        orderDate = dateForm
        datePicker?.isHidden = true
        print(dateForm)
    }
    
    private func getDateStringFormatted(for date: Date) -> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "nl_NL")
        formatter.setLocalizedDateFormatFromTemplate("dd-MMM-yyyy")
        var datetime = formatter.string(from: date)
        datetime.remove(at: datetime.firstIndex(of: ".")!)
        let dateForm = datetime.replacingOccurrences(of: " ", with: "-")
        return dateForm
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
        dateFormatter.dateFormat = "hh:mm"
        dateFormatter.timeStyle = .short
        let selectedStartTime = dateFormatter.string(from: sender.date)
        print(selectedStartTime)
        startTimeLabel.text = selectedStartTime
        orderStartTime = selectedStartTime
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
        orderEndTime = selectedEndTime
        endTimePicker?.isHidden = true
    }
    
    
    
    
    @IBAction func selectTechnician(_ sender: UIButton) {
        print("Select Technician")
        let job = getOrderData(isPrivate: true)
        if let showTechsVC = UIStoryboard(name: "ShowTechnicianScreenStoryboard", bundle: nil).instantiateViewController(identifier: "showTechVC") as? ShowTechnicianTableViewController{
            
            showTechsVC.job = job
            showTechsVC.orderImagesUrls = orderImagesUrls
            showTechsVC.onTechSelectedHandler = {
                self.presentingViewController?.dismiss(animated: true, completion:  nil)
            }
            
            navigationController?.pushViewController(showTechsVC, animated: true)
        }
    }
    
    
    
    @IBAction func publishOrder(_ sender: UIButton) {
        let job = getOrderData(isPrivate: false)
        if job != nil{
            
            publishOrderButton.isHidden = true
            selectTechnicianButton.isHidden = true
            activitySpinner.isHidden = false
            activitySpinner.startAnimating()
            uploadJob(job: job!)
        }
    }
    
    private func uploadJob(job : Job){
        if orderImagesUrls.isEmpty{
            FirestoreService.shared.saveJobDetails(job: job) { (jobData) in
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            } onFailHandler: {
                
            }
            
        }else{
            var imagesLinks = [StringPair]()
            for url in orderImagesUrls{
                FirestoreService.shared.uploadImagsToStorage(url) { [weak self](imagePair) in
                    imagesLinks += [imagePair]
                    if(imagesLinks.count == self?.orderImagesUrls.count ?? 0){
                        
                        job.images = imagesLinks
                        FirestoreService.shared.saveJobDetails(job: job) { (job) in
                            self?.presentingViewController?.dismiss(animated: true, completion: nil)
                            
                        } onFailHandler: {
                            
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    
    func getOrderData(isPrivate : Bool)-> Job?{
        if let date = dateLabel.text, !date.isEmpty{
            orderDate = date
        }
        orderStartTime = startTimeLabel.text
        orderEndTime = endTimeLabel.text
        orderDescription = descriptionTextField.text
        
        if(orderLocation != nil){
            let job = Job(uid: HomeScreenViewController.USER_OBJECT?.uid, type: jobType!, location: orderLocation, status: "OnRequest", jobId: "", description: descriptionTextField.text ?? "", date: orderDate ?? currentDate, completionDate: "", fromTime: orderStartTime, toTime: orderEndTime, price: nil, techID: nil, bidders: nil, images: nil, privateRequest: isPrivate)
            return job
        }
        return nil
    }
}


