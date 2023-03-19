--1. Stworzy� zapytanie zwracaj�ce klient�w z okre�lonego wojew�dztwa. Nazwa wojew�dztwa
--przekazana zostanie za pomoc� zmiennej. Nale�y zwr�ci� dane z p�l: ID, Nazwisko, Miasto,
--Wojew�dztwo. Wszystkie dane pochodz� z tabeli Klienci, bazy danych Northwind_PL.
--Ponadto na li�cie p�l instrukcji wybieraj�cej nale�y tak�e uwzgl�dni� zmienn� przekazuj�c�
--warto�� litera�u. Nale�y zadeklarowa� zmienne okre�lonego typu, a nast�pnie przypisa� im
--warto�� za pomoc� stosownego operatora. Poni�ej przedstawiono przyk�adowy rezultat
--dzia�ania zapytania.
use NORTHWIND_PL;

GO
DECLARE @wojewodztwo VARCHAR(50);
SET @wojewodztwo = '��dzkie';

SELECT ID, 'Klient' as Opis, Nazwisko, Miasto, Wojew�dztwo
FROM Klienci
WHERE Wojew�dztwo = @wojewodztwo;

--2. Stworzy� zapytanie zwracaj�ce: nazw� kategorii produkt�w, nazw� produktu, cen�
--jednostkow� produktu. Dane pochodz� z tabeli Products i Categories bazy danych
--Northwind. Zapytanie ma zwraca� dane nt. produkt�w, kt�rych cena zwiera si� w zadanym
--przedziale cenowym. Warto�ci przedzia�u cenowego produkt�w maj� by� przekazane za
--pomoc� zmiennych. Nale�y zadeklarowa� zmienne okre�lonego typu i jednocze�nie
--zainicjowa� je warto�ciami domy�lnymi. Dane maj� by� posortowane rosn�co wg nazwy
--kategorii oraz ceny produktu. Poni�ej przedstawiono przyk�adowy rezultat dzia�ania
--zapytania.

use Northwind;

GO

DECLARE @minCena DECIMAL(10,2) = 10.00;
DECLARE @maxCena DECIMAL(10,2) = 50.00;

SELECT c.CategoryName, p.ProductName, p.UnitPrice
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE p.UnitPrice BETWEEN @minCena AND @maxCena
ORDER BY c.CategoryName ASC, p.UnitPrice ASC;


--3. Napisa� zapytanie, kt�re zwr�ci informacj� nt. aktualnej daty w postaci przedstawionej
--poni�ej.

SELECT 'Dzisiejszy dzie� to ' 
    + DATENAME(WEEKDAY, GETDATE()) 
    + ' ' 
    + CAST(DATEPART(DAY, GETDATE()) AS VARCHAR(2)) 
    + ' dzie� miesi�ca, ' 
    + CAST(DATEPART(WEEKDAY, GETDATE()) AS VARCHAR(1)) 
    + ' dzie� tygodnia i ' 
    + CAST(DATEPART(DAYOFYEAR, GETDATE()) AS VARCHAR(3)) 
    + ' dzie� roku.' AS AktualnaData;


--4. Stworzy� zapytanie zwracaj�ce informacj� nt. liczby pa�stw na zadan� liter�, z kt�rych
--pochodz� klienci. Dane pochodz� z tabeli klienci bazy danych Northwind. Pierwsza litera
--nazwy pa�stwa ma by� przekazana za pomoc� zmiennej. W celu realizacji zadania nale�y
--pos�u�y� si� okre�lon� liczb� zmiennych, o okre�lonym typie danych. Nale�y pos�u�y� si�
--podzapytaniem. Poni�ej przedstawiono przyk�adowy rezultat dzia�ania zapytania.

DECLARE @litera CHAR(1) = 'A';

SELECT CONCAT('Liczba pa�stw na liter� ', @litera, ': ', COUNT(*)) AS Wynik
FROM (
    SELECT DISTINCT Country 
    FROM Customers 
    WHERE Country LIKE @litera + '%'
) AS DistinctCountries;


--5. Stworzy� zapytanie czy dzie� zadanej daty jest dniem roboczym, czy te� weekendem. Nale�y
--pos�u�y� si� zmienn� okre�lonego typu. Po��czy� deklaracje zmiennej z przypisaniem jej
--warto�ci domy�lnej. Ponadto nale�y u�y� odpowiedniej wbudowanej funkcji kategorii data i
--czas. Poni�ej przedstawiono przyk�adowy rezultat dzia�ania zapytania.

go
DECLARE @date DATETIME = getdate()
DECLARE @dayOfWeek varchar(20) = datename(WEEKDAY, @date)

if @dayOfWeek in ('Sunday','Saturday')
print 'Dzi� jest dzie�  wolny od pracy. Mamy weekend'
else
print 'Dzi� jest dzie� pracuj�cy'

--6. Zmodyfikowa� poprzednie zadanie w taki spos�b, aby dodatkowo zwracana by�a nazwa dnia
--tygodnia. W celu realizacji zadania nale�y zadeklarowa� odpowiedni� ilo�� zmiennych o
--okre�lonym typie danych. Ponadto nale�y zadba�, aby dni tygodnia zwracane by�y w j�zyku
--polskim. Poni�ej przedstawiono przyk�adowy rezultat dzia�ania zapytania.


--7. Zmodyfikowa� poprzednie zadanie w taki spos�b, aby dodatkowo by�a zwracana informacja
--nt. pozosta�ej liczby dni do weekendu w przypadku dni roboczych. Ponadto nale�y zadba� o
--poprawno�� j�zykow� zwracanych komunikat�w. Poni�ej przedstawiono przyk�adowy
--rezultat dzia�ania zapytania.