//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Max Campolo on 3/11/15.
//  Copyright (c) 2015 Max Campolo. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // MARK: - OUtlet Properties
    
    @IBOutlet weak var recordingInProgressLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    // MARK: - Global variables
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    // MARK: - Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        // Interface setup
        setupInterfaceAttributes()
    }
    
    // MARK: - Action
    
    @IBAction func recordAudio(sender: UIButton) {
        println("Recording started")
        // Show recording in progress label
        recordingInProgressLabel.text = "Recording"
        stopButton.hidden = false
        // Disable the record button
        recordButton.enabled = false
        
        // Record the audio
        var dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        println("Recording stopped")
        recordingInProgressLabel.text = "Tap to Record"
        stopButton.hidden = true
        
        // Stop the recording
        audioRecorder.stop()
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }
    
    // MARK: - Setup
    
    func setupInterfaceAttributes() {
        stopButton.hidden = true
        recordButton.enabled = true
        recordingInProgressLabel.text = "Tap to Record"
    }
    
    // MARK: Audio Recorder Delegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // Audio finished recording
        if (flag) {
            recordedAudio = RecordedAudio(audioTitle: recorder.url.lastPathComponent, audioFilePath: recorder.url)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }


}

