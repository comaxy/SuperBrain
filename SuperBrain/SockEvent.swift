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
    
    // BODY: Number1 Number2 都是UINT16
    case RC_START = 101
    
    // BODY: "Result;Time"
    case RC_RESULT = 102
    
    // BODY: "Name;Result;Time;Name;Result;Time;RightResult"
    case RC_FINAL = 103
    
    // 准备下局游戏
    case RC_PREPARE = 104
    
    case RAPID_CALCULATION_END = 200
}
