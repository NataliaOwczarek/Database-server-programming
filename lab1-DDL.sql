--lab 1

--1
--Stworzy� widok vw_studenci_lodzkie w schemacie u�ytkownika stud, kt�rego zadaniem b�dzie zwracanie rekord�w student�w pochodz�cych z wojew�dztwa ��dzkiego. 
--Widok ma udost�pnia� dane z p�l: IdStudenta, Imie, Nazwisko, Miejscowosc, Wojewodztwo.
Create view vw_studenci_lodzkie as
select s.IdStudenta, s.Imie, s.Nazwisko, s.Miejscowosc, w.Wojewodztwo
from stud.tbl_student as s, dict.tbl_wojewodztwo as w
where s.IdWojewodztwa=w.IdWojewodztwa and w.Wojewodztwo='��dzkie';

--2
--Wy�wietli� zawarto�� widoku vw_studenci_lodzkie dbaj�c o to, aby dane uporz�dkowane by�y wg pola IdStudenta.
Select * 
from vw_studenci_lodzkie
order by IdStudenta;

--3
--Zmodyfikowa� widok vw_studenci_lodzkie, w taki spos�b, aby imi� i nazwisko studenta by�o zwracane, jako jedno pole wynikowe o tytule Student. 
--Dodatkowo tworzony widok powinien zawiera� pole: Wiek studenta, kt�rego zadaniem b�dzie szacowanie wieku student�w.
Alter view vw_studenci_lodzkie as
SELECT s.IdStudenta, 
CONCAT(s.Imie, ' ', s.Nazwisko) AS Student, 
s.Miejscowosc,
w.Wojewodztwo,
       YEAR(getdate()) - YEAR(DataUrodzenia) AS 'Wiek studenta'
FROM stud.tbl_student as s, dict.tbl_wojewodztwo as w
where s.IdWojewodztwa=5 and s.IdWojewodztwa=w.IdWojewodztwa;

--4
--Wy�wietli� zawarto�� widoku vw_studenci_lodzkie w taki spos�b, aby dane uporz�dkowane by�y malej�co wg wieku studenta
Select * 
from vw_studenci_lodzkie
order by 'Wiek studenta' desc;

--5
--Utworzy� nowy widok vw_studenci_wg_plci w schemacie u�ytkownika stud, kt�rego zadaniem b�dzie podsumowanie w postaci: zliczenia liczby student�w w 
--poszczeg�lnych wojew�dztwach, z uwzgl�dnieniem podzia�u na p�e� studenta. Ponadto w podsumowaniu nale�y uwzgl�dni� wiek najm�odszego i najstarszego studenta 
--oraz �redni wiek student�w w danej grupie.

Create view vw_studenci_wg_plci as 
select 
w.Wojewodztwo, 
p.Plec,
count(s.IdStudenta) as 'liczba student�w', 
min (YEAR(getdate()) - YEAR(DataUrodzenia)) AS 'Wiek studenta najm�odszego',
max (YEAR(getdate()) - YEAR(DataUrodzenia)) AS 'Wiek studenta najstarszego',
avg (YEAR(getdate()) - YEAR(DataUrodzenia)) AS '�redni wiek studenta'
from stud.tbl_student as s, dict.tbl_wojewodztwo as w, dict.tbl_plec as p 
where s.IdWojewodztwa=w.IdWojewodztwa and s.IdPlci=p.IdPlci
group by w.Wojewodztwo, p.Plec;

--6
--Wy�wietli� zawarto�� widoku vw_studenci_wg_plci.
select *
from vw_studenci_wg_plci;

--7
--Utworzy� nowy widok vw_wojewodztwa w schemacie u�ytkownika dict, kt�rego zadaniem b�dzie zwr�cenie zawarto�ci wszystkich p�l z tabeli tbl_wojewodztwo.
create view vw_wojewodztwa as
select * from dict.tbl_wojewodztwo;

--8
--Wy�wietli� zawarto�� widoku vw_wojewodztwa
select *
from vw_wojewodztwa;

--9
--Zmodyfikowa� definicj� widoku vw_wojewodztwa przez do��czenie do niego nowego pola KodWoj o typie danych char(3).
ALTER TABLE dict.tbl_wojewodztwo 
ADD KodWoj char(3);

