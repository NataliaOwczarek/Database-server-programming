--1. Stworzyæ zapytanie zwracaj¹ce klientów z okreœlonego województwa. Nazwa województwa
--przekazana zostanie za pomoc¹ zmiennej. Nale¿y zwróciæ dane z pól: ID, Nazwisko, Miasto,
--Województwo. Wszystkie dane pochodz¹ z tabeli Klienci, bazy danych Northwind_PL.
--Ponadto na liœcie pól instrukcji wybieraj¹cej nale¿y tak¿e uwzglêdniæ zmienn¹ przekazuj¹c¹
--wartoœæ litera³u. Nale¿y zadeklarowaæ zmienne okreœlonego typu, a nastêpnie przypisaæ im
--wartoœæ za pomoc¹ stosownego operatora. Poni¿ej przedstawiono przyk³adowy rezultat
--dzia³ania zapytania.
use NORTHWIND_PL;

GO
DECLARE @wojewodztwo VARCHAR(50);
SET @wojewodztwo = '£ódzkie';

SELECT ID, 'Klient' as Opis, Nazwisko, Miasto, Województwo
FROM Klienci
WHERE Województwo = @wojewodztwo;

--2. Stworzyæ zapytanie zwracaj¹ce: nazwê kategorii produktów, nazwê produktu, cenê
--jednostkow¹ produktu. Dane pochodz¹ z tabeli Products i Categories bazy danych
--Northwind. Zapytanie ma zwracaæ dane nt. produktów, których cena zwiera siê w zadanym
--przedziale cenowym. Wartoœci przedzia³u cenowego produktów maj¹ byæ przekazane za
--pomoc¹ zmiennych. Nale¿y zadeklarowaæ zmienne okreœlonego typu i jednoczeœnie
--zainicjowaæ je wartoœciami domyœlnymi. Dane maj¹ byæ posortowane rosn¹co wg nazwy
--kategorii oraz ceny produktu. Poni¿ej przedstawiono przyk³adowy rezultat dzia³ania
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


--3. Napisaæ zapytanie, które zwróci informacjê nt. aktualnej daty w postaci przedstawionej
--poni¿ej.

SELECT 'Dzisiejszy dzieñ to ' 
    + DATENAME(WEEKDAY, GETDATE()) 
    + ' ' 
    + CAST(DATEPART(DAY, GETDATE()) AS VARCHAR(2)) 
    + ' dzieñ miesi¹ca, ' 
    + CAST(DATEPART(WEEKDAY, GETDATE()) AS VARCHAR(1)) 
    + ' dzieñ tygodnia i ' 
    + CAST(DATEPART(DAYOFYEAR, GETDATE()) AS VARCHAR(3)) 
    + ' dzieñ roku.' AS AktualnaData;


--4. Stworzyæ zapytanie zwracaj¹ce informacjê nt. liczby pañstw na zadan¹ liter¹, z których
--pochodz¹ klienci. Dane pochodz¹ z tabeli klienci bazy danych Northwind. Pierwsza litera
--nazwy pañstwa ma byæ przekazana za pomoc¹ zmiennej. W celu realizacji zadania nale¿y
--pos³u¿yæ siê okreœlon¹ liczb¹ zmiennych, o okreœlonym typie danych. Nale¿y pos³u¿yæ siê
--podzapytaniem. Poni¿ej przedstawiono przyk³adowy rezultat dzia³ania zapytania.

DECLARE @litera CHAR(1) = 'A';

SELECT CONCAT('Liczba pañstw na literê ', @litera, ': ', COUNT(*)) AS Wynik
FROM (
    SELECT DISTINCT Country 
    FROM Customers 
    WHERE Country LIKE @litera + '%'
) AS DistinctCountries;


--5. Stworzyæ zapytanie czy dzieñ zadanej daty jest dniem roboczym, czy te¿ weekendem. Nale¿y
--pos³u¿yæ siê zmienn¹ okreœlonego typu. Po³¹czyæ deklaracje zmiennej z przypisaniem jej
--wartoœci domyœlnej. Ponadto nale¿y u¿yæ odpowiedniej wbudowanej funkcji kategorii data i
--czas. Poni¿ej przedstawiono przyk³adowy rezultat dzia³ania zapytania.

go
DECLARE @date DATETIME = getdate()
DECLARE @dayOfWeek varchar(20) = datename(WEEKDAY, @date)

if @dayOfWeek in ('Sunday','Saturday')
print 'Dziœ jest dzieñ  wolny od pracy. Mamy weekend'
else
print 'Dziœ jest dzieñ pracuj¹cy'

--6. Zmodyfikowaæ poprzednie zadanie w taki sposób, aby dodatkowo zwracana by³a nazwa dnia
--tygodnia. W celu realizacji zadania nale¿y zadeklarowaæ odpowiedni¹ iloœæ zmiennych o
--okreœlonym typie danych. Ponadto nale¿y zadbaæ, aby dni tygodnia zwracane by³y w jêzyku
--polskim. Poni¿ej przedstawiono przyk³adowy rezultat dzia³ania zapytania.


--7. Zmodyfikowaæ poprzednie zadanie w taki sposób, aby dodatkowo by³a zwracana informacja
--nt. pozosta³ej liczby dni do weekendu w przypadku dni roboczych. Ponadto nale¿y zadbaæ o
--poprawnoœæ jêzykow¹ zwracanych komunikatów. Poni¿ej przedstawiono przyk³adowy
--rezultat dzia³ania zapytania.