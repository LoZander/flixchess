use Chess/Player.Player;
use Chess/Player.Player.{Black,White};
namespace Chess/Piece {
    pub enum Piece with Eq {
        case Pawn(Player),
        case Knight(Player),
        case Bishop(Player),
        case Rook(Player),
        case King(Player),
        case Queen(Player)
    }

    instance ToString[Piece] {
        pub def toString(p: Piece): String = match p {
            case King(Black)     => "\u2654",
            case Queen(Black)    => "\u2655",
            case Rook(Black)     => "\u2656",
            case Bishop(Black)   => "\u2657",
            case Knight(Black)   => "\u2658",
            case Pawn(Black)     => "\u2659",
            case King(White)     => "\u265A",
            case Queen(White)    => "\u265B",
            case Rook(White)     => "\u265C",
            case Bishop(White)   => "\u265D",
            case Knight(White)   => "\u265E",
            case Pawn(White)     => "\u265F"
        }
    }

    pub def getOwner(piece: Piece): Player = match piece {
        case Pawn(player) => player,
        case Rook(player) => player,
        case Knight(player) => player,
        case Bishop(player) => player,
        case King(player) => player,
        case Queen(player) => player
    }
}