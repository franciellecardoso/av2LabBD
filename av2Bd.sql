CREATE DATABASE av2Bd
GO 
USE av2Bd
GO
CREATE TABLE times(
codigo               INT            IDENTITY(1,1)					NOT NULL,
nome                 VARCHAR(50)									NOT NULL,
cidade               VARCHAR(50)									NOT NULL,
estadio              VARCHAR(50)									NOT NULL,
materialEsportivo    VARCHAR(50)									NOT NULL,
fl_unico             BIT											NOT NULL
PRIMARY KEY(codigo)
)
GO 
CREATE TABLE grupos(
codigo              INT                                             NOT NULL,
nome                VARCHAR(1)      CHECK(UPPER(nome) = 'A' OR 
									      UPPER(nome) = 'B' OR 
									      UPPER(nome) = 'C' OR 
									      UPPER(nome) = 'D')		NOT NULL
PRIMARY KEY (codigo)
)
GO
CREATE TABLE grupos_times(
codigoTime          INT							                    NOT NULL,
codigoGrupo         INT                                             NOT NULL
PRIMARY KEY(codigoTime, codigoGrupo),
FOREIGN KEY(codigoTime) REFERENCES times(codigo),
FOREIGN KEY(codigoGrupo) REFERENCES grupos(codigo)
)
GO
CREATE TABLE jogos(
codigoTimeA         INT                                             NOT NULL,
codigoTimeB         INT												NOT NULL,
golsTimeA           INT												NULL,
golsTimeB           INT												NULL,
data				DATE											NOT NULL
PRIMARY KEY(codigoTimeA, codigoTimeB),
FOREIGN KEY (codigoTimeA) REFERENCES times(codigo),
FOREIGN KEY (codigoTimeB) REFERENCES times(codigo)
)
GO
CREATE TABLE datas_jogos(
dia				     DATE			  NOT NULL,
fl_passou		     BIT			  NOT NULL
PRIMARY KEY(dia)
)
GO
INSERT INTO times VALUES('Corinthians', 'São Paulo', 'Neo Química Arena', 'Nike', 1),
						('Palmeiras', 'São Paulo', 'Allianz Parque', 'Puma', 1),
						('Santos', 'Santos', 'Vila Belmiro', 'Umbro', 1),
						('São Paulo', 'São Paulo', 'Morumbi', 'Adidas', 1),
						('Água Santa', 'Diadema', 'Distrital do Inamar', 'Karilu', 0),
						('Botafogo SP', 'Ribeirão Preto', 'Santa Cruz', 'Volt Sport', 0),
						('Ferroviária', 'Araraquara', 'Fonte Luminosa', 'Lupo', 0),
						('Guarani', 'Campinas', 'Brinco de Ouro', 'Kappa', 0),
						('Inter de Limeira', 'Limeira', 'Limeirão', 'Alluri Sports', 0),
						('Ituano', 'Itu', 'Novelli Júnior', 'Kanxa', 0),
						('Mirrasol', 'Mirrasol', 'José Maria de Campos Maia', 'Super Bolla', 0),
						('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi', 'Physicus', 0),
						('Ponte Preta', 'Campinas', 'Moisés Lucarelli', '1900(Marca Própria)', 0),
						('Red Bull Bragantino', 'Bragança Paulista', 'Nabi Abi Chedid', 'Nike', 0),
						('Santo André', 'Santo André', 'Bruno José Daniel', 'Icone Sports', 0),
						('São Bernardo', 'São Bernardo do Campo', 'Primeiro de Maio', 'Magnum Group', 0)
GO
INSERT INTO grupos VALUES (1, 'A'), (2, 'B'), (3, 'C'), (4, 'D')
GO
INSERT INTO datas_jogos VALUES ('2023-04-12', 0), ('2023-04-16', 0), ('2023-04-19', 0), 
('2023-04-23', 0), ('2023-04-26', 0), ('2023-04-30', 0), 
('2023-05-03', 0), ('2023-05-07', 0), ('2023-05-10', 0),
('2023-05-14', 0), ('2023-05-17', 0), ('2023-05-21', 0)	

GO
--SEPARANDO OS TIMES EM GRUPOS
CREATE PROCEDURE sp_gerador_grupos 
AS
BEGIN
--Limpa a separação de gupos passada
DELETE FROM grupos_times

