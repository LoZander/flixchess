use Chess/Board.{createBoard, getPiece, move};
use Chess/Board.Board;
use Chess/Piece.Piece;
use Chess/Piece.Piece.{King, Queen, Bishop, Knight, Rook, Pawn};
use Chess/Player.Player;
use Chess/Player.Player.{White, Black};

@test
def pieceCanMoveOntoEnemy(): Bool = {
    let fro = (3,3);
    let to = (3,4);
    let board: Board = Board.Board({tiles = Map#{fro => Rook(White), to => Rook(Black)}, turn = White});
    let result: Result[Board, String] = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(_) => true
    }
}

@test 
def whitePawnCanMoveUpRightOntoEnemy(): Bool = {
    let fro = (3,3);
    let to = (4,4);
    let board: Board = Board.Board({tiles = Map#{fro => Pawn(White), to => Pawn(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(_) => true
    }
}

@test
def whitePawnCanMoveUpLeftOntoEnemy(): Bool = {
    let fro = (3,3);
    let to = (2,4);
    let board: Board = Board.Board({tiles = Map#{fro => Pawn(White), to => Pawn(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(_) => true
    }
}

@test
def blackPawnCanMoveDownLeftOntoEnemy(): Bool = {
    let fro = (3,3);
    let to = (2,2);
    let board: Board = Board.Board({tiles = Map#{fro => Pawn(Black), to => Pawn(White)}, turn = Black});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(_) => true
    }
}

@test
def pieceCantMoveOntoFriend(): Bool = {
    let fro = (3,3);
    let to = (3,5);
    let board: Board = Board.Board({tiles = Map#{fro => Rook(White), to => Rook(White)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}