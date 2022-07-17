use Chess/Board.{createBoard, getPiece, move};
use Chess/Board.Board;
use Chess/Piece.Piece;
use Chess/Piece.Piece.{King, Queen, Bishop, Knight, Rook, Pawn};
use Chess/Player.Player;
use Chess/Player.Player.{White, Black};

@test
def pawnCanMoveForward1Step(): Bool = {
    let before = Board.Board({tiles = Map#{(1,1) => Piece.Pawn(Player.White)}, turn = White});
    let result = before |> move(fro = (1,1), to = (1,2));
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isPawnAt12 = inner |> getPiece((1,2)) == Some(Piece.Pawn(Player.White));
            isPawnAt12
        }
    }
}

@test
def afterMovingPieceItIsntDuplicated(): Bool = {
    let before = Board.Board({tiles = Map#{(1,1) => Piece.Pawn(Player.White)}, turn = White});
    let result = before |> move(fro = (1,1), to = (1,2));
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isNoneAt11 = inner |> getPiece((1,1)) == None;
            isNoneAt11
        }
    }
}

@test
def pawnCantMoveBackwards(): Bool = {
    let fro = (3,3);
    let to = (3,2);
    let result = Board.Board({tiles = Map#{fro => Piece.Pawn(Player.White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def whitePawnCantMoveUpRight(): Bool = {
    let fro = (3,3);
    let to = (4,4);
    let board: Board = Board.Board({tiles = Map#{fro => Piece.Pawn(Player.White)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def whitePawnCantMoveUpLeft(): Bool = {
    let fro = (3,3);
    let to = (2,4);
    let board: Board = Board.Board({tiles = Map#{fro => Piece.Pawn(Player.White)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def blackPawnCantMoveDownLeft(): Bool = {
    let fro = (3,3);
    let to = (2,2);
    let board: Board = Board.Board({tiles = Map#{fro => Piece.Pawn(Player.Black)}, turn = Black});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def blackPawnCantMoveDownRight(): Bool = {
    let fro = (3,3);
    let to = (4,2);
    let board: Board = Board.Board({tiles = Map#{fro => Piece.Pawn(Player.Black)}, turn = Black});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def pawnCanOnlyMoveOneStep(): Bool = {
    let fro = (1,1);
    let to = (1,3);
    let result = Board.Board({tiles = Map#{fro => Piece.Pawn(Player.White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def rookCanMoveMultipleTiles(): Bool = {
    let fro = (1,1);
    let to = (1,5);
    let result = Board.Board({tiles = Map#{fro => Rook(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isRookAt15 = inner |> getPiece((1,5)) == Some(Rook(White));
            isRookAt15
        }
    }
}

@test
def rookCantMoveDiagUpRight(): Bool = {
    let fro = (3,3);
    let to = (6,6);
    let result = Board.Board({tiles = Map#{fro => Rook(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def rookCanMoveOnXAxis(): Bool = {
    let fro = (3,3);
    let to = (6,3);
    let result = Board.Board({tiles = Map#{fro => Rook(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isRookAt63 = inner |> getPiece(to) == Some(Rook(White));
            isRookAt63
        }
    }
}

@test
def bishopCanMoveDiagUpRight(): Bool = {
    let fro = (3,3);
    let to = (6,6);
    let result = Board.Board({tiles = Map#{fro => Bishop(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isBishopAt66 = inner |> getPiece(to) == Some(Bishop(White));
            isBishopAt66
        }
    }
}

@test
def bishopCanMoveDiagDownRight(): Bool = {
    let fro = (3,3);
    let to = (6,0);
    let result = Board.Board({tiles = Map#{fro => Bishop(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isBishopAt60 = inner |> getPiece(to) == Some(Bishop(White));
            isBishopAt60
        }
    }
}

@test
def knightCanMoveUp2Right1(): Bool = {
    let fro = (3,3);
    let to = (4,5);
    let result = Board.Board({tiles = Map#{fro => Knight(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKnightAt45 = inner |> getPiece(to) == Some(Knight(White));
            isKnightAt45
        }
    }
}

@test
def knightCanMoveUp2Left1(): Bool = {
    let fro = (3,3);
    let to = (2,5);
    let result = Board.Board({tiles = Map#{fro => Knight(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKnightAt45 = inner |> getPiece(to) == Some(Knight(White));
            isKnightAt45
        }
    }
}

@test
def knightCanMoveDown1Left2(): Bool = {
    let fro = (3,3);
    let to = (1,2);
    let result = Board.Board({tiles = Map#{fro => Knight(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKnightAt45 = inner |> getPiece(to) == Some(Knight(White));
            isKnightAt45
        }
    }
}

@test
def queenCanMoveLikeBishop(): Bool = {
    let fro = (3,3);
    let to = (6,6);
    let result = Board.Board({tiles = Map#{fro => Queen(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isQueenAt66 = inner |> getPiece(to) == Some(Queen(White));
            isQueenAt66
        }
    }   
}

@test
def queenCanMoveLikeRook(): Bool = {
    let fro = (3,3);
    let to = (6,3);
    let result = Board.Board({tiles = Map#{fro => Queen(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isQueenAt63 = inner |> getPiece(to) == Some(Queen(White));
            isQueenAt63
        }
    }   
}

@test
def kingCanMoveForward(): Bool = {
    let fro = (3,3);
    let to = (3,4);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKingAt34 = inner |> getPiece(to) == Some(King(White));
            isKingAt34
        }
    }   
}

@test
def kingCantMoveForwardMoreThan1(): Bool = {
    let fro = (3,3);
    let to = (3,5);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }   
}

@test
def kingCanMoveLeft(): Bool = {
    let fro = (3,3);
    let to = (2,3);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKingAt23 = inner |> getPiece(to) == Some(King(White));
            isKingAt23
        }
    }   
}

@test
def kingCantMoveLeftMoreThan1(): Bool = {
    let fro = (3,3);
    let to = (1,3);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }   
}

@test 
def kingCanMoveBackwards(): Bool = {
    let fro = (3,3);
    let to = (3,2);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKingAt32 = inner |> getPiece(to) == Some(King(White));
            isKingAt32
        }
    }   
}

@test
def kingCantMoveBackwardsMoreThan1(): Bool = {
    let fro = (3,3);
    let to = (3,1);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }   
}

@test 
def kingCanMoveRight(): Bool = {
    let fro = (3,3);
    let to = (4,3);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isKingAt43 = inner |> getPiece(to) == Some(King(White));
            isKingAt43
        }
    }   
}

@test
def kingCantMoveRightMoreThan1(): Bool = {
    let fro = (3,3);
    let to = (5,3);
    let result = Board.Board({tiles = Map#{fro => King(White)}, turn = White}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }   
}

@test
def blackPawnCanMoveForward(): Bool = {
    let fro = (3,3);
    let to = (3,2);
    let result = Board.Board({tiles = Map#{fro => Pawn(Black)}, turn = Black}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => false,
        case Ok(inner) => {
            let isBlackPawnAt32 = inner |> getPiece(to) == Some(Pawn(Black));
            isBlackPawnAt32
        }
    }   
}

@test
def blackPawnCantMoveBackwards(): Bool = {
    let fro = (3,3);
    let to = (3,4);
    let result = Board.Board({tiles = Map#{fro => Pawn(Black)}, turn = Black}) |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }   
}

@test
def rookCantMoveVerticallyThroughPiece(): Bool = {
    let fro = (3,3);
    let mid = (3,5);
    let to = (3,8);
    let board: Board = Board.Board({tiles = Map#{fro => Rook(White), mid => Rook(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def rookCantMoveHorizontallyThroughPiece(): Bool = {
    let fro = (3,3);
    let mid = (2,3);
    let to = (0,3);
    let board: Board = Board.Board({tiles = Map#{fro => Rook(White), mid => Rook(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def bishopCantMoveUpRightThroughPiece(): Bool = {
    let fro = (3,3);
    let mid = (5,5);
    let to = (8,8);
    let board: Board = Board.Board({tiles = Map#{fro => Bishop(White), mid => Bishop(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def bishopCantMoveUpLeftThroughPiece(): Bool = {
    let fro = (3,3);
    let mid = (1,5);
    let to = (0,6);
    let board: Board = Board.Board({tiles = Map#{fro => Bishop(White), mid => Bishop(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def bishopCantMoveDownRightThroughPiece(): Bool = {
    let fro = (3,3);
    let mid = (5,1);
    let to = (6,0);
    let board: Board = Board.Board({tiles = Map#{fro => Bishop(White), mid => Bishop(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}

@test
def bishopCantMoveDownLeftThroughPiece(): Bool = {
    let fro = (3,3);
    let mid = (2,2);
    let to = (0,0);
    let board: Board = Board.Board({tiles = Map#{fro => Bishop(White), mid => Bishop(Black)}, turn = White});
    let result = board |> move(fro = fro, to = to);
    match result {
        case Err(_) => true,
        case Ok(_) => false
    }
}