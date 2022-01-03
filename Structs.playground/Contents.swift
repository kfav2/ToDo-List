import UIKit

// keep track of heroes
var heroName: String
var alias: String
var age: Int

// we can upate these values
heroName = "Wonder Woman"
alias = "Diana Prince"
age = 5000

// we can create a function with these values
func tellAboutHero (name: String, alias: String, age: Int) {
//    print("\(heroName) has the alias \(alias) and is \(age) years old.")
}

// and we can call it
tellAboutHero(name: heroName, alias: alias, age: age)

// we can also create three arrays to hold hero info, but we'll have to be sure to keep the indexes in sync
var heroNames = ["Wonder Woman", "Black Widdow", "Iron Man"]
var aliases = ["Diana Prince", "Natasha Romanoff", "Tony Stark"]
var ages = [5000, 36, 48]

tellAboutHero(name: heroNames[1], alias: aliases[1], age: ages[1])

//for index in 0..<aliases.count {
//    tellAboutHero(name: heroNames[index], alias: aliases[index], age: ages[index])
//}

heroNames.remove(at: 2)
heroNames.remove(at: 1)
//for index in 0..<aliases.count {
//    tellAboutHero(name: heroNames[index], alias: aliases[index], age: ages[index])
//}
// Fatal error: Index out of range
// print(heroNames.count, aliases.count, ages.count)

// Now create a single Type to hold three properties or attributes of a hero
struct Hero {
    var name: String
    var alias: String
    var age: Int
}

var hero = Hero(name: "Wonder Woman", alias: "Diana Prince", age: 5000)
//print("Who is \(hero.name)? Oh that's \(hero.alias)")

// with a struct we can pass in a single struct value instead of three separate parameters
func heroInfo(hero: Hero) {
    print("\(hero.name) has the alias \(hero.alias) and is \(hero.age) years old.")
}

//heroInfo(hero: hero)

// Even better we can make the method of a struct like this:
struct SuperHero {
    var name: String
    var alias: String
    var age: Int
    
    func info() {
        print("\(name) has the alias \(alias) and is \(age) years old.")
    }
}

var superHero = SuperHero(name: "Black Widdow", alias: "Natasha Romanoff", age: 36)

// superHero.info()

// you can also create an array of structs, so all properties are synced in a single array, rather than spread across multiple arrays
var superHeros: [SuperHero] = []
superHeros.append(SuperHero(name: "Wonder Woman", alias: "Diana Prince", age: 5000))
var newHero = SuperHero(name: "Black Widdow", alias: "Natasha Romanoff", age: 36)
superHeros.append(newHero)
superHeros.append(SuperHero(name: "Iron Man", alias: "Tony Stark", age: 48))

//for index in 0..<superHeros.count {
//    superHeros[index].info()
//}

//for index in 0..<superHeros.count {
//    print("Who is \(superHeros[index].alias)? Oh that's \(superHeros[index].name).")
//}

for superHero in superHeros {
    superHero.info()
}

superHeros.remove(at: 2)
superHeros.remove(at: 1)

for superHero in superHeros {
    superHero.info()
}
