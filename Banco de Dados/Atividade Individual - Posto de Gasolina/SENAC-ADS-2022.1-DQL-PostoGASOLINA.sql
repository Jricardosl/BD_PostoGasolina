
/*--------------------------------------------------------------------------------------------*/
/*--------------------------------------- COMANDOS DQL----------------------------------------*/
/*--------------------------------------------------------------------------------------------*/ 

/*----------------------------------Relatório 1-----------------------------------------------*/ 
/*Lista dos empregados admitidos entre 2022-06-01 e 2022-07-30, 
trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Cidade Moradia, Número de Telefone), 
ordenado por data de admissão decrescente */

select e.nome "Nome Empregado", 
	   e.cpf "CPF Empregado", 
       e.dataadm "Data Admissão", 
       concat("R$ ",e.salario) "Salário", 
       en.cidade "Cidade Moradia" , 
       tel.numero "Número de Telefone"
			from empregado e
				inner join endereco en on en.empregado_cpf = e.cpf
				inner join telefone tel on e.cpf = tel.Empregado_CPF
					where e.dataAdm between '2022-06-01' and '2022-07-30'
						order by dataAdm;
	
/*----------------------------------Relatório 2-----------------------------------------------*/ 
/*Lista dos empregados que ganham menos que a média salarial dos funcionários do Posto de Gasolina, 
trazendo as colunas (Nome Empregado, CPF Empregado, Data Admissão,  Salário, Cidade Moradia), 
ordenado por nome do empregado*/

select avg(salario) from empregado;

select e.nome "Nome Empregado", 
	   e.cpf "CPF Empregado", 
       e.dataadm "Data Admissão", 
       concat("R$ ",e.salario) "Salário", 
       en.cidade "Cidade Moradia"
			from empregado e
				inner join endereco en on en.empregado_cpf = e.cpf
					where salario < (select avg(salario) from empregado)
						order by e.nome;
                
/*----------------------------------Relatório 3-----------------------------------------------*/ 
/*Lista dos empregados que são da cidade do Recife e possuem dependentes, trazendo as colunas 
(Nome Empregado, CPF Empregado, Data Admissão,  Salário, Cidade Moradia, Quantidade de Dependentes), 
ordenado por nome do empregado;*/

create view quantidadeDependenteRECIFE as
select e.nome "Nome_Empregado",  
	   e.cpf "CPF_Empregado", 
       e.dataadm "Data_Admissão", 
       concat("R$ ",e.salario) "Salário", 
       en.cidade "Cidade_Moradia" , 
       count(d.cpf) "Quantidade_de_Dependente"
		from empregado e
			inner join endereco en on en.empregado_cpf = e.cpf
			inner join dependente d on e.cpf = d.Empregado_CPF
				where en.cidade like "%ecife" 
					group by e.nome
						order by e.nome;                
	
select * from quantidadedependenterecife;


select 
   Nome_Empregado,
		count(*) as "Quantidade de Dependentes"
			from quantidadedependenterecife
				group by nome_empregado;

/*----------------------------------Relatório 4-----------------------------------------------*/ 
/*Lista dos empregados com a quantidade total de vendas já realiza por cada Empregado, trazendo as colunas
(Nome Empregado, CPF Empregado, Sexo, Salário, Quantidade Vendas, Total Valor Vendido), 
ordenado por quantidade total de vendas realizadas;*/            

select e.nome "Nome_Empregado",  
	   e.cpf "CPF_Empregado", 
       e.sexo "Sexo", 
       e.salario "Salário", 
       sum(iv.qtdProduto) "Quantidade_Vendas", 
       concat("R$ ",sum(v.valortotal)) "Total valor vendido"
		from empregado e
			inner join vendas v on v.Empregado_CPF = e.cpf
            inner join itensvenda iv on v.idVendas = iv.Estoque_idProduto
				group by e.nome
                    order by e.nome;


/*----------------------------------Relatório 5-----------------------------------------------*/ 
/* Lista dos empregados que trabalham em cada departamento, trazendo as colunas 
(Nome Empregado, CPF Empregado, Salário, Nome da Ocupação, Número do Telefone do Empregado, 
Nome do Departamento, Local do Departamento, Número de Telefone do Departamento, Nome do Gerente), 
ordenado por nome do Departamento;*/            

