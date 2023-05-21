//
//  TakeAPhotoViewController.swift
//  Probit
//
//  Created by Đào Mỹ Đông on 07/11/2565 BE.
//  
//

import Foundation
import AVFoundation
import UIKit

class TakeAPhotoViewController: BaseViewController {
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var actionContentView: UIView!
    @IBOutlet weak var cardBannerLabel: UILabel!
    @IBOutlet weak var takeAPhotoBtn: UIButton!
    @IBOutlet weak var scanView: UIView!
    @IBOutlet weak var marginLeftDes: NSLayoutConstraint!
    @IBOutlet weak var marginRightDes: NSLayoutConstraint!
    @IBOutlet weak var descripsStack: UIStackView!
    @IBOutlet weak var descripsView: UIView!
    
    //Camera Capture requiered properties
    var scannerOverlayPreviewLayer: ScannerOverlayPreviewLayer?
    var photoDataOutput: AVCapturePhotoOutput!
    var videoDataOutputQueue: DispatchQueue!
    var previewLayer: ScannerOverlayPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var session: AVCaptureSession?
    var stylePhoto: StylePhoto?

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopCamera()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCamera()
        guard let stylePhoto = stylePhoto else { return }
        switch stylePhoto {
        case .FACE:
            return
        case .CARD(let cardType):
            if cardType == .ID_CARD_BACK_SIDE || cardType == .DRIVING_BACK_LICENSE {
                let guideView = GuideView()
                guideView.showGuideVC(title: "kyc_capturebackguide_title".Localizable(),
                                        message: "kyc_capturebackguide_content".Localizable(),
                                        image: cardType.image,
                                      titleButton: "dialog_continue".Localizable(),
                                        onNextAction: {
                    guideView.removeToWindow()
                })
            }
        }
    }
    
    // MARK: - Properties
    var presenter: ViewToPresenterTakeAPhotoProtocol?
    
    override func setupUI() {
        setupNavigationBar(title: "globalkyc_title".Localizable(),
                           titleLeftItem: "navigationbar_settings".Localizable())
        takeAPhotoBtn.setTitle("", for: .normal)
        takeAPhotoBtn.borderWidth = 5
        takeAPhotoBtn.borderColor = UIColor(hexString: "#A39BDE")
        takeAPhotoBtn.backgroundColor = UIColor(hexString: "#4231C8")
        descripsView.backgroundColor = UIColor(hexString: "#222222").withAlphaComponent(0.5)
        descripsView.isHidden = true
    }
    
    override func localizedString() {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        cardBannerLabel.text = "globalkyc_cameracapture_idcapturedirection".Localizable()
        switch stylePhoto {
        case .FACE:
            cardBannerLabel.isHidden = true
            descripsStack.addArrangedSubview(BulletedListView(photoDescripstion: "globalkyc_capturereview_confirmcaptured_subtitle_selfie".Localizable(),
                                                              icon: UIImage(named: "ico_user")))
            descripsStack.addArrangedSubview(BulletedListView(photoDescripstion: "globalkyc_cameracapture_hint3".Localizable(), icon: UIImage(named: "ico_lighning")))
            marginRightDes.constant = 40
            marginLeftDes.constant = 40
        default:
            descripsStack.addArrangedSubview(BulletedListView(photoDescripstion: "globalkyc_cameracapture_hint1".Localizable()))
            descripsStack.addArrangedSubview(BulletedListView(photoDescripstion: "globalkyc_cameracapture_hint2".Localizable()))
            descripsStack.addArrangedSubview(BulletedListView(photoDescripstion: "globalkyc_cameracapture_hint3".Localizable()))
            cardBannerLabel.isHidden = false
            marginRightDes.constant = 16.0
            marginLeftDes.constant = 16.0
        }
    }
    
    @objc override func tappedLeftBarButton(sender : UIButton) {
        self.popToParentView()
    }
    
    func presentCameraSettings() {
        DispatchQueue.main.async {
            PopupHelper.shared.show(viewController: self,
                                    title: "dialog_notice".Localizable(),
                                    message: "globalkyc_capturedocumentviewfinder_permissiondenied".Localizable(),
                                    activeTitle: "dialog_camera_permission_allowcamerapermission".Localizable(),
                                    activeAction: { self.openSetting() },
                                    cancelTitle: nil,
                                    cancelAction: { self.pop(isAnimated: false)},
                                    isCameraView: true)
        }
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            presentCameraSettings()
        case .restricted:
            print("Restricted, device owner must approve")
        case .authorized:
            self.setupAVCapture()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] success in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    if success {
                        self.checkCameraAccess()
                    } else {
                        self.presentCameraSettings()
                    }
                }
            }
        @unknown default:
            return
        }
    }
    
    func openSetting() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: { [weak self] _ in
                guard let self = self else { return }
                self.checkCameraAccess()
            })
        }
    }
    
    @IBAction func doChangeCamera(_ sender: Any) {
        guard let currentCameraInput: AVCaptureInput = session?.inputs.first else {
            return
        }
        //Indicate that some changes will be made to the session
        session?.beginConfiguration()
        session?.removeInput(currentCameraInput)
        
        //Get new input
        var newCamera: AVCaptureDevice! = nil
        if let input = currentCameraInput as? AVCaptureDeviceInput {
            if (input.device.position == .back) {
                newCamera = self.getCamera(with: .front)
            } else {
                newCamera = self.getCamera(with: .back)
            }
        }
        //Add input to session
        var err: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            newVideoInput = try AVCaptureDeviceInput(device: newCamera)
        } catch let err1 as NSError {
            err = err1
            newVideoInput = nil
        }
        if newVideoInput == nil || err != nil {
            print("Error creating capture device input: \(err?.localizedDescription ?? "")")
        } else {
            session?.addInput(newVideoInput)
        }
        
        //Commit all the configuration changes at once
        session?.commitConfiguration()
    }
    
    @IBAction func doTakePhoto(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        settings.livePhotoVideoCodecType = .jpeg
        photoDataOutput.capturePhoto(with: settings, delegate: self)
    }
}