DECLARE @loop INT
SET @loop = 1

WHILE(@loop < 5)BEGIN
	DECLARE @time INT
	SELECT TOP 1 @time = t.codigo FROM times AS t 
	LEFT JOIN grupos_times AS gt ON gt.codigoTime = t.codigo
	WHERE fl_unico = 1 AND gt.codigoTime IS NULL ORDER BY NEWID()
	INSERT INTO grupos_times VALUES(@time, @loop)
	SET @loop = @loop + 1
END

SET @loop = 1
WHILE (@loop < 13)BEGIN
	DECLARE @grupo INT

	SELECT TOP 1 @time = t.codigo FROM times AS t 
	LEFT JOIN grupos_times AS gt ON gt.codigoTime = t.codigo
	WHERE fl_unico = 0 AND gt.codigoTime IS NULL ORDER BY NEWID()

	SELECT TOP 1 @grupo = g.codigo 
	FROM grupos g, grupos_times gt
	WHERE gt.codigoGrupo = g.codigo
	GROUP BY g.codigo
	HAVING COUNT(g.codigo) < 4
	ORDER BY NEWID()

	INSERT INTO grupos_times VALUES(@time, @grupo) 

	SET @loop = @loop + 1
END
END
--EXECUTANDO procedure acima
EXEC sp_gerador_grupos
--LISTA DE GRUPOS E NOME DOS TIMES
SELECT g.nome, t.nome AS time
FROM grupos g, times t, grupos_times gt
WHERE gt.codigoTime = t.codigo
      AND gt.codigoGrupo = g.codigo --AND g.nome = 'A' 
ORDER BY nome, codigoTime 

--DIVIDINDO OS TIMES POR RODADAS
GO
CREATE PROCEDURE sp_divide_times_rodadas(@rodada INT, @jogos INT, @codigoA INT OUTPUT, @codigoB INT OUTPUT)
AS
BEGIN
	IF(@rodada <= 4)
	BEGIN
		IF(@jogos <= 4)
		BEGIN
			SET @codigoA = 1
			SET @codigoB = 2
		END
		ELSE
		BEGIN
			SET @codigoA = 3
			SET @codigoB = 4
		END
	END

	IF(@rodada > 4 AND @rodada <= 8)
	BEGIN
		IF(@jogos <= 4)
		BEGIN
			SET @codigoA = 1
			SET @codigoB = 4
		END
		ELSE
		BEGIN
			SET @codigoA = 2
			SET @codigoB = 3
		END
	END

	IF(@rodada > 8)
	BEGIN
		IF(@jogos <= 4)
		BEGIN
			SET @codigoA = 1
			SET @codigoB = 3
		END
		ELSE
		BEGIN
			SET @codigoA = 2
			SET @codigoB = 4
		END
	END
END
GO
--GERANDO OS JOGOS
CREATE PROCEDURE sp_gerador_jogos
AS
BEGIN
--Limpa as últimas partidas
DELETE FROM jogos
UPDATE datas_jogos SET fl_passou = 0

--Separa os grupos caso não estejam separados
IF(ISNULL((SELECT COUNT(codigoTime) FROM grupos_times), 0) = 0)BEGIN
	exec sp_gerador_grupos
END

DECLARE @loopRodada INT, @data DATE
SET @loopRodada = 1
SELECT TOP 1 @data = dia FROM datas_jogos WHERE fl_passou != 1 ORDER BY NEWID()