select e.nome "Nome_Empregado", 
       e.cpf "CPF_Empregado",  
       concat("R$ ",e.salario) "Salário", 
       o.nome "Ocupação", 
       coalesce(tel.numero, null,'-')  "Telefone",   
       d.nome "Departamento", 
       d.localdep "Local_Departamto", 
       coalesce(td.numero, null, '-') "Telefone_Departamento" ,  
       eg.nome "Gerente"
			from trabalhar t
				inner join empregado e on e.cpf = t.empregado_cpf
				inner join ocupacao o on o.cbo = t.ocupacao_cbo
				inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
				inner join gerente g on g.empregado_cpf = d.gerente_empregado_cpf
				inner join empregado eg on eg.cpf = g.empregado_cpf
				inner join endereco ed on ed.empregado_cpf = e.cpf
				left join telefone tel on tel.empregado_cpf = e.cpf
				left join telefone td on td.Departamento_idDepartamento = d.idDepartamento
					order by d.nome;

/*----------------------------------Relatório 6-----------------------------------------------*/ 
/* Lista dos departamentos contabilizando o número total de empregados por departamento, 
trazendo as colunas (Nome Departamento, Local Departamento, Total de Empregados do Departamento, 
Nome do Gerente, Número do Telefone do Departamento), ordenado por nome do Departamento;*/            

select d.nome "Departamento", 
       d.localdep "Local_Departamto",  
       count(e.CPF)  "Total_Empregados", 
       eg.nome "Gerente",  
       coalesce(td.numero, null, '-') "Telefone_Departamento" 
		from trabalhar t
			inner join empregado e on e.cpf = t.empregado_cpf
			inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
			inner join gerente g on g.empregado_cpf = d.gerente_empregado_cpf
			inner join empregado eg on eg.cpf = g.empregado_cpf
            left join telefone td on td.Departamento_idDepartamento = d.idDepartamento
                group by d.idDepartamento
					order by d.nome;

select * from departamento;

select * from empregado;

/*----------------------------------Relatório 7-----------------------------------------------*/ 
/* Lista das formas de pagamentos mais utilizadas nas Vendas, informando quantas vendas cada forma de pagamento
 já foi relacionada, trazendo as colunas (Tipo Forma Pagamento, Quantidade Vendas, Total Valor Vendido), 
 ordenado por quantidade total de vendas realizadas*/
 
 select fp.tipopag "Tipo forma Pagamento",
		count(fp.idFormaPag) "Quantidade de Vendas",
        concat("R$ ",sum(v.valortotal)) "Total Valor Vendido"
			from  vendas v
				inner join formapag fp on fp.idformapag = v.idvendas
                inner join itensvenda iv on iv.vendas_idvendas = v.idvendas
					group by fp.tipoPag
                    order by fp.idFormaPag;
	
/*----------------------------------Relatório 8-----------------------------------------------*/ 
/* Lista das Vendas, informando o detalhamento de cada venda quanto os seus itens, 
trazendo as colunas (Data Venda, Nome Produto, Quantidade ItensVenda, 
Valor Produto, Valor Total Venda, Nome Empregado, Nome do Departamento), ordenado por Data Venda*/
    
     select v.dataVenda "Data Venda",
		es.nome  "Nome Produto",
        iv.qtdProduto "Quantidade Itens Vendas",
        concat("R$ ", round(es.valor, 2)) "Valor Produto",
        concat("R$ ",v.valorTotal) "Valor total Vendas",
        e.nome "Nome Empregado",
        d.nome "Nome Departamento"
			from  vendas v
				inner join itensvenda iv on iv.Vendas_idVendas = v.idvendas
                inner join estoque es on es.idProduto = iv.estoque_idproduto
                inner join empregado e on e.CPF = v.Empregado_CPF
                inner join trabalhar t on t.Empregado_CPF = e.CPF
                inner join departamento d on d.idDepartamento = t.Departamento_idDepartamento
					order by v.dataVenda;
	

