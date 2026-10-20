# Banco de Dados – Jogo de RPG Online

Atividade de Banco de Dados (SENAI): uso da linguagem de manipulação de dados (DML) para inserir, consultar, atualizar e excluir os dados do banco do jogo de RPG online.

SGBD: **Microsoft SQL Server** (T-SQL).

## Arquivos

| Arquivo | Conteúdo |
|---|---|
| [`01_rpg_online_ddl.sql`](01_rpg_online_ddl.sql) | Criação do banco `RPGOnlineDB` e das tabelas (DDL) |
| [`02_rpg_online_dml.sql`](02_rpg_online_dml.sql) | Inserção, consulta, atualização e exclusão dos dados (DML/DQL) |

## Como executar

1. Abra o SQL Server Management Studio (SSMS) e conecte-se ao servidor.
2. Abra `01_rpg_online_ddl.sql` e execute (F5) para criar o banco e as tabelas.
3. Abra `02_rpg_online_dml.sql` e execute (F5) para inserir e manipular os dados.

O script DML usa os Ids gerados pelo `IDENTITY` em um banco recém-criado, por isso deve ser executado logo após o script DDL.

## Modelo

- **Usuarios** 1:N **Personagens**: um usuário pode ter vários personagens.
- **Classes** 1:N **Personagens**: cada personagem pertence a uma classe.
- **Classes** N:N **Habilidades**: resolvido pela tabela associativa `Classes_Habilidades`.

## Dados inseridos

- **Usuarios:** 5 contas (a conta de teste é excluída no final do script)
- **Classes:** Bárbaro, Cruzado, Caçadora de Demônios, Monge, Necromante, Feiticeiro e Arcanista
- **Habilidades:** Lança Mortal, Escudo Supremo, Recuperar Vida, Bola de Fogo, Invocar Esqueletos, Chuva de Flechas e Golpe Relâmpago
- **Personagens:** DeuBug, BitBug, Fer8, NullPointer, StackOverflow e PersonagemTeste
- **Classes_Habilidades:** 11 associações entre classes e habilidades

## Comandos utilizados

- `INSERT`: inserção de várias linhas por instrução, sempre com a lista de colunas
- `SELECT`: consultas simples, com `WHERE` e com `INNER JOIN` entre as tabelas
- `UPDATE`: renomear personagem, alterar descrição de classe e trocar senha
- `DELETE`: remover uma associação classe/habilidade e encerrar uma conta de teste

## Boas práticas de segurança

- Senhas gravadas como hash SHA2_256 (`HASHBYTES`), nunca em texto puro.
- Consultas de usuários não exibem a coluna `Senha`.
- Todo `UPDATE` e `DELETE` tem `WHERE` e é conferido com `SELECT` antes e depois.
- Exclusões respeitam as chaves estrangeiras: primeiro o registro filho (`Personagens`), depois o pai (`Usuarios`).
- Ids excluídos não são reaproveitados pelo `IDENTITY`.
