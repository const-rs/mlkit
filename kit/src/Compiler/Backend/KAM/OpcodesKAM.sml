(* This file is auto-generated with Tools/GenOpcodes *)
functor OpcodesKAM () : OPCODES_KAM = 
  struct
    val ALLOC_N = 0
    val ALLOC_IF_INF_N = 1
    val ALLOC_SAT_INF_N = 2
    val ALLOC_SAT_IF_INF_N = 3
    val ALLOC_ATBOT_N = 4
    val BLOCK_ALLOC_N = 5
    val BLOCK_ALLOC_IF_INF_N = 6
    val BLOCK_ALLOC_SAT_INF_N = 7
    val BLOCK_N = 8
    val BLOCK_ALLOC_SAT_IF_INF_N = 9
    val BLOCK_ALLOC_ATBOT_N = 10
    val CLEAR_ATBOT_BIT = 11
    val SET_ATBOT_BIT = 12
    val SET_BIT_30 = 13
    val SET_BIT_31 = 14
    val CLEAR_BIT_30_AND_31 = 15
    val UB_TAG_CON = 16
    val SELECT_STACK_N = 17
    val SELECT_ENV_N = 18
    val SELECT_N = 19
    val STORE_N = 20
    val STACK_ADDR_INF_BIT = 21
    val STACK_ADDR = 22
    val ENV_TO_ACC = 23
    val IMMED_INT = 24
    val IMMED_STRING = 25
    val IMMED_REAL = 26
    val PUSH = 27
    val PUSH_LBL = 28
    val POP_N = 29
    val APPLY_FN_CALL = 30
    val APPLY_FN_JMP = 31
    val APPLY_FUN_CALL = 32
    val APPLY_FUN_JMP = 33
    val RETURN = 34
    val C_CALL0 = 35
    val C_CALL1 = 36
    val C_CALL2 = 37
    val C_CALL3 = 38
    val C_CALL4 = 39
    val LABEL = 40
    val JMP_REL = 41
    val IF_NOT_EQ_JMP_REL_IMMED = 42
    val IF_LESS_THAN_JMP_REL_IMMED = 43
    val IF_GREATER_THAN_JMP_REL_IMMED = 44
    val DOT_LABEL = 45
    val JMP_VECTOR = 46
    val RAISE = 47
    val PUSH_EXN_PTR = 48
    val POP_EXN_PTR = 49
    val GLOBAL_EXN_HANDLER_REPORT = 50
    val LETREGION_FIN = 51
    val LETREGION_INF = 52
    val ENDREGION_INF = 53
    val RESET_REGION = 54
    val MAYBE_RESET_REGION = 55
    val RESET_REGION_IF_INF = 56
    val FETCH_DATA = 57
    val STORE_DATA = 58
    val HALT = 59
    val STACK_OFFSET = 60
    val POP_PUSH = 61
    val IMMED_INT_PUSH = 62
    val SELECT_PUSH = 63
    val SELECT_ENV_PUSH = 64
    val SELECT_ENV_CLEAR_ATBOT_BIT_PUSH = 65
    val STACK_ADDR_PUSH = 66
    val STACK_ADDR_INF_BIT_ATBOT_BIT_PUSH = 67
    val SELECT_STACK_PUSH = 68
    val ENV_PUSH = 69
    val PRIM_GET_CONN = 70
    val PRIM_EQUAL_I = 71
    val PRIM_SUB_I = 72
    val PRIM_ADD_I = 73
    val PRIM_MUL_I = 74
    val PRIM_NEG_I = 75
    val PRIM_ABS_I = 76
    val PRIM_ADD_F = 77
    val PRIM_SUB_F = 78
    val PRIM_MUL_F = 79
    val PRIM_DIV_F = 80
    val PRIM_NEG_F = 81
    val PRIM_ABS_F = 82
    val PRIM_LESS_THAN_F = 83
    val PRIM_LESS_EQUAL_F = 84
    val PRIM_GREATER_THAN_F = 85
    val PRIM_GREATER_EQUAL_F = 86
    val PRIM_LESS_THAN = 87
    val PRIM_LESS_EQUAL = 88
    val PRIM_GREATER_THAN = 89
    val PRIM_GREATER_EQUAL = 90
    val PRIM_LESS_THAN_UNSIGNED = 91
    val PRIM_GREATER_THAN_UNSIGNED = 92
    val PRIM_LESS_EQUAL_UNSIGNED = 93
    val PRIM_GREATER_EQUAL_UNSIGNED = 94
    val PRIM_ADD_W8 = 95
    val PRIM_SUB_W8 = 96
    val PRIM_MUL_W8 = 97
    val PRIM_AND_I = 98
    val PRIM_OR_I = 99
    val PRIM_XOR_I = 100
    val PRIM_SHIFT_LEFT_I = 101
    val PRIM_SHIFT_RIGHT_SIGNED_I = 102
    val PRIM_SHIFT_RIGHT_UNSIGNED_I = 103
    val PRIM_ADD_W = 104
    val PRIM_SUB_W = 105
    val PRIM_MUL_W = 106
    val PRIM_FRESH_EXNAME = 107
  end