/*----------------------------------Relatório 9-----------------------------------------------*/ 
/* Balaço das Vendas, informando a soma dos valores vendidos por dia, trazendo as colunas 
(Data Venda, Quantidade de Vendas, Valor Total Venda), ordenado por Data Venda;*/

select substring(v.datavenda, 1, 10) "Data Venda",
	   sum(iv.qtdproduto) "Quantidade de Vendas",
       concat("R$ ",sum(v.valortotal)) "Valor Total Venda"
			from vendas v 
				inner join itensvenda iv on iv.Vendas_idVendas = v.idVendas
					group by substring(v.datavenda, 1, 10)
						order by substring(v.dataVenda, 1, 10);


/*----------------------------------Relatório 10-----------------------------------------------*/ 
/*  Lista dos Produtos, informando qual Fornecedor de cada produto, trazendo as colunas 
(Nome Produto, Valor Produto, Categoria do Produto, Nome Fornecedor, Email Fornecedor, Telefone Fornecedor), 
ordenado por Nome Produto;*/

select es.nome "Nome do Produto",
	   concat("R$ ", round(es.valor, 2)) "Valor do Produto",
       es.categoria "Categoria do Produto",
       f.nome "Nome do Fornecedor",
       f.email "Email Fornecedor",
       coalesce(Tel.numero, null, '-') "Telefone Fornecedor"
			from compras c
				inner join estoque es on c.Estoque_idProduto = es.idProduto
                inner join fornecedor f on c.`Fornecedor_cnpj/cpf` = f.`cnpj/cpf`
                left join telefone tel on f.`cnpj/cpf` = tel.`Fornecedor_cnpj/cpf`
					order by es.nome;
       
       /*----------------------------------Relatório 11-----------------------------------------------*/ 
/*  Lista dos Produtos mais vendidos, informando a quantidade (total) de vezes que cada produto participou em vendas, 
trazendo as colunas (Nome Produto, Quantidade (Total) Vendas),
 ordenado por quantidade de vezes que o produto participou em vendas;*/
 
 select es.nome "Nome Produto",
		count(iv.Estoque_idProduto) "Quantidade (Total) Vendas"
			from itensvenda iv
				inner join vendas v on v.idVendas = iv.Vendas_idVendas
                inner join estoque es on es.idProduto = iv.Estoque_idProduto
					group by iv.Estoque_idProduto
                    order by iv.Estoque_idProduto;
                
 
/*----------------------------------Relatório 12-----------------------------------------------*/ 
/*Lista das vendas por departamentos contabilizando o número total de vendas por departamento,
 trazendo as colunas (Nome Departamento, Local Departamento, Nome do Gerente,  
 Total de Vendas,  Valor Total das Vendas), ordenado por nome do Departamento*/
 
select d.nome "Departamento", 
       d.localdep "Local_Departamto",  
       eg.nome "Gerente",  
       count(iv.Vendas_idVendas) "Total de Vendas",
       concat("R$ ",sum(v.valorTotal)) "Valor Total das Vendas"
		from trabalhar t
			inner join empregado e on e.cpf = t.empregado_cpf
			inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
			inner join gerente g on g.empregado_cpf = d.gerente_empregado_cpf
			inner join empregado eg on eg.cpf = g.empregado_cpf
            inner join vendas v on v.Empregado_CPF = e.CPF
            inner join itensvenda iv on iv.Vendas_idVendas = v.idVendas
				where d.nome like "frente%" or d.nome like "Conv%"
				group by d.nome
					order by d.nome;

select  cpf, nome, salario, case when statusemp = 1 then 'ATIVO'
else'INATIVO' end "status"
 from empregado;
 
select * from empregado;

create view depidade as
select cpf, nome, year(now()) - substring(datanasc, 1,4) "idade", empregado_cpf
	from dependente;
    
create procedure dependentesidade ()
	select cpf, nome, year(now()) - substring(datanasc, 1,4) "idade", empregado_cpf
		from dependente;
    
call dependentesidade ();

drop procedure dependentesidade;

drop procedure empregadoCidade;

