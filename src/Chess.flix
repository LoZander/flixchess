use Chess/Piece.{Piece, getOwner};
use Chess/Player.Player;
use Chess/Player.Player.{Black, White};
use Chess/Piece.Piece.{King, Queen, Knight, Bishop, Rook, Pawn};

namespace Chess/Board {
    pub enum Board({ tiles :: Map[(Int32,Int32), Piece], turn :: Player})

    instance ToString[Board] {
        /**
         * The string representation of a chess board in the format
         *      ♖ ♘ ♗ ♔ ♕ ♗ ♘ ♖                                                                 
         *      ♙ ♙ ♙ ♙ ♙ ♙ ♙ ♙
         *
         *
         *
         *
         *      ♟ ♟ ♟ ♟ ♟ ♟ ♟ ♟
         *      ♜ ♞ ♝ ♚ ♛ ♝ ♞ ♜.
         * This representation assumes dark-mode (white text on black background),
         * making white and black seem swapped in light-mode (black text on white background).
         */
        pub def toString(b: Board): String = {
            let Board(inner) = b;

            def formatOption(o: Option[Piece]) = match o {
                case None => " ",
                case Some(p) => "${p}"
            };

            let getAndProcess = (x,y) -> y.tiles |> Map.get(x) |> formatOption;

            def loop(c: (Int32,Int32), s: String) = match c {
                case (7,0) => "${s}${inner |> getAndProcess((7,0))}",
                case (7,y) => "${s}${inner |> getAndProcess((7,y))}\n${loop((0, y - 1), s)}",
                case (x,y) => "${s}${inner |> getAndProcess((x,y))} ${loop((x + 1,y), s)}"
            };

            loop((0,7), "")
        }
    }

    /**
     *  The piece at a given position, if such a piece exists.
     *  
     *  @param xy (Int32, Int32): The position from whence to fetch the piece.
     *  @param board Board: The chess board of the game in question.
     *  @return Option[Piece]: Some(piece) if there is a piece, None if there is none
     */
    pub def getPiece(xy: (Int32, Int32), b: Board): Option[Piece] & Pure = {
        let Board(inner) = b;
        inner.tiles |> Map.get(xy)
    }

    /**
     *  The player who's turn it is.
     *
     *  @param Board: The chess board of the game in question.
     *  @return Player: The player who's turn it is.
     */
    pub def getTurn(board: Board): Player & Pure = {
        let Board(inner) = board;
        inner.turn
    }

    def nextTurn(board: Board): Board & Pure = {
        let Board(inner) = board;
        match inner.turn {
            case White => {turn = Black | inner}
            case Black => {turn = White | inner}
        } |> Board
    }

    def mapTiles(f: Map[(Int32, Int32), Piece] -> Map[(Int32, Int32), Piece], b: Board): Board & Pure = {
        let Board(inner) = b;
        let tiles = inner.tiles |> f;
        Board({tiles = tiles | inner})
    }

    def insertPiece(xy: (Int32, Int32), p: Piece, b: Board): Board & Pure = b |> mapTiles(Map.insert(xy,p))

    def removePiece(xy: (Int32, Int32), b: Board): Board & Pure = b |> mapTiles(Map.remove(xy))

    /**
     *  Moves a piece from one tile to another, if such a move is valid.
     *
     *  @param fro {fro :: (Int32, Int32)}: The "from" position.
     *  @param to {to :: (Int32, Int32)}: The "to" position.
     *  @param board Board: The board on which the move is to be performed.
     *
     *  @return Result[Board, String]: Result of either the board after the move,
     *  or a an error string in case the move wasn't valid.
     */
    pub def move(fro: {fro :: (Int32, Int32)}, to: {to :: (Int32, Int32)}, b: Board): Result[Board, String] & Pure  = {
        let op = b |> getPiece(fro.fro);
        match op {
            case None => Err("No piece at fro position"),
            case Some(p) => {
                b |> 
                Chess/MoveValidator.isMoveValid(fro, to, p) |> 
                Result.map(executeMove(fro, to, p))
            }
        }
    }

    def executeMove(fro: {fro :: (Int32,Int32)}, to: {to :: (Int32, Int32)}, p: Piece): Board -> Board = {
        removePiece(fro.fro) >> insertPiece(to.to, p) >> nextTurn
    }

    /**
     *  Initializes a chess board in its default configuration.
     *  @return Board: The intialized chess board.
     */
    pub def createBoard(): Board & Pure = {
        Board({
            turn = White,
            tiles = Map#{
                (0,0) => Rook(White),
                (1,0) => Knight(White),
                (2,0) => Bishop(White),
                (3,0) => King(White),
                (4,0) => Queen(White),
                (5,0) => Bishop(White),
                (6,0) => Knight(White),
                (7,0) => Rook(White),
                (0,7) => Rook(Black),
                (1,7) => Knight(Black),
                (2,7) => Bishop(Black),
                (3,7) => King(Black),
                (4,7) => Queen(Black),
                (5,7) => Bishop(Black),
                (6,7) => Knight(Black),
                (7,7) => Rook(Black),
                (0,1) => Pawn(White),
                (1,1) => Pawn(White),
                (2,1) => Pawn(White),
                (3,1) => Pawn(White),
                (4,1) => Pawn(White),
                (5,1) => Pawn(White),
                (6,1) => Pawn(White),
                (7,1) => Pawn(White),
                (0,6) => Pawn(Black),
                (1,6) => Pawn(Black),
                (2,6) => Pawn(Black),
                (3,6) => Pawn(Black),
                (4,6) => Pawn(Black),
                (5,6) => Pawn(Black),
                (6,6) => Pawn(Black),
                (7,6) => Pawn(Black)
            }
        })
    } 
}