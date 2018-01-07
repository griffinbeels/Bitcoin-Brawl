//
//  GameScene.swift
//  Bitcoin Brawl
//
//  Created by Griffin  Beels on 1/5/18.
//  Copyright © 2018 Omega Bunny. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var reset : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    private var taps : Int = 0 {
        didSet {
            label?.text = "Bitcoin \(taps)"
        }
    }
    private var tapScale : Int = 1 {
        didSet{
            currentScale = "Coins per Tap: \(tapScale)\nCost: \(tapScale * 50)"
            self.testButton.setTitle(currentScale, for: .normal)
        }
    }
    private var currentScale = ""
    
   private let testButton = UIButton(frame: CGRect(x: 75, y: 100, width: 200, height: 100))
    
    override func didMove(to view: SKView) {
        if UserDefaults.standard.object(forKey: "tapsCounter")as? Int != nil{
            taps = UserDefaults.standard.object(forKey: "tapsCounter") as! Int
        }
        if UserDefaults.standard.object(forKey: "tapScale")as? Int != nil{
            tapScale = UserDefaults.standard.object(forKey: "tapScale") as! Int
        }
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        label?.text = "Bitcoin \(taps)"

        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        currentScale = "Coins per Tap: \(tapScale)\nCost: \(tapScale * 50)"
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        createButton();
    }
    
    func createButton()
    {
        // Put it in the center of the scene
        self.testButton.backgroundColor = .red
        self.testButton.setTitle(currentScale, for: .normal)
        self.testButton.addTarget(self, action: #selector(upgradeAction), for: .touchUpInside)
        testButton.titleLabel?.lineBreakMode = .byWordWrapping
        // you probably want to center it
        testButton.titleLabel?.textAlignment = .center
        self.view?.addSubview(testButton)
    }
    
    @objc func upgradeAction(sender: UIButton!){
        if taps >= tapScale*50 {
            taps -= tapScale*50
            tapScale += 1
            UserDefaults.standard.set(taps, forKey: "tapsCounter")
            UserDefaults.standard.set(tapScale, forKey: "tapScale")
        }
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
            taps += tapScale
            UserDefaults.standard.set(taps, forKey: "tapsCounter")
	        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
