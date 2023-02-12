//
//  File.swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 06/07/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import Foundation


class Mode {
    let navBarColor : String?
    let backroundOfDecksCollectionViewController : String?
    let buttonCreateDeckForDecksCollectionViewControllerEnglish : String?
    let buttonCreateDeckForDecksCollectionViewControllerRussian : String?
    let buttonSettings : String?
    let colorOfNameOfDeckCell : String?
    let imageMyDecksEnglish : String?
    let imageMeDecksRussian : String?
    let colorForBackgroundInTableView : String?
    let colorForTextColorInTableViewCells : String?
    let colorOfTextInButtons : String?
    let tickForLanguageColor : String?
    let backGroundOfDeckCells : String?
    let settingsButton : String?
    let addCardButton  : String?
    let backGroundForCards : String?
    let cardsColor : String?
    let textColorOnCards : String?
    let backgroundForCardsinCardViewController : String?
    let backgroundForCardInCardCollectionViewController : String?
    let backgroundInCardCollectionViewController : String?
    let backgroundForMiniView : String?
    let imageSwapAction : String?
    let chosenLanguageColor : String?
    let textFieldColor : String?
    
    
    init(navBarColor : String , backroundOfDecksCollectionViewController : String , buttonCreateDeckForDecksCollectionViewControllerEnglish : String ,  buttonCreateDeckForDecksCollectionViewControllerRussian : String , buttonSettings : String,  colorOfNameOfDeckCell : String , imageMyDecksEnglish : String ,  imageMeDecksRussian : String , colorForBackgroundInTableView : String ,colorForTextColorInTableViewCells : String , colorOfTextInButtons : String , tickForLanguageColor : String , backGroundOfDeckCells : String, settingsButton : String , addCardButton : String ,  backGroundForCards : String , cardsColor : String , textColorOnCards : String , backgroundForCardsInCardViewController : String , backgroundForCardInCardCollectionViewController : String , backgroundInCardCollectionViewController : String , backgroundForMiniView : String , imageSwapAction : String , chosenLanguageColor : String, textFieldColor: String) {
        self.navBarColor = navBarColor
        self.backroundOfDecksCollectionViewController = backroundOfDecksCollectionViewController
        self.buttonCreateDeckForDecksCollectionViewControllerEnglish = buttonCreateDeckForDecksCollectionViewControllerEnglish
        self.buttonCreateDeckForDecksCollectionViewControllerRussian = buttonCreateDeckForDecksCollectionViewControllerRussian
        self.buttonSettings = buttonSettings
        self.colorOfNameOfDeckCell = colorOfNameOfDeckCell
        self.imageMyDecksEnglish = imageMyDecksEnglish
        self.imageMeDecksRussian = imageMeDecksRussian
        self.colorForBackgroundInTableView = colorForBackgroundInTableView
        self.colorForTextColorInTableViewCells = colorForTextColorInTableViewCells
        self.colorOfTextInButtons = colorOfTextInButtons
        self.tickForLanguageColor = tickForLanguageColor
        self.backGroundOfDeckCells = backGroundOfDeckCells
        self.settingsButton = settingsButton
        self.addCardButton = addCardButton
        self.backGroundForCards = backGroundForCards
        self.cardsColor = cardsColor
        self.textColorOnCards = textColorOnCards
        self.backgroundForCardsinCardViewController = backgroundForCardsInCardViewController
        self.backgroundInCardCollectionViewController = backgroundInCardCollectionViewController
        self.backgroundForCardInCardCollectionViewController = backgroundForCardInCardCollectionViewController
        self.backgroundForMiniView = backgroundForMiniView
        self.imageSwapAction = imageSwapAction
        self.chosenLanguageColor = chosenLanguageColor
        self.textFieldColor = textFieldColor
    }
    
    class func fetchModes () -> [Mode] {
        var mode = [Mode]()
        //nav bar color = 54B4F2
        let lightMode = Mode(navBarColor: "54B4F2", backroundOfDecksCollectionViewController: "FFFFFF", buttonCreateDeckForDecksCollectionViewControllerEnglish: "Create Deck English", buttonCreateDeckForDecksCollectionViewControllerRussian: "Create Deck Russian", buttonSettings: "setting button copy", colorOfNameOfDeckCell: "54B4F2", imageMyDecksEnglish: "My decks star line two", imageMeDecksRussian: "My decks star line two Russian", colorForBackgroundInTableView: "FFFFFF", colorForTextColorInTableViewCells: "000000", colorOfTextInButtons: "626164", tickForLanguageColor: "4A8C03", backGroundOfDeckCells: "54B4F2", settingsButton: "setting button copy", addCardButton: "add card button", backGroundForCards: "EEEEEE", cardsColor: "FFFFFF", textColorOnCards: "000000", backgroundForCardsInCardViewController: "E0E0E0", backgroundForCardInCardCollectionViewController: "FFFFFF", backgroundInCardCollectionViewController: "FFFFFF", backgroundForMiniView: "8AC9F1", imageSwapAction: "front back light mode", chosenLanguageColor: "434343", textFieldColor: "000000")
        
        
        mode.append(lightMode)
        //nav bar color = 12243A
        let darkMode = Mode(navBarColor: "12243A", backroundOfDecksCollectionViewController: "21344A", buttonCreateDeckForDecksCollectionViewControllerEnglish: "DarkModeCreateDeckEnglish", buttonCreateDeckForDecksCollectionViewControllerRussian: "DarkModeCreateDeckRussian", buttonSettings: "DarkModeCreateDeckEnglish", colorOfNameOfDeckCell: "35485E", imageMyDecksEnglish: "My decks star line English", imageMeDecksRussian: "My decks star line Russian", colorForBackgroundInTableView: "21344A", colorForTextColorInTableViewCells: "FFFFFF", colorOfTextInButtons: "FFFFFF", tickForLanguageColor: "FFFFFF", backGroundOfDeckCells: "35485E", settingsButton: "setting button Dark Mode", addCardButton: "add card button-1", backGroundForCards: "21344A", cardsColor: "35485E", textColorOnCards: "FFFFFF", backgroundForCardsInCardViewController: "21344A", backgroundForCardInCardCollectionViewController: "35485E", backgroundInCardCollectionViewController: "35485E", backgroundForMiniView: "35485E", imageSwapAction: "front back", chosenLanguageColor: "FFFFFF", textFieldColor: "FFFFFF")
        
        mode.append(darkMode)
        
        
        
        
        
        return mode
    }
}
