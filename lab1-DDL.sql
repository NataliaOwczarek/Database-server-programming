--lab 1

--1
--Stworzyæ widok vw_studenci_lodzkie w schemacie u¿ytkownika stud, którego zadaniem bêdzie zwracanie rekordów studentów pochodz¹cych z województwa ³ódzkiego. 
--Widok ma udostêpniaæ dane z pól: IdStudenta, Imie, Nazwisko, Miejscowosc, Wojewodztwo.
Create view vw_studenci_lodzkie as
select s.IdStudenta, s.Imie, s.Nazwisko, s.Miejscowosc, w.Wojewodztwo
from stud.tbl_student as s, dict.tbl_wojewodztwo as w
where s.IdWojewodztwa=w.IdWojewodztwa and w.Wojewodztwo='£ódzkie';

--2
--Wyœwietliæ zawartoœæ widoku vw_studenci_lodzkie dbaj¹c o to, aby dane uporz¹dkowane by³y wg pola IdStudenta.
Select * 
from vw_studenci_lodzkie
order by IdStudenta;

--3
--Zmodyfikowaæ widok vw_studenci_lodzkie, w taki sposób, aby imiê i nazwisko studenta by³o zwracane, jako jedno pole wynikowe o tytule Student. 
--Dodatkowo tworzony widok powinien zawieraæ pole: Wiek studenta, którego zadaniem bêdzie szacowanie wieku studentów.
Alter view vw_studenci_lodzkie as
SELECT s.IdStudenta, 
CONCAT(s.Imie, ' ', s.Nazwisko) AS Student, 
s.Miejscowosc,
w.Wojewodztwo,
       YEAR(getdate()) - YEAR(DataUrodzenia) AS 'Wiek studenta'
FROM stud.tbl_student as s, dict.tbl_wojewodztwo as w
where s.IdWojewodztwa=5 and s.IdWojewodztwa=w.IdWojewodztwa;

--4
--Wyœwietliæ zawartoœæ widoku vw_studenci_lodzkie w taki sposób, aby dane uporz¹dkowane by³y malej¹co wg wieku studenta
Select * 
from vw_studenci_lodzkie
order by 'Wiek studenta' desc;

--5
--Utworzyæ nowy widok vw_studenci_wg_plci w schemacie u¿ytkownika stud, którego zadaniem bêdzie podsumowanie w postaci: zliczenia liczby studentów w 
--poszczególnych województwach, z uwzglêdnieniem podzia³u na p³eæ studenta. Ponadto w podsumowaniu nale¿y uwzglêdniæ wiek najm³odszego i najstarszego studenta 
--oraz œredni wiek studentów w danej grupie.

Create view vw_studenci_wg_plci as 
select 
w.Wojewodztwo, 
p.Plec,
count(s.IdStudenta) as 'liczba studentów', 
min (YEAR(getdate()) - YEAR(DataUrodzenia)) AS 'Wiek studenta najm³odszego',
max (YEAR(getdate()) - YEAR(DataUrodzenia)) AS 'Wiek studenta najstarszego',
avg (YEAR(getdate()) - YEAR(DataUrodzenia)) AS 'œredni wiek studenta'
from stud.tbl_student as s, dict.tbl_wojewodztwo as w, dict.tbl_plec as p 
where s.IdWojewodztwa=w.IdWojewodztwa and s.IdPlci=p.IdPlci
group by w.Wojewodztwo, p.Plec;

--6
--Wyœwietliæ zawartoœæ widoku vw_studenci_wg_plci.
select *
from vw_studenci_wg_plci;

--7
--Utworzyæ nowy widok vw_wojewodztwa w schemacie u¿ytkownika dict, którego zadaniem bêdzie zwrócenie zawartoœci wszystkich pól z tabeli tbl_wojewodztwo.
create view vw_wojewodztwa as
select * from dict.tbl_wojewodztwo;

--8
--Wyœwietliæ zawartoœæ widoku vw_wojewodztwa
select *
from vw_wojewodztwa;

--9
--Zmodyfikowaæ definicjê widoku vw_wojewodztwa przez do³¹czenie do niego nowego pola KodWoj o typie danych char(3).
ALTER TABLE dict.tbl_wojewodztwo 
ADD KodWoj char(3);

