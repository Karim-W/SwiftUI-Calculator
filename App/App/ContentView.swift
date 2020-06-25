//
//  ContentView.swift
//  App
//
//  Created by Karim Wael on 6/24/20.
//  Copyright © 2020 Karim Wael. All rights reserved.
//

import SwiftUI

enum keys:String{
       case Zero,One,Two,Three,Four,Five,Six,Seven,Eight,Nine,dec
       case Plus,Minus,Multiply,Divide,Equal
       case AC,PC,PM
       var title:String {
           switch self {
           case .dec:return "."
               case .Equal : return "="
           case .Zero:return "0"
           case .One:
               return "1"
           case .Two:
               return "2"
           case .Three:
               return "3"
           case .Four:
               return "4"
           case .Five:
               return "5"
           case .Six:
               return "6"
           case .Seven:
               return "7"
           case .Eight:
               return "8"
           case .Nine:
               return "9"
           case .Plus:
               return "+"
           case .Minus:
               return "-"
           case .Multiply:
               return "x"
           case .Divide:
               return "÷"//÷
           case .AC:
               return "AC"//AC
           case .PC:
               return "%"
           case .PM:
               return "+/-"
   
           }
       }
       
       var backgroundColor:Color{
       switch self{
       case .Plus: return Color.orange
       case .Equal : return Color.orange
       case .Zero,.One,.Two,.Three,.Four,.Five,.Six,.Seven,.Eight,.Nine,.dec:
           return Color.init(UIColor.darkGray)
       case .Minus:
           return Color.orange
       case .Multiply:
           return Color.orange
       case .Divide:
           return Color.orange
       case .AC:
           return Color.gray
       case .PC:
           return Color.gray
       case .PM:
           return Color.gray
           }
           
       }
   }
class GlobalEnviroment: ObservableObject{
    @Published var Display = ""
    @Published var Satement = ""
    @Published var eq =  false
    @Published var dFlag = false
    @Published var left = ""
    @Published var OP = Character("z")

}

struct Queues {
    var list = [Character]()
    
    public mutating func enqueue( element: Character) {
      list.append(element)
    }
    public mutating func dequeue() -> Character{
        let t = list.remove(at: 0)
        return t
    }
}

struct ContentView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    let buttons:[[keys]] = [
        [.AC,.PM,.PC,.Divide],
        [.Seven,.Eight,.Nine,.Multiply],
        [.Four,.Five,.Six,.Minus],
        [.One,.Two,.Three,.Plus],
        [.Zero,.dec,.Equal]]
    var Disp:String = ""
    let col = Color.gray
    let itemw = (UIScreen.main.bounds.width-40)/4
    var body: some View {
        ZStack (alignment: .bottom ){
            
            Color.black.edgesIgnoringSafeArea(.all)
            VStack (spacing: 12){
                HStack{
                    Spacer()
                    
                    Text(env.Display).foregroundColor(.white).font(.system(size: 72))}.padding()
                ForEach(buttons,id: \.self)
                { row in
                HStack{
                    ForEach(row,id: \.self)
                    {
                        button in
                        Button(action: {
                            if (self.env.eq == true) {self.env.Display = ""; self.env.eq = false}
                            if(button == .AC){
                                self.env.Display = ""
                                self.env.left = ""
                                self.env.dFlag = false
                            }else
                            if (button == .PC){
                                self.env.dFlag = true
                                let t: Float = ( self.env.Display as NSString).floatValue
                                self.env.Display = String(t/100)
                            }else
                            if (button == .PM){
                                self.env.dFlag = true
                                let t: Float = ( self.env.Display as NSString).floatValue
                                self.env.Display = String(t * -1)
                            }else if(button.title == "+" || button.title == "-" || button.title == "x" || button.title == "÷"){
                                self.env.left = self.env.Display
                                self.env.Display = ""
                                self.env.OP = Character(button.title)
                                }else
                            if (button == .Equal){
                                self.env.eq = true
                                self.env.Display = self.Domath(l: self.env.left, o: self.env.OP, r: self.env.Display)
                            }else{
                                self.env.Display = self.env.Display + button.title}
                            
                            
                        }) {
                            Text(button.title).font(.system(size: 32)).frame(width: self.getW(but: button), height: self.itemw, alignment: .center).foregroundColor(.white).background(button.backgroundColor).cornerRadius(self.getW(but: button)/2)
                        }
                    }
                    }
                }
            }.padding(.bottom)
        }
        
    }
    func calc(dis:String) -> String{
        var que = Queues()
        var left = String()
        var right = String()
        var op = Character("z")
        //var res = Float()
        let state = dis.unicodeScalars.map{ Character($0) }
        //let char = charSequence[index]
        for i in 0...state.count-1
        {
            if( state[i] == "+" || state[i] == "-" || state[i] == "x" || state[i] == "÷")
            {
                op = state[i]
            }else if (op == "z")
            {
                left.append(state[i])
            }else {
                right.append(state[i])
            }
        }
        
        return Domath(l:left, o:op, r:right)
    }
    func Domath(l:String,o:Character,r:String)->String{
        var res = Float()
        var nres = Int()
        switch o{
        case "+":
            if (env.dFlag == false){
                nres = (Int(l)! + Int(r)!)
            return String(nres)
            }else{
                res = ((l as NSString).floatValue + (r as NSString).floatValue)
                return String(res)
        }
        case"-":
            if (env.dFlag == false){
                nres = (Int(l)! - Int(r)!)
            return String(nres)
            }else{
            res = ((l as NSString).floatValue - (r as NSString).floatValue)
                return String(res)
                
            }
        case"x":
            if (env.dFlag == false){
                nres = (Int(l)! * Int(r)!)
            return String(nres)
            }else{
            res = ((l as NSString).floatValue * (r as NSString).floatValue)
                return String(res)
            }
        case "÷":
            res = ((l as NSString).floatValue / (r as NSString).floatValue)
            return String(res)
        default:
            return "ERR"
        }
    }
    
    func getW(but:keys) -> CGFloat{
        if (but == .Zero){
            return itemw * 2
        }else{
            return itemw
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnviroment())
    }
}