WHILE(@loopRodada < 13)BEGIN
	DECLARE @loopJogos INT
	SET @loopJogos = 1
	WHILE(@loopJogos < 9)BEGIN
		DECLARE @loopValido BIT, @grupoA INT, @grupoB INT
		SET @loopValido = 0

		EXEC sp_divide_times_rodadas @loopRodada, @loopJogos, @grupoA OUTPUT, @grupoB OUTPUT

		--prevenção DeadLock
		DECLARE @temp TABLE (CodigoTime INT, CodigoGrupo INT)
		DELETE FROM @temp

		IF(@loopRodada % 2 = 0)BEGIN
			IF(@loopJogos % 2 = 0)BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime ASC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime ASC
			END
			ELSE
			BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime DESC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime DESC
			END
		END
		ELSE
		BEGIN
			IF(@loopJogos % 2 = 0)BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime ASC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime DESC
			END
			ELSE
			BEGIN
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoA ORDER BY codigoTime DESC
				INSERT INTO @temp
				SELECT TOP 2 * FROM grupos_times WHERE codigoGrupo = @grupoB ORDER BY codigoTime ASC
			END
		END

		--Loop para validação da partida
		WHILE(@loopValido = 0)BEGIN
			DECLARE @timeA INT, @timeB INT, @golsA INT, @golsB INT 
			
			SELECT TOP 1 @timeA = codigoTime FROM @temp 
			WHERE codigoGrupo = @grupoA
			AND codigoTime NOT IN(SELECT codigoTimeA FROM jogos WHERE Data = @data)
			ORDER BY NEWID() 

			SELECT TOP 1 @timeB = codigoTime FROM @temp
			WHERE codigoGrupo = @grupoB
			AND codigoTime NOT IN(SELECT codigoTimeB FROM jogos WHERE Data = @data)
			ORDER BY NEWID()
			
			IF((SELECT codigoTimeA FROM jogos WHERE CodigoTimeA = @timeA AND CodigoTimeB = @timeB) IS NULL)BEGIN
				INSERT INTO jogos(CodigoTimeA, CodigoTimeB, Data) VALUES (@timeA, @timeB, @data)
				SET @loopValido = 1
				SET @loopJogos = @loopJogos + 1
			END
		END
	END

	UPDATE datas_jogos SET fl_passou = 1 WHERE dia = @data
	SELECT TOP 1 @data = dia FROM datas_jogos WHERE fl_passou != 1 ORDER BY NEWID()
	SET @loopRodada = @loopRodada + 1
END
END
--EXEC procedure acima
EXEC sp_gerador_jogos
--LISTA TODOS OS JOGOS
SELECT * FROM jogos ORDER BY Data
--LISTANDO JOGO POR DATA
SELECT CONVERT(VARCHAR, data, 103) AS dia FROM jogos WHERE data = '12/04/2023' 

SELECT CONVERT(VARCHAR, dia, 103) AS dia FROM datas_jogos

SELECT ta.nome AS timeA, 
	   tb.nome AS timeB, 
	   j.GolsTimeA, j.GolsTimeB, CONVERT(VARCHAR, Data, 103) AS data 
FROM times ta, times tb, jogos j  
WHERE j.CodigoTimeA = ta.codigo
	AND j.CodigoTimeB = tb.codigo
	AND data = '12/04/2023'

--ERROS ACIMA CORRIGIDOS E INÍCIO DA AV2 ABAIXO:
GO
CREATE TRIGGER t_grupos ON grupos_times
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
	RAISERROR('A tabela de grupos não pode ser alterada', 16, 1)
	ROLLBACK TRANSACTION
END
GO
CREATE TRIGGER t_jogos ON jogos
AFTER INSERT, DELETE
AS
BEGIN
	RAISERROR('Jogos não podem ser inseridos ou excluidos', 16, 1)
	ROLLBACK TRANSACTION
END

--INSERINDO OS JOGOS
GO
CREATE PROCEDURE sp_marcar_gols(@golsTimeA INT, @golsTimeB INT, @timeA VARCHAR(100), @timeB VARCHAR(100))
AS
BEGIN
	DECLARE @codigoTimeA INT, @codigoTimeB INT
	SELECT @codigoTimeA = codigo FROM times WHERE nome LIKE '%'+@timeA+'%'
	SELECT @codigoTimeB = codigo FROM times WHERE nome LIKE '%'+@timeB+'%'

	UPDATE jogos SET GolsTimeA = @golsTimeA, GolsTimeB = @golsTimeB
	WHERE CodigoTimeA = @codigoTimeA AND CodigoTimeB = @codigoTimeB
END

