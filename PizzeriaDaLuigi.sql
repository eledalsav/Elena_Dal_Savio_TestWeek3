create database PizzeriaDaLuigi

create table Pizza(
IdPizza int identity(1,1),
NomePizza nvarchar(20) not null,
PrezzoPizza decimal not null
constraint PK_Pizza primary key (IdPizza),
constraint Chk_CostoPizza check(PrezzoPizza>0),

);


create table Ingrediente(
IdIngrediente int identity(1,1),
NomeIngrediente nvarchar(30) not null,
PrezzoIngrediente decimal not null,
ScorteIngrediente int,
constraint PK_Ingrediente primary key (IdIngrediente),
constraint Chk_CostoIngrediente check(PrezzoIngrediente>0),
constraint Chk_Scorte check(ScorteIngrediente >=0)


);


Create table PizzaIngrediente(
IdPizza int not null,
IdIngrediente int not null,
constraint FK_Pizza foreign key (IdPizza) references Pizza(IdPizza),
constraint FK_Ingrediente foreign key (IdIngrediente) references Ingrediente(IdIngrediente),
constraint PK_PizzaIngrediente primary key (IdPizza,IdIngrediente)


);



INSERT INTO Pizza VALUES ('Margherita', 5)
INSERT INTO Pizza VALUES ('Bufala', 7)
INSERT INTO Pizza VALUES ('Diavola', 6)
INSERT INTO Pizza VALUES ('Quattro stagioni', 6.5)
INSERT INTO Pizza VALUES ('Porcini', 7)
INSERT INTO Pizza VALUES ('Dionisio', 8)
INSERT INTO Pizza VALUES ('Ortolana', 8)
INSERT INTO Pizza VALUES ('Patate e salsiccia', 6)
INSERT INTO Pizza VALUES ('Pomodorini', 6)
INSERT INTO Pizza VALUES ('Quattro formaggi', 7.5)
INSERT INTO Pizza VALUES ('Caprese', 7.5)
INSERT INTO Pizza VALUES ('Zeus', 7.5)

INSERT INTO Ingrediente VALUES('Pomodoro',0.5,50)
INSERT INTO Ingrediente VALUES('Mozzarella',0.5,80)
INSERT INTO Ingrediente VALUES('Mozzarella di bufala',0.5,30)
INSERT INTO Ingrediente VALUES('Spianata piccante',0.5,10)
INSERT INTO Ingrediente VALUES('Funghi',0.5,20)
INSERT INTO Ingrediente VALUES('Carciofi',0.5,20)
INSERT INTO Ingrediente VALUES('Cotto',0.5,30)
INSERT INTO Ingrediente VALUES('Olive',0.5,20)
INSERT INTO Ingrediente VALUES('Funghi porcini',0.5,20)
INSERT INTO Ingrediente VALUES('Speck',0.5,30)
INSERT INTO Ingrediente VALUES('Rucola',0.5,20)
INSERT INTO Ingrediente VALUES('Stracchino',0.5,15)
INSERT INTO Ingrediente VALUES('Grana',0.5,60)
INSERT INTO Ingrediente VALUES('Verdure di stagione',0.5,40)
INSERT INTO Ingrediente VALUES('Patate',0.5,20)
INSERT INTO Ingrediente VALUES('Salsiccia',0.5,20)
INSERT INTO Ingrediente VALUES('Ricotta',0.5,20)
INSERT INTO Ingrediente VALUES('Provola',0.5,15)
INSERT INTO Ingrediente VALUES('Gorgonzola',0.5,15)
INSERT INTO Ingrediente VALUES('Pomodoro fresco',0.5,30)
INSERT INTO Ingrediente VALUES('Basilico',0.5,15)
INSERT INTO Ingrediente VALUES('Bresaola',0.5,15)

SELECT * from Pizza;
SELECT * from Ingrediente;