extension TakeAPhotoViewController: AVCapturePhotoCaptureDelegate {
    // TODO: Implement View Output Methods
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            if let error = error {
                print("error occured : \(error.localizedDescription)")
            }
            if let dataImage = photo.fileDataRepresentation() {
                let dataProvider = CGDataProvider(data: dataImage as CFData)
                let cgImageRef: CGImage! = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: .defaultIntent)
                let image = UIImage(cgImage: cgImageRef, scale: 1.0, orientation: .right)
                if let cropImage = cropToPreviewLayer(originalImage: image) {
                    presenter?.uploaImage(image: cropImage)
                }
            } else {
                print("some error here")
            }
        }
}

extension TakeAPhotoViewController: PresenterToViewTakeAPhotoProtocol {
    func pauseCamera() {
        self.session?.stopRunning()
    }
    
    func resumeCamera() {
        self.session?.startRunning()
    }
    
    // TODO: Implement View Output Methods
    func stopCamera(){
        self.session?.inputs.forEach { input in
            self.session?.removeInput(input)
        }
        self.session?.stopRunning()
        self.session = nil
    }
    
    func setupCamera() {
        checkCameraAccess()
    }
    
    func popToParentView() {
        guard let stylePhoto = presenter?.interactor?.stylePhoto else { return }
        switch stylePhoto {
        case .FACE:
            self.navigationController?.popToViewController(ofClass: KycAddressInputViewController.self) { isNavigated in
                if isNavigated { return }
                KycAddressInputRouter().showScreen()
            }
        case .CARD:
            self.navigationController?.popToViewController(ofClass: UploadGovermentViewController.self) { isNavigated in
                if isNavigated { return }
                UploadGovermentRouter().showScreen()
            }
        }
    }
}
 
private extension TakeAPhotoViewController {
    func cropToPreviewLayer(originalImage: UIImage) -> UIImage? {
        guard let cgImage = originalImage.cgImage else { return nil }
        if let outputRect = previewLayer?.metadataOutputRectConverted(fromLayerRect: previewLayer?.maskContainer ?? .zero) {
            let width = CGFloat(cgImage.width)
            let height = CGFloat(cgImage.height)
            let cropRect = CGRect(x: (outputRect.origin.x * width), y: (outputRect.origin.y * height), width: (outputRect.size.width * width), height: (outputRect.size.height * height))
            if let croppedCGImage = cgImage.cropping(to: cropRect) {
                return UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: originalImage.imageOrientation)
            }
            
            
        }
        return nil
    }
    
    func setupAVCapture(){
        guard let stylePhoto = stylePhoto else { return }
        session = AVCaptureSession()
        previewLayer = ScannerOverlayPreviewLayer(session: session!)
        previewLayer?.stylePhoto = stylePhoto
        previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer?.backgroundColor = UIColor(hexString: "#222222").withAlphaComponent(0.5).cgColor

        session?.sessionPreset = AVCaptureSession.Preset.high
        guard let device = AVCaptureDevice
            .default(.builtInWideAngleCamera,
                     for: .video,
                     position: stylePhoto.defaultPoisition) else {
            return
        }
        captureDevice = device
        beginSession()
    }
    
    // clean up AVCapture
    
    
    func beginSession(){
        guard let session = self.session,
        let captureDevice = self.captureDevice,
        let previewLayer = self.previewLayer else { return }
        
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            guard deviceInput != nil else {
                print("error: cant get deviceInput")
                return
            }
            
            if session.canAddInput(deviceInput){
                session.addInput(deviceInput)
            }
            
            photoDataOutput = AVCapturePhotoOutput()
            videoDataOutputQueue = DispatchQueue(label: "VideoDataOutputQueue")
            
            if session.canAddOutput(self.photoDataOutput) {
                session.addOutput(self.photoDataOutput)
            }
            
            let rootLayer: CALayer = self.previewView.layer
            rootLayer.masksToBounds = true
            self.previewLayer?.frame = previewView.bounds
            self.previewLayer?.bottomEdge = view.bounds.height - descripsView.frame.origin.y

            rootLayer.addSublayer(previewLayer)
            videoDataOutputQueue.async { [weak self] in
                self?.session?.startRunning()
                DispatchQueue.main.async {
                    self?.descripsView.isHidden = false
                    self?.actionContentView.isHidden = false
                }
            }
        } catch let error as NSError {
            deviceInput = nil
            print("error: \(error.localizedDescription)")
        }
    }
    
    func getCamera(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDescoverySession = AVCaptureDevice.DiscoverySession.init(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)

            for device in deviceDescoverySession.devices {
                if device.position == position {
                    return device
                }
            }
        return nil
    }
    
    func shopPopupPopToKycIntro() {
        showPopupHelper("globalkyc_activity_closedialog_title".Localizable(),
                        message: "globalkyc_activity_closedialog_content".Localizable(),
                        warning: nil,
                        acceptTitle: "globalkyc_activity_closedialog_confirmbutton".Localizable(),
                        cancleTitle: "globalkyc_activity_closedialog_closebutton".Localizable(),
                        acceptAction: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.popToViewController(ofClass: SettingViewController.self)
        }, cancelAction: nil)
    }
}
