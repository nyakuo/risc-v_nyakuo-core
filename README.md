# nyakou core

RISC-V (RV32I) を実装する。

## マイルストン

- 今週末までに実施
  - CPU の作り方(本) の読了
  - RV32I の実装完了のために以下を実施
    - Verilator によるデバッグ環境の構築
    - RV32I の実装
    - RV32I の動作を Verilator で確認
    - 
    
### ボツ案

- riscv/riscv-tests の実施  
これについては仮想マシンによる試験を前提としているように見え、Verilator による試験には少しハードルがありそう
最終的に実施するかどうかは Ariane のコード調査において結論を出す予定

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

