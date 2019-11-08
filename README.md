# nyakou core

RISC-V (RV32I) を実装する。

## 用語定義

| 用語     | 定義                        |
| ------ | ------------------------- |
| PC     | Program Counter のこと       |
| 命令レジスタ | FETCHステージで読み出した値を保存するレジスタ |

## コアのパイプラインステージ

1. FETCH
1. DECODE
1. EXECUTE
1. UPDATE_PC

### FETCH

PC が指す命令を読み出して DECODE ステージに渡す。

### DECODE

命令レジスタを読んで EXECUTE ステージの3コンポーネントの入出力を接続するマルチプレクサとして動作する。

### EXECUTE

次のコンポーネントに分けて命令を実行する。

- ALU
  - calc
    add, sub
  - logic
    and, or xor
  - shift
    logical shift, arithmetic shift
- Branch
  branch, jump
- Load/Store
  load, store