--10. 
--Nastêpnie ponownie wyœwietliæ zawartoœæ widoku vw_wojewodztwa weryfikuj¹c czy w zestawie zwracanych wyników widoczna jest kolumna KodWoj.
select *
from dict.tbl_wojewodztwo;
--11. 
--Odœwie¿yæ definicjê widoku vw_wojewodztwa za pomoc¹ systemowej procedury sk³adowanej sp_refreshview.
Execute sp_refreshview 'vw_wojewodztwa';
--12. 
--Nastêpnie ponownie wyœwietliæ zawartoœæ widoku vw_wojewodztwa weryfikuj¹c czy w zestawie zwracanych wyników widoczna jest kolumna KodWoj.
select *
from vw_wojewodztwa;
--13. 
--Wyœwietliæ kod tworz¹cy widok vw_studenci_lodzkie za pomoc¹ systemowej procedury sk³adowanej sp_helptext.
Execute sp_helptext 'vw_studenci_lodzkie';
--14. 
--Zmodyfikowaæ definicjê widoku vw_studenci_lodzkie w taki sposób, aby kod go definiuj¹cy mia³ postaæ zaszyfrowan¹.
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
--Ponownie wyœwietliæ kod tworz¹cy widok vw_studenci_lodzkie za pomoc¹ systemowej procedury sk³adowanej sp_helptext
Execute sp_helptext 'vw_studenci_lodzkie';
--16. 
--Zmodyfikowaæ definicjê widoku vw_studenci_lodzkie w taki sposób, aby kod go definiuj¹cy mia³ postaæ odszyfrowan¹.
ALTER VIEW vw_studenci_lodzkie AS
SELECT IdStudenta, Imie, Nazwisko, Miejscowosc, Wojewodztwo
FROM stud.tbl_student
	INNER JOIN dict.tbl_wojewodztwo
	ON stud.tbl_student.IdWojewodztwa = dict.tbl_wojewodztwo.IdWojewodztwa
WHERE dict.tbl_wojewodztwo.Wojewodztwo = '£ódzkie';

--17. 
--Ponownie wyœwietliæ kod tworz¹cy widok stud.vw_studenci_lodzkie za pomoc¹ systemowej procedury sk³adowanej sp_helptext.
Execute sp_helptext 'vw_studenci_lodzkie';

--18. 
--W schemacie u¿ytkownika stud utworzyæ 5 tabel: tbl_studenci_dolnoslaskie, tbl_studenci_opolskie, tbl_studenci_slaskie, tbl_studenci_swietokrzyskie, 
--tbl_studenci_malopolskie, tbl_studenci_podkarpackiekie i wype³niæ je zawartoœci¹. W tym celu pos³u¿yæ siê instrukcj¹ wybieraj¹c¹ SELECT INTO.
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
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Dolnoœl¹skie';

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
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Œwiêtokrzyskie'; 
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
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Ma³opolskie';
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
WHERE dict.tbl_wojewodztwo.Wojewodztwo = 'Œl¹skie'; 

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
--Utworzyæ w schemacie u¿ytkownika stud, lokalny partycjonowany widok (widok dzielony) vw_studenci_gory. 
--Widok ma zwracaæ dane w postaci pól: IdStudenta, Student (po³¹czenie zawartoœci pól Imie i Nazwisko), Miejscowosc, Wojewodztwo. 
--Dane pochodz¹ z tabel utworzonych w poprzednim punkcie.
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
--Wyœwietliæ zawartoœæ lokalnego widoku dzielonego vw_studenci_gory. Zwracane dane powinny byæ uporz¹dkowane rosn¹co wg pól Wojewodztwo oraz IdStudenta.
select *
from vw_studenci_gory
order by Wojewodztwo, IdStudenta;

--21. 
--Utworzyæ w schemacie u¿ytkownika stud widok vw_studenci_wg_plci_indeks. Zadaniem widoku jest zliczenie studentów wzglêdem p³ci 
--w poszczególnych województwach. W definicji widoku nale¿y pos³u¿yæ siê klauzul¹ WITH SCHEMABINDING. Dane grupowane s¹ wg województw oraz symbolu p³ci.
create view vw_studenci_wg_plci_indeks 
WITH SCHEMABINDING as
select count_big(*) as 'liczba studentów', w.Wojewodztwo, SymbolPlci
from stud.tbl_student as s, dict.tbl_plec as p,dict.tbl_wojewodztwo as w
where s.IdWojewodztwa=w.IdWojewodztwa and s.IdPlci=p.IdPlci 
group by Wojewodztwo, SymbolPlci;

--22. 
--Nastêpnie na widoku vw_studenci_wg_plci_indeks utworzyæ z³o¿ony indeks klastrowy idx_uc_woj na polach: Wojewodztwo, SymbolPlci, 
--tworz¹c tym samym widok zmaterializowany.
create unique clustered index idx_uc_woj on vw_studenci_wg_plci_indeks(Wojewodztwo,SymbolPlci);

--23. 
--Wyœwietliæ zawartoœæ indeksowanego widoku vw_studenci_wg_plci_indeks.
select *
from vw_studenci_wg_plci_indeks;