--TABELA GERAL
GO
CREATE FUNCTION fn_tabela_geral()
RETURNS @tabela TABLE (
nomeTime		VARCHAR(100),
jogosDisputados	INT,
vitorias		INT,
empates			INT,
derrotas		INT,
golsMarcados	INT,
golsSofridos	INT,
saldoGols		INT,
pontos			INT,
fg_rebaixamento BIT		DEFAULT(0)
)
AS
BEGIN

	DECLARE @loopJogos INT
	SET @loopJogos = 1
	WHILE(@loopJogos < 17)
	BEGIN
		DECLARE @nome VARCHAR(100), @jogosDisputados INT, @vitorias INT, @empates INT, @derrotas INT, @marcados INT,
		@sofridos INT, @saldo INT, @pontos INT

		SELECT @nome = nome FROM times WHERE codigo = @loopJogos

		SELECT @jogosDisputados = COUNT(CodigoTimeA) FROM jogos WHERE CodigoTimeA = @loopJogos AND GolsTimeA IS NOT NULL
		SET @jogosDisputados = @jogosDisputados + (SELECT COUNT(CodigoTimeB) FROM jogos WHERE CodigoTimeB = @loopJogos AND GolsTimeB IS NOT NULL)

		SELECT @vitorias = COUNT(CodigoTimeA) FROM jogos WHERE CodigoTimeA = @loopJogos AND GolsTimeA > GolsTimeB
		SET @vitorias = @vitorias + (SELECT COUNT(CodigoTimeB) FROM jogos WHERE CodigoTimeB = @loopJogos AND GolsTimeB > GolsTimeA)

		SELECT @empates = COUNT(CodigoTimeA) FROM jogos WHERE CodigoTimeA = @loopJogos AND GolsTimeA = GolsTimeB
		SET @empates = @empates + (SELECT COUNT(CodigoTimeB) FROM jogos WHERE CodigoTimeB = @loopJogos AND GolsTimeB = GolsTimeA)

		SELECT @derrotas = COUNT(CodigoTimeA) FROM jogos WHERE CodigoTimeA = @loopJogos AND GolsTimeA < GolsTimeB
		SET @derrotas = @derrotas + (SELECT COUNT(CodigoTimeB) FROM jogos WHERE CodigoTimeB = @loopJogos AND GolsTimeB < GolsTimeA)

		SELECT @marcados = SUM(GolsTimeA) FROM jogos WHERE CodigoTimeA = @loopJogos
		SET @marcados = ISNULL(@marcados, 0) + ISNULL((SELECT SUM(GolsTimeB) FROM jogos WHERE CodigoTimeB = @loopJogos), 0)

		SELECT @sofridos = SUM(GolsTimeB) FROM jogos WHERE CodigoTimeA = @loopJogos
		SET @sofridos = ISNULL(@sofridos, 0) + ISNULL((SELECT SUM(GolsTimeA) FROM jogos WHERE CodigoTimeB = @loopJogos), 0)

		SET @saldo = @marcados - @sofridos

		SET @pontos = (3 * @vitorias) + @empates

		INSERT INTO @tabela VALUES (@nome, @jogosDisputados, @vitorias, @empates, @derrotas, @marcados, @sofridos, @saldo, @pontos, default)

		SET @loopJogos = @loopJogos + 1
	END

	;WITH tabela AS 
	( 
	SELECT TOP 2 * FROM @tabela 
	ORDER BY pontos ASC, vitorias ASC, golsMarcados ASC, saldoGols ASC 
	) 
	UPDATE tabela SET fg_rebaixamento = 1
 
	RETURN
END

--TABELA DE GRUPOS
GO
CREATE FUNCTION fn_tabela_grupos(@grupo VARCHAR(15))
RETURNS @tabela TABLE (
nomeTime		VARCHAR(100),
jogosDisputados	INT,
vitorias		INT,
empates			INT,
derrotas		INT,
golsMarcados	INT,
golsSofridos	INT,
saldoGols		INT,
pontos			INT,
fg_rebaixamento BIT		DEFAULT(0)
)
AS
BEGIN
	
	DECLARE @codigoGrupo INT
	SELECT @codigoGrupo = codigo FROM grupos WHERE nome LIKE '%'+@grupo+'%'

	INSERT INTO @tabela
	SELECT tb.nomeTime, tb.jogosDisputados, tb.vitorias, tb.empates, tb.derrotas, tb.golsMarcados, tb.golsSofridos, tb.saldoGols, tb.pontos, tb.fg_rebaixamento
	FROM fn_tabela_geral() tb, times t, grupos_times gt 
	WHERE gt.codigoGrupo = @codigoGrupo
		AND t.nome = tb.nomeTime 
		AND gt.codigoTime = t.codigo
	RETURN
END