delimiter $$
create procedure empregadoCidade (in cid varchar (45))
	begin
		select e.nome "Nome_Empregado",  
			   e.cpf "CPF_Empregado", 
			   e.dataadm "Data_Admissão", 
			   concat("R$ ",e.salario) "Salário", 
			   en.cidade "Cidade_Moradia" , 
			   count(d.cpf) "Quantidade_de_Dependente"
				from empregado e
					inner join endereco en on en.empregado_cpf = e.cpf
					inner join dependente d on e.cpf = d.Empregado_CPF
						where en.cidade like cid 
							group by e.nome
								order by e.nome; 
	end $$
delimiter ;

call empregadoCidade('%linda');
    

delimiter //
create procedure reajusteSalarial (in taxa float)
	begin
		update empregado set salario = salario * taxa;
	end //
delimiter ;

call reajusteSalarial(1.2);

/*Destravar a base de dados para permitir delete sem where*/
set sql_safe_updates = 0;

/*Travar a base de dados para permitir delete sem where*/
set SQL_SAFE_UPDATES = 1;

select * from depidade;

select e.cpf "CPF", upper(e.nome) "Nome", e.salario "Salário",
	case when e.statusEmp = 1 then 'Ativo'
		when e.statusEmp = 0 then 'Inativo' end "Status",
			case when di.idade <=3 then 'Sim'
				else 'Não' end "Auxílio Creche"
			from empregado e
				left join depidade di on di.empregado_cpf = e.cpf
                
				
delimiter //
	create procedure pagaAuxcreche (in empregado varchar (60))
		begin
			select distinct e.cpf "CPF", upper(e.nome) "Nome", e.salario "Salário",
				case when e.statusEmp = 1 then 'Ativo'
					when e.statusEmp = 0 then 'Inativo' end "Status",
				case when di.idade <=3 then 'Sim'
					else 'Não' end "Auxílio Creche"
				from empregado e
					left join depidade di on di.empregado_cpf = e.cpf
						where e.nome like empregado
							order by e.nome;
	end //
delimiter ;

call pagaAuxCreche ("%");

drop procedure salvadep;

delimiter //
	create procedure salvaDep (in c varchar (14), 
								in n varchar (45), 
                                in dn date, 
                                in p varchar (15), 
                                in ecpf varchar (14))
			begin
				declare _cpfdep varchar (14);
					select cpf into _cpfdep from dependente where cpf like cpf;
					if isnull(_cpfdep) = null then
						insert into dependente value (c, n, dn, p, ecpf);
					else
						update depenente set cpf = c, nome = n, datanasc = dn, parentesco = p
							where cpf = c;
                    end if;
	end //
    
delimiter ;


call salvadep ("123.456.789-20", "César Pinho", '2021-10-27', "Filho", "098.765.432-11");


delimiter //
	create function temposervico (dataIni datetime, cpfEmp varchar (14))
		returns int 
			DETERMINISTIC
				begin
					declare _stEmp int;
                    declare _dd datetime;
                    select statusEmp into _stEmp from empregado where CPF = cpfEmp;
                    if _stEmp = 1 then
						return year (now()) - year (dataIni);
					else 
						select dataDem into _dd from empregado where cpf = cpfEmp;
						return year (_dd) - year (dataIni);
		
		end if;
                
              end //
                
delimiter ;


select nome, tempoServico (dataAdm, cpf), dataAdm from empregado;


create procedure dependentesIdade()
	select cpf, nome, year(now()) - substring(dataNasc, 1, 4) "idade", empregado_cpf
		from dependente;
        
call dependentesIdade();

select * from depidade;

drop procedure empregadoCidade;

delimiter $$
	create procedure empregadoCidade(in cid varchar(45))
		begin
			select e.nome "Empregado", e.CPF "CPF", e.dataAdm "Data Admissão", e.salario "Salário", 
				en.cidade "Cidade", count(d.Empregado_CPF) "Quantidade Dependente"
				from empregado e
					inner join endereco en on en.Empregado_CPF = e.cpf
					left join dependente d on d.Empregado_CPF = e.CPF
						where en.cidade like cid
							group by (e.CPF)
								order by e.nome;
        end $$
delimiter ;

call empregadoCidade('Olinda');

delimiter //
	create procedure reajusteSalarial(in taxa float)
		begin
			update empregado set salario = salario * taxa;
        end //