--10. 
--Nast�pnie ponownie wy�wietli� zawarto�� widoku vw_wojewodztwa weryfikuj�c czy w zestawie zwracanych wynik�w widoczna jest kolumna KodWoj.
select *
from dict.tbl_wojewodztwo;
--11. 
--Od�wie�y� definicj� widoku vw_wojewodztwa za pomoc� systemowej procedury sk�adowanej sp_refreshview.
Execute sp_refreshview 'vw_wojewodztwa';
--12. 
--Nast�pnie ponownie wy�wietli� zawarto�� widoku vw_wojewodztwa weryfikuj�c czy w zestawie zwracanych wynik�w widoczna jest kolumna KodWoj.
select *
from vw_wojewodztwa;
--13. 
--Wy�wietli� kod tworz�cy widok vw_studenci_lodzkie za pomoc� systemowej procedury sk�adowanej sp_helptext.
Execute sp_helptext 'vw_studenci_lodzkie';
--14. 
--Zmodyfikowa� definicj� widoku vw_studenci_lodzkie w taki spos�b, aby kod go definiuj�cy mia� posta� zaszyfrowan�.
ALTER VIEW vw_studenci_lodzkie
WITH ENCRYPTION
AS
	select 
	[IdStudenta],
	[Student],
	[Miejscowosc],
	[Wojewodztwo],
	[Wiek studenta]
FROM vw_studenci_lodzkie;
GO

--15. 
--Ponownie wy�wietli� kod tworz�cy widok vw_studenci_lodzkie za pomoc� systemowej procedury sk�adowanej sp_helptext
Execute sp_helptext 'vw_studenci_lodzkie';
--16. 
--Zmodyfikowa� definicj� widoku vw_studenci_lodzkie w taki spos�b, aby kod go definiuj�cy mia� posta� odszyfrowan�.
ALTER VIEW vw_studenci_lodzkie AS
SELECT IdStudenta, Imie, Nazwisko, Miejscowosc, Wojewodztwo
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = '��dzkie';

--17. 
--Ponownie wy�wietli� kod tworz�cy widok stud.vw_studenci_lodzkie za pomoc� systemowej procedury sk�adowanej sp_helptext.
Execute sp_helptext 'vw_studenci_lodzkie';

--18. 
--W schemacie u�ytkownika stud utworzy� 5 tabel: tbl_studenci_dolnoslaskie, tbl_studenci_opolskie, tbl_studenci_slaskie, tbl_studenci_swietokrzyskie, 
--tbl_studenci_malopolskie, tbl_studenci_podkarpackiekie i wype�ni� je zawarto�ci�. W tym celu pos�u�y� si� instrukcj� wybieraj�c� SELECT INTO.
SELECT [IdStudenta],
	[Imie],
	[Nazwisko],
	[Adres],
	[KodPocztowy],
	[Miejscowosc],
	[DataUrodzenia],
	[MiejscowoscUrodzenia],
	[DataRozpoczeciaStudiow],
	[DataZakonczeniaStudiow],
	[Pesel],
	[Telefon],
	[TelefonKomorkowy],
	[Email],
	[IdPlci], [Wojewodztwo]
INTO stud.tbl_studenci_dolnoslaskie
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Dolno�l�skie';

SELECT [IdStudenta],
	[Imie],
	[Nazwisko],
	[Adres],
	[KodPocztowy],
	[Miejscowosc],
	[DataUrodzenia],
	[MiejscowoscUrodzenia],
	[DataRozpoczeciaStudiow],
	[DataZakonczeniaStudiow],
	[Pesel],
	[Telefon],
	[TelefonKomorkowy],
	[Email],
	[IdPlci], [Wojewodztwo]
INTO stud.tbl_studenci_opolskie
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Opolskie';


SELECT [IdStudenta],
	[Imie],
	[Nazwisko],
	[Adres],
	[KodPocztowy],
	[Miejscowosc],
	[DataUrodzenia],
	[MiejscowoscUrodzenia],
	[DataRozpoczeciaStudiow],
	[DataZakonczeniaStudiow],
	[Pesel],
	[Telefon],
	[TelefonKomorkowy],
	[Email],
	[IdPlci], [Wojewodztwo]
INTO stud.tbl_studenci_swietokrzyskie
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = '�wi�tokrzyskie'; 
SELECT [IdStudenta],
	[Imie],
	[Nazwisko],
	[Adres],
	[KodPocztowy],
	[Miejscowosc],
	[DataUrodzenia],
	[MiejscowoscUrodzenia],
	[DataRozpoczeciaStudiow],
	[DataZakonczeniaStudiow],
	[Pesel],
	[Telefon],
	[TelefonKomorkowy],
	[Email],
	[IdPlci], [Wojewodztwo]
INTO stud.tbl_studenci_malopolskie
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Ma�opolskie';
SELECT [IdStudenta],
	[Imie],
	[Nazwisko],
	[Adres],
	[KodPocztowy],
	[Miejscowosc],
	[DataUrodzenia],
	[MiejscowoscUrodzenia],
	[DataRozpoczeciaStudiow],
	[DataZakonczeniaStudiow],
	[Pesel],
	[Telefon],
	[TelefonKomorkowy],
	[Email],
	[IdPlci], [Wojewodztwo]
