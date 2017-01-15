//
//  ViewController.swift
//  Calleasy
//
//  Created by Ellen Coelho on 19/10/16.
//  Copyright © 2016 Ellen Coelho. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI
import Foundation

class ContactStructModel{
    let name : String
    let number : String
    
    init(name : String, number : String ){
        self.name = name
        self.number = number
    }

}

class ViewController: UIViewController,UITableViewDataSource, CNContactPickerDelegate,UITableViewDelegate {
    @IBOutlet weak var tableViewContacts: UITableView!
    
    var filteredObjectsName: [String] = []
    var selectedName : Bool = false
    var contactsStruct = [ContactStructModel]()
    
    var arrayOfNames:[String]=[]
    
    var numberContact :String = ""

    @IBOutlet weak var numberLabel: UILabel!
    
    var contactStore = CNContactStore()
    
    var filtro :Int = 0
    
    var digitei: String = ""
    
    let nenhumContato = ContactStructModel(name: "Nenhum contato",number: "")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberLabel.text = ""
        print("entrei no did load ")
        self.askForContactAccess()
        tableViewContacts.isHidden = true
//        NotificationCenter.default.addObserver(
//            self,
//            selector:#selector(ViewController.getContacts),
//            name: NSNotification.Name.UIApplicationDidBecomeActive,
//            object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
                print("entrei no did appear ")
                NotificationCenter.default.addObserver(
                    self,
                    selector:#selector(ViewController.getContacts),
                    name: NSNotification.Name.UIApplicationDidBecomeActive,
                    object: nil)
    }
     func getContacts() {
        //self.askForContactAccess()
        contactsStruct = []
        arrayOfNames = []
        filteredObjectsName = []
        filtro = 0
    
        let contacts: [CNContact] = {
            let contactStore = CNContactStore()
            let keysToFetch = [
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactEmailAddressesKey,
                CNContactPhoneNumbersKey,
                CNContactImageDataAvailableKey,
                CNContactThumbnailImageDataKey] as [Any]
            
            // Get all the containers
            var allContainers: [CNContainer] = []
            do {
                allContainers = try contactStore.containers(matching: nil)
            } catch {
                print("Error fetching containers")
            }
            
            var results: [CNContact] = []
            
            // Iterate all containers and append their contacts to our results array
            for container in allContainers {
                let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
                
                do {
                    let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                    results.append(contentsOf: containerResults)
                } catch {
                    print("Error fetching results for container")
                }
            }
            
            return results
        }()
        
        print("Numero de contato",contacts.count)
        
        var index = 0;
        
        for contactOfCell in contacts {
            
            let nome = contactOfCell.givenName
            let countOfNumber = contactOfCell.phoneNumbers.count
            var numero = "Número não encontado";
    
            if(countOfNumber > 0){
                
                numero = ((contactOfCell.phoneNumbers[0].value ).value(forKey: "digits") as? String)!
            }
            
            
            let contato = ContactStructModel(name:nome,number: numero)
            
            self.contactsStruct.append(contato)
            print("Contato " + String(index) + " " + contactsStruct[index].name + contactsStruct[index].number)
            //print(contactsStruct[index].number)
            index = index + 1;
            
        }
        
        for contactsOfcell in contactsStruct {
            arrayOfNames.append(contactsOfcell.name)
            //print("Array of name",contactsOfcell.name)
            if (filteredObjectsName == [] && filtro >= 1){
                arrayOfNames.append(nenhumContato.name)
                
            }
        }
        
    }
    
    func askForContactAccess() {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if !access {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            let alertController = UIAlertController(title: "Contacts", message: message, preferredStyle: UIAlertControllerStyle.alert)
                            
                            let dismissAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (action) -> Void in
                            }
                            
                            self.present(alertController, animated: true, completion: nil)
                            alertController.addAction(dismissAction)
                            
                            
                        })
                    }
                }
            })
            
            break
        default:
            break
        }
        
    }
    

    @IBAction func funcButtons(_ sender: AnyObject) {
        self.tableViewContacts.isHidden = false
        filtrandoNumeroDigitado(numeroInt: sender.tag)
        
       
    }
    
    
    func filtrando(_ letra1:Character,letra2:Character,letra3:Character,letra4:Character,letra5:Character,letra6:Character){
        
        if(filteredObjectsName == []){
            for item in arrayOfNames {
                
                let strCharactersArray = Array(item.characters)
                if(item != ""){
                    if(strCharactersArray[0]==letra1 || strCharactersArray[0] == letra2 || strCharactersArray[0]==letra3 || strCharactersArray[0]==letra4 || strCharactersArray[0] == letra5 || strCharactersArray[0]==letra6){
                    
                        filteredObjectsName.append(item)
                        
                    }}
                
                filtro = 1
            }
            print(filteredObjectsName)
        }else{
            
            for item in filteredObjectsName {
                
                let strCharactersArray = Array(item.characters)
                
                if(filtro < strCharactersArray.count){
                    let character = strCharactersArray[filtro]
                
                    if(character  != letra1 && character != letra2 && character != letra3 && character != letra4 && character != letra5 && character != letra6){
                    
                    filteredObjectsName = filteredObjectsName.filter(){$0 != item}
                }
                }else{
                    filteredObjectsName = filteredObjectsName.filter(){$0 != item}
                }}
            filtro = filtro + 1
           // print("filtro",filtro)
            print(filteredObjectsName)
        }
        if(filteredObjectsName.count == 0){
            print(filteredObjectsName)
            
            print("nenhum resultado encontrado")}
        
        
        
    }
    
    func filtrando2(_ letra1:Character,letra2:Character,letra3:Character,letra4:Character,letra5:Character,letra6:Character,letra7:Character,letra8:Character){
        
        if(filteredObjectsName == []){
            
            for item in arrayOfNames {
                
                let strCharactersArray = Array(item.characters)
                if(item != ""){
                if(strCharactersArray[0]==letra1 || strCharactersArray[0] == letra2 || strCharactersArray[0]==letra3 || strCharactersArray[0]==letra4 || strCharactersArray[0] == letra5 || strCharactersArray[0]==letra6 || strCharactersArray[0] == letra7 || strCharactersArray[0]==letra8 ){
                    
                    filteredObjectsName.append(item)
                    
                    }}
                
                filtro = 1
            }
            
        }else{
            
            for item in filteredObjectsName {
                
                let strCharactersArray = Array(item.characters)
                if(filtro < strCharactersArray.count){
                let character = strCharactersArray[filtro]
                
                if(character  != letra1 && character != letra2 && character != letra3 && character != letra4 && character != letra5 && character != letra6 && character != letra7 && character != letra8){
                    
                    filteredObjectsName = filteredObjectsName.filter(){$0 != item}
                }
                }else{
                    filteredObjectsName = filteredObjectsName.filter(){$0 != item}
                }}
            filtro = filtro + 1
        }
        
        print(filteredObjectsName)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (filteredObjectsName == [] ) {
            
            return 1
        }else{
            
            return filteredObjectsName.count
        }
    }
    
   internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableViewContacts.dequeueReusableCell(withIdentifier: "identCell", for: indexPath) as! contactsCellTableViewCell

        
        if( filteredObjectsName == []){
            if (filtro == 0) {
                tableViewContacts.isHidden = true
            }else if(digitei != ""){
                cell.nameContact.text = "Nenhum contato encontrado"
            }else{
                tableViewContacts.isHidden = true
            }
        }
        else{
            cell.nameContact.text = filteredObjectsName[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedName = true
        
        if(filteredObjectsName != []){
            for contato in contactsStruct{
                if(contato.name == filteredObjectsName[indexPath.row]){
                    numberContact = contato.number
                
                    numberLabel.text = numberContact
                
                    digitei = numberContact
                
                }
            }
        }
    }
    
    func filtrandoNumeroDigitado(numeroInt:Int) -> Void {
        selectedName = false
        
        switch numeroInt {
            
        case 0:
            print("Digitei 0 ESPAÇO ")
            
            digitei = digitei + "0"
            
            for item in filteredObjectsName {
                
                let strCharactersArray = Array(item.characters)
                
                if(filtro < strCharactersArray.count){
                    let character = strCharactersArray[filtro]
                    
                    if(character != " "){
                        
                        filteredObjectsName = filteredObjectsName.filter(){$0 != item}
                    }
                }else{
                    filteredObjectsName = filteredObjectsName.filter(){$0 != item}
                }}
            filtro = filtro + 1
            break
        case 1:
            print("Digitei 1")
            digitei = digitei + "1"
            break
        case 2:
            print("Digitei 2 filtrar ABC ")
            digitei = digitei + "2"
            
            filtrando("a", letra2: "b", letra3: "c", letra4: "A", letra5: "B" ,letra6: "C")
            
            
            break
        case 3:
            print("Digitei 3 DEF")
            digitei = digitei + "3"
            filtrando("d", letra2: "e", letra3: "f", letra4: "D", letra5: "E" ,letra6: "F")
            
            break
        case 4:
            print("Digitei 4 ghi")
            digitei = digitei + "4"
            
            filtrando("g", letra2: "h", letra3: "i", letra4: "G", letra5: "H" ,letra6: "I")
            break
        case 5:
            print("Digitei 5 jkl")
            digitei = digitei + "5"
            filtrando("j", letra2: "k", letra3: "l", letra4: "J", letra5: "K" ,letra6: "L")
            break
        case 6:
            print("Digitei 6 mno")
            digitei = digitei + "6"
            filtrando("m", letra2: "n", letra3: "o", letra4: "M", letra5: "N" ,letra6: "O")
            
            break
        case 7:
            print("Digitei 7 PQRS")
            digitei = digitei + "7"
            filtrando2("p", letra2: "q", letra3: "r", letra4: "s", letra5: "P" ,letra6: "Q",letra7: "R" ,letra8: "S")
            break
        case 8:
            print("Digitei 8")
            digitei = digitei + "8"
            filtrando("t", letra2: "u", letra3: "v", letra4: "T", letra5: "U" ,letra6: "V")
            break
        case 9:
            print("Digitei 9 wkyz")
            digitei = digitei + "9"
            filtrando2("w", letra2: "k", letra3: "y", letra4: "z", letra5: "W" ,letra6: "K",letra7: "Y" ,letra8: "Z")
            
            break
        default:
            print("erro")
            
        }
//        if numberLabel.text == ""{
//            filteredObjectsName = []
//        
//        }
        numberLabel.text = digitei
        
        tableViewContacts.reloadData()
        
       //return filteredObjectsName
    }
    
    @IBAction func buttonCall(_ sender: AnyObject) {
        let ligando : String = numberLabel.text!

        let url = URL(string: "tel://" + ligando)
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
       
        
    }
    
    @IBAction func deleteButton(_ sender: AnyObject) {
        print("entrei em funcao delete")
        
        let strCharactersArray = Array(digitei.characters)
        var index : Int = 0
        var stringChar:[Character] = []
        var numeroDigitadoInteiro : Int
        
        filteredObjectsName = []
        //while index < (strCharactersArray.count - 1)
        
         digitei = ""
        if(selectedName == false){
            for item in strCharactersArray{
                
                if(index < (strCharactersArray.count - 1)) {
                    stringChar.append(item)
                    print(item)
                    //************ Ajeitar esse erro depois!!! *********
                    numeroDigitadoInteiro = Int(String(item))!
                    
                    filtrandoNumeroDigitado(numeroInt: numeroDigitadoInteiro)
                    //numberLabel.text = digitei
            
                    index = index + 1
                }
                
            }}
        
            let stringNumber = String(stringChar)
        
            digitei = stringNumber
        
            print("O que eu havia digitado",digitei)
        
            print("Objetos filtrados",filteredObjectsName)
        
            numberLabel.text = digitei
        
            tableViewContacts.reloadData()
        
    }
}