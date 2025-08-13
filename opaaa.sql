
-- Criação do banco de dados
CREATE DATABASE IF NOT EXISTS marcenariaOnline;
USE marcenariaOnline;
-- Tabela de Clientes
CREATE TABLE clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP,
    endereco_cep VARCHAR(9),
    endereco_logradouro VARCHAR(100),
    endereco_numero VARCHAR(10),
    endereco_complemento VARCHAR(50),
    endereco_bairro VARCHAR(50),
    endereco_cidade VARCHAR(50),
    endereco_uf VARCHAR(2)
);

-- Tabela de Produtos (Modelos de Móveis)
CREATE TABLE produtos (
    produto_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    categoria VARCHAR(50) NOT NULL,
    preco_base DECIMAL(10,2) NOT NULL,
    tempo_producao_medio INT COMMENT 'Tempo médio em dias',
    ativo BOOLEAN DEFAULT TRUE
);

-- Tabela de Materiais
CREATE TABLE materiais (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco_por_metro DECIMAL(10,2) NOT NULL,
    espessura DECIMAL(5,2) COMMENT 'Em milímetros',
    cor VARCHAR(50),
    fornecedor VARCHAR(100),
    estoque_disponivel DECIMAL(10,2) COMMENT 'Em metros quadrados'
);

-- Tabela de Pedidos
CREATE TABLE pedidos (
    pedido_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    data_entrega_prevista DATE,
    status ENUM('orcamento', 'aprovado', 'em_producao', 'pronto', 'entregue', 'cancelado') DEFAULT 'orcamento',
    valor_total DECIMAL(10,2),
    observacoes TEXT,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
);

-- Tabela de Itens do Pedido
CREATE TABLE pedido_itens (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    material_id INT NOT NULL,
    quantidade INT DEFAULT 1,
    largura DECIMAL(6,2) COMMENT 'Em centímetros',
    altura DECIMAL(6,2) COMMENT 'Em centímetros',
    profundidade DECIMAL(6,2) COMMENT 'Em centímetros',
    valor_unitario DECIMAL(10,2),
    valor_total DECIMAL(10,2),
    observacoes TEXT,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id),
    FOREIGN KEY (material_id) REFERENCES materiais(material_id)
);

-- Tabela de Pagamentos
CREATE TABLE pagamentos (
    pagamento_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    metodo ENUM('cartao_credito', 'cartao_debito', 'boleto', 'pix', 'transferencia') NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    status ENUM('pendente', 'processando', 'aprovado', 'recusado', 'reembolsado') DEFAULT 'pendente',
    data_pagamento DATETIME,
    codigo_transacao VARCHAR(100),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);

-- Tabela de Funcionários
CREATE TABLE funcionarios (
    funcionario_id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20),
    cpf VARCHAR(14) UNIQUE,
    cargo VARCHAR(50) NOT NULL,
    data_admissao DATE NOT NULL
);

-- Tabela de Produção
CREATE TABLE producao (
    producao_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    funcionario_id INT NOT NULL,
    data_inicio DATE,
    data_conclusao DATE,
    status ENUM('na_fila', 'em_andamento', 'pausado', 'concluido') DEFAULT 'na_fila',
    observacoes TEXT,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id),
    FOREIGN KEY (funcionario_id) REFERENCES funcionarios(funcionario_id)
);

-- Tabela de Entregas
CREATE TABLE entregas (
    entrega_id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    transportadora VARCHAR(100),
    codigo_rastreio VARCHAR(100),
    data_envio DATE,
    data_entrega DATE,
    status ENUM('preparando', 'enviado', 'em_transito', 'entregue', 'atrasado', 'devolvido') DEFAULT 'preparando',
    custo_frete DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
);
-- Inserindo alguns clientes
INSERT INTO clientes (nome, email, telefone, cpf, endereco_cep, endereco_logradouro, endereco_numero, endereco_bairro, endereco_cidade, endereco_uf)
VALUES 
('João Silva', 'joao.silva@email.com', '(11) 99999-9999', '123.456.789-00', '01234-567', 'Rua das Flores', '100', 'Centro', 'São Paulo', 'SP'),
('Maria Oliveira', 'maria.oliveira@email.com', '(21) 88888-8888', '987.654.321-00', '20000-000', 'Avenida Brasil', '200', 'Copacabana', 'Rio de Janeiro', 'RJ');

-- Inserindo produtos
INSERT INTO produtos (nome, descricao, categoria, preco_base, tempo_producao_medio)
VALUES 
('Armário Sob Medida', 'Armário modular para quarto ou sala', 'Armários', 1500.00, 15),
('Mesa de Jantar', 'Mesa de jantar retangular ou redonda', 'Mesas', 2000.00, 20),
('Estante', 'Estante modular para livros e objetos', 'Estantes', 1200.00, 12);

-- Inserindo materiais
INSERT INTO materiais (nome, descricao, preco_por_metro, espessura, cor, fornecedor, estoque_disponivel)
VALUES 
('MDF Branco', 'MDF 15mm branco', 45.00, 15.00, 'Branco', 'Madeireira XYZ', 500.00),
('MDF Carvalho', 'MDF 18mm acabamento carvalho', 60.00, 18.00, 'Carvalho', 'Madeireira XYZ', 300.00),
('Compensado Freijó', 'Compensado 15mm freijó', 55.00, 15.00, 'Freijó', 'Madeireira ABC', 400.00);