delimiter ;

select * from empregado;

call reajusteSalarial(0.7);

drop procedure mediaSalarial;

delimiter //
	create procedure mediaSalarial(out media decimal(7,2))
		begin
			select round(avg(salario), 2) into media from empregado;
        end //
delimiter ;

call mediaSalarial(@media);

select @media;

select * from dependenteidade;

delimiter //
create procedure pagaAuxCreche(in empregado varchar(60))
	begin
		select e.cpf "CPF", upper(e.nome) "Nome", e.salario "Salário",
			case when e.statusEmp = 1 then 'Ativo'
				when e.statusEmp = 0 then 'Inativo' end "Status",
			case when  di.idade <= 3 then 'Sim'
				else 'Não' end "Auxílio Creche"
			from empregado e
				left join depIdade di  on di.Empregado_CPF = e.cpf
					where e.nome like empregado
						order by e.nome;
    end //
delimiter ;

call pagaAuxCreche("Danilo Farias%");

drop procedure salvarDep;

delimiter //
create procedure salvarDep(in c varchar(14), in n varchar(45), in dn date, in p varchar(15), in ecpf varchar(14))
	begin
		declare _cpfDep varchar(14);
		select cpf into _cpfDep from dependente where cpf like c;
		if isnull(_cpfDep) then
			insert into dependente value (c, n, dn, p, ecpf);
		else 
			update dependente set nome = n, dataNasc = dn, parentesco = p, empregado_cpf = ecpf
				where cpf = c;
        end if;            
	end //
delimiter ;

call salvarDep("122.789.765-90", "Vinicius Raoni", '2021-11-15', "Filho", "098.765.432-11");

call salvarDep('123.456.789-40', 'Diego Raoni', '2021-10-27', 'Filho', '098.765.432-11');

delimiter //
create function tempoServico(dataIni datetime, cpfEmp varchar(14)) 
	returns int 
		DETERMINISTIC
			begin
				declare _stEmp int;
                declare _dd datetime;
                select statusEmp into _stEmp from empregado where cpf = cpfEmp; 
				if _stEmp = 1 then
					return year(now()) - year(dataIni); 
				else 
					select dataDem into _dd from empregado where cpf = cpfEmp;
                    return year(_dd) - year(dataIni);
				end if;
			end //
delimiter ;

select nome, tempoServico(dataAdm, cpf), dataAdm from empregado;

-- ADS 3ª Noite PCRxPD (UNIT) (Sexta) --
-- cross join --
select d.cpf, d.nome, d.dataNasc, d.parentesco, e.cpf, e.nome
	from dependente d, empregado e;

-- inner join (implicita) --
select d.cpf, d.nome, d.dataNasc, d.parentesco, e.cpf, e.nome
	from dependente d, empregado e
		where d.empregado_cpf = e.cpf;

-- inner join (explicita) --
select d.cpf, d.nome, d.dataNasc, d.parentesco, e.cpf, e.nome
	from dependente d
		inner join empregado e on d.empregado_cpf = e.cpf;

select e.cpf "CPF", e.nome "Empregado", e.salario "Salário", o.nome "Ocupação",
	d.nome "Departemento", d.localDep "Local do Departamento"
    from trabalhar t
		inner join empregado e on e.cpf = t.empregado_cpf
        inner join ocupacao o on o.cbo = t.ocupacao_cbo
        inner join departamento d on d.iddepartamento = t.departamento_iddepartamento;

select e.cpf "CPF", e.nome "Empregado", e.salario "Salário", o.nome "Ocupação",
	d.nome "Departemento", d.localDep "Local do Departamento", eg.nome "Gerente"
    from trabalhar t
		inner join empregado e on e.cpf = t.empregado_cpf
        inner join ocupacao o on o.cbo = t.ocupacao_cbo
        inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
        inner join gerente g on d.gerente_empregado_cpf = g.empregado_cpf
        inner join empregado eg on eg.cpf = g.empregado_cpf;