INTO stud.tbl_studenci_slaskie
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = '�l�skie'; 

SELECT [IdStudenta],
	[Imie],
	[Nazwisko],
	[Adres],
	[KodPocztowy],
	[Miejscowosc],
	[DataUrodzenia],
	[MiejscowoscUrodzenia],
	[DataRozpoczeciaStudiow],
	[DataZakonczeniaStudiow],
	[Pesel],
	[Telefon],
	[TelefonKomorkowy],
	[Email],
	[IdPlci], [Wojewodztwo]
INTO stud.tbl_studenci_podkarpackie
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Podkarpackie';


--19. 
--Utworzy� w schemacie u�ytkownika stud, lokalny partycjonowany widok (widok dzielony) vw_studenci_gory. 
--Widok ma zwraca� dane w postaci p�l: IdStudenta, Student (po��czenie zawarto�ci p�l Imie i Nazwisko), Miejscowosc, Wojewodztwo. 
--Dane pochodz� z tabel utworzonych w poprzednim punkcie.
CREATE VIEW vw_studenci_gory AS
SELECT IdStudenta, concat(Imie,' ', Nazwisko) Student, Miejscowosc, Wojewodztwo
FROM stud.tbl_studenci_dolnoslaskie
UNION
SELECT IdStudenta,concat(Imie,' ', Nazwisko) Student, Miejscowosc, Wojewodztwo
FROM stud.tbl_studenci_opolskie
UNION
SELECT IdStudenta, concat(Imie,' ', Nazwisko) Student, Miejscowosc, Wojewodztwo
FROM stud.tbl_studenci_podkarpackie
UNION
SELECT IdStudenta, concat(Imie,' ', Nazwisko) Student, Miejscowosc, Wojewodztwo
FROM stud.tbl_studenci_swietokrzyskie
UNION
SELECT IdStudenta,concat(Imie,' ', Nazwisko) Student, Miejscowosc, Wojewodztwo
FROM stud.tbl_studenci_malopolskie;


--20. 
--Wy�wietli� zawarto�� lokalnego widoku dzielonego vw_studenci_gory. Zwracane dane powinny by� uporz�dkowane rosn�co wg p�l Wojewodztwo oraz IdStudenta.
select *
from vw_studenci_gory
order by Wojewodztwo, IdStudenta;

--21. 
--Utworzy� w schemacie u�ytkownika stud widok vw_studenci_wg_plci_indeks. Zadaniem widoku jest zliczenie student�w wzgl�dem p�ci 
--w poszczeg�lnych wojew�dztwach. W definicji widoku nale�y pos�u�y� si� klauzul� WITH SCHEMABINDING. Dane grupowane s� wg wojew�dztw oraz symbolu p�ci.
create view vw_studenci_wg_plci_indeks 
WITH SCHEMABINDING as
select count_big(*) as 'liczba student�w', w.Wojewodztwo, SymbolPlci
from stud.tbl_student as s, dict.tbl_plec as p,dict.tbl_wojewodztwo as w
where s.IdWojewodztwa=w.IdWojewodztwa and s.IdPlci=p.IdPlci 
group by Wojewodztwo, SymbolPlci;

--22. 
--Nast�pnie na widoku vw_studenci_wg_plci_indeks utworzy� z�o�ony indeks klastrowy idx_uc_woj na polach: Wojewodztwo, SymbolPlci, 
--tworz�c tym samym widok zmaterializowany.
create unique clustered index idx_uc_woj on vw_studenci_wg_plci_indeks(Wojewodztwo,SymbolPlci);

--23. 
--Wy�wietli� zawarto�� indeksowanego widoku vw_studenci_wg_plci_indeks.
select *
from vw_studenci_wg_plci_indeks;