INSERT INTO PizzaIngrediente VALUES(2,1);
INSERT INTO PizzaIngrediente VALUES(2,2);
INSERT INTO PizzaIngrediente VALUES(3,1);
INSERT INTO PizzaIngrediente VALUES(3,3);
INSERT INTO PizzaIngrediente VALUES(4,1);
INSERT INTO PizzaIngrediente VALUES(4,2);
INSERT INTO PizzaIngrediente VALUES(4,4);
INSERT INTO PizzaIngrediente VALUES(5,1);
INSERT INTO PizzaIngrediente VALUES(5,2);
INSERT INTO PizzaIngrediente VALUES(5,5);
INSERT INTO PizzaIngrediente VALUES(5,6);
INSERT INTO PizzaIngrediente VALUES(5,7);
INSERT INTO PizzaIngrediente VALUES(5,8);
INSERT INTO PizzaIngrediente VALUES(6,1);
INSERT INTO PizzaIngrediente VALUES(6,2);
INSERT INTO PizzaIngrediente VALUES(6,9);
INSERT INTO PizzaIngrediente VALUES(7,1);
INSERT INTO PizzaIngrediente VALUES(7,2);
INSERT INTO PizzaIngrediente VALUES(7,12);
INSERT INTO PizzaIngrediente VALUES(7,10);
INSERT INTO PizzaIngrediente VALUES(7,11);
INSERT INTO PizzaIngrediente VALUES(7,13);
INSERT INTO PizzaIngrediente VALUES(8,1);
INSERT INTO PizzaIngrediente VALUES(8,2);
INSERT INTO PizzaIngrediente VALUES(8,14);
INSERT INTO PizzaIngrediente VALUES(9,2);
INSERT INTO PizzaIngrediente VALUES(9,15);
INSERT INTO PizzaIngrediente VALUES(9,16);
INSERT INTO PizzaIngrediente VALUES(10,2);
INSERT INTO PizzaIngrediente VALUES(10,20);
INSERT INTO PizzaIngrediente VALUES(10,17);
INSERT INTO PizzaIngrediente VALUES(11,2);
INSERT INTO PizzaIngrediente VALUES(11,18);
INSERT INTO PizzaIngrediente VALUES(11,19);
INSERT INTO PizzaIngrediente VALUES(11,13);
INSERT INTO PizzaIngrediente VALUES(12,2);
INSERT INTO PizzaIngrediente VALUES(12,20);
INSERT INTO PizzaIngrediente VALUES(12,21);
INSERT INTO PizzaIngrediente VALUES(13,2);
INSERT INTO PizzaIngrediente VALUES(13,22);
INSERT INTO PizzaIngrediente VALUES(13,11);

select * from PizzaIngrediente;


--Estrarre tutte le pizze con prezzo superiore a 6 euro
select distinct NomePizza, PrezzoPizza
from Pizza
where PrezzoPizza>6;


--Estrarre la pizza/le pizze più costosa/
select p.NomePizza, p.PrezzoPizza
from Pizza p 
where p.PrezzoPizza = (select max(q.PrezzoPizza)
						from Pizza q);


--Estrarre le pizze «bianche»
select p.NomePizza
from Pizza p join PizzaIngrediente a on a.IdPizza=p.IdPizza
						join Ingrediente i on a.IdIngrediente=i.IdIngrediente
where i.IdIngrediente not in (select i.IdIngrediente
								from Pizza p join PizzaIngrediente a on a.IdPizza=p.IdPizza
														join Ingrediente i on a.IdIngrediente=i.IdIngrediente
								where i.IdIngrediente=1);


--Estrarre le pizze che contengono funghi (di qualsiasi tipo)
select p.NomePizza
from PizzaIngrediente a join Pizza p on a.IdPizza=p.IdPizza
						join Ingrediente i on a.IdIngrediente=i.IdIngrediente
where i.IdIngrediente=5 or i.IdIngrediente=9;
						

--Inserimento di una nuova pizza (parametri: nome, prezzo)
go
create procedure InserisciPizza
@NomePizza nvarchar(30),
@PrezzoPizza decimal
as
insert into Pizza values(@NomePizza,@PrezzoPizza);
go
execute InserisciPizza'Wurstel', 7;
select * from Pizza;


--Assegnazione di un ingrediente a una pizza (parametri: nome pizza, nome ingrediente)
go
create procedure InserisciIngredientePizza
@Nomepizza nvarchar(30),
@NomeIngrediente nvarchar(30)
as
declare @ID_PIZZA int
select @ID_PIZZA=IdPizza from Pizza where NomePizza=@Nomepizza
declare @ID_INGREDIENTE int
select @ID_INGREDIENTE=IdIngrediente from Ingrediente where NomeIngrediente=@NomeIngrediente
insert into PizzaIngrediente values(@ID_PIZZA,@ID_INGREDIENTE);
go

execute InserisciIngredientePizza'Wurstel', 'Pomodoro';
select * from PizzaIngrediente;


--Aggiornamento del prezzo di una pizza (parametri: nome pizza e nuovo prezzo)
go
create procedure AggiornaPrezzoPizza
@NomePizza nvarchar(30),
@NuovPrezzo decimal
as 
declare @ID_PIZZA int
select @ID_PIZZA=IdPizza from Pizza where NomePizza=@NomePizza
begin
update Pizza
set PrezzoPizza=@NuovPrezzo
where Pizza.IdPizza=@ID_PIZZA
end;
insert into Pizza values (@NomePizza, @NuovPrezzo);
go
execute AggiornaPrezzoPizza 'Pugliese',9;
select * from Pizza;


--Eliminazione di un ingrediente da una pizza (parametri: nome pizza, nome ingrediente)
go
create procedure EliminazioneIngrediente
@NomePizza nvarchar(30),
@NomeIngrediente nvarchar(30)
as
begin 
declare @ID_PIZZA int
select @ID_PIZZA=IdPizza
from Pizza where NomePizza=@NomePizza;

