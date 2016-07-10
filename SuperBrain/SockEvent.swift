import Foundation

enum SockEvent: UInt8 {
    case REGISTER = 1
    case REG_RESULT = 2
    case LOGIN = 3
    case LOGIN_RESULT = 4
    case GET_PLAYER_LIST_REQUEST = 5
    case GET_PLAYER_LIST_RESPONSE = 6
    case CHALLENGE_FRIEND_REQUEST = 7
    case CHALLENGE_FRIEND_RESPONSE = 8
}
