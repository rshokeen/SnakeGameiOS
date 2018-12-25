//
//  GameManager.swift
//  Snake Game
//
//  Created by Rajiv Shokeen on 12/24/18.
//  Copyright © 2018 Rajiv Shokeen. All rights reserved.
//

import Foundation
import SpriteKit

class GameManager {
    
    //Step 4.1 - GameManager must contain a reference to the GameScene class once it is initialized. Now the GameManager class can communicate to the GameScene by calling scene.method_name. For instance, scene.startGame() would run the start game function from within the control of the GameManager class.
    var scene: GameScene!
    
    //Step 5.2 - initialize two new variables. nextTime is the nextTime interval we will print a statement to the console, timeExtension is how long we will wait between each print (1 second)
    var nextTime: Double?
    var timeExtension: Double = 1
    
    //Step 5.3 - Create a variable that is used to determine the player’s current direction. In the code the variable is set to 1, in the gif in Figure Q I set the direction to 4. Change this variable to see all the different directions. 1 == left, 2 == up, 3 == right, 4 == down
    var playerDirection: Int = 1
    
    init(scene: GameScene)
    {
        self.scene = scene
    }
    
    //Step 4.2 - This adds 3 coordinates to the GameScene’s playerPositions array
    func initGame()
    {
        //starting player position
        scene.playerPositions.append((10, 10))
        scene.playerPositions.append((10, 11))
        scene.playerPositions.append((10, 12))
        renderChange()
    }
    
    //Step 4.2 - We will call this method every time we move the “snake” or player. This renders all blank squares as clear and all squares where the player is located as cyan. We now have our player rendered on screen and the ability to render any number of positions. If you add more coordinates to the playerPositions array then more squares will be colored cyan. 
    func renderChange()
    {
        for (node, x, y) in scene.gameArray {
            if contains(a: scene.playerPositions, v: (x,y)) {
                node.fillColor = SKColor.cyan
            } else {
                node.fillColor = SKColor.clear
            }
        }
    }
    
    //Step 4.2 - checks if a tuple (a swift data structure that can contain an combination of types in the form of (Int, CGFloat, Int, String)…. etc) exists in an array of tuples. This function checks if the playerPositions array contains the inputted coordinates from the GameScene’s array of cells. This is not necessarily the most efficient way of doing things as we are checking every single cell during each update.
    func contains(a:[(Int, Int)], v:(Int,Int)) -> Bool
    {
        let (c1, c2) = v
        for (v1, v2) in a { if v1 == c1 && v2 == c2 { return true } }
        return false
    }
    
    //Step 5.2 - This update function is called 60 times per second, we only want to update the player position once per second so that the game is not ridiculously fast. In order to accomplish this we check if nextTime has been set. As you can see from //1, nextTime has been initialized to be an optional value. The “ ? “ after Double tells the swift compiler that we want nextTime to be a double and that it CAN be set to nil. When the update function is called we first check if the nextTime has been set, if it has not been set we set it to the current time + the timeExtension (1 second). Once the current time eclipses the “nextTime” we then increase nextTime by 1 second. This function now takes an irregular update function (around 30–60 times / second) and only produces an output once per second
    func update(time: Double)
    {
        if nextTime == nil {
            nextTime = time + timeExtension
        }
        else {
            if time >= nextTime! {
                nextTime = time + timeExtension
                //print(time)
                //Step 5.3 - update player position
                updatePlayerPosition()
            }
        }
    }
    
    //Step 5.3 - This method moves the player or “snake” around the screen.
    private func updatePlayerPosition()
    {
        //Set variables to determine the change we should make to the x/y of the snake’s front.
        var xChange = -1
        var yChange = 0
        
        //This is a switch statement, it takes the input of the playerPosition and modifies the x/y variables according to wether the player is moving up, down, left or right.
        switch playerDirection {
        case 1:
            //left
            xChange = -1
            yChange = 0
            break
        case 2:
            //up
            xChange = 0
            yChange = -1
            break
        case 3:
            //right
            xChange = 1
            yChange = 0
            break
        case 4:
            //down
            xChange = 0
            yChange = 1
            break
        default:
            break
        }
        
        //This block of code moves the positions forwards in the array. We want to move the front of the tail in the appropriate direction and then move all the tail blocks forward to the next position.
        if scene.playerPositions.count > 0 {
            var start = scene.playerPositions.count - 1
            while start > 0 {
                scene.playerPositions[start] = scene.playerPositions[start - 1]
                start -= 1
            }
            scene.playerPositions[0] = (scene.playerPositions[0].0 + yChange, scene.playerPositions[0].1 + xChange)
        }
        
        //Step 6.1 - Warping the snake around the screen when it hits the wall
        if scene.playerPositions.count > 0
        {
            let x = scene.playerPositions[0].1
            let y = scene.playerPositions[0].0
            if y > 40 {
                scene.playerPositions[0].0 = 0
            } else if y < 0 {
                scene.playerPositions[0].0 = 40
            } else if x > 20 {
                scene.playerPositions[0].1 = 0
            } else if x < 0 {
                scene.playerPositions[0].1 = 20
            }
        }
        
        //Render the changes we made to the array of positions
        renderChange()
        
    }
    
    //Step 7.2 - Set Snake direction based on swipe gesture. If a swipe is not conflicting with the current direction, set the player’s direction to the swipe input.
    func swipe(ID: Int)
    {
        if !(ID == 2 && playerDirection == 4) && !(ID == 4 && playerDirection == 2)
        {
            if !(ID == 1 && playerDirection == 3) && !(ID == 3 && playerDirection == 1)
            {
                playerDirection = ID
            }
        }
    }
    
}
