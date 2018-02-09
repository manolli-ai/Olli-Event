//
//  GameViewController.swift
//  Olli Vui
//
//  Created by Man Huynh on 12/13/17.
//  Copyright © 2017 Man Huynh. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet var counterLB: UILabel!
    @IBOutlet var stateLB: UILabel!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var progressLabel: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var retryButton: UIButton!
    @IBOutlet var backButton: UIButton!
    @IBOutlet var testingButton: UIButton!
    let service:Services = Services()
    var isRecording = false
    var audioRecorder: AVAudioRecorder?
    var player : AVAudioPlayer?
    var timer: Timer!
    var countDown: Int = 0
    var game: Records!
//    var counter:Int = 0 {
//        didSet {
//            let fractionalProgress = Float(counter) / 1200.0
//            let animated = counter != 0
//            progressView.setProgress(fractionalProgress, animated: animated)
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.setProgress(0, animated: true)
        self.setupUI()
        self.startRecording()
//        self.StartProcgcessView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.countDown = 30
        self.counterLB.text = String("00:\(self.countDown)")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCountDown), userInfo: nil, repeats: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.StartProcgcessView()
        self.stateLB.startBlink()
        self.progressLabel.animate(newText: "xin chao mung ban den voi the gioi game cua olli, chuc ban vui ve", characterDelay: 0.15)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.progressLabel.animate(newText: "", characterDelay: 0)
        self.stateLB.stopBlink()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }
    
    func setupUI() {
        self.nextButton.layer.cornerRadius = 75
        self.retryButton.layer.cornerRadius = 40
        self.backButton.layer.cornerRadius = 35
        self.nextButton.setRadiusWithShadow()
        self.retryButton .setRadiusWithShadow()
        self.backButton.setRadiusWithShadow()
    }
    @objc func updateCountDown() {
        if countDown > 0{
            countDown -= 1
            self.counterLB.text = String("00:\(self.countDown)")
        } else {
            (self.timer).invalidate()
            self.stateLB.stopBlink()
        }
    }
    func record() {
        if isRecording {
            finishRecording()
        }else {
            startRecording()
        }
    }
    func finishRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    func playSound(){
        let url = getAudioFileUrl()
        
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
    func startRecording() {
        //1. create the session
        let session = AVAudioSession.sharedInstance()
        
        do {
            // 2. configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // 3. set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            // 4. create the audio recording, and assign ourselves as the delegate
            audioRecorder = try AVAudioRecorder(url: getAudioFileUrl(), settings: settings)
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
    func getAudioFileUrl() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = docsDirect.appendingPathComponent("recording.m4a")
        return audioUrl
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            finishRecording()
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
    
    @IBAction func Next(_ sender: AnyObject) {
        self.finishRecording()
    }
    @IBAction func Retry(_ sender: AnyObject) {
//        self.StartProcgcessView()
//        self.progressLabel.animate(newText: "xin chao mung ban den voi the gioi game cua olli, chuc ban vui ve", characterDelay: 0.15)
        self.service.HTTPRequestPostUpLoadFileMethod(token: "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJlbWFpbCIsInN1YiI6eyJpZCI6IjEiLCJzY3JlZW5uYW1lIjoiQWRtaW5pc3RyYXRvciIsImZ1bGxuYW1lIjoiQWRtaW5pc3RyYXRvciIsImVtYWlsIjoiYWRtaW5AbG9jYWxob3N0LmxvY2FsIiwiYWRkcmVzcyI6IiIsInBhc3N3b3JkIjoiIiwiZ3JvdXBpZCI6ImFkbWluaXN0cmF0b3IiLCJhdmF0YXIiOiIiLCJnZW5kZXIiOiJtYWxlIiwic3RhdHVzIjoiMSIsImRvYiI6bnVsbCwib2F1dGh1aWQiOiIiLCJvYXV0aGFjY2Vzc3Rva2VuIjoiIiwib2F1dGhwcm92aWRlciI6IiIsIm9uZXNpZ25hbGlkIjoiIiwic3RhdGUiOiIwIiwiZGF0ZWNyZWF0ZWQiOiIxNDk0NTYwNjk2IiwiZGF0ZWxhc3RjaGFuZ2VwYXNzd29yZCI6IjAiLCJkYXRlbW9kaWZpZWQiOiIxNTExNzc5ODcwIiwibW9iaWxlbnVtYmVyIjoiIiwiaXN2ZXJpZmllZCI6IjEiLCJ2ZXJpZnl0eXBlIjoiMSJ9LCJpYXQiOjE1MTE4NTUzMjcsImV4cCI6MTU0Nzg1NTMyN30.vz80gczJSUE8D1p4imK2P_eU3lZRnpRKho5f9RMqWTc", sid: "12", gid: "13", url: self.getAudioFileUrl(), functionPath: "/records")
    }
    @IBAction func Back(_ sender: AnyObject) {
        self.navigationController?.popViewController(animated:true)
    }
    @IBAction func playSound(sender:AnyObject){
        self.playSound()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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

extension UIView {
    func setRadiusWithShadow(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    func setDefaultRadiusCornerWithShadown(_ radius: CGFloat? = nil) {
        self.layer.cornerRadius = radius ?? self.frame.width / 2
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
    }
    
}
