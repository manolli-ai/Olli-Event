//
//  GameViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/13/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
import AVFoundation
import KRProgressHUD
import Speech
import Firebase

class GameViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet var counterLB: UILabel!
    @IBOutlet var stateLB: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var testingButton: UIButton!
    @IBOutlet var totalNumber: UILabel!
    @IBOutlet var headerView : UIView!
    @IBOutlet var redDotLB : UIImageView!
    @IBOutlet var stopBnt : UIButton!
    
    let customHeaderView : CustomHeaderViewViewController = CustomHeaderViewViewController()
    let finishGameView : FinishRecordGameViewController = FinishRecordGameViewController()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let service:Services = Services()
    var record_scripts : [RecordScripts] = []
    var currentRecordScript : RecordScripts = RecordScripts()
    var currenRecordtIndext = 0
    var isRecording = false
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "vi-VN"))
    var audioRecorder: AVAudioRecorder?
    var player : AVAudioPlayer?
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    let audioEngine = AVAudioEngine()
    var timer: Timer!
    var countDown: Int = 0
    var gameAnswers : Int = 0
    var game: Records!
    var mainViewController : ViewController!
    
    let postNotifi = Notification.Name("APPSTATE")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDta()
        self.setupUI()
        self.customHeaderView.parentView = self
        self.subscriptTotalScipt()
        
         NotificationCenter.default.addObserver(self, selector: #selector(updateAppState(notfication:)), name: self.postNotifi, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.countDown = 30
        self.nextButton.isUserInteractionEnabled = true
        self.customHeaderView.mainViewController.currentIndexView = 2
        if(self.record_scripts != nil && self.record_scripts.count == 0) {
            getRecordScrip()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.stateLB.stopBlink()
        self.redDotLB.stopBlink()
        if(isRecording) {
           self.stopRecord(sending: self.stopBnt)
        }
        
        NotificationCenter.default.removeObserver(self, name: self.postNotifi, object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }
    
    @objc func updateAppState(notfication: NSNotification) {
        if(notfication.userInfo![AnyHashable("status")] as! String == "Background") {
            if(isRecording) {
                self.stopRecord(sending: self.stopBnt)
            }
        }
        else {
            
        }
    }
    
    func subscriptTotalScipt() {
        if(self.appDelegate.user.oauthuid != nil) {
            let userID = self.appDelegate.user.oauthuid
            if(userID != nil) {
                let userRef = Database.database().reference().child("users").child(userID!)
                var refHandle : DatabaseHandle!
                refHandle = userRef.observe(.value, with: { (snapshot) in
                    let scoreValue = snapshot.value as? [String : AnyObject] ?? [:]
                    let score : Int = scoreValue["record_times"] as! CVarArg as! Int
                    let anwsers : Int = 1000 - score
                    self.gameAnswers = anwsers
                    let checkNumber : Int = (Int)(UserDefaults.standard.value(forKey: "PolicyLimit") as! String)!
                    if(anwsers <  checkNumber) {
                        DispatchQueue.main.async {
                            self.customHeaderView.titleLB.text =  String(format: "%d/1000", anwsers)
                        }
                    }
                })
            }
        }
    }
    
    func setUpDta() {
        self.customHeaderView.mainViewController = self.mainViewController
        self.customHeaderView.currentView = self
        self.appDelegate.totalScripts = 1
    }
    
    func setupUI() {
//        self.customHeaderView.titleLB.text =  "\(self.appDelegate.totalScripts)/100"
        self.stateLB.layer.cornerRadius = 12
        self.nextButton.layer.cornerRadius = 75
        self.retryButton.layer.cornerRadius = 75
        self.customHeaderView.view.frame = CGRect.init(x: 0, y: 0, width: self.headerView.frame.width, height: self.headerView.frame.size.height)
        self.customHeaderView.viewTitle = "Thu âm"
        self.headerView.addSubview(customHeaderView.view)
    }
 
    @objc func updateCountDown() {
        if(countDown > 0) {
            countDown -= 1
            if (countDown >= 10){
                self.counterLB.text = String("00:\(self.countDown)")
            }
            else if(countDown < 10) {
                self.counterLB.text = String("00:0\(self.countDown)")
            }
        }
        else {
//            self.nextButton.isUserInteractionEnabled = false
//            self.finishRecording()
            self.stopRecord(sending: self.stopBnt)
        }
    }

    func finishRecording() {
        audioRecorder?.stop()
        self.stateLB.stopBlink()
        self.redDotLB.stopBlink()
        self.stopTimer()
        isRecording = false
    }
    func playSound(){
        let url = getAudioFileUrl(id:NSInteger(NSNumber.init(value: Int32(self.currentRecordScript.id)!)))
        
        do {
            // AVAudioPlayer setting up with the saved file URL
            let sound = try AVAudioPlayer(contentsOf: url)
            self.player = sound
            
            // Here conforming to AVAudioPlayerDelegate
            sound.delegate = self
            sound.prepareToPlay()
            sound.play()
        } catch {
            print("error loading file")
            // couldn't load file :(
        }
    }
    func setupRecordsAudio(id: NSInteger) {
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let currentQuestId = id
        let filename = String(describing: currentQuestId) + "Audio.wav"
        
        let soundFileURL = dirPaths[0].appendingPathComponent(filename)
        
//        let currentAnwser = self.record_scripts[id]
        self.record_scripts[id].path = soundFileURL
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    func startRecording(recordSCript: RecordScripts) {
        //1. create the session
        let session = AVAudioSession.sharedInstance()

        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let recordSettings =
                [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
                 AVEncoderBitRateKey: 16,
                 AVNumberOfChannelsKey: 1,
                 AVSampleRateKey: 16000.0] as [String : Any]
            // 4. create the audio recording, and assign ourselves as the delegate
            let fileURL = getAudioFileUrl(id: NSInteger.init(NSNumber.init(value: Int32(recordSCript.id)!)))
            audioRecorder = try AVAudioRecorder(url:fileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.delegate = self
            audioRecorder?.record()
            //5. Changing record icon to stop icon
            isRecording = true
        }
        catch let error {
            print(error)
        }
    }
    // Path for saving/retreiving the audio file
    func getAudioFileUrl(id: NSInteger) -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let filename = String(describing: id) + "Audio.wav"
        let audioUrl = docsDirect.appendingPathComponent(filename)
        return audioUrl
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
//            finishRecording()
        }else {
            // Recording interrupted by other reasons like call coming, reached time limit.
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            
        }else {
            // Playing interrupted by other reasons like call coming, the sound has not finished playing.
        }
    }
    func stopTimer() {
        if (timer != nil) {
            self.timer.invalidate()
        }
    }
    func startTimer() {
        self.countDown = 30
        self.counterLB.text = String("00:\(self.countDown)")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    
    @IBAction func Next(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            sender.isUserInteractionEnabled = true
        })
        let checkNumber : Int = (Int)(UserDefaults.standard.value(forKey: "PolicyLimit") as! String)!
        if(self.gameAnswers < checkNumber ) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.stateLB.text = "Đang ghi âm"
                //        if(self.appDelegate.totalScripts <= 120) {
                //            self.customHeaderView.titleLB.text =  "\(self.appDelegate.totalScripts)/120"
                self.retryButton.isHidden =  true
                self.stopBnt.isHidden = false
                /*  1 if recording threads == 5 disable next button
                 //2 if recording->stop recording
                 //3.0 upload record to server on background thread
                 //3.1 -if- currenRecordtIndext == record_scripts.count --> ResetRecordScript --> getRecordScript()
                 //3.1 -else- start next record in record_scripts[]
                 
                 */
                
                //step2
                self.finishRecording()
                //step3
                //3.0
                self.UploadRecordScript()
                //3.1-if-
                if(self.record_scripts.count > 0 && self.currenRecordtIndext == self.record_scripts.count-1) {
                    self.resetRecordScipt()
                    self.getRecordScrip()
                }
                //3.1-else-
                if(self.record_scripts.count > 0 && self.currenRecordtIndext < self.record_scripts.count)
                {
                    self.currenRecordtIndext += 1
                    self.currentRecordScript = self.record_scripts[self.currenRecordtIndext]
                    
                    DispatchQueue.main.async {
                        self.startTimer()
                        self.stateLB.startBlink()
                        self.redDotLB.startBlink()
                        self.progressLabel.text = self.currentRecordScript.text
                    }
                    self.startRecording(recordSCript: self.currentRecordScript)
                }
            })
        } else {
            self.finishGameView.mainViewController = self.mainViewController
            self.present(self.finishGameView, animated: true, completion: nil)
        }
    }
    func reTry() {
        self.nextButton.isUserInteractionEnabled = true
        if(isRecording) {
            self.finishRecording()
        }
        DispatchQueue.main.async {
            self.stateLB.startBlink()
            self.redDotLB.startBlink()
        }
        self.startTimer()
        self.startRecording(recordSCript: self.currentRecordScript)
    }
    @IBAction func Retry(_ sender: AnyObject) {
         self.stateLB.text = "Đang ghi âm"
        self.stopBnt.isHidden = false
        self.retryButton.isHidden = true
        self.reTry()
    }
    @IBAction func stopRecord(sending : Any) {
        self.stateLB.text = "Tạm dừng"
        self.retryButton.isHidden = false
        self.stopBnt.isHidden = true
        self.finishRecording()
    }
    func UploadRecordScript() {
        self.service.HTTPRequestPostUpLoadFileMethod(token: "Bearer " + self.appDelegate.token, sid : currentRecordScript.id, gid: "19", url: self.getAudioFileUrl(id:NSInteger(NSNumber.init(value: Int32(self.currentRecordScript.id)!))), functionPath: "/records")
    }
    
    func getRecordScrip() {
        self.service.HTTPRequestGetMethod(token:"Bearer " + self.appDelegate.token, param: ["":""], functionPath: "/records/scripts", complettionHandler: { (data, response,error) in
            do {
                if(data != nil) {
                    let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
                    if((json["data"] as! NSArray).count > 0) {
                        self.parseJsonToRecorsScripts(value: json["data"] as! NSArray)
                    }
                    else {
                        KRProgressHUD.showMessage("data error")
                    }
                }
                else {
                    //show error
                }
            }catch {
                KRProgressHUD.showMessage(error.localizedDescription)
            }
        })
    }
    func parseJsonToRecorsScripts(value: NSArray) {
        value.map {
            let status : Status = Status.init(
                label: (($0 as! Dictionary<String, Any>)["status"] as! Dictionary<String,Any>)["label"] as! String,
                value: (($0 as! Dictionary<String, Any>)["status"] as! Dictionary<String,Any>)["value"] as! String,
                style: (($0 as! Dictionary<String, Any>)["status"] as! Dictionary<String,Any>)["style"] as! String
            )
            let recordscript : RecordScripts = RecordScripts.init(
                id: ($0 as! Dictionary<String, Any>)["id"] as! String,
                comnand: ($0 as! Dictionary<String, Any>)["command"] as! String,
                text: ($0 as! Dictionary<String, Any>)["text"] as! String,
                dateCreated: ($0 as! Dictionary<String, Any>)["datecreated"] as! String,
                humanDateCreated: ($0 as! Dictionary<String, Any>)["humandatecreated"] as! String,
                status: status,
                path: URL.init(string: "root")!
            )
            self.record_scripts.append(recordscript)
        }
        KRProgressHUD.dismiss()
        self.currentRecordScript = self.record_scripts[0]
        self.currenRecordtIndext = 0
        DispatchQueue.main.async {
            self.progressLabel.text = self.currentRecordScript.text
            self.stateLB.startBlink()
            self.redDotLB.startBlink()
            self.progressLabel.text = self.currentRecordScript.text
//            self.totalNumber.text = "câu " + "\(self.currenRecordtIndext+1)/\(self.record_scripts.count)"
            self.startTimer()
        }
        self.startRecording(recordSCript: self.currentRecordScript)
    }
    
    func resetRecordScipt() {
        self.currenRecordtIndext = 0
        self.record_scripts.removeAll()
    }
    func resetLabe() {
        self.stateLB.stopBlink()
        self.redDotLB.stopBlink()
    }
    @IBAction func Back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func playSound(sender:AnyObject){
        self.playSound()
    }
    
    func clearCacheFile() {
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        
        do {
            if let documentPath = documentsPath
            {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                self.logAtributeFile(url: documentsUrl as URL)
                for fileName in fileNames {
                    
                    if (fileName.hasSuffix(".wav"))
                    {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
            }
            
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func checkAndDeleteFileWithURL(url: String) {
        let Furl = URL(string: url)
        if(FileManager.default.fileExists(atPath: Furl!.path)) {
            do {
                try FileManager.default.removeItem(atPath: Furl!.path)
            }
            catch {
                KRProgressHUD.showMessage(error as! String)
            }
            
        }
    }
    func logAtributeFile(url: URL) {
        // Create a FileManager instance
        
        let fileManager = FileManager.default
        
        // Get attributes of 'myfile.txt' file
        
        do {
            let attributes = try fileManager.attributesOfItem(atPath: url.path)
            print(attributes)
        }
        catch let error as NSError {
            print("Ooops! Something went wrong: \(error)")
        }
    }
}

extension UILabel {
    
    func animate(newText: String, characterDelay: TimeInterval) {
        self.text = ""
        DispatchQueue.main.async {
            for (index, character) in newText.characters.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index)) {
                    self.text?.append(character)
                }
            }
        }
    }
    func startBlink() {
        UIView.animate(withDuration: 1.2,
                       delay:0.5,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}
extension UIImageView {
    func startBlink() {
        UIView.animate(withDuration: 1.2,
                       delay:0.5,
                       options:[.allowUserInteraction, .curveEaseInOut, .autoreverse, .repeat],
                       animations: { self.alpha = 0 },
                       completion: nil)
    }
    
    func stopBlink() {
        layer.removeAllAnimations()
        alpha = 1
    }
}

extension UIView {
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
//        self.layer.shadowColor = UIColor.darkGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
//        self.layer.shadowRadius = 1.0
//        self.layer.shadowOpacity = 0.7
//        self.layer.masksToBounds = false
    }
    func setDefaultRadiusCornerWithShadown(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
//        self.layer.shadowColor = UIColor.darkGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
//        self.layer.shadowRadius = 1.0
//        self.layer.shadowOpacity = 0.7
//        self.layer.masksToBounds = false
    }
    
}