--24. 
--Utworzy� w schemacie u�ytkownika stud widok vw_studenci_wg_plci_statystyka1. Zadaniem widoku jest wielopoziomowe podsumowanie danych. 
--Widok ma zwraca� nast�puj�ce dane: Wojewodztwo, SymbolPlci, Liczba student�w wg plci, Srednia liczba os�b danej p�ci na wojew�dztwo. 
--Warto�� dw�ch ostatnich p�l nale�y oszacowa� wewn�trz zapytania. Poni�ej przedstawiono przyk�adowy zestaw wynik�w zwracanych przez zapytanie.
create view vw_studenci_wg_plci_statystyka1 as 
select w.Wojewodztwo, p.SymbolPlci, cast(COUNT_BIG(p.SymbolPlci) as int) as 'Liczba student�w wg p�ci', 
AVG(CAST(COUNT(*) AS FLOAT)) OVER(PARTITION BY w.wojewodztwo, p.SymbolPlci)
as '�rednia liczba os�b danej p�ci na wojew�dztwo'
from stud.tbl_student as s inner join dict.tbl_wojewodztwo as w
on s.IdWojewodztwa=w.IdWojewodztwa
inner join dict.tbl_plec as p on s.IdPlci=p.IdPlci
group by w.Wojewodztwo, p.SymbolPlci;
--create view vw_studenci_wg_plci_statystyka1 as 
--select w.Wojewodztwo, p.SymbolPlci, cast(COUNT_BIG(p.SymbolPlci) as int) as 'Liczba student�w wg p�ci', 
--case
--	p.SymbolPlci when 'K' then (select COUNT_BIG(IdStudenta) from stud.tbl_student where IdPlci=1)/(select count_big(IdWojewodztwa) from dict.tbl_wojewodztwo) 
--	when 'M' then ((select COUNT_BIG(IdStudenta) from stud.tbl_student where IdPlci=2)/(select count_big(IdWojewodztwa) from dict.tbl_wojewodztwo))
--	else ((select COUNT_BIG(*) from stud.tbl_student)/(select count_big(IdWojewodztwa) from dict.tbl_wojewodztwo))
--end

--as '�rednia liczba os�b danej p�ci na wojew�dztwo'
--from stud.tbl_student as s inner join dict.tbl_wojewodztwo as w
--on s.IdWojewodztwa=w.IdWojewodztwa
--inner join dict.tbl_plec as p on s.IdPlci=p.IdPlci
--group by w.Wojewodztwo, p.SymbolPlci;

--25. Wy�wietli� zawarto�� widoku vw_studenci_wg_plci_statystyka1.
select *
from vw_studenci_wg_plci_statystyka1;

--26. Utworzy� w schemacie u�ytkownika stud nowy widok vw_studenci_wg_plci_statystyka2. Jako �r�d�o danych nale�y wykorzysta� widok z poprzedniego 
--punktu. Widok powinien dodatkowo zawiera� dwa dodatkowe pola: Opis i Procent. Pole opis powinno zwraca� informacj� w postaci: > od �redniej o 
--liczb� 194. Pole procent powinno szacowa� warto�� procentow� liczby student�w danej p�ci do �redniej liczby student�w danej p�ci, 
--w danym wojew�dztwie.

CREATE VIEW vw_studenci_wg_plci_statystyka2 AS
SELECT 
    s.wojewodztwo, 
    s.SymbolPlci, 
    s.[Liczba student�w wg p�ci],
    CASE 
        WHEN s.[Liczba student�w wg p�ci] > avg(s.[Liczba student�w wg p�ci]) OVER(PARTITION BY s.SymbolPlci, s.wojewodztwo) 
            THEN '> od �redniej o '+ CAST(s.[Liczba student�w wg p�ci] - avg(s.[Liczba student�w wg p�ci]) OVER(PARTITION BY s.SymbolPlci, s.wojewodztwo) AS VARCHAR) 
        ELSE '<= �redniej'
    END AS opis,
    ROUND(100 * s.[Liczba student�w wg p�ci] / sum(s.[Liczba student�w wg p�ci]) OVER(PARTITION BY s.SymbolPlci, s.wojewodztwo), 2) AS procent
FROM vw_studenci_wg_plci_statystyka1 s;

--27. Wy�wietli� zawarto�� widoku vw_studenci_wg_plci_statystyka2.
select *
from vw_studenci_wg_plci_statystyka2;

--28. Utworzy� w schemacie u�ytkownika stud nowy widok vw_studenci_wg_plci_statystyka3 w oparciu o definicj� widoku vw_studenci_wg_plci_statystyka2.
--Widok dodatkowo powinien uwzgl�dnia� kolumn�: Procent ca�kowitej populacji p�ci, zawieraj�c� udzia� procentowy kobiet, m�czyzn z poszczeg�lnych 
--wojew�dztw w odniesieniu do ca�ej populacji kobiet i m�czyzn w Polsce, a tak�e udzia� procentowy wszystkich student�w z terenu poszczeg�lnych 
--wojew�dztw (bez wzgl�du na p�e�) w odniesieniu do ca�kowitej populacji student�w w Polsce.

--29. Wy�wietli� zawarto�� widoku vw_studenci_wg_plci_statystyka3.
select *
from vw_studenci_wg_plci_statystyka3;

--30. Usun�� z bazy danych SZBD2022 wszystkie utworzone widoki za pomoc� pojedynczej instrukcji.
DROP VIEW IF EXISTS vw_studenci_wg_plci_statystyka1, vw_studenci_wg_plci_statystyka2, vw_studenci_wg_plci_statystyka3;