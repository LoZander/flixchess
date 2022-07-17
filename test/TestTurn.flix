use Chess/Board.{createBoard, getPiece, getTurn, move};
use Chess/Board.Board;
use Chess/Piece.Piece;
use Chess/Piece.Piece.{King, Queen, Bishop, Knight, Rook, Pawn};
use Chess/Player.Player;
use Chess/Player.Player.{White, Black};

@test
def canMoveWhitePieceWhenWhiteTurn(): Bool = {
    let board: Board = Board.Board({turn = White, tiles = Map#{(3,3) => Queen(White)}});
    let result: Result[Board,String] = board |> move(fro = (3,3), to = (4,4));
    match result {
        case Err(_) => false,
        case Ok(_) => true
    }
}

@test
def cantMoveWhitePieceWhenBlackTurn(): Bool = {
    let board: Board = Board.Board({turn = Black, tiles = Map#{(3,3) => Queen(White)}});
    let result: Result[Board,String] = board |> move(fro = (3,3), to = (4,4));
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def canMoveBlackPieceWhenBlackTurn(): Bool = {
    let board: Board = Board.Board({turn = Black, tiles = Map#{(3,3) => Queen(Black)}});
    let result: Result[Board,String] = board |> move(fro = (3,3), to = (4,4));
    match result {
        case Err(_) => false,
        case Ok(_) => true
    }
}

@test
def cantMoveBlackPieceWhenWhiteTurn(): Bool = {
    let board: Board = Board.Board({turn = White, tiles = Map#{(3,3) => Queen(Black)}});
    let result: Result[Board,String] = board |> move(fro = (3,3), to = (4,4));
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def whiteStarts(): Bool = {
    let board: Board = createBoard();
    let turn: Player = board |> getTurn;
    turn == White
}

@test
def blackAfterWhite(): Bool = {
    let board: Board = Board.Board({turn = White, tiles = Map#{(3,3) => Queen(White)}});
    let result: Result[Board, String] = board |> move(fro = (3,3), to = (3,4));
    match result {
        case Err(_) => false
        case Ok(b) => b |> getTurn == Black
    }
}

@test
def whiteAfterBlack(): Bool = {
    let board: Board = Board.Board({turn = Black, tiles = Map#{(3,3) => Queen(Black)}});
    let result: Result[Board, String] = board |> move(fro = (3,3), to = (3,4));
    match result {
        case Err(_) => false
        case Ok(b) => b |> getTurn == White
    }
}