select e.cpf "CPF", e.nome "Empregado", e.salario "Salário", o.nome "Ocupação",
	d.nome "Departemento", d.localDep "Local do Departamento", eg.nome "Gerente"
    from trabalhar t
		inner join empregado e on e.cpf = t.empregado_cpf
        inner join ocupacao o on o.cbo = t.ocupacao_cbo
        inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
        inner join gerente g on d.gerente_empregado_cpf = g.empregado_cpf
        inner join empregado eg on eg.cpf = g.empregado_cpf
        inner join endereco en on en.empregado_cpf = e.cpf
			where en.cidade like "%ecife";

select avg(salario) from empregado;

select e.cpf "CPF", e.nome "Empregado", e.salario "Salário", o.nome "Ocupação",
	d.nome "Departemento", d.localDep "Local do Departamento", eg.nome "Gerente"
    from trabalhar t
		inner join empregado e on e.cpf = t.empregado_cpf
        inner join ocupacao o on o.cbo = t.ocupacao_cbo
        inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
        inner join gerente g on d.gerente_empregado_cpf = g.empregado_cpf
        inner join empregado eg on eg.cpf = g.empregado_cpf
			where e.salario <= (select avg(salario) from empregado);
            
create view empregadoTrab as
	select e.cpf "CPF", e.nome "Empregado", e.salario "Salário", o.nome "Ocupação",
		d.nome "Departemento", d.localDep "Local do Departamento", eg.nome "Gerente"
		from trabalhar t
			inner join empregado e on e.cpf = t.empregado_cpf
			inner join ocupacao o on o.cbo = t.ocupacao_cbo
			inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
			inner join gerente g on d.gerente_empregado_cpf = g.empregado_cpf
			inner join empregado eg on eg.cpf = g.empregado_cpf;

select * from empregadotrab;

select * from empregadotrab
	where `Salário` >= (select avg(salario) from empregado);

select e.cpf "CPF", e.nome "Empregado", tel.numero "Telefone", e.salario "Salário", o.nome "Ocupação",
	d.nome "Departemento", d.localDep "Local do Departamento", eg.nome "Gerente"
    from trabalhar t
		inner join empregado e on e.cpf = t.empregado_cpf
        inner join ocupacao o on o.cbo = t.ocupacao_cbo
        inner join departamento d on d.iddepartamento = t.departamento_iddepartamento
        inner join gerente g on d.gerente_empregado_cpf = g.empregado_cpf
        inner join empregado eg on eg.cpf = g.empregado_cpf
        left join telefone tel on tel.empregado_cpf = e.cpf;

select cpf, nome, parentesco, year(now()) - year(dataNasc) "idade", empregado_CPF 
	from dependente
		where parentesco like "%ilh%";

create view dependenteIdade as
	select cpf, nome, parentesco, timestampdiff(year, dataNasc, now()) "idade", empregado_CPF 
		from dependente
			where parentesco like "%ilh%";

drop view dependenteidade;

select di.nome, di.idade, e.nome
	from dependenteidade di
		inner join empregado e on e.CPF = di.empregado_cpf;

select e.nome "Empregado", e.cpf "CPF", e.salario "Salário", 
	case when di.idade between 1 and 3 then "Sim"
		else "Não" end "Auxílio Creche"
	from empregado e
		left join dependenteidade di on di.Empregado_CPF = e.CPF
			order by e.nome;

select e.nome "Empregado", e.cpf "CPF", e.salario "Salário", 
	case when di.idade <= 3 then "Sim"
		else "Não" end "Auxílio Creche"
	from empregado e
		left join dependenteidade di on di.Empregado_CPF = e.CPF
			where di.empregado_cpf is null
				order by e.nome;

select cast("86/10/22" as date) ;

create procedure depIdade()
	select e.nome "Empregado", e.cpf "CPF", e.salario "Salário", 
		case when di.idade between 1 and 3 then "Sim"
			else "Não" end "Auxílio Creche"
		from empregado e
			left join dependenteidade di on di.Empregado_CPF = e.CPF
				order by e.nome;

call depIdade();

delimiter //
create procedure empregadoCid(in cidade varchar(45))
	begin
		select e.CPF "CPF", e.nome "Empregado", e.salario "Salário", 
			e.dataAdm "Data Admissão", ed.cidade "Cidade"
			from empregado e
				inner join endereco ed on ed.Empregado_CPF = e.CPF
					where ed.cidade like cidade;
	end //
