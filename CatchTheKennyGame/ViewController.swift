//
//  ViewController.swift
//  CatchTheKennyGame
//
//  Created by user209479 on 1/6/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var kennyImage: UIImageView!
    
    var time = Timer()
    var hideTimer = Timer()
    var counter = 0
    var score = 0
    var highscore = 0
    var startingPosition = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startingPosition = Int(CGFloat(kennyImage.frame.origin.y))
        counter = 10
        timeLabel.text = "Time: \(counter)"
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown) ,userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(spawnRandomPosition), userInfo: nil, repeats: true)
        scoreLabel.text = "Score: \(score)"
        
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")
        if let newHighSocre = storedHighScore as? Int {
            highscoreLabel.text = "High Score: \(newHighSocre)"
            highscore = newHighSocre
        }else {
            highscoreLabel.text = "High Score: 0"
        }
        
        kennyImage.isUserInteractionEnabled = true
        let touchKenny = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        kennyImage.addGestureRecognizer(touchKenny)
    }
    
    @objc func countDown() {
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter == 0{
            time.invalidate()
            hideTimer.invalidate()
            timeLabel.text = "Time is over!"
            
            let alert = UIAlertController(title: "Time is up!", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) {
            (UIAlertAction) in
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
            self.counter = 10
            self.timeLabel.text = "Time \(self.counter)"
                
            self.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
            self.hideTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(self.spawnRandomPosition), userInfo: nil, repeats: true)
                
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func increaseScore() {
        score += 1
        scoreLabel.text = "Score: \(score)"
        
        if score > highscore {
            highscore = score
            highscoreLabel.text = "High Score: \(highscore)"
            UserDefaults.standard.set(highscore, forKey: "highScore")
        }
    }
    
    @objc func spawnRandomPosition() {
        let kenny = kennyImage
        let kennyWidth = kenny!.frame.width
        let kennyHeight = kenny!.frame.height
        
        
        let viewWidth = CGFloat(500)
        let viewHeight = CGFloat(500)
        
        
        let xwidth = viewWidth - kennyWidth
        let yheight = viewHeight - kennyHeight
        
        
        let xoffset = CGFloat(arc4random_uniform(UInt32(xwidth)))
        let yoffset = CGFloat(arc4random_uniform(UInt32(yheight)))
        
        
        kenny!.center.x = xoffset + kennyWidth / 2
        kenny!.center.y = yoffset + CGFloat(startingPosition) + kennyHeight / 2
     }
}

