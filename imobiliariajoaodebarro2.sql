-- Criar o banco de dados
CREATE DATABASE ImobiliariaJoaoDeBarro;
USE ImobiliariaJoaoDeBarro;

-- Tabela Síndico
CREATE TABLE Sindico (
    Matricula VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20)
);

-- Tabela Condomínio
CREATE TABLE Condominio (
    Codigo INT PRIMARY KEY AUTO_INCREMENT,
    Nome VARCHAR(255) NOT NULL,
    Endereco VARCHAR(255),
    Matricula_Sindico VARCHAR(20) UNIQUE,
    FOREIGN KEY (Matricula_Sindico) REFERENCES Sindico(Matricula)
);

-- Tabela Apartamento
CREATE TABLE Apartamento (
    Codigo_Condominio INT,
    Numero INT,
    Tipo ENUM('Padrão', 'Cobertura') NOT NULL,
    PRIMARY KEY (Codigo_Condominio, Numero),
    FOREIGN KEY (Codigo_Condominio) REFERENCES Condominio(Codigo)
);

-- Tabela Garagem (1:1 com Apartamento)
CREATE TABLE Garagem (
    Codigo_Condominio INT,
    Numero_Apartamento INT,
    Numero_Garagem INT UNIQUE NOT NULL,
    Tipo ENUM('Padrão', 'Coberta') NOT NULL,
    PRIMARY KEY (Codigo_Condominio, Numero_Apartamento),
    FOREIGN KEY (Codigo_Condominio, Numero_Apartamento) 
        REFERENCES Apartamento(Codigo_Condominio, Numero)
);

-- Tabela Proprietário
CREATE TABLE Proprietario (
    RG VARCHAR(20) PRIMARY KEY,
    Nome VARCHAR(255) NOT NULL,
    Telefone VARCHAR(20),
    Email VARCHAR(255) UNIQUE
);

-- Tabela de relacionamento Proprietário-Apartamento (N:M)
CREATE TABLE Proprietario_Apartamento (
    RG_Proprietario VARCHAR(20),
    Codigo_Condominio INT,
    Numero_Apartamento INT,
    PRIMARY KEY (RG_Proprietario, Codigo_Condominio, Numero_Apartamento),
    FOREIGN KEY (RG_Proprietario) REFERENCES Proprietario(RG),
    FOREIGN KEY (Codigo_Condominio, Numero_Apartamento) 
        REFERENCES Apartamento(Codigo_Condominio, Numero)
);

-- Inserir dados de 2 Síndicos
INSERT INTO Sindico (Matricula, Nome, Endereco, Telefone) VALUES
('S001', 'Carlos Silva', 'Rua X, 123', '11999999999'),
('S002', 'Ana Souza', 'Rua Y, 456', '11988888888');

-- Inserir dados de 10 Proprietários
INSERT INTO Proprietario (RG, Nome, Telefone, Email) VALUES
('RG001', 'João Mendes', '11977777777', 'joao@email.com'),
('RG002', 'Maria Oliveira', '11966666666', 'maria@email.com'),
('RG003', 'Pedro Santos', '11955555555', 'pedro@email.com'),
('RG004', 'Fernanda Lima', '11944444444', 'fernanda@email.com'),
('RG005', 'Roberto Alves', '11933333333', 'roberto@email.com'),
('RG006', 'Paula Rocha', '11922222222', 'paula@email.com'),
('RG007', 'Gabriel Nunes', '11911111111', 'gabriel@email.com'),
('RG008', 'Juliana Costa', '11900000000', 'juliana@email.com'),
('RG009', 'Lucas Martins', '11899999999', 'lucas@email.com'),
('RG010', 'Camila Fernandes', '11888888888', 'camila@email.com');

-- Inserir dados de 2 Condomínios com Síndicos
INSERT INTO Condominio (Nome, Endereco, Matricula_Sindico) VALUES
('Residencial Primavera', 'Rua A, 123', 'S001'),
('Condomínio Azul', 'Rua B, 456', 'S002');

-- Inserir dados de 5 Apartamentos para cada Condomínio
INSERT INTO Apartamento (Codigo_Condominio, Numero, Tipo) VALUES
(1, 101, 'Padrão'), (1, 102, 'Padrão'), (1, 103, 'Padrão'), (1, 104, 'Padrão'), (1, 105, 'Cobertura'),
(2, 201, 'Padrão'), (2, 202, 'Padrão'), (2, 203, 'Padrão'), (2, 204, 'Padrão'), (2, 205, 'Cobertura');

-- Inserir dados de Garagem
INSERT INTO Garagem (Codigo_Condominio, Numero_Apartamento, Numero_Garagem, Tipo) VALUES
(1, 101, 1, 'Padrão'), (1, 102, 2, 'Padrão'), (1, 103, 3, 'Padrão'), (1, 104, 4, 'Padrão'), (1, 105, 5, 'Coberta'),
(2, 201, 6, 'Padrão'), (2, 202, 7, 'Padrão'), (2, 203, 8, 'Padrão'), (2, 204, 9, 'Padrão'), (2, 205, 10, 'Coberta');

-- Distribuir os Apartamentos entre os Proprietários
INSERT INTO Proprietario_Apartamento (RG_Proprietario, Codigo_Condominio, Numero_Apartamento) VALUES
('RG001', 1, 101), ('RG002', 1, 102), ('RG003', 1, 103), ('RG004', 1, 104), ('RG005', 1, 105),
('RG006', 2, 201), ('RG007', 2, 202), ('RG008', 2, 203), ('RG009', 2, 204), ('RG010', 2, 205),
('RG001', 2, 201), ('RG002', 2, 202);

-- Simular a venda de 2 Apartamentos
DELETE FROM Proprietario_Apartamento WHERE Codigo_Condominio = 1 AND Numero_Apartamento = 101;
INSERT INTO Proprietario_Apartamento (RG_Proprietario, Codigo_Condominio, Numero_Apartamento) VALUES ('RG003', 1, 101);

DELETE FROM Proprietario_Apartamento WHERE Codigo_Condominio = 2 AND Numero_Apartamento = 201;
INSERT INTO Proprietario_Apartamento (RG_Proprietario, Codigo_Condominio, Numero_Apartamento) VALUES ('RG004', 2, 201);

-- Excluir o Proprietário que ficou sem Apartamento
DELETE FROM Proprietario WHERE RG = 'RG001';