delimiter ;

drop procedure empregadoCid;

call empregadoCid("Jabo%");

delimiter //
create procedure relatorioVendas(in inicio date, in fim date)
	begin
		select v.dataVenda "Data", est.nome "Produto", iv.qtdProduto "Quantidade", 
			concat('R$ ', round(est.valor, 2)) "Valor do Produto", 
            concat('R$ ', v.valorTotal) "Valor Total", 
			e.nome "Empregado", d.nome "Departamento"
				from vendas v
					inner join empregado e on e.CPF = v.Empregado_CPF
					inner join trabalhar t on t.Empregado_CPF = e.CPF
					inner join departamento d on d.idDepartamento = t.Departamento_idDepartamento
					inner join itensvenda iv on iv.Vendas_idVendas = v.idVendas
					inner join estoque est on est.idProduto = iv.Estoque_idProduto
						where date_format(v.dataVenda, '%Y-%m-%d') between inicio  and fim
							order by v.dataVenda;
    end //
delimiter ;

call relatorioVendas('2022-06-02', '2022-06-15');


-- BDII - 2ª Exercício de BDII - DQL (Join) --
-- Reletorio 1 --
select e.nome "Empregado", e.CPF "CPF", e.dataAdm "Data Admissão", e.salario "Salário", 
	en.cidade "Cidade", tel.numero "Número de Telefone"
    from empregado e
		inner join endereco en on en.Empregado_CPF = e.cpf
        left join telefone tel on tel.Empregado_CPF = e.cpf
			where e.dataAdm between '2019-01-01' and '2022-04-01'
				order by e.dataAdm desc;
-- Reletorio 2 --
select e.nome "Empregado", e.CPF "CPF", e.dataAdm "Data Admissão", e.salario "Salário", 
	en.cidade "Cidade"
    from empregado e
		inner join endereco en on en.Empregado_CPF = e.cpf
			where e.salario <= (select avg(salario) from empregado)
				order by e.nome;
-- Adeno... --
select e.nome "Empregado", e.CPF "CPF", e.dataAdm "Data Admissão", e.salario "Salário", 
	en.cidade "Cidade"
    from empregado e
		inner join endereco en on en.Empregado_CPF = e.cpf
			where e.CPF in (select Empregado_CPF from dependente)
				order by e.nome;

-- Reletorio 3 --
select e.nome "Empregado", e.CPF "CPF", e.dataAdm "Data Admissão", e.salario "Salário", 
	en.cidade "Cidade", count(d.Empregado_CPF) "Quantidade Dependente"
    from empregado e
		inner join endereco en on en.Empregado_CPF = e.cpf
        left join dependente d on d.Empregado_CPF = e.CPF
			where en.cidade like "Recife"
				group by (e.CPF)
					order by e.nome;

-- Reletorio 4 --
select e.nome "Empregado", e.cpf "CPF", e.sexo "Sexo", e.salario "Salário", 
	count(v.idvendas) "Quantidade Vendas", sum(v.valorTotal) "Total Vendido"
		from vendas v
			inner join empregado e on e.cpf = v.Empregado_CPF
				group by (v.Empregado_CPF)
					order by sum(v.valorTotal) desc;

-- Relatório 5 --
select e.nome "Empregado", e.cpf "CPF", e.salario "Salário", o.nome "Ocupação", 
	telEmp.numero "Telefone do Empregado", d.nome "Departamento", 
    d.localDep"Local do Departamento", telDep.numero "Telefone do Departamento", 
    eg.nome "Gerente"
		from trabalhar t
			inner join empregado e on e.CPF = t.Empregado_CPF
            inner join ocupacao o on o.cbo = t.Ocupacao_cbo
            inner join departamento d on d.idDepartamento = t.Departamento_idDepartamento
            inner join gerente g on g.Empregado_CPF = d.Gerente_Empregado_CPF
            inner join empregado eg on eg.CPF = g.Empregado_CPF
            left join telefone telEmp on telEmp.Empregado_CPF = e.CPF
            left join telefone telDep on telDep.Departamento_idDepartamento = d.idDepartamento
				order by d.nome, e.nome;

