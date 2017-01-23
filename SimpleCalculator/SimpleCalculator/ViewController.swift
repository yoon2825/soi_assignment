//
//  ViewController.swift
//  SimpleCalculator
//
//  Created by Dongyoon Kang on 2017. 1. 22..
//  Copyright © 2017년 Dongyoon Kang. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var displayView: UITextField!
    var isInitCalculator : Bool = false
    var accumulator: Double = 0.0 // 가산기. 결과값 저장해놓고 가산.
    var userInput = "" // 유저의 입력
    var numStack: [Double] = [] // 넘버 저장해놓는 배열
    var opStack: [String] = [] // 연산자를 저장해놓는 배열

    override func viewDidLoad() {
        super.viewDidLoad()
        displayView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetDisplayView()
    }
    
    @IBAction func inputNumber(_ sender : UIButton) {
        let digit = sender.currentTitle
    
        handleInput(digit!)
    
    }
    
    @IBAction func inputOperand(_ sender : UIButton) {
        let operand = sender.currentTitle!
        
        switch operand {
        case "+" :
            doMath("+")
        case "-" :
            doMath("-")
        case "x" :
            doMath("*")
        case "/" :
            doMath("/")
        case "=" :
            doEquals()
        default : break
            
        }
    }
    
    @IBAction func dotButtonClicked(_ sender : UIButton) {
        if hasIndex(stringToSearch: userInput, characterToFind: ".") == false {
            handleInput(".")
        }
    }
    
    
    func doMath(_ newOp: String) {
        
        if userInput != "" && !numStack.isEmpty { // 입력숫자가 있다면 연산.
            if !opStack.isEmpty {
                let stackOp = opStack.removeLast()
                switch stackOp {
                case "+":
                    accumulator = add(numStack.removeLast(), accumulator)
                case "-":
                    accumulator = sub(numStack.removeLast(), accumulator)
                case "*":
                    accumulator = mul(numStack.removeLast(), accumulator)
                case "/":
                    if accumulator == Double(0) {
                        displayView.text = "오류"
                        userInput = ""
                        accumulator = 0
                        opStack.removeAll()
                        numStack.removeAll()
                        return
                    }
                    accumulator = div(numStack.removeLast(), accumulator)
                default: break
                }
                doEquals()
            }
        }
        // 연산 후 새로 들어온 연산자 opStack에 추가 < 여긴 무조건 수행 > 무조건 수행되면 안된다. opStack은 없다면 append, 하나라도 있다면 교체
        if opStack.isEmpty {
            opStack.append(newOp)
        } else {
            opStack.removeAll()
            opStack.append(newOp)
        }
        numStack.append(accumulator)
        userInput = ""
        updateDisplay()
    }
    
    @IBAction func clearButtonClicked(_ sender : UIButton) {
        userInput = ""
        accumulator = 0
        updateDisplay()
        numStack.removeAll()
        opStack.removeAll()
        isInitCalculator = true
    }
    
    func doEquals() {
        if userInput == "" {
            return
        }
        if !numStack.isEmpty && !opStack.isEmpty {
            let stackOp = opStack.last!
            switch stackOp {
            case "+":
                accumulator = add(numStack.removeLast(), accumulator)
            case "-":
                accumulator = sub(numStack.removeLast(), accumulator)
            case "*":
                accumulator = mul(numStack.removeLast(), accumulator)
            case "/":
                if accumulator == Double(0) {
                    displayView.text = "오류"
                    userInput = ""
                    accumulator = 0
                    opStack.removeAll()
                    numStack.removeAll()
                    return
                }
                accumulator = div(numStack.removeLast(), accumulator)
            default: break
            }
            
        }
        updateDisplay()
        userInput = ""
    }

    func updateDisplay() {

        // Int형식일때는 .을 표시하지 않는다.
        let iAcc = Int(accumulator)
        if accumulator - Double(iAcc) == 0 {
            displayView.text = "\(iAcc)"
        } else {
            displayView.text = "\(accumulator)"
        }
    }
    
    // 사칙연산 함수
    func add(_ a: Double, _ b: Double) -> Double {
        let result = a + b
        return result
    }
    func sub(_ a: Double, _ b: Double) -> Double {
        let result = a - b
        return result
    }
    func mul(_ a: Double, _ b: Double) -> Double {
        let result = a * b
        return result
    }
    func div(_ a: Double, _ b: Double) -> Double {

        let result = a / b
        
        return result
    }

    
    // '.' 이 하나만 눌리기 위한 character 검사
    func hasIndex(stringToSearch str: String, characterToFind ch: Character) -> Bool {
        for c in str.characters{
            if c == ch {
                return true
            }
        }
        return false
    }
    
    func handleInput(_ str: String) {
        userInput += str
        accumulator = (userInput as NSString).doubleValue
        updateDisplay()
    }
    
    // 키보드 숨기기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // 델리게이트 - 입력이 시작될 때 0으로 초기화 되어있다면 text 는 ""로 초기화
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.text == "0" {
            textField.text = ""
        }
        return true
    }
    // 델리게이트 - 입력이 끝난 후 텍스트가 비어있다면 0으로 초기화 아니라면, 입력 처리
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            resetDisplayView()
        } else {
            handleInput(textField.text!)
        }
    }
    
    // 텍스트필드가 숫자만 입력 가능하도록 제한.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let regex = try! NSRegularExpression(pattern: "\\..{3,}", options: [])
        let matches = regex.matches(in: newText, options:[], range:NSMakeRange(0, newText.characters.count))
        guard matches.count == 0 else { return false }
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            let array = textField.text?.characters.map { String($0) }
            var decimalCount = 0
            for character in array! {
                if character == "." {
                    decimalCount += 1
                }
            }
            if decimalCount > 0 {
                return false
            } else {
                return true
            }
        default:
            let array = string.characters.map { String($0) }
            if array.count == 0 {
                return true
            }
            return false
        }
    }
    // 계산기 초기화
    func resetDisplayView(){
        displayView.text = "0"
        isInitCalculator = true
    }
    
}

