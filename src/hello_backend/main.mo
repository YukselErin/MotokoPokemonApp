import List = "mo:base/List";
import Buffer "mo:base/Buffer";
import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Random = "Random";
import Float "mo:base/Float";
import Nat "mo:base/Nat";

actor {

    type Pokemon ={
        Name : Text;
        Type : Text;
        var Hp : Float;
    };
    var pokedex = List.nil<Pokemon>();
    var isInFight : Bool = false;
    let rand = Random.new();
    let ownedPokemon = Buffer.Buffer<Pokemon>(1);

    var wildPokemon : Pokemon = {
        Name = "Charmender";
        Type = "fire";
        var Hp = 10;
    };

    var sentPokemon : Pokemon = {
        Name = "Charmender";
        Type = "fire";
        var Hp = 10;
    };

    public func listAllPokemons() : async Text {
        var output: Text="";
        List.iterate<Pokemon>(pokedex, func n {output := output # (n.Name)#"\n"});
        return output;
    };

    public func listOwnedPokemons() : async Text {
        var index = 1;
        var output: Text="";
        Buffer.iterate<Pokemon>(ownedPokemon, func n {output := output #(Nat.toText(index) # ". " #n.Name#"\n"); index :=index+1;});
        return output;

    };

    public func getStarter(): async Text{
        if(ownedPokemon.size() == 0){
            var temp = rand.next() % List.size<Pokemon>(pokedex); 
            var tempStarter = List.get<Pokemon>(pokedex,temp);
            var newStarter : Pokemon = switch(tempStarter) { case null { {Name = "Bulbasaur"; Type = "grass";var Hp = 10;}}; case (?tempStarter) { {Name = tempStarter.Name; Type = tempStarter.Type;var Hp = tempStarter.Hp;} }; };
            ownedPokemon.add(
                    {
                    Name = newStarter.Name;
                    Type = newStarter.Type;
                    var Hp = 10
                }
                );
            return ("You gained the starter: " # ownedPokemon.get(0).Name);
        };
        return "You already have a pokemon!";

    };
    
    public func walkInWild(): async Text {
       if(isInFight){
        return ("You are already in a fight!");
       };
        var output : Text = "";
        if(ownedPokemon.size() != 0){
            var temp = rand.next() % List.size<Pokemon>(pokedex); 
            var tempWild = List.get<Pokemon>(pokedex,temp);
            wildPokemon := switch(tempWild) { case null { {Name = "Bulbasaur"; Type = "grass";var Hp = 10;}}; case (?tempWild) { {Name = tempWild.Name; Type = tempWild.Type;var Hp = tempWild.Hp;} }; };
            output := output # ("A wild " # wildPokemon.Name # " appears!\n");
            sentPokemon := ownedPokemon.get(0);
            isInFight := true;
            output := output #("Go! " # sentPokemon.Name#"\n" );
        }
        else {
            return ("You need a starter first!\n");
        };
        return output;
    };
    private func getTypeMult(from : Text , to : Text) : Float{
        let tindexFrom = Buffer.indexOf<Text>(from, currentTypes, Text.equal);
        let indexFrom = switch(tindexFrom) { case null { 0 }; case (?tindexFrom) { tindexFrom }; };

        let tindexTo = Buffer.indexOf<Text>(to, currentTypes, Text.equal);
        let indexTo = switch(tindexTo) { case null { 0 }; case (?tindexTo) { tindexTo }; };

        TypeMultipliers[indexFrom][indexTo];
    };

    var faintedPokemons = 0;

    public func attack() : async Text{
        let output1:Text="It's super effective!\n";
        if(sentPokemon.Hp == 0){
            return ("Fainted pokemon can't attack!\n");
            isInFight := false;
        };
        var output : Text = "";

        if(isInFight){
            let mult = getTypeMult(sentPokemon.Type, wildPokemon.Type);
            if(mult == 2.0){
                output := output # (output1);
            };
            if(wildPokemon.Hp - mult * 2 > 0){
                wildPokemon.Hp := wildPokemon.Hp - mult *2;
                output := output # (wildPokemon.Name # " is down to " # Float.toText(wildPokemon.Hp) # " hp!\n");
                output := output # (wildPokemon.Name # " attacks " # sentPokemon.Name # "!\n");
                let multWild = getTypeMult(wildPokemon.Type , sentPokemon.Type);
                if(multWild == 2.0){
                    output := output # (output1);
                };
                if(sentPokemon.Hp - multWild * 2 > 0){
                    sentPokemon.Hp := sentPokemon.Hp - multWild * 2 ;
                    output := output # (sentPokemon.Name # " is down to " # Float.toText(sentPokemon.Hp) # " hp\n!");
                }
                else {
                    output := output # (sentPokemon.Name # " fainted!\n");
                    sentPokemon.Hp := 0;
                    faintedPokemons := faintedPokemons + 1;
                    if(faintedPokemons == ownedPokemon.size()){
                        output := output # ("All your pokemons fainted. You lose the battle!\n");
                        isInFight := false;
                    };
                }
            }
            else {
                isInFight := false;
                output := output #  (wildPokemon.Name # " has been defeated!\n");
            };
        };
        return output;

    };
    public func visitPokeCenter() : async Text{
        if(isInFight){
            return ("You can not do that during a battle!\n");
        }
        else{
            Buffer.iterate<Pokemon>(ownedPokemon, func n {n.Hp := 10});
            return("All your pokemons are healed!\n");
        };
    };
    public func throwPokeBall(): async Text{
        var output : Text = "";
        if(isInFight){
            output := output # ("You throw a pokeball!\n");
            if(Float.fromInt(rand.next() % 10) > (wildPokemon.Hp + 2)){
                output := output #("3..2..1...\n");
                output := output #("You captured " # wildPokemon.Name # "!\n");
                ownedPokemon.add({Name=wildPokemon.Name; Type = wildPokemon.Type;var Hp = 10});
                isInFight := false;
            }
            else {
                output := output #("3..2..1...\n");
                output := output #(wildPokemon.Name # " broke away!\n");
            }
        }
        else {
            output := output #("There is no wild pokemon to throw pokeball!\n");
        };
       return output;
    };
    public func changePokemon(indexOfPokemon : Nat) : async Text{
        if(indexOfPokemon <= 0 )
        return "No pokemon on this index";
        let bufferIndex = indexOfPokemon -1 ;
        if(bufferIndex >= 0 and bufferIndex < ownedPokemon.size()){
            var output = "";
            output := ( sentPokemon.Name #" come back!\n");
            sentPokemon := ownedPokemon.get(bufferIndex);
            output := output #( sentPokemon.Name #" GO!\n");
            return output;
        }
        else{
            return "No pokemon on this index";
        }
    };
    
    pokedex :=  List.push<Pokemon>( {
        Name = "Bulbasaur";
        Type = "grass";
        var Hp = 10;
    }, pokedex);
    
    pokedex :=  List.push<Pokemon>( {
        Name = "Oddish";
        Type = "grass";
        var Hp = 10;
    }, pokedex);
    
    pokedex :=  List.push<Pokemon>( {
        Name = "Squirtle";
        Type = "water";
        var Hp = 10;
    }, pokedex);

    pokedex :=  List.push<Pokemon>( {
        Name = "Poliwag";
        Type = "water";
        var Hp = 10;
    }, pokedex);
    
    pokedex :=  List.push<Pokemon>( {
        Name = "Charmender";
        Type = "fire";
        var Hp = 10;
    }, pokedex);

    pokedex :=  List.push<Pokemon>( {
        Name = "Cyndaquil";
        Type = "fire";
        var Hp = 10;
    }, pokedex);

    pokedex :=  List.push<Pokemon>( {
        Name = "Pikachu";
        Type = "electric";
        var Hp = 10;
    }, pokedex);

    pokedex :=  List.push<Pokemon>( {
        Name = "Jolteon";
        Type = "electric";
        var Hp = 10;
    }, pokedex);

    pokedex :=  List.push<Pokemon>( {
        Name = "Diglett";
        Type = "ground";
        var Hp = 10;
    }, pokedex);

    pokedex :=  List.push<Pokemon>( {
        Name = "Cubone";
        Type = "ground";
        var Hp = 10;
    }, pokedex); 
    let currentTypes = Buffer.Buffer<Text>(3);
    currentTypes.add("water");
    currentTypes.add("fire");
    currentTypes.add("grass");
    currentTypes.add("electric");
    currentTypes.add("ground");
    type PokemonType = {#water; #fire; #grass; #electric; #ground};

    let pokemonTypes = ["water", "fire", "grass", "electric", "ground"];
    let TypeMultipliers : [[Float]] = 
    [[0.5 , 2.0 , 0.5, 1.0, 2.0],
     [0.5 , 0.5 , 2.0, 1.0, 1.0],
     [ 2.0 , 0.5 , 0.5, 1.0, 2.0],
     [2.0, 1.0, 0.5, 0.5, 0.0],
     [1.0, 2.0, 0.5, 2.0, 0.5]
    
     ];
};