-- Relatório 6 --
select d.nome "Departamento", d.localDep "Local Departamento", count(e.cpf) "Total de Empregados",
	eg.nome "Nome do Gerente", telDep.numero "Número do Telefone"
		from trabalhar t 
			inner join empregado e on e.CPF = t.Empregado_CPF
            inner join departamento d on d.idDepartamento = t.Departamento_idDepartamento
            inner join gerente g on g.Empregado_CPF = d.Gerente_Empregado_CPF
            inner join empregado eg on eg.CPF = g.Empregado_CPF
            left join telefone telDep on telDep.Departamento_idDepartamento = d.idDepartamento
				group by d.idDepartamento
					order by d.nome;
-- Relatório 7 --
select fp.tipoPag "Tipo Forma Pagamento", count(v.idVendas) "Quantidade Vendas", 
	concat('R$ ', sum(v.valorTotal)) "Total Vendido"
		from vendas v
			inner join formapag fp on fp.Vendas_idVendas = v.idVendas
				group by fp.tipoPag
					order by count(v.idVendas) desc;

-- Relatório 8 --
select v.dataVenda "Data", est.nome "Produto", iv.qtdProduto "Quantidade", 
	concat('R$ ', round(est.valor, 2)) "Valor do Produto", concat('R$ ', v.valorTotal) "Valor Total", 
    e.nome "Empregado", d.nome "Departamento"
		from vendas v
			inner join empregado e on e.CPF = v.Empregado_CPF
            inner join trabalhar t on t.Empregado_CPF = e.CPF
            inner join departamento d on d.idDepartamento = t.Departamento_idDepartamento
            inner join itensvenda iv on iv.Vendas_idVendas = v.idVendas
            inner join estoque est on est.idProduto = iv.Estoque_idProduto
				where d.nome like "Conv%" or d.nome like "Frente%" 
					order by v.dataVenda;
-- Relatório 9 --
/*create view totalVendasData as select count(v.idVendas) "total" from vendas v group by substring(v.dataVenda, 1, 10);
drop view totalVendasData;
select max(total) from totalVendasData;*/

select substring(v.dataVenda, 1, 10) "Data", count(v.idVendas) "Quantidade Vendas", 
	concat('R$ ', sum(v.valorTotal)) "Total Vendido"
	from vendas v
		group by substring(v.dataVenda, 1, 10);
			-- having count(v.idVendas) = (select max(total) from totalVendasData) --;

-- Relatório 10 --
select est.nome "Produto", concat('R$ ', round(est.valor, 2)) "Valor Produto", 
	est.categoria "Categoria do Produto", f.nome "Nome Fornecedor", f.email "Email Fornecedor",
    tel.numero "Telefone Fornecedor"
    from compras c
		inner join estoque est on est.idProduto = c.Estoque_idProduto
        inner join fornecedor f on f.`cnpj/cpf` = c.`Fornecedor_cnpj/cpf`
        left join telefone tel on tel.`Fornecedor_cnpj/cpf` = f.`cnpj/cpf`
			order by est.nome;

-- Relatório 11 --
select est.nome "Nome Produto", count(iv.Estoque_idProduto) "Quantidade (Total) Vendas"
	from itensvenda iv
		inner join estoque est on iv.Estoque_idProduto = est.idProduto
			group by est.idProduto
				order by count(iv.Estoque_idProduto) desc;

-- Relatório 12 --
select d.nome "Departamento", 
	d.localDep "Local Departamento", 
	eg.nome "Gerente",  
	count(v.idVendas) "Total de Vendas", 
    sum(v.valorTotal) "Valor Total"
		from vendas v
			inner join empregado e on e.CPF = v.Empregado_CPF
            inner join trabalhar t on t.Empregado_CPF = e.CPF
            inner join departamento d on d.idDepartamento = t.Departamento_idDepartamento
            inner join gerente g on g.Empregado_CPF = d.Gerente_Empregado_CPF
            inner join empregado eg on eg.CPF = g.Empregado_CPF
				where d.nome like "Frente%" or d.nome like "Conv%"
					group by d.nome
						order by d.nome;


				
                
	