use Chess/Board.{createBoard};
use Chess/Piece.Piece;
use Chess/Player.Player;

@test
def shouldBeWhiteRookAt00(): Bool = createBoard() |> Chess/Board.getPiece((0,0)) == Some(Piece.Rook(Player.White))

@test
def shouldBeWhiteRookAt70(): Bool = createBoard() |> Chess/Board.getPiece((7,0)) == Some(Piece.Rook(Player.White))

@test
def shouldBeBlackRookAt07(): Bool = createBoard() |> Chess/Board.getPiece((0,7)) == Some(Piece.Rook(Player.Black))

@test
def shouldBeBlackRookAt77(): Bool = createBoard() |> Chess/Board.getPiece((7,7)) == Some(Piece.Rook(Player.Black))

@test
def shouldBeBlackKnightAt67(): Bool = createBoard() |> Chess/Board.getPiece((6,7)) == Some(Piece.Knight(Player.Black))

@test
def shouldBeWhitePawnAt31(): Bool = createBoard() |> Chess/Board.getPiece((3,1)) == Some(Piece.Pawn(Player.White))

@test
def shouldBeNoPieceAt42(): Bool = createBoard() |> Chess/Board.getPiece((4,2)) == None

@test
def shouldBeNoPieceAt05(): Bool = createBoard() |> Chess/Board.getPiece((0,5)) == None