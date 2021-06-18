import Foundation
import GameKit

class UIOverlay: SKSpriteNode {

    
    init(positon: CGPoint, localTexture: SKTexture, localWidth: CGFloat){
        
        var localSize = localTexture.size()
        let localHeight = (localWidth / localSize.width) * localSize.height
        localSize = CGSize(width: localWidth, height: localHeight)
        
        super.init(texture: localTexture, color: emptyColor, size: localSize)
    }
    
    func handleInputs(){
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
