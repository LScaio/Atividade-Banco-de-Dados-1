-- =====================================================
-- Projeto: Jogo de RPG Online
-- Script DDL: criação do banco de dados e das tabelas
-- SGBD: Microsoft SQL Server (T-SQL)
-- =====================================================

-- criacao do banco de dados do projeto
CREATE DATABASE RPGOnlineDB
GO

-- seleciona o banco para que as tabelas sejam criadas nele
USE RPGOnlineDB
GO

-- =====================================================
-- 1. Tabelas sem chave estrangeira (menos dependentes)
-- =====================================================

-- criacao da tabela de usuarios
CREATE TABLE Usuarios
(
     UsuarioId INT PRIMARY KEY IDENTITY      -- chave primária
    ,Email VARCHAR(120) NOT NULL UNIQUE       -- não pode repetir e-mail
    ,Senha VARCHAR(255) NOT NULL              -- espaço para senha criptografada (hash)
)
GO

-- criacao da tabela de classes
CREATE TABLE Classes
(
     ClasseId INT PRIMARY KEY IDENTITY       -- chave primária
    ,Nome VARCHAR(100) NOT NULL UNIQUE        -- não pode haver classes com o mesmo nome
    ,Descricao VARCHAR(255)                   -- descrição da classe (opcional)
)
GO

-- criacao da tabela de habilidades
CREATE TABLE Habilidades
(
     HabilidadeId INT PRIMARY KEY IDENTITY   -- chave primária
    ,Nome VARCHAR(100) NOT NULL UNIQUE        -- não pode haver habilidades com o mesmo nome
)
GO

-- =====================================================
-- 2. Tabelas com chave estrangeira (dependentes)
-- =====================================================

-- criacao da tabela de personagens
-- USUARIOS 1:N PERSONAGENS  |  CLASSES 1:N PERSONAGENS
CREATE TABLE Personagens
(
     PersonagemId INT PRIMARY KEY IDENTITY   -- chave primária
    ,NomePersonagem VARCHAR(50) NOT NULL UNIQUE -- nome único no jogo
    ,UsuarioId INT NOT NULL FOREIGN KEY REFERENCES Usuarios(UsuarioId) -- chave estrangeira
    ,ClasseId INT NOT NULL FOREIGN KEY REFERENCES Classes(ClasseId)    -- chave estrangeira
)
GO

-- criacao da tabela associativa entre classes e habilidades
-- CLASSES N:N HABILIDADES (resolvido por Classes_Habilidades)
CREATE TABLE Classes_Habilidades
(
     ClasseId INT NOT NULL FOREIGN KEY REFERENCES Classes(ClasseId)              -- PK e FK
    ,HabilidadeId INT NOT NULL FOREIGN KEY REFERENCES Habilidades(HabilidadeId)  -- PK e FK
    ,CONSTRAINT PK_Classes_Habilidades PRIMARY KEY (ClasseId, HabilidadeId)     -- chave primária composta
)
GO