declare @ID_INGREDIENTE int
select @ID_INGREDIENTE=IdIngrediente
from Ingrediente where NomeIngrediente=@NomeIngrediente;

delete from PizzaIngrediente where IdPizza=@ID_PIZZA and IdIngrediente=@ID_INGREDIENTE;
end
go
execute EliminazioneIngrediente'Pugliese','Pomodoro';
select* from PizzaIngrediente;

--Incremento del 10% del prezzo delle pizze contenenti un ingrediente (parametro: nome ingrediente)
go
create procedure IncrementaPrezzoPizza4
@NomeIngrediente nvarchar(30)
as
declare @PrezzoPizza decimal
select p.PrezzoPizza from Pizza p where p.IdPizza=(
select a.IdPizza from PizzaIngrediente a join Ingrediente i on a.IdIngrediente=i.IdIngrediente
where i.NomeIngrediente=@NomeIngrediente);
begin
			set @PrezzoPizza += (@PrezzoPizza/10);
end
update Pizza set PrezzoPizza=@PrezzoPizza;
go
execute IncrementaPrezzoPizza4'Mozzarella di bufala';
select * from Pizza;--Non va a buon fine


--Tabella listino pizze (nome, prezzo) (parametri: nessuno)
go
create function ListinoPizze()
returns table

AS
return
select p.NomePizza, p.PrezzoPizza
from Pizza p;
go

select * from ListinoPizze();

--Tabella listino pizze (nome, prezzo) contenenti un ingrediente (parametri: nome ingrediente)
go
create function ListinoPizzaIngrediente4(@NomeIngrediente nvarchar(30))
returns table
as
return
select p.NomePizza, p.PrezzoPizza
from Pizza p
where p.IdPizza=any(select a.IdPizza
				from PizzaIngrediente a join Ingrediente i on i.IdIngrediente=a.IdIngrediente
				where i.NomeIngrediente=@NomeIngrediente);
go

select * from ListinoPizzaIngrediente4('Mozzarella');


--Tabella listino pizze (nome, prezzo) che non contengono un certo ingrediente(parametri: nome ingrediente
go
create function ListinoPizzaSenzaIngrediente3(@NomeIngrediente nvarchar(30))
returns table
as
return
select p.NomePizza, p.PrezzoPizza
from Pizza p
where p.IdPizza not in(select a.IdPizza
				from PizzaIngrediente a join Ingrediente i on i.IdIngrediente=a.IdIngrediente
				where i.NomeIngrediente=@NomeIngrediente);
go

select * from ListinoPizzaSenzaIngrediente3('Mozzarella');



--Calcolo numero pizze contenenti un ingrediente (parametri: nome ingrediente)
go
create function NumeroPizzeConIngrediente(@NomeIngrediente nvarchar(30))
returns int
as
begin
declare @NumeroPizze int
select @NumeroPizze=COUNT(*)
from  PizzaIngrediente a join Pizza p on a.IdPizza=p.IdPizza
						join Ingrediente i on a.IdIngrediente=i.IdIngrediente
where i.NomeIngrediente=@NomeIngrediente;
return @NumeroPizze
end;
go
select dbo.NumeroPizzeConIngrediente('Mozzarella') as [numero di pizze con la mozzarella:];


--Calcolo numero pizze che non contengono un ingrediente (parametri: codice ingrediente)
go
create function NumeroPizzeSenzaIngrediente2(@NomeIngrediente nvarchar(30))
returns int
as
begin
declare @NumeroPizze int
select @NumeroPizze=COUNT(*)
from Pizza p
where p.IdPizza not in(select a.IdPizza
				from PizzaIngrediente a join Ingrediente i on i.IdIngrediente=a.IdIngrediente
				where i.NomeIngrediente=@NomeIngrediente);
return @NumeroPizze
end;
go
select dbo.NumeroPizzeSenzaIngrediente2('Mozzarella') as [numero di pizze senza mozzarella:];


--Calcolo numero ingredienti contenuti in una pizza (parametri: nome pizza)
go
create function NumeroIngredientiInPizza(@NomePizza nvarchar(30))
returns int
as
begin
declare @NumeroIngredienti int
select @NumeroIngredienti=COUNT(*)
from  PizzaIngrediente a join Pizza p on a.IdPizza=p.IdPizza
						join Ingrediente i on a.IdIngrediente=i.IdIngrediente
where p.NomePizza=@NomePizza;
return @NumeroIngredienti
end;
go

select dbo.NumeroIngredientiInPizza('Quattro formaggi') as [numero di ingredienti contenuti in questa pizza:];



--Realizzare una view che rappresenta il menù con tutte le pizze.
go
create view MenùPizze (Pizza, Prezzo)
AS(
select p.NomePizza, p.PrezzoPizza
from Pizza p
);
go
select * from MenùPizze;


