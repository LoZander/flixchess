use Chess/Piece.Piece;
use Chess/Player.Player;
use Chess/Board.{Board, createBoard, move};

// The main entry point.
def main(): Unit & Impure = {
    let board = createBoard();
    board |> println;
    let board2 = board |> move(fro = (1,1), to = (1,2));
    match board2 {
        case Err(s) => s |> println,
        case Ok(b) => b |> println
    }
}