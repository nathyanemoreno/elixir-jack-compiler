# Elixir Jack Compiler

![Elixir](https://img.shields.io/badge/Elixir-1.12.0-9378C9?logo=elixir&logoColor=9378C9)

<div style="text-align:center">
  <img src="https://raw.githubusercontent.com/PKief/vscode-material-icon-theme/main/icons/elixir.svg" width="250">
</div>

## Description

A `.jack` compiler program coded in elixir language.

## Local Development

How to run locally:

### Compiling

```sh
$ mix escript.build 
```

### Running

```
$ elixir_jack_compiler

Usage: elixir_jack_compiler [FLAGS]... [FILE]...

FLAGS:

--i path to JACK input file
--o path to XML output file (case empty, default "build/xml")
```

### Determistic Finite Automaton (DFA)
![Alt text](docs/JackTokenizer-DFA.png?raw=true "DFA")

## Also implemented in
[![Assembly](https://img.shields.io/badge/-Assembly-FF6946?logo=AssemblyScript)](https://github.com/alexaragao/assembly-jack-compiler)

## Contribuitors
<table>
  <tr>
    <td align="center">
      <a href="https://github.com/alexaragao">
        <img src="https://avatars.githubusercontent.com/u/43763150?s=100" width="100px;" alt="Alexandre Aragão"/>
        <br />
        <b>Alexandre Aragão</b>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/nathyanemoreno">
        <img src="https://avatars.githubusercontent.com/u/40841909?s=100" width="100px;" alt="Nathyane Moreno"/>
        <br />
        <b>Nathyane Moreno</b>
      </a>
    </td>
  </tr>
</table>
