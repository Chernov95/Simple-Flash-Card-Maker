//
//  Language .swift
//  Flash Card Creator
//
//  Created by Filip Cernov on 22/05/2019.
//  Copyright © 2019 Filip Cernov. All rights reserved.
//

import UIKit


class Language {
    let imageToCreateDeck : String
    let titleFirstCollectionViewController : String
    let titleSettings : String
    let darkMode : String
    let laguage : String
    let ratetheApp : String
    let sendUsFeedback : String
    let buttonDelete : String
    let buttonRemoveAll : String
    let enterADeckName : String
    let cancel : String
    let wrong : String
    let writeNameADeck : String
    let gotIt : String
    let frontSideIsEmpty : String
    let backSideIsEmtpy : String
    let titleLanguage : String
    let deleteForSwipe : String
    let front : String
    let back : String
    let create : String
    let check : String
    let selectedLanguage : String
    let closeButton : String
    let backButton : String
    let counter : String
    let backForNavBar : String
    let added : String
    let noImageSelected : String
    let placeholderInSearchBar : String
    let myDecksImage : String
    let noInformationProvided : String
    let selectImageFrom : String
    let camera : String
    let cameraRoll : String
    let saveFailed : String
    let failedToSaveImage : String
    let fontSizeForCreateButton : String
    let nameOfButtonForEditing : String
    let shakeYouPhone : String
    
    
    
    
    init(imageToCreateDeck : String , titleFirstCollectionViewController : String , titleSettings : String ,darkMode : String,laguage : String ,ratetheApp : String, sendUsFeedback : String , buttonDelete : String ,buttonRemoveAll : String , enterADeckName : String , cancel : String , wrong : String , writeNameADeck : String , gotIt : String  , frontSideIsEmpty : String ,backSideIsEmtpy : String,  titleLanguage : String , deleteForSwipe : String ,front : String, back : String , create : String , check : String , selectedLanguage : String , closeButton : String , backButton : String , counter : String , backForNavBar : String , added : String , noImageSelected : String , placeholderInSearchBar : String , myDecksImage : String , selectImageFrom : String , camera : String , cameraRoll : String, saveFailed : String , failedToSaveImage : String ,fontSizeForCreateButton :  String , nameOfButtonForEditing : String , noInformationProvided : String , shakeYouPhone : String) {
        
        self.imageToCreateDeck = imageToCreateDeck
        self.titleFirstCollectionViewController = titleFirstCollectionViewController
        self.titleSettings = titleSettings
        self.darkMode = darkMode
        self.laguage = laguage
        self.ratetheApp = ratetheApp
        self.sendUsFeedback = sendUsFeedback
        self.buttonDelete = buttonDelete
        self.buttonRemoveAll = buttonRemoveAll
        self.enterADeckName = enterADeckName
        self.cancel = cancel
        self.wrong = wrong
        self.writeNameADeck = writeNameADeck
        self.gotIt = gotIt
        self.frontSideIsEmpty = frontSideIsEmpty
        self.titleLanguage = titleLanguage
        self.deleteForSwipe = deleteForSwipe
        self.front = front
        self.back = back
        self.create = create
        self.check = check
        self.selectedLanguage = selectedLanguage
        self.closeButton = closeButton
        self.backButton = backButton
        self.counter = counter
        self.backForNavBar = backForNavBar
        self.added = added
        self.noImageSelected = noImageSelected
        self.placeholderInSearchBar = placeholderInSearchBar
        self.myDecksImage = myDecksImage
        self.selectImageFrom = selectImageFrom
        self.camera = camera
        self.cameraRoll = cameraRoll
        self.saveFailed = saveFailed
        self.failedToSaveImage = failedToSaveImage
        self.fontSizeForCreateButton = fontSizeForCreateButton
        self.nameOfButtonForEditing = nameOfButtonForEditing
        self.noInformationProvided = noInformationProvided
        self.backSideIsEmtpy = backSideIsEmtpy
        self.shakeYouPhone = shakeYouPhone
    }
    
    
    class func fetchLanguages () -> [Language]  {
        var languages = [Language]()
        //Enter a deck name
        
        //No image selected
        //"You must provide all data to create flash card"
        let englishLanguage = Language(imageToCreateDeck: "Create Deck English", titleFirstCollectionViewController: "Decks", titleSettings: "Settings", darkMode: "Dark Mode", laguage: "Language", ratetheApp: "Rate the app", sendUsFeedback: "Send us feedback", buttonDelete: "Delete", buttonRemoveAll: "Remove All", enterADeckName: "Deck Name", cancel: "Cancel", wrong: "WRONG!!!", writeNameADeck: "Write name a deck", gotIt: "GOT IT", frontSideIsEmpty: "The front of this card is completely blank \n add some text or image", backSideIsEmtpy: "The back of this card is completely blank \n  add some text or image" , titleLanguage: "Language" , deleteForSwipe: "Delete" , front: "Front" , back: "Back" , create: "CREATE" , check: "CHECK" , selectedLanguage: "English", closeButton: "done", backButton: "back"  , counter: "of" , backForNavBar: "Back" , added: "ADDED" , noImageSelected: "", placeholderInSearchBar: "Search", myDecksImage: "My decks star line two", selectImageFrom: "Select Image From", camera: "Camera", cameraRoll: "Camera Roll", saveFailed: "Save Failed", failedToSaveImage: "Failed to save image", fontSizeForCreateButton: "23", nameOfButtonForEditing: "SAVE", noInformationProvided: "You're trying to create blank card", shakeYouPhone: "Shuffle Deck")
        languages.append(englishLanguage)
        
        //Фотография не выбрана
        //"Заполни все поля для того чтобы создать карточку"
        let russianLanguage = Language(imageToCreateDeck: "Create Deck Russian", titleFirstCollectionViewController: "Колоды", titleSettings: "Настройки", darkMode: "Темный Режим", laguage: "Язык", ratetheApp: "Оцени приложение", sendUsFeedback: "Отправь нам отзыв", buttonDelete: "Удалить", buttonRemoveAll: "Удалить все", enterADeckName: "Название Колоды", cancel: "Отменить", wrong: "Ошибка", writeNameADeck: "Напиши название колоды", gotIt: "Понял", frontSideIsEmpty: "Передняя сторона карточки полностью пуста , \n добавь туда текст или картинку", backSideIsEmtpy: "Задняя сторона карточки полностью пуста , \n добавь туда текст или картинку ", titleLanguage: "Язык" , deleteForSwipe: "Удалить" , front: "Передняя сторона" , back: "Задняя сторона" , create: "СОЗДАТЬ" , check: "ПРОВЕРИТЬ" , selectedLanguage:  "Русский", closeButton: "готово" , backButton: "назад" , counter: "из" , backForNavBar: "Назад", added: "ДОБАВЛЕНО" , noImageSelected: "", placeholderInSearchBar: "Поиск", myDecksImage: "My decks star line two Russian", selectImageFrom: "Выбрать фотографию", camera: "Сфотографировать", cameraRoll: "Из фото", saveFailed: "Ошибка", failedToSaveImage: "Ошибка при сохранении фотографии", fontSizeForCreateButton: "20", nameOfButtonForEditing: "СОХРАНИТЬ", noInformationProvided: "Карточка пуста", shakeYouPhone: "Тасовать колоду встряхиванием")
        
        languages.append(russianLanguage)
        
        
        
        return languages
    }
    
    
}
