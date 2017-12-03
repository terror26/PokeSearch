
import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg:UIImageView!
    @IBOutlet weak var name:UILabel!
    
    var pokemon : Pokemon!
    required init?( coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layer.cornerRadius = 5.0
    }
    func ConfigureCell( _ pokemon: Pokemon) {
        self.pokemon = pokemon
        
        self.name.text = self.pokemon.name
        thumbImg.image = UIImage(named: "\(self.pokemon.pokemonId)")
    }
}


