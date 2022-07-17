use Chess/Piece.{Piece, getOwner};
use Chess/Player.Player;
use Chess/Player.Player.{Black, White};
use Chess/Piece.Piece.{King, Queen, Knight, Bishop, Rook, Pawn};
use Chess/Board.{Board, getTurn, getPiece, isPlayerInTurn};

namespace Chess/MoveValidator {
    /**
     *  Checks that a move from one tile to another is valid.
     *
     *  @precondition: there is a piece at the "from tile".
     *
     *  @param fro {fro :: (Int32, Int32)}: The position the piece is to be moved from.
     *  @param to {to :: (Int32, Int32)}: The position the piece is to be moved to.
     *  @param piece Piece: The piece which is to be moved.
     *  @param board Board: The board in question.
     *
     *  @return Result[Board, String]: Ok(board) if the move is valid, where board is unchanged,
     *  or Err(message) if the move is invalid, where message explains why.
     */
    pub def isMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, piece: Piece, board: Board): Result[Board, String] & Pure = {
        Ok(board)                                   |> 
        Result.flatMap(actingPlayerIsInTurn(fro))   |>
        Result.flatMap(isFriendlyFire(fro, to))     |>
        Result.flatMap(pieceCheck(fro, to, piece))
    }

    def actingPlayerIsInTurn(fro: {fro :: (Int32, Int32)}, board: Board): Result[Board, String] = {
        let playerInTurn: Player = getTurn(board);
        let moverIsInTurn: Bool = board         |>
        getPiece(fro.fro)                       |>
        Option.map(getOwner)                    |>
        Option.map(p1 -> p1 == playerInTurn)    |>
        Option.getWithDefault(false);

        if(not moverIsInTurn)
            Err("${playerInTurn} can only move ${playerInTurn} pieces")
        else
            Ok(board)
        
    }

    def isFriendlyFire(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, b: Board): Result[Board, String] = {
        let isFriendlyFire: Bool = match (b |> getPiece(fro.fro), b |> getPiece(to.to)) {
            case (Some(p1), Some(p2))   => getOwner(p1) == getOwner(p2),
            case _                      => false
        };
        if(isFriendlyFire)
            Err("Friendly fire is not allowed")
        else
            Ok(b)
    }

    def pieceCheck(f: {fro :: (Int32,Int32)}, t: {to :: (Int32,Int32)}, p: Piece, b: Board): Result[Board, String] = {
        b |> match p {
            case King(_)    => isKingMoveValid(f, t),
            case Queen(_)   => isQueenMoveValid(f, t),
            case Bishop(_)  => isBishopMoveValid(f, t),
            case Knight(_)  => isKnightMoveValid(f, t),
            case Rook(_)    => isRookMoveValid(f, t),
            case Pawn(_)    => isPawnMoveValid(f, t, p)
        }
    }

    def isRookMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, board: Board): Result[Board, String] & Pure = {
        let (xFro, yFro) = fro.fro;
        let (xTo, yTo) = to.to;
        let xDif = xTo - xFro;
        let yDif = yTo - yFro;

        match (xDif, yDif) {
            case (0,0) => Err("Can't move a piece to it's current position"),
            case (x,0) => board |> isPieceBetween(offset -> (xFro + offset, yFro), x),
            case (0,y) => board |> isPieceBetween(offset -> (xFro, yFro + offset), y),
            case _ => Err("Rook can only move strictly vertically or horizontally")
        }
    }

    def isPieceBetween(xyUpdateFunction: Int32 -> (Int32, Int32) & Pure, z: Int32, board: Board): Result[Board, String] = {
        def loop(c: Int32) = match c {
            case 0 => false,
            case a => {
                let isPiece = not (board |> getPiece(xyUpdateFunction(a)) |> Option.isEmpty);
                isPiece or loop(a + if(z < 0) 1 else -1)
            }
        };

        if(loop(z - 1))
            Err("Rook can't move through pieces")
        else
            Ok(board)
    }

    def isBishopMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, board: Board): Result[Board, String] & Pure = {
        let (xFro, yFro) = fro.fro;
        let (xTo, yTo) = to.to;
        let xDif = xTo - xFro;
        let yDif = yTo - yFro;
        let moveIsDiagonal: Bool = xDif == yDif or xDif == -yDif;
        if(not moveIsDiagonal)
            Err("Bishop can only move diagonally")
        else if(xDif == yDif)
            board |> isPieceBetween(offset -> (xFro + offset, yFro + offset), xDif)
        else if(xDif == -yDif)
            board |> isPieceBetween(offset -> (xFro + offset, yFro - offset), xDif)
        else
            Ok(board)
    }

    def isKnightMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, board: Board): Result[Board, String] & Pure = {
        let xDif = Int32.abs(fst(to.to) - fst(fro.fro));
        let yDif = Int32.abs(snd(to.to) - snd(fro.fro));

        match (xDif,yDif) {
            case (1, 2) => Ok(board),
            case (2, 1) => Ok(board),
            case _ => Err("Knight can only move in L-shapes")
        }
    }

    def isQueenMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, board: Board): Result[Board, String] & Pure = {
        let isRookMove = board |> isRookMoveValid(fro, to);
        let isBishopMove = board |> isBishopMoveValid(fro, to);
        if(isRookMove |> Result.isOk or isBishopMove |> Result.isOk)
            Ok(board)
        else
            Err("Queen can only move strictly horizontally, vertically or diagonally")
    }

    def isKingMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, board: Board): Result[Board, String] & Pure = {
        let verticalMoveLessEq1 = () -> Int32.abs(snd(to.to) - snd(fro.fro)) <= 1;
        let horizontalMoveLessEq1 = () -> Int32.abs(fst(to.to) - fst(fro.fro)) <= 1;
        if(not verticalMoveLessEq1()) {
            Err("King cannot move vertically more than 1 tile")
        } else if(not horizontalMoveLessEq1()) {
            Err("King cannot move horizontally more than 1 tile")
        } else {
            Ok(board)
        }
    }

    def isPawnMoveValid(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, piece: Piece , board: Board): Result[Board, String] & Pure = {
        let toPiece: Option[Piece] = board |> getPiece(to.to);
        let moveIsAttack: Bool = match toPiece {
            case None => false,
            case Some(defendingPiece) => {
                let attackingPlayer = piece |> getOwner;
                let defendingPlayer = defendingPiece |> getOwner;
                attackingPlayer != defendingPlayer
            }
        };
        
        let yMovementIsValid: Bool = match piece {
            case Pawn(White) => snd(to.to) - snd(fro.fro) == 1,
            case Pawn(Black) => snd(to.to) - snd(fro.fro) == -1,
            case _ => false
        };

        let xMovementIsZero: Bool = fst(to.to) - fst(fro.fro) == 0;
        let xMovementIsValid: Bool = moveIsAttack != xMovementIsZero;

        let moveIsValid: Bool = xMovementIsValid and yMovementIsValid;
        if(not moveIsValid) {
            Err("Pawn can only move forward and only 1 tile")
        } else {
            Ok(board)
        }
    }
}