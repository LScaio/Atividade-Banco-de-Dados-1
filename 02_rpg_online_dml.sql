-- =====================================================
-- Projeto: Jogo de RPG Online
-- Script DML: inserção, consulta, atualização e exclusão de dados
-- SGBD: Microsoft SQL Server (T-SQL)
-- Pré-requisito: executar antes o script 01_rpg_online_ddl.sql
-- =====================================================
--
-- Boas práticas de segurança aplicadas neste script:
--   1. senhas gravadas como hash (HASHBYTES SHA2_256), nunca em texto puro
--   2. consultas de usuários não exibem a coluna Senha
--   3. todo UPDATE e DELETE tem WHERE e é conferido com SELECT antes e depois
--   4. todo INSERT informa a lista de colunas explicitamente
--   5. exclusões respeitam as chaves estrangeiras (primeiro o filho, depois o pai)
--
-- Os Ids comentados ao lado de cada registro consideram o banco recém-criado,
-- pois o IDENTITY começa em 1 e incrementa a cada inserção.

-- seleciona o banco do projeto
USE RPGOnlineDB
GO

-- =====================================================
-- 1. Inserção nas tabelas sem chave estrangeira
-- =====================================================

-- insercao de usuarios
-- a senha é convertida em hash SHA2_256 (texto hexadecimal de 64 caracteres)
-- obs.: em um sistema real o hash (com salt, ex.: bcrypt) é gerado pela aplicação
-- e a senha nunca aparece no script; aqui o HASHBYTES é usado para fins didáticos
INSERT INTO Usuarios (Email, Senha)
VALUES
     ('jogador1@rpgonline.com',    CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', 'Dr@gao#2026'), 2))   -- UsuarioId 1
    ,('jogador2@rpgonline.com',    CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', 'Esp@da!Magica9'), 2)) -- UsuarioId 2
    ,('jogador3@rpgonline.com',    CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', 'Grimorio$Arc4no'), 2)) -- UsuarioId 3
    ,('jogador4@rpgonline.com',    CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', 'Flecha&Certa77'), 2)) -- UsuarioId 4
    ,('conta.teste@rpgonline.com', CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', 'Teste#Temp2026'), 2)) -- UsuarioId 5
GO

-- insercao de classes
INSERT INTO Classes (Nome, Descricao)
VALUES
     ('Bárbaro', 'Guerreiro forte e resistente, especialista em combate corpo a corpo.')            -- ClasseId 1
    ,('Cruzado', 'Guerreiro sagrado que combina armadura pesada e magia de luz.')                    -- ClasseId 2
    ,('Caçadora de Demônios', 'Especialista em ataques à distância com bestas e armadilhas.')        -- ClasseId 3
    ,('Monge', 'Lutador ágil que usa artes marciais e poderes espirituais.')                          -- ClasseId 4
    ,('Necromante', 'Conjurador que controla mortos-vivos e magias de sangue.')                      -- ClasseId 5
    ,('Feiticeiro', 'Usa vodu e invoca criaturas para lutar ao seu lado.')                           -- ClasseId 6
    ,('Arcanista', 'Mestre das magias elementais de fogo, gelo e raio.')                             -- ClasseId 7
GO

-- insercao de habilidades
INSERT INTO Habilidades (Nome)
VALUES
     ('Lança Mortal')        -- HabilidadeId 1
    ,('Escudo Supremo')      -- HabilidadeId 2
    ,('Recuperar Vida')      -- HabilidadeId 3
    ,('Bola de Fogo')        -- HabilidadeId 4
    ,('Invocar Esqueletos')  -- HabilidadeId 5
    ,('Chuva de Flechas')    -- HabilidadeId 6
    ,('Golpe Relâmpago')     -- HabilidadeId 7
GO

-- =====================================================
-- 2. Inserção nas tabelas com chave estrangeira
-- =====================================================

-- insercao de personagens
-- USUARIOS 1:N PERSONAGENS: o usuário 1 possui dois personagens
INSERT INTO Personagens (NomePersonagem, UsuarioId, ClasseId)
VALUES
     ('DeuBug', 1, 1)           -- PersonagemId 1: jogador1, Bárbaro
    ,('BitBug', 2, 4)           -- PersonagemId 2: jogador2, Monge
    ,('Fer8', 3, 7)             -- PersonagemId 3: jogador3, Arcanista
    ,('NullPointer', 1, 5)      -- PersonagemId 4: jogador1, Necromante
    ,('StackOverflow', 4, 3)    -- PersonagemId 5: jogador4, Caçadora de Demônios
    ,('PersonagemTeste', 5, 2)  -- PersonagemId 6: conta.teste, Cruzado
GO

-- insercao na tabela associativa
-- CLASSES N:N HABILIDADES: uma classe tem várias habilidades
-- e uma habilidade pode pertencer a várias classes
INSERT INTO Classes_Habilidades (ClasseId, HabilidadeId)
VALUES
     (1, 1)  -- Bárbaro: Lança Mortal
    ,(1, 2)  -- Bárbaro: Escudo Supremo
    ,(2, 2)  -- Cruzado: Escudo Supremo
    ,(2, 3)  -- Cruzado: Recuperar Vida
    ,(3, 6)  -- Caçadora de Demônios: Chuva de Flechas
    ,(4, 3)  -- Monge: Recuperar Vida
    ,(4, 7)  -- Monge: Golpe Relâmpago
    ,(5, 5)  -- Necromante: Invocar Esqueletos
    ,(6, 5)  -- Feiticeiro: Invocar Esqueletos
    ,(7, 4)  -- Arcanista: Bola de Fogo
    ,(7, 7)  -- Arcanista: Golpe Relâmpago
GO

-- =====================================================
-- 3. Consultas (SELECT)
-- =====================================================

-- usuarios: apenas Id e e-mail, a senha (hash) não é exibida
SELECT UsuarioId, Email FROM Usuarios ORDER BY UsuarioId

-- todas as colunas das demais tabelas
SELECT * FROM Classes
SELECT * FROM Habilidades ORDER BY HabilidadeId
SELECT * FROM Personagens
SELECT * FROM Classes_Habilidades

-- WHERE: nome e descrição da classe cujo Id é 4
SELECT Nome, Descricao
FROM Classes
WHERE ClasseId = 4

-- WHERE: personagens do usuário 1
SELECT PersonagemId, NomePersonagem
FROM Personagens
WHERE UsuarioId = 1

-- personagens com o e-mail do dono e o nome da classe
SELECT P.PersonagemId, P.NomePersonagem, U.Email, C.Nome AS Classe
FROM Personagens P
INNER JOIN Usuarios U ON U.UsuarioId = P.UsuarioId
INNER JOIN Classes C ON C.ClasseId = P.ClasseId

-- habilidades de cada classe
SELECT C.Nome AS Classe, H.Nome AS Habilidade
FROM Classes_Habilidades CH
INNER JOIN Classes C ON C.ClasseId = CH.ClasseId
INNER JOIN Habilidades H ON H.HabilidadeId = CH.HabilidadeId
ORDER BY C.Nome, H.Nome
GO

-- =====================================================
-- 4. Atualização (UPDATE)
-- SELECT antes para ver o dado, UPDATE com WHERE e SELECT depois
-- =====================================================

-- 4.1 o jogador2 renomeia o personagem BitBug (PersonagemId 2)
SELECT PersonagemId, NomePersonagem FROM Personagens WHERE PersonagemId = 2

UPDATE Personagens SET NomePersonagem = 'BitBugMestre' WHERE PersonagemId = 2

SELECT PersonagemId, NomePersonagem FROM Personagens WHERE PersonagemId = 2
GO

-- 4.2 atualiza a descrição da classe Feiticeiro (ClasseId 6)
SELECT ClasseId, Nome, Descricao FROM Classes WHERE ClasseId = 6

UPDATE Classes
SET Descricao = 'Usa vodu, venenos e invoca criaturas para lutar ao seu lado.'
WHERE ClasseId = 6

SELECT ClasseId, Nome, Descricao FROM Classes WHERE ClasseId = 6
GO

-- 4.3 o jogador3 (UsuarioId 3) troca a senha: grava o hash da nova senha
-- aqui a coluna Senha é exibida só para conferir que o hash mudou
SELECT UsuarioId, Email, Senha FROM Usuarios WHERE UsuarioId = 3

UPDATE Usuarios
SET Senha = CONVERT(VARCHAR(255), HASHBYTES('SHA2_256', 'N0v@Senha#Arcana'), 2)
WHERE UsuarioId = 3

SELECT UsuarioId, Email, Senha FROM Usuarios WHERE UsuarioId = 3
GO

-- =====================================================
-- 5. Exclusão (DELETE)
-- SELECT antes para ver o dado, DELETE com WHERE e SELECT depois
-- =====================================================

-- 5.1 o Cruzado (ClasseId 2) deixa de ter a habilidade Recuperar Vida (HabilidadeId 3)
-- a chave primária é composta, então o WHERE usa as duas colunas
SELECT ClasseId, HabilidadeId FROM Classes_Habilidades WHERE ClasseId = 2 AND HabilidadeId = 3

DELETE FROM Classes_Habilidades WHERE ClasseId = 2 AND HabilidadeId = 3

SELECT ClasseId, HabilidadeId FROM Classes_Habilidades WHERE ClasseId = 2 AND HabilidadeId = 3
GO

-- 5.2 a conta de teste (UsuarioId 5) é encerrada
-- primeiro deleta o personagem (filho) e depois o usuário (pai);
-- na ordem inversa a chave estrangeira impede o DELETE do usuário
SELECT PersonagemId, NomePersonagem, UsuarioId FROM Personagens WHERE UsuarioId = 5

DELETE FROM Personagens WHERE UsuarioId = 5

SELECT PersonagemId, NomePersonagem, UsuarioId FROM Personagens WHERE UsuarioId = 5

SELECT UsuarioId, Email FROM Usuarios WHERE UsuarioId = 5

DELETE FROM Usuarios WHERE UsuarioId = 5

SELECT UsuarioId, Email FROM Usuarios WHERE UsuarioId = 5
GO

-- obs.: por segurança, os Ids deletados (UsuarioId 5 e PersonagemId 6)
-- não serão reaproveitados pelo IDENTITY em novas inserções
