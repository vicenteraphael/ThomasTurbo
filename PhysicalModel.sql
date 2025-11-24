CREATE DATABASE IF NOT EXISTS ThomasTurbo;
USE ThomasTurbo;

SET SQL_SAFE_UPDATES = 0;

-- =====================
-- TABELAS BÁSICAS
-- =====================

CREATE TABLE IF NOT EXISTS Cadastro (
    PK_CadastroID INT PRIMARY KEY AUTO_INCREMENT,
    CadastroDataCriacao DATE NOT NULL,
    CadastroDataAtualizacao DATE,
    CadastroStatus BOOLEAN DEFAULT TRUE,
    CadastroPeriodoAnos INT
);

CREATE TABLE IF NOT EXISTS Profissao (
    PK_ProfissaoID INT PRIMARY KEY AUTO_INCREMENT,
    ProfissaoTipo VARCHAR(100),
    ProfissaoSalarioBase DECIMAL(10,2)
);

CREATE TABLE IF NOT EXISTS ContaTipo (
    PK_ContaTipoID INT PRIMARY KEY AUTO_INCREMENT,
    ContaTipoNome VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS TipoPagamento (
    PK_TipoPagamentoID INT PRIMARY KEY AUTO_INCREMENT,
    TipoPagamentoDescricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS TipoEntrega (
    PK_TipoEntregaID INT PRIMARY KEY AUTO_INCREMENT,
    TipoEntregaDescricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS PecaCategoria (
    PK_PecaCategoriaID INT PRIMARY KEY AUTO_INCREMENT,
    PecaCategoriaDescricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS PecaMarca (
    PK_PecaMarcaID INT PRIMARY KEY AUTO_INCREMENT,
    PecaMarcaNome VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS VeiculoMarca (
    PK_VeiculoMarcaID INT PRIMARY KEY AUTO_INCREMENT,
    VeiculoMarcaDescricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS VeiculoModelo (
    PK_VeiculoModeloID INT PRIMARY KEY AUTO_INCREMENT,
    VeiculoModeloDescricao VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS EstoqueOperacao (
    PK_EstoqueOperacaoID INT PRIMARY KEY AUTO_INCREMENT,
    EstoqueOperacaoNome VARCHAR(100),
    EstoqueOperacaoQuantidade INT
);

CREATE TABLE IF NOT EXISTS FidelidadeAssinatura (
    PK_FidelidadeAssinaturaID INT PRIMARY KEY AUTO_INCREMENT,
    FidelidadeAssinaturaMensalidade DECIMAL(10,2),
    FidelidadeAssinaturaDataInicio DATE,
    FidelidadeAssinaturaDataFim DATE,
    FidelidadeAssinaturaStatus BOOLEAN
);

-- =====================
-- PESSOAS
-- =====================

CREATE TABLE IF NOT EXISTS Pessoa (
    PK_PessoaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_CadastroID INT,
    FOREIGN KEY (FK_CadastroID) REFERENCES Cadastro(PK_CadastroID)
);

CREATE TABLE IF NOT EXISTS PessoaFisica (
    PK_PessoaFisicaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    AK_PessoaCPF CHAR(11) UNIQUE,
    PessoaNome VARCHAR(150),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE IF NOT EXISTS PessoaJuridica (
    PK_PessoaJuridicaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    AK_PessoaCNPJ CHAR(14) UNIQUE,
    PessoaJuridicaRazaoSocial VARCHAR(150),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE IF NOT EXISTS Telefone (
    PK_TelefoneID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    TelefoneNumeracao VARCHAR(15),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE IF NOT EXISTS Email (
    PK_EmailID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    PessoaEmail VARCHAR(150),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE IF NOT EXISTS Endereco (
    PK_EnderecoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    EnderecoRua VARCHAR(100),
    EnderecoNumero INT,
    EnderecoBairro VARCHAR(100),
    EnderecoEstado CHAR(2),
    EnderecoCidade VARCHAR(100),
    EnderecoCEP CHAR(9),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

-- =====================
-- FUNCIONÁRIOS / CLIENTES
-- =====================

CREATE TABLE IF NOT EXISTS Funcionario (
    PK_FuncionarioID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaFisicaID INT,
    FK_ProfissaoID INT,
    FuncionarioCurriculo VARCHAR(255),
    FuncionarioSalario DECIMAL(10,2) NOT NULL,
    FuncionarioContrato VARCHAR(100),
    FOREIGN KEY (FK_PessoaFisicaID) REFERENCES PessoaFisica(PK_PessoaFisicaID),
    FOREIGN KEY (FK_ProfissaoID) REFERENCES Profissao(PK_ProfissaoID)
);

CREATE TABLE IF NOT EXISTS ClienteFidelidade (
    PK_ClienteFidelidadeID INT PRIMARY KEY AUTO_INCREMENT,
    FK_FidelidadeAssinaturaID INT,
    ClienteFidelidadeNome VARCHAR(100),
    ClienteFidelidadeDescricao VARCHAR(200),
    ClienteFidelidadeDescontoPercentual DECIMAL(5,2),
    FOREIGN KEY (FK_FidelidadeAssinaturaID) REFERENCES FidelidadeAssinatura(PK_FidelidadeAssinaturaID)
);

CREATE TABLE IF NOT EXISTS Cliente (
    PK_ClienteID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    FK_ClienteFidelidadeID INT,
    ClienteDataNascimento DATE,
    ClienteSexo CHAR(1),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID),
    FOREIGN KEY (FK_ClienteFidelidadeID) REFERENCES ClienteFidelidade(PK_ClienteFidelidadeID)
);

CREATE TABLE IF NOT EXISTS Fornecedor (
    PK_FornecedorID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaJuridicaID INT,
    FOREIGN KEY (FK_PessoaJuridicaID) REFERENCES PessoaJuridica(PK_PessoaJuridicaID)
);

-- =====================
-- VEÍCULOS / PEÇAS / ESTOQUE
-- =====================

CREATE TABLE IF NOT EXISTS Veiculo (
    PK_VeiculoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_VeiculoMarcaID INT,
    FK_VeiculoModeloID INT,
    VeiculoAno YEAR,
    VeiculoDescricao VARCHAR(150),
    FOREIGN KEY (FK_VeiculoMarcaID) REFERENCES VeiculoMarca(PK_VeiculoMarcaID),
    FOREIGN KEY (FK_VeiculoModeloID) REFERENCES VeiculoModelo(PK_VeiculoModeloID)
);

CREATE TABLE IF NOT EXISTS Peca (
    PK_PecaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_CadastroID INT,
    FK_FornecedorID INT,
    FK_PecaCategoriaID INT,
    FK_PecaMarcaID INT,
    FK_PecaVeiculoID INT,
    PecaDescricao VARCHAR(200),
    PecaPreco DECIMAL(10,2),
    PecaValidade DATE,
    FOREIGN KEY (FK_CadastroID) REFERENCES Cadastro(PK_CadastroID),
    FOREIGN KEY (FK_FornecedorID) REFERENCES Fornecedor(PK_FornecedorID),
    FOREIGN KEY (FK_PecaCategoriaID) REFERENCES PecaCategoria(PK_PecaCategoriaID),
    FOREIGN KEY (FK_PecaMarcaID) REFERENCES PecaMarca(PK_PecaMarcaID),
    FOREIGN KEY (FK_PecaVeiculoID) REFERENCES Veiculo(PK_VeiculoID)
);

CREATE TABLE IF NOT EXISTS Estoque (
    PK_EstoqueID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PecaID INT,
    EstoqueQuantidadePecas INT,
    FOREIGN KEY (FK_PecaID) REFERENCES Peca(PK_PecaID)
);

CREATE TABLE IF NOT EXISTS MovimentacaoEstoque (
    PK_MovimentacaoEstoqueID INT PRIMARY KEY AUTO_INCREMENT,
    FK_FuncionarioID INT,
    FK_EstoqueID INT,
    FK_EstoqueOperacaoID INT,
    MovimentacaoEstoqueObservacoes VARCHAR(255),
    MovimentacaoEstoqueData DATE,
    FOREIGN KEY (FK_FuncionarioID) REFERENCES Funcionario(PK_FuncionarioID),
    FOREIGN KEY (FK_EstoqueID) REFERENCES Estoque(PK_EstoqueID),
    FOREIGN KEY (FK_EstoqueOperacaoID) REFERENCES EstoqueOperacao(PK_EstoqueOperacaoID)
);

-- =====================
-- PEDIDOS / COMPRAS / PAGAMENTOS
-- =====================

CREATE TABLE IF NOT EXISTS Pedido (
    PK_PedidoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_ClienteID INT,
    FK_FuncionarioID INT,
    PedidoData DATE,
    PedidoStatus CHAR(1),
    PedidoObservacoes VARCHAR(255),
    FOREIGN KEY (FK_ClienteID) REFERENCES Cliente(PK_ClienteID),
    FOREIGN KEY (FK_FuncionarioID) REFERENCES Funcionario(PK_FuncionarioID)
);

CREATE TABLE IF NOT EXISTS ItemPedido (
    PK_ItemPedidoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PedidoID INT,
    FK_PecaID INT,
    ItemPedidoQuantidade INT,
    ItemPedidoPrecoUnitario DECIMAL(10,2),
    FOREIGN KEY (FK_PedidoID) REFERENCES Pedido(PK_PedidoID),
    FOREIGN KEY (FK_PecaID) REFERENCES Peca(PK_PecaID)
);

CREATE TABLE IF NOT EXISTS Compra (
    PK_CompraID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PedidoID INT,
    CompraData DATE,
    CompraNotaFiscal VARCHAR(50),
    FOREIGN KEY (FK_PedidoID) REFERENCES Pedido(PK_PedidoID)
);

CREATE TABLE IF NOT EXISTS Pagamento (
    PK_PagamentoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_CompraID INT,
    FK_TipoPagamentoID INT,
    PagamentoData DATE,
    PagamentoValor DECIMAL(10,2),
    FOREIGN KEY (FK_CompraID) REFERENCES Compra(PK_CompraID),
    FOREIGN KEY (FK_TipoPagamentoID) REFERENCES TipoPagamento(PK_TipoPagamentoID)
);

CREATE TABLE IF NOT EXISTS Devolucao (
    PK_DevolucaoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_ItemPedidoID INT,
    DevolucaoData DATE,
    DevolucaoMotivo VARCHAR(255),
    FOREIGN KEY (FK_ItemPedidoID) REFERENCES ItemPedido(PK_ItemPedidoID)
);

CREATE TABLE IF NOT EXISTS Encomenda (
    PK_EncomendaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PedidoID INT,
    FK_TipoEntregaID INT,
    EncomendaDataPrevista DATE,
    FOREIGN KEY (FK_PedidoID) REFERENCES Pedido(PK_PedidoID),
    FOREIGN KEY (FK_TipoEntregaID) REFERENCES TipoEntrega(PK_TipoEntregaID)
);

-- =====================
-- CONTAS BANCÁRIAS
-- =====================

CREATE TABLE IF NOT EXISTS Conta (
    PK_ContaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_ContaTipoID INT,
    FK_FuncionarioID INT,
    ContaAgencia VARCHAR(10),
    ContaNumeracao VARCHAR(20),
    FOREIGN KEY (FK_ContaTipoID) REFERENCES ContaTipo(PK_ContaTipoID),
    FOREIGN KEY (FK_FuncionarioID) REFERENCES Funcionario(PK_FuncionarioID)
);

-- =====================
-- OPERAÇÕES CRUD
-- =====================

/*
Cadastro de um Funcionário
*/

-- Cadastro
INSERT INTO Cadastro (CadastroDataCriacao, CadastroStatus, CadastroPeriodoAnos)
VALUES ('2025-11-03', TRUE, 5);
SET @CadastroID = LAST_INSERT_ID();
SELECT * FROM Cadastro;

-- Pessoa
INSERT INTO Pessoa (FK_CadastroID)
VALUES (@CadastroID);
SET @PessoaID = LAST_INSERT_ID();
SELECT * FROM Pessoa;

-- PessoaFisica
INSERT INTO PessoaFisica (FK_PessoaID, AK_PessoaCPF, PessoaNome)
VALUES (@PessoaID, '55010002450', "Thomas Nascimento Correia");
SET @PessoaFisicaID = LAST_INSERT_ID();
SELECT * FROM PessoaFisica;

-- Profissao
INSERT INTO Profissao (ProfissaoTipo, ProfissaoSalarioBase)
VALUES
	('Mecânico', 3500.00),
    ('Atendente', 2200.00),
    ('Entregador', 1600.00),
    ('Gerente', 5200.00);
SET @ProfissaoID = LAST_INSERT_ID();
SELECT * FROM Profissao;

-- Funcionario
INSERT INTO Funcionario (FK_PessoaFisicaID, FK_ProfissaoID, FuncionarioCurriculo, FuncionarioSalario, FuncionarioContrato)
VALUES (@PessoaFisicaID, @ProfissaoID, null, 10000.00, "Contrato CLT");
SELECT * FROM Funcionario;

/*
Atualizando dados
*/

UPDATE Profissao 
SET ProfissaoSalarioBase = 8000.00
WHERE ProfissaoTipo = 'Gerente';

SELECT * FROM Profissao;

/*
Removendo dados
*/

DELETE FROM Profissao
WHERE ProfissaoTipo = 'Entregador';

SELECT * FROM Profissao;

/*
Mais inserções
*/

INSERT INTO VeiculoMarca (VeiculoMarcaDescricao)
VALUES ('Toyota');
SELECT * FROM VeiculoMarca;

INSERT INTO VeiculoModelo (VeiculoModeloDescricao)
VALUES ('Corolla');
SELECT * FROM VeiculoMarca;

INSERT INTO Veiculo (FK_VeiculoMarcaID, FK_VeiculoModeloID, VeiculoAno, VeiculoDescricao)
VALUES (1, 1, 2023, 'Toyota Corolla 2023');
SELECT * FROM Veiculo;