CREATE DATABASE ThomasTurbo;
USE ThomasTurbo;

SET SQL_SAFE_UPDATES = 0;

-- =====================
-- TABELAS BÁSICAS
-- =====================

CREATE TABLE Cadastro (
    PK_CadastroID INT PRIMARY KEY AUTO_INCREMENT,
    CadastroDataCriacao DATE NOT NULL,
    CadastroDataAtualizacao DATE,
    CadastroStatus BOOLEAN DEFAULT TRUE,
    CadastroPeriodoAnos INT
);

CREATE TABLE Profissao (
    PK_ProfissaoID INT PRIMARY KEY AUTO_INCREMENT,
    ProfissaoTipo VARCHAR(100),
    ProfissaoSalarioBase DECIMAL(10,2)
);

CREATE TABLE ContaTipo (
    PK_ContaTipoID INT PRIMARY KEY AUTO_INCREMENT,
    ContaTipoNome VARCHAR(50)
);

CREATE TABLE TipoPagamento (
    PK_TipoPagamentoID INT PRIMARY KEY AUTO_INCREMENT,
    TipoPagamentoDescricao VARCHAR(100)
);

CREATE TABLE TipoEntrega (
    PK_TipoEntregaID INT PRIMARY KEY AUTO_INCREMENT,
    TipoEntregaDescricao VARCHAR(100)
);

CREATE TABLE PecaCategoria (
    PK_PecaCategoriaID INT PRIMARY KEY AUTO_INCREMENT,
    PecaCategoriaDescricao VARCHAR(100)
);

CREATE TABLE PecaMarca (
    PK_PecaMarcaID INT PRIMARY KEY AUTO_INCREMENT,
    PecaMarcaNome VARCHAR(100)
);

CREATE TABLE VeiculoMarca (
    PK_VeiculoMarcaID INT PRIMARY KEY AUTO_INCREMENT,
    VeiculoMarcaDescricao VARCHAR(100)
);

CREATE TABLE VeiculoModelo (
    PK_VeiculoModeloID INT PRIMARY KEY AUTO_INCREMENT,
    VeiculoModeloDescricao VARCHAR(100)
);

CREATE TABLE EstoqueOperacao (
    PK_EstoqueOperacaoID INT PRIMARY KEY AUTO_INCREMENT,
    EstoqueOperacaoNome VARCHAR(100),
    EstoqueOperacaoQuantidade INT
);

CREATE TABLE FidelidadeAssinatura (
    PK_FidelidadeAssinaturaID INT PRIMARY KEY AUTO_INCREMENT,
    FidelidadeAssinaturaMensalidade DECIMAL(10,2),
    FidelidadeAssinaturaDataInicio DATE,
    FidelidadeAssinaturaDataFim DATE,
    FidelidadeAssinaturaStatus BOOLEAN
);

-- =====================
-- PESSOAS
-- =====================

CREATE TABLE Pessoa (
    PK_PessoaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_CadastroID INT,
    FOREIGN KEY (FK_CadastroID) REFERENCES Cadastro(PK_CadastroID)
);

