//
//  ViewController.swift
//  XOGame
//
//  Created by Nouf Alloboon on 14/03/1447 AH.
//

import UIKit

class ViewController: UIViewController {

    enum Player: String{case x = "X", o = "O"}

    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var scoreXLabel: UILabel!
    @IBOutlet weak var scoreOLabel: UILabel!
    @IBOutlet var cells: [UIButton]!

    private var board: [Player?] = Array(repeating: nil, count: 9)
    private var current: Player = .x
    private var winner: Player? = nil
    private var isDraw: Bool = false
    private var scoreX: Int = 0
    private var scoreO: Int = 0

    private let winSets: Set<Set<Int>> = [
        [0,1,2], [3,4,5], [6,7,8],
        [0,3,6], [1,4,7], [2,5,8],
        [0,4,8], [2,4,6]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI()
                
    }
    
    private func setupUI() {
        cells.sort{$0.tag < $1.tag}
        cells.forEach { b in
            b.layer.cornerRadius = 12
            b.layer.borderWidth = 2
            b.layer.borderColor = UIColor.label.cgColor
            b.setTitle("", for: .normal)
            b.configuration = nil
            b.titleLabel?.font = .systemFont(ofSize: 100, weight: .bold)
       //     b.setTitleColor(.black, for: .normal)
        }

    }

    private func updateUI() {
        for i in 0..<9 {
            if let player = board[i] {
                cells[i].setTitle(player.rawValue, for: .normal)
                if player == .x {
                    cells[i].setTitleColor(.systemRed, for: .normal)
                } else {
                    cells[i].setTitleColor(.systemBlue, for: .normal)
                }
            } else {
                cells[i].setTitle("", for: .normal)
            }
            cells[i].isEnabled = (board[i] == nil) && (winner == nil) && !isDraw
            cells[i].alpha = cells[i].isEnabled ? 1.0 : 0.75
        }
        turnLabel.text = "Turn: \(current.rawValue)"
        scoreXLabel.text = "X: \(scoreX)"
        scoreOLabel.text = "O: \(scoreO)"
    }

    private func evaluateBoard() {
        let positions = Set(board.indices.compactMap { board[$0] == current ? $0 : nil })
        for w in winSets where w.isSubset(of: positions) {
            winner = current
            return
        }
        if board.allSatisfy({ $0 != nil }) { isDraw = true }
    }
    
    private func resetRound(keepScore: Bool) {
        board = Array(repeating: nil, count: 9)
        winner = nil
        isDraw = false
        if !keepScore { current = .x }
        updateUI()
    }
    
    
    
    @IBAction func cellTapped(_ sender: UIButton){
        let index = sender.tag
        guard board[index] == nil, winner == nil, !isDraw else { return }

        board[index] = current
        evaluateBoard()

        if winner == nil && !isDraw {
            current = (current == .x) ? .o : .x
        }

        updateUI()

        if let w = winner {
            if w == .x { scoreX += 1 } else { scoreO += 1 }
            showResultAlert(title: "Win", message: "Player \(w.rawValue) wins!")
        } else if isDraw {
            showResultAlert(title: "Draw", message: "No one wins.")
        }
    }
    
    @IBAction func resetRoundTapped(_ sender: Any) {
        resetRound(keepScore: true)
    }
    
 
    @IBAction func resetAllTapped(_ sender: Any) {
        scoreX = 0
        scoreO = 0
        resetRound(keepScore: false)
    }
    
    
    private func showResultAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "New Round", style: .default, handler: { _ in
            self.resetRound(keepScore: true)
        }))
        present(alert, animated: true)
    }
    
}