--JOGOS AJUSTADOS
GO
CREATE FUNCTION fn_jogos(@data VARCHAR(15))
RETURNS @tabela TABLE (
timeA		VARCHAR(100),
timeB		VARCHAR(100),
golsTimeA		INT,
golsTimeB		INT,
data			VARCHAR(100)
)
AS
BEGIN
	INSERT INTO @tabela
	SELECT ta.nome AS timeA, 
	   tb.nome AS timeB, 
	   j.GolsTimeA, j.GolsTimeB, CONVERT(VARCHAR, data, 103) AS data 
	FROM times ta, times tb, jogos j  
	WHERE j.CodigoTimeA = ta.codigo
	AND j.CodigoTimeB = tb.codigo
	AND data = @data
	RETURN
END

--JOGOS ALEATÓRIOS
GO
CREATE PROCEDURE sp_marcar_aleatorios
AS
BEGIN
	DECLARE @loop INT
SET @loop = 1

	UPDATE jogos SET GolsTimeA = NULL, GolsTimeB = NULL

	WHILE(@loop < 97)BEGIN
		WITH tabela AS 
		( 
		SELECT TOP 1 * 
		FROM jogos
		WHERE GolsTimeA IS NULL
		ORDER BY NEWID()
		)
		UPDATE tabela SET GolsTimeA = CAST((RAND() * 5) AS INT), GolsTimeB = CAST((RAND() * 5) AS INT)
	SET @loop = @loop + 1
	END
END

--QUARTAS DE FINAL
GO
CREATE FUNCTION fn_quartas()
RETURNS @tabela TABLE (
timeA		VARCHAR(100),
timeB		VARCHAR(100)
)
AS
BEGIN
	DECLARE @time1 VARCHAR(100), @time2 VARCHAR(100), @grupo VARCHAR(1), @loop INT
	SET @loop = 1

	WHILE(@loop < 5)BEGIN
		SELECT @grupo = nome FROM grupos WHERE codigo = @loop

		SELECT TOP 1 @time1 = nomeTime FROM fn_tabela_grupos(@grupo) ORDER BY pontos DESC, vitorias DESC, golsMarcados DESC, saldoGols DESC 
	
		SELECT TOP 1 @time2 = nomeTime FROM fn_tabela_grupos(@grupo) WHERE nomeTime != @time1
		ORDER BY pontos DESC, vitorias DESC, golsMarcados DESC, saldoGols DESC

		INSERT INTO @tabela VALUES(@time1, @time2)

		SET @loop = @loop + 1
	END
	RETURN
END

EXEC sp_marcar_aleatorios

SELECT * FROM fn_quartas()

SELECT * FROM fn_tabela_grupos('B') ORDER BY pontos DESC, vitorias DESC, golsMarcados DESC, saldoGols DESC

SELECT * FROM fn_tabela_geral() ORDER BY pontos DESC, vitorias DESC, golsMarcados DESC, saldoGols DESC, fg_rebaixamento ASC

SELECT * FROM times
SELECT * FROM grupos_times

SELECT * FROM jogos WHERE CodigoTimeA = 5 AND CodigoTimeB = 1

SELECT * FROM fn_jogos('12/04/2023')

UPDATE jogos SET GolsTimeA = NULL, GolsTimeB = NULL

DECLARE @loop INT
SET @loop = 1

WHILE(@loop < 97)BEGIN

	;WITH tabela AS 
	( 
	SELECT TOP 1 * 
	FROM jogos
	WHERE GolsTimeA IS NULL
	ORDER BY NEWID()
	)
	UPDATE tabela SET GolsTimeA = CAST((RAND() * 5) AS INT), GolsTimeB = CAST((RAND() * 5) AS INT)

SET @loop = @loop + 1
END

--LISTANDO JOGO POR DATA
SELECT CONVERT(VARCHAR, data, 103) AS dia FROM jogos WHERE data = '12/04/2023' 

SELECT CONVERT(VARCHAR, dia, 103) AS dia FROM datas_jogos

SELECT ta.nome AS timeA, 
	   tb.nome AS timeB, 
	   j.GolsTimeA, j.GolsTimeB, CONVERT(VARCHAR, Data, 103) AS data 
FROM times ta, times tb, jogos j  
WHERE j.CodigoTimeA = ta.codigo
	AND j.CodigoTimeB = tb.codigo
	AND data = '12/04/2023'