--24. 
--Utworzyæ w schemacie u¿ytkownika stud widok vw_studenci_wg_plci_statystyka1. Zadaniem widoku jest wielopoziomowe podsumowanie danych. 
--Widok ma zwracaæ nastêpuj¹ce dane: Wojewodztwo, SymbolPlci, Liczba studentów wg plci, Srednia liczba osób danej p³ci na województwo. 
--Wartoœæ dwóch ostatnich pól nale¿y oszacowaæ wewn¹trz zapytania. Poni¿ej przedstawiono przyk³adowy zestaw wyników zwracanych przez zapytanie.
create view vw_studenci_wg_plci_statystyka1 as 
select w.Wojewodztwo, p.SymbolPlci, cast(COUNT_BIG(p.SymbolPlci) as int) as 'Liczba studentów wg p³ci', 
AVG(CAST(COUNT(*) AS FLOAT)) OVER(PARTITION BY w.wojewodztwo, p.SymbolPlci)
as 'œrednia liczba osób danej p³ci na województwo'
from stud.tbl_student as s inner join dict.tbl_wojewodztwo as w
on s.IdWojewodztwa=w.IdWojewodztwa
inner join dict.tbl_plec as p on s.IdPlci=p.IdPlci
group by w.Wojewodztwo, p.SymbolPlci;
--create view vw_studenci_wg_plci_statystyka1 as 
--select w.Wojewodztwo, p.SymbolPlci, cast(COUNT_BIG(p.SymbolPlci) as int) as 'Liczba studentów wg p³ci', 
--case
--	p.SymbolPlci when 'K' then (select COUNT_BIG(IdStudenta) from stud.tbl_student where IdPlci=1)/(select count_big(IdWojewodztwa) from dict.tbl_wojewodztwo) 
--	when 'M' then ((select COUNT_BIG(IdStudenta) from stud.tbl_student where IdPlci=2)/(select count_big(IdWojewodztwa) from dict.tbl_wojewodztwo))
--	else ((select COUNT_BIG(*) from stud.tbl_student)/(select count_big(IdWojewodztwa) from dict.tbl_wojewodztwo))
--end

--as 'œrednia liczba osób danej p³ci na województwo'
--from stud.tbl_student as s inner join dict.tbl_wojewodztwo as w
--on s.IdWojewodztwa=w.IdWojewodztwa
--inner join dict.tbl_plec as p on s.IdPlci=p.IdPlci
--group by w.Wojewodztwo, p.SymbolPlci;

--25. Wyœwietliæ zawartoœæ widoku vw_studenci_wg_plci_statystyka1.
select *
from vw_studenci_wg_plci_statystyka1;

--26. Utworzyæ w schemacie u¿ytkownika stud nowy widok vw_studenci_wg_plci_statystyka2. Jako Ÿród³o danych nale¿y wykorzystaæ widok z poprzedniego 
--punktu. Widok powinien dodatkowo zawieraæ dwa dodatkowe pola: Opis i Procent. Pole opis powinno zwracaæ informacjê w postaci: > od œredniej o 
--liczbê 194. Pole procent powinno szacowaæ wartoœæ procentow¹ liczby studentów danej p³ci do œredniej liczby studentów danej p³ci, 
--w danym województwie.

CREATE VIEW vw_studenci_wg_plci_statystyka2 AS
SELECT 
    s.wojewodztwo, 
    s.SymbolPlci, 
    s.[Liczba studentów wg p³ci],
    CASE 
        WHEN s.[Liczba studentów wg p³ci] > avg(s.[Liczba studentów wg p³ci]) OVER(PARTITION BY s.SymbolPlci, s.wojewodztwo) 
            THEN '> od œredniej o '+ CAST(s.[Liczba studentów wg p³ci] - avg(s.[Liczba studentów wg p³ci]) OVER(PARTITION BY s.SymbolPlci, s.wojewodztwo) AS VARCHAR) 
        ELSE '<= œredniej'
    END AS opis,
    ROUND(100 * s.[Liczba studentów wg p³ci] / sum(s.[Liczba studentów wg p³ci]) OVER(PARTITION BY s.SymbolPlci, s.wojewodztwo), 2) AS procent
FROM vw_studenci_wg_plci_statystyka1 s;

--27. Wyœwietliæ zawartoœæ widoku vw_studenci_wg_plci_statystyka2.
select *
from vw_studenci_wg_plci_statystyka2;

--28. Utworzyæ w schemacie u¿ytkownika stud nowy widok vw_studenci_wg_plci_statystyka3 w oparciu o definicjê widoku vw_studenci_wg_plci_statystyka2.
--Widok dodatkowo powinien uwzglêdniaæ kolumnê: Procent ca³kowitej populacji p³ci, zawieraj¹c¹ udzia³ procentowy kobiet, mê¿czyzn z poszczególnych 
--województw w odniesieniu do ca³ej populacji kobiet i mê¿czyzn w Polsce, a tak¿e udzia³ procentowy wszystkich studentów z terenu poszczególnych 
--województw (bez wzglêdu na p³eæ) w odniesieniu do ca³kowitej populacji studentów w Polsce.

--29. Wyœwietliæ zawartoœæ widoku vw_studenci_wg_plci_statystyka3.
select *
from vw_studenci_wg_plci_statystyka3;

--30. Usun¹æ z bazy danych SZBD2022 wszystkie utworzone widoki za pomoc¹ pojedynczej instrukcji.
DROP VIEW IF EXISTS vw_studenci_wg_plci_statystyka1, vw_studenci_wg_plci_statystyka2, vw_studenci_wg_plci_statystyka3;