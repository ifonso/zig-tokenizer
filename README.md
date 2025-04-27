# Zig Tokenizer

Um projeto de teste para criação de um tokenizer para LLMs, atualmente implementa dois modos: quebra conservadora, e quebra agressiva.

- **Conservative**: preserva palavras compostas (e.g., "co-working", "Let's") e separa apenas em pontuações pesadas e espaços.
- **Aggressive**: separa símbolos intermediários como hífens, apóstrofes e barras, para gerar tokens mais fragmentados, ideal para pré-processamento de LLMs.

> Não é uma lib. (até o momento)

## Como usar

Inicialize o tokenizer informando as opções desejadas:

```zig
const Tokenizer = @import("tokenizer.zig").Tokenizer;

const tokenizer = Tokenizer.init(true, .Agressive);

const input = "Olá, Mundo!";
const tokens = try tokenizer.tokenize(allocator, input);
```

## Status

- [x] Tokenização de palavras, pontuação e símbolos intermediários.
- [x] Suporte a modos Conservative e Aggressive.
- [x] Offsets para reconstrução reversível.
- [x] Lowercasing opcional.
- [ ] BPE (Byte-Pair Encoding) após tokenização.
- [ ] Suporte completo a Unicode (caracteres acentuados, scripts orientais, etc).
- [ ] Tratamento especial para emojis e símbolos complexos.