CREATE TABLE PessoaFisica (
    PK_PessoaFisicaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    AK_PessoaCPF CHAR(11) UNIQUE,
    PessoaNome VARCHAR(150),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE PessoaJuridica (
    PK_PessoaJuridicaID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    AK_PessoaCNPJ CHAR(14) UNIQUE,
    PessoaJuridicaRazaoSocial VARCHAR(150),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE Telefone (
    PK_TelefoneID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    TelefoneNumeracao VARCHAR(15),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE Email (
    PK_EmailID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    PessoaEmail VARCHAR(150),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID)
);

CREATE TABLE Endereco (
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

CREATE TABLE Funcionario (
    PK_FuncionarioID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaFisicaID INT,
    FK_ProfissaoID INT,
    FuncionarioCurriculo VARCHAR(255),
    FuncionarioSalario DECIMAL(10,2) NOT NULL,
    FuncionarioContrato VARCHAR(100),
    FOREIGN KEY (FK_PessoaFisicaID) REFERENCES PessoaFisica(PK_PessoaFisicaID),
    FOREIGN KEY (FK_ProfissaoID) REFERENCES Profissao(PK_ProfissaoID)
);

CREATE TABLE ClienteFidelidade (
    PK_ClienteFidelidadeID INT PRIMARY KEY AUTO_INCREMENT,
    FK_FidelidadeAssinaturaID INT,
    ClienteFidelidadeNome VARCHAR(100),
    ClienteFidelidadeDescricao VARCHAR(200),
    ClienteFidelidadeDescontoPercentual DECIMAL(5,2),
    FOREIGN KEY (FK_FidelidadeAssinaturaID) REFERENCES FidelidadeAssinatura(PK_FidelidadeAssinaturaID)
);

CREATE TABLE Cliente (
    PK_ClienteID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaID INT,
    FK_ClienteFidelidadeID INT,
    ClienteDataNascimento DATE,
    ClienteSexo CHAR(1),
    FOREIGN KEY (FK_PessoaID) REFERENCES Pessoa(PK_PessoaID),
    FOREIGN KEY (FK_ClienteFidelidadeID) REFERENCES ClienteFidelidade(PK_ClienteFidelidadeID)
);

CREATE TABLE Fornecedor (
    PK_FornecedorID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PessoaJuridicaID INT,
    FOREIGN KEY (FK_PessoaJuridicaID) REFERENCES PessoaJuridica(PK_PessoaJuridicaID)
);

-- =====================
-- VEÍCULOS / PEÇAS / ESTOQUE
-- =====================

CREATE TABLE Veiculo (
    PK_VeiculoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_VeiculoMarcaID INT,
    FK_VeiculoModeloID INT,
    VeiculoAno YEAR,
    VeiculoDescricao VARCHAR(150),
    FOREIGN KEY (FK_VeiculoMarcaID) REFERENCES VeiculoMarca(PK_VeiculoMarcaID),
    FOREIGN KEY (FK_VeiculoModeloID) REFERENCES VeiculoModelo(PK_VeiculoModeloID)
);

CREATE TABLE Peca (
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

CREATE TABLE Estoque (
    PK_EstoqueID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PecaID INT,
    EstoqueQuantidadePecas INT,
    FOREIGN KEY (FK_PecaID) REFERENCES Peca(PK_PecaID)
);

CREATE TABLE MovimentacaoEstoque (
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

CREATE TABLE Pedido (
    PK_PedidoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_ClienteID INT,
    FK_FuncionarioID INT,
    PedidoData DATE,
    PedidoStatus CHAR(1),
    PedidoObservacoes VARCHAR(255),
    FOREIGN KEY (FK_ClienteID) REFERENCES Cliente(PK_ClienteID),
    FOREIGN KEY (FK_FuncionarioID) REFERENCES Funcionario(PK_FuncionarioID)
);

CREATE TABLE ItemPedido (
    PK_ItemPedidoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PedidoID INT,
    FK_PecaID INT,
    ItemPedidoQuantidade INT,
    ItemPedidoPrecoUnitario DECIMAL(10,2),
    FOREIGN KEY (FK_PedidoID) REFERENCES Pedido(PK_PedidoID),
    FOREIGN KEY (FK_PecaID) REFERENCES Peca(PK_PecaID)
);

CREATE TABLE Compra (
    PK_CompraID INT PRIMARY KEY AUTO_INCREMENT,
    FK_PedidoID INT,
    CompraData DATE,
    CompraNotaFiscal VARCHAR(50),
    FOREIGN KEY (FK_PedidoID) REFERENCES Pedido(PK_PedidoID)
);

CREATE TABLE Pagamento (
    PK_PagamentoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_CompraID INT,
    FK_TipoPagamentoID INT,
    PagamentoData DATE,
    PagamentoValor DECIMAL(10,2),
    FOREIGN KEY (FK_CompraID) REFERENCES Compra(PK_CompraID),
    FOREIGN KEY (FK_TipoPagamentoID) REFERENCES TipoPagamento(PK_TipoPagamentoID)
);

CREATE TABLE Devolucao (
    PK_DevolucaoID INT PRIMARY KEY AUTO_INCREMENT,
    FK_ItemPedidoID INT,
    DevolucaoData DATE,
    DevolucaoMotivo VARCHAR(255),
    FOREIGN KEY (FK_ItemPedidoID) REFERENCES ItemPedido(PK_ItemPedidoID)
);

CREATE TABLE Encomenda (
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

CREATE TABLE Conta (
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

INSERT INTO Profissao (ProfissaoTipo, ProfissaoSalarioBase)
VALUES
    ('Mecânico', 3500.00),
    ('Atendente', 2200.00),
    ('Gerente', 5200.00);

SELECT * FROM Profissao;

UPDATE Profissao
SET ProfissaoSalarioBase = 3800.00
WHERE ProfissaoTipo = 'Mecânico';

SELECT * FROM Profissao;

DELETE FROM Profissao
WHERE ProfissaoTipo = 'Atendente';

SELECT * FROM Profissao;