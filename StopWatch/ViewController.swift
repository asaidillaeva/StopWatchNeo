//
//  ViewController.swift
//  StopWatch
//
//  Created by Aliia Saidillaeva  on 31/5/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var btnStop: Button!
    @IBOutlet weak var btnPause: Button!
    @IBOutlet weak var btnPlay: Button!
    @IBOutlet weak var picker: UIPickerView!
   
    
    var isGoingOn = false {
        didSet {
            [btnPlay, btnStop, btnPause].forEach { $0?.bool = isGoingOn}
        }
    }
    
    var isTimer = true
    var timer: Timer = Timer()
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.isHidden = true
        picker.delegate = self
        reset()
    }
    
    @IBAction func segmentClick(_ sender: UISegmentedControl) {
        isTimer = sender.selectedSegmentIndex == 0
        picker.isHidden = sender.selectedSegmentIndex == 0
        reset()
    }
    
    @IBAction func stop(_ sender: Any) {
        reset()
    }
    
    @IBAction func pause(_ sender: Any) {
        if !isGoingOn {
            return
        }
        timer.invalidate()
        toggle()
    }
    
    @IBAction func play(_ sender: Any) {
        if isGoingOn {
            return
        }
        toggle()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        if !isTimer {
            picker.isHidden = true
        }
    }
    
    func reset(){
        isGoingOn = false
        timerLabel.text = "00:00:00"
        timer.invalidate()
        count = 0
        
        let strs = ["play.circle", "pause.circle"]
        [btnPlay, btnPause].enumerated().forEach { index, button in
            button?.bool = isGoingOn
            button! ++ (strs[index], strs[index] + ".fill")
        }
        
        
        if !isTimer{
            picker.isHidden = false
            picker.selectRow(0, inComponent:0, animated: true)
            picker.selectRow(0, inComponent:1, animated: true)
            picker.selectRow(0, inComponent:2, animated: true)
        }
    }
    
    @objc func updateTimer() -> Void{
        count = isTimer ? count + 1 : count - 1
        timerLabel.text = secondsToString(seconds: count)
    }
    
    func secondsToString(seconds: Int) -> (String){
        var timeStr = ""
        timeStr.append( String(format: "%02d", (seconds/3600)) + ":")
        timeStr.append( String(format: "%02d", (seconds%3600)/60) + ":")
        timeStr.append( String(format: "%02d", (seconds%3600)%60) )
        
        return timeStr
    }
    
    private func toggle(){
        isGoingOn.toggle()
        btnPlay.bool = isGoingOn
        btnPause.bool = !isGoingOn
        btnPlay ++ ("play.circle", "play.circle.fill")
        btnPause ++ ("pause.circle", "pause.circle.fill")
    }
    
}

class Button: UIButton {
    var bool = false
}

infix operator ++
extension Button {
    static func ++ (lhs: Button, rhs: (String, String)) {
        lhs.setBackgroundImage(.init(systemName: lhs.bool ? rhs.0 : rhs.1), for: .normal)
    }
}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return 24
        case 1, 2:
            return 60
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return pickerView.frame.size.width/3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "\(row)"
        case 1:
            return "\(row)"
        case 2:
            return "\(row)"
        default:
            return ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            count = row*3600
        case 1:
            count = row*60
        case 2:
            count = row
        default:
            break;
        }
    }
}
