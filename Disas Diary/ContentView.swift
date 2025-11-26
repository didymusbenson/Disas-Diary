//
//  ContentView.swift
//  Disas Diary
//
//  Created by DBenson on 12/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var goyfPT = "*/1+*"
    @State private var artifact = false
    @State private var artifactcount = 0
    @State private var creature = false
    @State private var enchantment = false
    @State private var land = false
    @State private var instant = false
    @State private var sorcery = false
    @State private var planeswalker = false
    @State private var battle = false
    @State private var kindred = false

    var body: some View {
        
        VStack{
            //POWER AND TOUGHNESS
            HStack{
                
                //Relic of old Doubling Season code
                ForEach(items){item in
                    TokenView(item: item).listRowSeparator(.hidden).listRowInsets(EdgeInsets())
                }
            }
            .cornerRadius(20)
                .overlay( /// apply a rounded border
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.primary, lineWidth: 2)
                )
                .padding(5)
            // Creature
            HStack{
                Spacer()
                Toggle(isOn: $creature) {
                    Text("Creature")
                        .font(.title2)
                        
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: creature){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)

                Spacer()
            }
            
            //Artifact & Creature
            HStack{
                Spacer()
                    Toggle(isOn: $artifact) {
                        Text("Artifact").font(.title2)
                            .frame(maxWidth:.infinity)
                    }.toggleStyle(.button)
                    .onChange(of: artifact){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)

                Toggle(isOn: $enchantment) {
                    Text("Enchantment").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: enchantment){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            
            // Instant & Sorcery
            HStack{
                Spacer()
                Toggle(isOn: $instant) {
                    Text("Instant").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: instant){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)
                
                Toggle(isOn: $sorcery) {
                    Text("Sorcery").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: sorcery){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)
                Spacer()
            }

            //Enchantment & Land
            HStack{
                Spacer()

                Toggle(isOn: $planeswalker) {
                    Text("Planeswalker").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: planeswalker){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)
                
                Toggle(isOn: $land) {
                    Text("Land").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: land){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)
                Spacer()
            }



            // Planeswalker & Battle
            HStack{
                Spacer()
                Toggle(isOn: $battle) {
                    Text("Battle").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: battle){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)
                
                Toggle(isOn: $kindred) {
                    Text("Kindred").font(.title2)
                        .frame(maxWidth:.infinity)
                }.toggleStyle(.button).onChange(of: kindred){updateGoyfPt()}
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .foregroundColor(.secondary)

                Spacer()
            }
            VStack(spacing:3){
                GraveStepper(name: "My Types")
                GraveStepper(name: "My Creatures")
                GraveStepper(name: "All Creatures")
                GraveStepper(name: "Instants")
                GraveStepper(name: "Sorceriess")
                GraveStepper(name: "Lands")
                GraveStepper(name: "Nonbasic lands")
                GraveStepper(name: "Enchantments")
            }


            Spacer()
        }.onAppear{
            UIApplication.shared.isIdleTimerDisabled = true
            setItem(abilities:"Tarmogoyf’s power is equal to the number of card types among cards in all graveyards and its toughness is equal to that number plus 1.", name: "Tarmogoyf", pt: goyfPT, colors:"G", amount: 1, createTapped: false)
            }
    }
    
    func updateGoyfPt(){
        var uniqueCards = 0
        if artifact{
            uniqueCards += 1
        }
        if creature{
            uniqueCards += 1
        }
        if enchantment{
            uniqueCards += 1
        }
        if land{
            uniqueCards += 1
        }
        if instant{
            uniqueCards += 1
        }
        if sorcery{
            uniqueCards += 1
        }
        if planeswalker{
            uniqueCards += 1
        }
        if battle{
            uniqueCards += 1
        }
        if kindred{
            uniqueCards += 1
        }
            
        if uniqueCards == 0 {
         goyfPT = "*/*+1"
            
        }
        else{
            goyfPT = String(uniqueCards) + "/" + String(uniqueCards + 1)
        }
        items.first?.pt = goyfPT
    }
    
    private func setItem(abilities: String, name: String, pt: String, colors: String, amount: Int, createTapped: Bool) {
        let newItem = Item(
            abilities: abilities,
            name: name,
            pt: pt,
            colors: colors,
            amount: amount,
            createTapped: createTapped
        )
        do{
            try modelContext.delete(model:Item.self)
        }catch{
            print("Awww shit you broke it.")
        }
        modelContext.insert(newItem)
        
    }
    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
