//
//  CreateView.swift
//  Marubatu
//
//  Created by 鴛海剛 on 2025/02/15.
//

import SwiftUI

struct CreateView: View {
    @Binding var quizzesArray: [Quiz] //回答画面を読み込んだ問題を受け取る
    @State private var questionText = ""//テキストフィールドの文字を受け取る
    @State private var selectedAnswer = "◯" //ピッカーで選ばれた解答を受け取る
    let answers = ["◯", "×"] // ピッカーの選択肢一覧
    
    
    var body: some View {
        VStack {
            Text("問題文を解答を入力して、追加ボタンを押してください。")
                .foregroundStyle(.gray)
                .padding()
            
            TextField(text: $questionText) {
                
                Text("問題文を入力して下さい")
            }
            .padding()
            .textFieldStyle(.roundedBorder)
            
            //解答を選択するピッカー
            Picker("解答", selection: $selectedAnswer) {
                ForEach(answers, id: \.self) { answer in
                    Text(answer)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            //追加ボタン
            Button {
                //追加ボタンがおされたの処理
                addQuiz(question: questionText, answer: selectedAnswer)

            } label: {
                Text("追加")
            }
            .padding()
            
            //全削除ボタン
            Button {
                quizzesArray .removeAll()//配列を空に
                UserDefaults.standard
                    .removeObject(forKey: "quiz")//保存されいるもの
            }  label: {
                Text("全削除")
            }
            .foregroundStyle(.red)
            .padding()
        }
    }
    
    //問題追加・保存の関数
    func addQuiz(question: String, answer: String) {
        //問題文が入力されているかチェック
        if question.isEmpty {
            print("問題文が入力されていません")
            return
        }
        
        var savingAnswer = true //保存するためのtrue/falseを入れる変数
        
        //◯か×で、true/faseを切り替える
        switch answer {
        case "◯":
            savingAnswer = true
        case "×":
            savingAnswer = false
        default:
            print("適切な答えが入っていません")
            break
        }
        
        let newQuiz = Quiz(question: question, answer: savingAnswer)
        
        var array: [Quiz] = []   //Quizの配列の変数を用意
        array.append(newQuiz)//作った問題を配列に追加
        let storeKey = "quiz"//UserDefaultsに保存するキー
        
        if let encodedQuizzes = try? JSONEncoder().encode(array) {
            UserDefaults.standard.setValue(encodedQuizzes, forKey: storeKey)
            questionText = "" // テキストフィールドも空白に戻しておく
            quizzesArray = array//既存の問題　＋新問題となった配列に更新
        }
    }
    
}


//#Preview {
//    CreateView()
//}