-- Inserindo funcionários
INSERT INTO funcionarios (nome, email, telefone, cpf, cargo, data_admissao)
VALUES 
('Carlos Mendes', 'carlos.mendes@marcenaria.com', '(11) 77777-7777', '111.222.333-44', 'Marceneiro', '2020-01-15'),
('Ana Souza', 'ana.souza@marcenaria.com', '(11) 66666-6666', '222.333.444-55', 'Designer', '2021-03-10');
-- Consulta para visualizar pedidos em andamento
SELECT 
    p.pedido_id,
    c.nome AS cliente,
    p.data_pedido,
    p.status,
    p.valor_total
FROM 
    pedidos p
JOIN 
    clientes c ON p.cliente_id = c.cliente_id
WHERE 
    p.status NOT IN ('entregue', 'cancelado')
ORDER BY 
    p.data_pedido DESC;

-- Consulta para calcular materiais necessários para produção
SELECT 
    m.nome AS material,
    SUM(pi.largura * pi.altura / 10000) AS area_total_m2,
    SUM(pi.largura * pi.altura / 10000 * m.preco_por_metro) AS custo_total_material
FROM 
    pedido_itens pi
JOIN 
    materiais m ON pi.material_id = m.material_id
JOIN 
    pedidos p ON pi.pedido_id = p.pedido_id
WHERE 
    p.status = 'aprovado'
GROUP BY 
    m.nome;

-- Consulta para acompanhamento de produção
SELECT 
    pr.producao_id,
    p.pedido_id,
    c.nome AS cliente,
    f.nome AS responsavel,
    pr.data_inicio,
    pr.data_conclusao,
    pr.status
FROM 
    producao pr
JOIN 
    pedidos p ON pr.pedido_id = p.pedido_id
JOIN 
    clientes c ON p.cliente_id = c.cliente_id
JOIN 
    funcionarios f ON pr.funcionario_id = f.funcionario_id
WHERE 
    pr.status != 'concluido'
ORDER BY 
    pr.data_inicio;
    -- View para relatório de vendas por produto
CREATE VIEW vendas_por_produto AS
SELECT 
    prod.nome AS produto,
    COUNT(pi.item_id) AS quantidade_vendida,
    SUM(pi.valor_total) AS total_vendido
FROM 
    pedido_itens pi
JOIN 
    produtos prod ON pi.produto_id = prod.produto_id
JOIN 
    pedidos p ON pi.pedido_id = p.pedido_id
WHERE 
    p.status != 'cancelado'
GROUP BY 
    prod.nome
ORDER BY 
    total_vendido DESC;

-- View para estoque crítico de materiais
CREATE VIEW estoque_critico AS
SELECT 
    nome,
    estoque_disponivel,
    preco_por_metro
FROM 
    materiais
WHERE 
    estoque_disponivel < 50
ORDER BY 
    estoque_disponivel ASC;
    -- Procedure para calcular orçamento
DELIMITER //
CREATE PROCEDURE calcular_orcamento(
    IN p_produto_id INT,
    IN p_material_id INT,
    IN p_largura DECIMAL(6,2),
    IN p_altura DECIMAL(6,2),
    IN p_profundidade DECIMAL(6,2),
    OUT p_valor_total DECIMAL(10,2)
)
BEGIN
    DECLARE v_preco_base DECIMAL(10,2);
    DECLARE v_preco_material DECIMAL(10,2);
    DECLARE v_area DECIMAL(10,2);
    
    -- Obter preço base do produto
    SELECT preco_base INTO v_preco_base FROM produtos WHERE produto_id = p_produto_id;
    
    -- Obter preço do material
    SELECT preco_por_metro INTO v_preco_material FROM materiais WHERE material_id = p_material_id;
    
    -- Calcular área em m² (considerando todas as faces do móvel)
    -- Esta é uma fórmula simplificada - ajuste conforme necessário para seu modelo de negócios
    SET v_area = (p_largura * p_altura * 2 + p_largura * p_profundidade * 2 + p_altura * p_profundidade * 2) / 10000;
    
    -- Calcular valor total (preço base + custo do material)
    SET p_valor_total = v_preco_base + (v_area * v_preco_material);
END //
DELIMITER ;

-- Procedure para atualizar status do pedido
DELIMITER //
CREATE PROCEDURE atualizar_status_pedido(
    IN p_pedido_id INT,
    IN p_novo_status VARCHAR(20)
BEGIN
    UPDATE pedidos SET status = p_novo_status WHERE pedido_id = p_pedido_id;
    
    -- Se o status for alterado para "em_producao", criar registro na tabela de produção
    IF p_novo_status = 'em_producao' THEN
        INSERT INTO producao (pedido_id, funcionario_id, status)
        VALUES (p_pedido_id, 1, 'na_fila'); -- Assumindo que o funcionário 1 é o padrão
    END IF;
END //
DELIMITER ;
-- Trigger para atualizar valor total do pedido quando itens são inseridos/atualizados
DELIMITER //
CREATE TRIGGER atualizar_total_pedido
AFTER INSERT ON pedido_itens
FOR EACH ROW
BEGIN
    UPDATE pedidos
    SET valor_total = (
        SELECT SUM(valor_total)
        FROM pedido_itens
        WHERE pedido_id = NEW.pedido_id
    )
    WHERE pedido_id = NEW.pedido_id;
END //
DELIMITER ;

-- Trigger para atualizar estoque quando um pedido é concluído
DELIMITER //
CREATE TRIGGER atualizar_estoque
AFTER UPDATE ON pedidos
FOR EACH ROW
BEGIN
    IF NEW.status = 'entregue' AND OLD.status != 'entregue' THEN
        UPDATE materiais m
        JOIN pedido_itens pi ON m.material_id = pi.material_id
        SET m.estoque_disponivel = m.estoque_disponivel - (pi.largura * pi.altura / 10000)
        WHERE pi.pedido_id = NEW.pedido_id;
    END IF;
END //
DELIMITER ;