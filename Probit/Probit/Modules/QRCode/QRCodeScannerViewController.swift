
import UIKit
import AVFoundation

class QRCodeScannerViewController: BaseViewController {
    @IBOutlet private var permissionView: UIView!
    @IBOutlet private weak var contentScanView: UIView!
    @IBOutlet weak var qrCodeTitle: UILabel!
    @IBOutlet weak var scanQrCodeLabel: UILabel!
    @IBOutlet weak var allowCameraButton: StyleButton!
    @IBOutlet weak var inputAddressLabel: UnderlinedLabel!
    @IBOutlet private var scanView: UIView!
    @IBOutlet private var scanAreaView: CornerView!
    @IBOutlet private var noticeText: UILabelPadded!
    @IBOutlet private var errorText: UILabel!
    
    // MARK: - Properties
    var presenter: ViewToPresenterQRCodeScannerProtocol?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    private let captureMetadataOutput = AVCaptureMetadataOutput()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var completeScan: ((String) -> Void)?
    
    override func viewDidLoad() {
        view.layoutIfNeeded()
        scanView.layoutIfNeeded()
        contentScanView.layoutIfNeeded()
        scanAreaView.layoutIfNeeded()
        scanAreaView.layoutSubviews()
        
        super.viewDidLoad()
        errorText.isHidden = true
        checkPermission()
        NotificationCenter.default.addObserver(self, selector:#selector(self.didChangeCaptureInputPortFormatDescription(notification:)), name: NSNotification.Name.AVCaptureInputPortFormatDescriptionDidChange, object: nil)
    }
    
    override func setupUI() {
        setupNavigationBar(title: "QR Code", titleLeftItem: "Address")
        addRightBarItem(imageName: "", imageTouch: "", title: "Cancel")
        errorText.text = "qrcode_unsupported".Localizable()
        inputAddressLabel.addTapGesture(action: {
            self.presenter?.popToReview()
        })
    }
    
    
    private func setAutofocus() {
//        guard  let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
//        guard let input = try? AVCaptureDeviceInput.init(device: captureDevice) else { return }
//
//
//        do {
//            try captureDevice.lockForConfiguration()
//            if captureDevice.isFocusPointOfInterestSupported {
//                captureDevice.focusPointOfInterest = focusPoint
//                captureDevice.focusMode = AVCaptureDevice.FocusMode.autoFocus
//            }
//
//            if captureDevice.isExposurePointOfInterestSupported {
//               captureDevice.exposurePointOfInterest = focusPoint
//                captureDevice.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
//            }
//            captureDevice.unlockForConfiguration()
//        }
//        catch {
//            // just ignore
//        }

    }
    
    private func configScanner() {
        guard  let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard let input = try? AVCaptureDeviceInput.init(device: captureDevice) else { return }
        
        captureSession = AVCaptureSession()
        captureSession?.addInput(input)
        captureSession?.addOutput(captureMetadataOutput)
        
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        captureMetadataOutput.metadataObjectTypes = [.qr, .pdf417]
        
        
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        view.bringSubviewToFront(scanView)
        startScan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScan()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func localizedString() {
        noticeText.text = "• \("activity_qrcode_detection".Localizable())"
        inputAddressLabel.text = "dialog_camera_permission_cancel".Localizable()
        qrCodeTitle.text = "fragment_withdrawal_address_qrscan".Localizable()
        scanQrCodeLabel.text = "dialog_camera_permission_content".Localizable()
        allowCameraButton.setTitle("dialog_camera_permission_allowcamerapermission".Localizable(), for: .normal)
    }
    
    private func checkPermission() {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            permissionView.isHidden = true
            scanView.isHidden = false
            configScanner()
            self.hideNavigationBar(isHide: false)
        } else {
            self.hideNavigationBar()
            permissionView.isHidden = false
            scanView.isHidden = true
        }
    }
    
    private func startScan() {
        if (captureSession?.isRunning == false) {
            DispatchQueue.global(qos: .background).async {
                self.captureSession?.commitConfiguration()
                self.captureSession?.startRunning()
            }
        }
    }
    
    override func tappedRightBarButton(sender: UIButton) {
        presenter?.popToReview()
    }
    
    override func viewDidLayoutSubviews() {
        super.didLayoutSubviews()
        self.reDrawCaptureView()
    }
    
    @IBAction func requestCameraPermission(_ sender: Any) {
        proceedWithCameraAccess(identifier: "")
    }
    
    func reDrawCaptureView() {
        self.view.layoutIfNeeded()
        let holePos = CGRect(x: scanAreaView.frame.origin.x + 1,
                             y: scanAreaView.frame.origin.y + 1,
                             width: scanAreaView.frame.width - 2,
                             height: scanAreaView.frame.height - 2)
        
        scanView.makeClearHole(rect: holePos)
        
        if let videoPreviewLayer = videoPreviewLayer {
            captureMetadataOutput.rectOfInterest = videoPreviewLayer.metadataOutputRectConverted(fromLayerRect: scanAreaView.frame)
        }
    }
    
    private func proceedWithCameraAccess(identifier: String){
        AVCaptureDevice.requestAccess(for: .video) { success in
            if success {
                DispatchQueue.main.async {
                    self.hideNavigationBar(isHide: false)
                    self.permissionView.isHidden = true
                    self.scanView.isHidden = false
                    self.configScanner()
                    self.startScan()
                }
            } else {
                let alert = UIAlertController(title: "Camera", message: "Camera access is absolutely necessary to use this app", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }))
                DispatchQueue.main.async {
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideNavigationBar(isHide: false)
        
        if (captureSession?.isRunning == true) {
            captureSession?.stopRunning()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @objc func didChangeCaptureInputPortFormatDescription(notification: NSNotification) {
        if let metadataOutput = self.captureSession?.outputs.last as? AVCaptureMetadataOutput,
           let rect = self.videoPreviewLayer?.metadataOutputRectConverted(fromLayerRect: self.scanAreaView.frame) {
            metadataOutput.rectOfInterest = rect
        }
    }
}

extension QRCodeScannerViewController: PresenterToViewQRCodeScannerProtocol{
    // TODO: Implement View Output Methods
}

extension QRCodeScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        if let metadataObject = metadataObjects.first, let completion = self.completeScan {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            completion(stringValue)
        }
        navigationController?.popViewController(animated: true)
    }
}
