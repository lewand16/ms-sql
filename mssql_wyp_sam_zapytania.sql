--1.1 Wy�wietli� zawarto�� wszystkich kolumn z tabeli pracownik.
SELECT * FROM pracownik;

--1.2 Z tabeli pracownik wy�wietli� same imiona pracownik�w.
SELECT imie FROM pracownik;

--1.3 Wy�wietli� zawarto�� kolumn imi�, nazwisko i dzia� z tabeli pracownik.
SELECT imie, nazwisko, dzial FROM pracownik;

--2.1 Wy�wietli� zawarto�� kolumn imi�, nazwisko i pensja z tabeli pracownik. Wynik posortuj malej�co wzgl�dem pensji.
SELECT imie, nazwisko, pensja 
FROM pracownik 
ORDER BY pensja DESC;

--2.2 Wy�wietl zawarto�� kolumn nazwisko i imi� z tabeli pracownik. Wynik posortuj rosn�co (leksykograficznie) 
--wzgl�dem nazwiska i imienia.
SELECT nazwisko, imie 
FROM pracownik 
ORDER BY nazwisko ASC, imie ASC;

--2.3 Wy�wietli� zawarto�� kolumn nazwisko, dzia�, stanowisko z tabeli pracownik. Wynik posortuj rosn�co wzgl�dem 
--dzia�u, a dla tych samych nazw dzia��w malej�co wzgl�dem stanowiska.
SELECT nazwisko, dzial, stanowisko 
FROM pracownik 
ORDER BY dzial ASC, stanowisko DESC;

--3.1 Wy�wietli� niepowtarzaj�ce si� warto�ci kolumny dzia� z tabeli pracownik.
SELECT DISTINCT dzial FROM pracownik;

--3.2 Wy�wietli� unikatowe wiersze zawieraj�ce warto�ci kolumn dzia� i stanowisko w tabeli pracownik.
SELECT DISTINCT dzial, stanowisko FROM pracownik;

--3.3 Wy�wietli� unikatowe wiersze zawieraj�ce warto�ci kolumn dzia� i stanowisko w tabeli pracownik. Wynik posortuj
--malej�co wzgl�dem dzia�u i stanowiska.
SELECT DISTINCT dzial, stanowisko FROM pracownik
ORDER BY dzial DESC, stanowisko DESC;

--4.1 Znajd� pracownik�w o imieniu Jan. Wy�wietl ich imiona i nazwiska.
SELECT imie FROM pracownik WHERE imie = 'Jan';

--4.2 Wy�wietli� imiona i nazwiska pracownik�w pracuj�cych na stanowisku sprzedawca.
SELECT imie, nazwisko 
	FROM pracownik 
	WHERE stanowisko = 'sprzedawca';

--4.3 Wy�wietli� imiona, nazwiska, pensje pracownik�w, kt�rzy zarabiaj� powy�ej 1500 z�. Wynik posortuj malej�co
--wzgl�dem pensji.
SELECT imie, nazwisko, pensja 
	FROM pracownik 
	WHERE pensja > 1500 
	ORDER BY pensja DESC;

--5.1 Z tabeli pracownik wy�wietli� imiona, nazwiska, dzia�y, stanowiska tych pracownik�w, kt�rzy pracuj� w dziale
--obs�ugi klienta na stanowisku sprzedawca.
SELECT imie, nazwisko, dzial, stanowisko
	FROM pracownik
	WHERE dzial = 'obs�uga klienta' AND
		stanowisko = 'sprzedawca';

--5.2 Znale�� pracownik�w pracuj�cych w dziale technicznym na stanowisku kierownika lub sprzedawcy. Wy�wietl
--imi�, nazwisko, dzia�, stanowisko.
SELECT imie, nazwisko, dzial, stanowisko
	FROM pracownik
	WHERE 
		dzial = 'techniczny' AND (
		stanowisko = 'kierownik' OR
		stanowisko = 'sprzedawca'
		);

--5.3 Znale�� samochody, kt�re nie s� marek fiat i ford.
SELECT marka 
	FROM samochod
	WHERE 
		marka != 'fiat' AND
		marka != 'ford';

--6.1 Znale�� samochody marek mercedes, seat i opel.
SELECT * 
	FROM samochod
	WHERE marka IN ('mercedes', 'seat', 'opel');

--6.2 Znajd� pracownik�w o imionach Anna, Marzena i Alicja. Wy�wietl ich imiona, nazwiska i daty zatrudnienia.
SELECT imie, nazwisko, data_zatr
	FROM pracownik
	WHERE imie IN ('Anna', 'Marzena', 'Alicja');

--6.3 Znajd� klient�w, kt�rzy nie mieszkaj� w Warszawie lub we Wroc�awiu. Wy�wietl ich imiona, nazwiska i miasta
--zamieszkania.
SELECT imie, nazwisko, miasto
	FROM klient
	WHERE miasto NOT IN ('Warszawa', 'Wroc�aw');

--7.1 Wy�wietli� imiona i nazwiska klient�w, kt�rych nazwisko zawiera liter� K.
SELECT imie, nazwisko
	FROM klient
	WHERE nazwisko LIKE '%K%';

--7.2 Wy�wietli� imiona i nazwiska klient�w, dla kt�rych nazwisko zaczyna si� na D, a ko�czy si� na SKI.
SELECT imie, nazwisko
	FROM klient
	WHERE nazwisko LIKE 'D%SKI';

--7.3 Znale�� imiona i nazwiska klient�w, kt�rych nazwisko zawiera drug� liter� O lub A.
SELECT imie, nazwisko
	FROM klient
	WHERE nazwisko LIKE '_[ao]%';

--8.1 Z tabeli samoch�d wy�wietli� wiersze, dla kt�rych pojemno�� silnika jest z przedzia�u [1100,1600].
SELECT *
	FROM samochod
	WHERE poj_silnika BETWEEN 1100 AND 1600;

--8.2 Znale�� pracownik�w, kt�rzy zostali zatrudnieni pomi�dzy datami 1997-01-01 a 1997-12-31.
SELECT *
	FROM pracownik
	WHERE data_zatr BETWEEN '1997-01-01' AND '1997-12-31';

--8.3 Znale�� samochody, dla kt�rych przebieg jest pomi�dzy 10000 a 20000 km lub pomi�dzy 30000 a 40000 km.
SELECT *
	FROM samochod
	WHERE przebieg BETWEEN 10000 AND 20000 
	OR (przebieg BETWEEN 30000 AND 40000);

--9.1 Znale�� pracownik�w, kt�rzy nie maj� okre�lonego dodatku do pensji.
SELECT *
  FROM pracownik
  WHERE dodatek IS NULL;

--9.2 Wy�wietli� klient�w, kt�rzy posiadaj� kart� kredytow�.
SELECT *
  FROM klient
  WHERE nr_karty_kredyt IS NOT NULL;

--9.3 Dla ka�dego pracownika wy�wietl imi�, nazwisko i wysoko�� dodatku. Warto�� NULL z kolumny dodatek powinna
--by� wy�wietlona jako 0. Wskaz�wka: U�yj funkcji COALESCE.
SELECT imie, nazwisko, COALESCE (dodatek, 0) AS dodatek
  FROM pracownik;

--10.1 Wy�wietli� imiona, nazwiska pracownik�w ich pensje i dodatki oraz kolumn� wyliczeniow� do_zap�aty,
--zawieraj�c� sum� pensji i dodatku. Wskaz�wka: Warto�� NULL z kolumny dodatek powinna by� wy�wietlona jako
--zero
SELECT imie, nazwisko, pensja, COALESCE (dodatek, 0) AS dodatek, (pensja + COALESCE (dodatek, 0)) AS do_zaplaty
  FROM pracownik;

--10.2 Dla ka�dego pracownika wy�wietl imi�, nazwisko i wyliczeniow� kolumn� nowa_pensja, kt�ra b�dzie mia�a o
--50% wi�ksz� warto�� ni� dotychczasowa pensja.
SELECT imie, nazwisko, (pensja * 1.5) AS nowa_pensja
  FROM pracownik;

--10.3 Dla ka�dego pracownika oblicz ile wynosi 1% zarobk�w (pensja + dodatek). Wy�wietl imi�, nazwisko i obliczony
--1%. Wyniki posortuj rosn�co wzgl�dem obliczonego 1%.
SELECT imie, nazwisko, ((pensja + COALESCE (dodatek, 0)) * 0.01) AS procent
  FROM pracownik;

--11.1 Znajd� imi� i nazwisko pracownika, kt�ry jako pierwszy zosta� zatrudniony w wypo�yczalni samochod�w.
--(Jest tylko jeden taki pracownik.)
SELECT TOP 1 imie, nazwisko
  FROM pracownik
  ORDER BY data_zatr ASC;

--11.2 Wy�wietl pierwszych czterech pracownik�w z alfabetycznej listy (nazwiska i imiona) wszystkich pracownik�w.
--(W tym zadaniu nie musisz si� przejmowa� powt�rkami imion i nazwisk, ale gdyby� chcia� to sprawd� konstrukcj�
--SELECT TOP x WITH TIES �)
SELECT TOP 4 imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko ASC, imie ASC;

-- SELECT TOP x WITH TIES spowoduje, �e nawet ograniczona lista powi�kszy si�, je�li na ostatniej pozycji b�dzie 
--kilka identycznych
SELECT TOP 3 WITH TIES imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko ASC, imie ASC;

--11.3 Wyszukaj informacj� o ostatnim wypo�yczeniu samochodu.
SELECT TOP 1 *
  FROM wypozyczenie
  ORDER BY data_wyp DESC;

--12.1 Wyszukaj pracownik�w zatrudnionych w maju. Wy�wietl ich imiona, nazwiska i dat� zatrudnienia. Wynik
--posortuj rosn�co wzgl�dem nazwiska i imienia.
--Wskaz�wka: Zajrzyj do dokumentacji MS SQL i poczytaj o funkcjach: DAY, MONTH, YEAR, GETDATE, DATEDIFF.
SELECT imie, nazwisko, data_zatr
  FROM pracownik
  WHERE MONTH(data_zatr) = 5
  ORDER BY nazwisko ASC, imie ASC;

--12.2 Dla ka�dego pracownika (imi� i nazwisko) oblicz ile ju� pracuje dni. Wynik posortuj malej�co wed�ug ilo�ci
--przepracowanych dni.
 SELECT imie, nazwisko, (DATEDIFF(DAY, data_zatr, GETDATE())) AS liczba_dni_zatrudnienia
   FROM pracownik
   ORDER BY liczba_dni_zatrudnienia DESC;

--12.3 Dla ka�dego samochodu (marka, typ) oblicz ile lat up�yn�o od jego produkcji. Wynik posortuj malej�co po ilo�ci
--lat.
SELECT marka, typ, (DATEDIFF(YEAR, data_prod, GETDATE())) AS liczba_lat_od_produkcji
  FROM samochod
  ORDER BY liczba_lat_od_produkcji DESC;

--13.1 Wy�wietl imi�, nazwisko i inicja�y ka�dego klienta. Wynik posortuj wzgl�dem inicja��w, nazwiska i imienia
--klienta.
--Wskaz�wka: Zajrzyj do dokumentacji MS SQL i poczytaj o funkcjach: LEFT, RIGHT, LEN, UPPER, LOWER, STUFF.
SELECT imie, nazwisko, (LEFT(imie, 1) + '. ' + LEFT(nazwisko, 1)) AS inicjaly
  FROM pracownik
  ORDER BY inicjaly ASC, nazwisko ASC, imie ASC;

--13.2 Wy�wietl imiona i nazwiska klient�w w taki spos�b, aby pierwsza litera imienia i nazwiska by�a wielka, a
--pozosta�e ma�e.
SELECT (UPPER(LEFT(imie, 1)) + LOWER(RIGHT(imie, LEN(imie) - 1))) AS imie, (UPPER(LEFT(nazwisko, 1)) + LOWER(RIGHT(nazwisko, LEN(nazwisko) - 1))) AS nazwisko
  FROM pracownik;

--13.3 Wy�wietl imiona, nazwiska i numery kart kredytowych klient�w. Ka�da z ostatnich sze�ciu cyfr wy�wietlanego
--numeru karty kredytowej klienta powinna by� zast�piona znakiem x .
SELECT imie, nazwisko, (LEFT(nr_karty_kredyt, LEN(nr_karty_kredyt) - 6) + 'xxxxxx') AS nr_karty_kredytowej
  FROM klient;

--14.1 Pracownikom, kt�rzy nie maj� okre�lonej wysoko�ci dodatku nadaj dodatek w wysoko�ci 50 z�.
SELECT dodatek FROM pracownik; --przed zmianami

UPDATE pracownik
  SET dodatek = 50
  WHERE dodatek IS NULL;

SELECT dodatek FROM pracownik; --po zmianach

--14.2 Klientowi o identyfikatorze r�wnym 10 zmie� imi� i nazwisko na Jerzy Nowak.
SELECT imie, nazwisko FROM pracownik; --przed zmianami

UPDATE pracownik
  SET imie = 'Jerzy', nazwisko = 'Nowak'
  WHERE id_pracownik = 10;

SELECT imie, nazwisko FROM pracownik; --po zmianach

--14.3 Zwi�ksz o 100 z� dodatek pracownikom, kt�rych pensja jest mniejsza ni� 1500 z�.
SELECT pensja, dodatek FROM pracownik; --przed zmianami

UPDATE pracownik
  SET dodatek = dodatek + 100
  WHERE pensja < 1500;

SELECT pensja, dodatek FROM pracownik; --po zmianach

--15.1 Usun�� klienta o identyfikatorze r�wnym 17.
SELECT * FROM klient; --przed zmianami

DELETE FROM klient
  WHERE id_klient = 17;

SELECT * FROM klient; --po zmianach

--15.2 Usun�� wszystkie informacje o wypo�yczeniach dla klienta o identyfikatorze r�wnym 17.
SELECT * FROM wypozyczenie ORDER BY id_klient ASC; --przed zmianami

DELETE FROM wypozyczenie
  WHERE id_klient = 17;

SELECT * FROM wypozyczenie ORDER BY id_klient ASC; --po zmianach

--15.3 Usu� wszystkie samochody o przebiegu wi�kszym ni� 60000.
SELECT * FROM samochod ORDER BY przebieg ASC; --przed zmianami

DELETE FROM samochod
  WHERE przebieg > 60000;

SELECT * FROM samochod ORDER BY przebieg ASC; --po zmianach

--16.1 Dodaj do bazy danych klienta o identyfikatorze r�wnym 121: Adam Cichy zamieszka�y ul. Korzenna 12, 00-950
--Warszawa, tel. 123-454-321.
INSERT INTO klient(id_klient, imie, nazwisko, ulica, numer, kod, miasto, telefon)
  VALUES(121, 'Adam', 'Cichy', 'Korzenna', '12', '00-950', 'Warszawa', '123-454-321');

SELECT * FROM klient WHERE id_klient = 121; --sprawdzenie po zmianach

--16.2 Dodaj do bazy danych nowy samoch�d o identyfikatorze r�wnym 50: srebrna skoda octavia o pojemno�ci silnika
--1896 cm3 wyprodukowana 1 wrze�nia 2012 r. i o przebiegu 5 000 km.
INSERT INTO samochod(id_samochod, kolor, marka, typ, poj_silnika, data_prod, przebieg)
  VALUES(50, 'srebrny', 'skoda', 'octavia', 1896, '2012-09-01', 5000);

SELECT * FROM samochod WHERE id_samochod = 50; --sprawdzenie po zmianach

--16.3 Dodaj do bazy danych pracownika: Alojzy Mikos zatrudniony od 11 sierpnia 2010 r. w dziale zaopatrzenie na
--stanowisku magazyniera z pensj� 3000 z� i dodatkiem 50 z�, telefon do pracownika: 501-501-501, pracownik pracuje w
--Warszawie na ul. Lewartowskiego 12, kod pocztowy: 00-950.
INSERT INTO miejsce(id_miejsce, miasto, ulica, numer, kod)
  VALUES((SELECT TOP 1 id_miejsce FROM miejsce ORDER BY id_miejsce DESC) + 1 , 'Warszawa', 'Lewartowskiego', '12', '00-950');
INSERT INTO pracownik(id_pracownik, imie, nazwisko, data_zatr, dzial, stanowisko, pensja, dodatek, telefon, id_miejsce)
  VALUES((SELECT TOP 1 id_pracownik FROM pracownik ORDER BY id_pracownik DESC) + 1 ,'Alojzy', 'Mikos', '2010-08-11', 'zaopatrzenie', 'magazynier', 3000, 50, '501-501-501', (SELECT id_miejsce FROM miejsce WHERE miasto = 'Warszawa' AND ulica = 'Lewartowskiego' AND numer = '12' AND kod = '00-950'));
  --lub pro�ciej
INSERT INTO miejsce(id_miejsce, miasto, ulica, numer, kod)
  VALUES((SELECT TOP 1 id_miejsce FROM miejsce ORDER BY id_miejsce DESC) + 1 , 'Warszawa', 'Lewartowskiego', '12', '00-950');
INSERT INTO pracownik(id_pracownik, imie, nazwisko, data_zatr, dzial, stanowisko, pensja, dodatek, telefon, id_miejsce)
  VALUES((SELECT TOP 1 id_pracownik FROM pracownik ORDER BY id_pracownik DESC) + 1 ,'Alojzy', 'Mikos', '2010-08-11', 'zaopatrzenie', 'magazynier', 3000, 50, '501-501-501', (SELECT TOP 1 id_miejsce FROM miejsce ORDER BY id_miejsce DESC));
SELECT * FROM pracownik; --sprawdzenie po zmianach
SELECT * FROM miejsce; --sprawdzenie po zmianach

--17.1 Wyszukaj samochody, kt�re nie zosta�y zwr�cone. (Data oddania samochodu ma mie� warto�� NULL.) Wy�wietl
--identyfikator, mark� i typ samochodu oraz jego dat� wypo�yczenia i oddania.
SELECT s.id_samochod, s.marka, s.typ, w.data_wyp, w.data_odd
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  WHERE w.data_odd IS NULL;

--17.2 Wyszukaj klient�w, kt�rzy nie zwr�cili jeszcze samochodu. (Data oddania samochodu ma mie� warto�� NULL.)
--Wy�wietl imi� i nazwisko klienta oraz identyfikator samochodu i dat� wypo�yczenia nie zwr�conego jeszcze
--samochodu. Wynik posortuj rosn�co wzgl�dem nazwiska i imienia klienta.
SELECT k.imie, k.nazwisko, w.id_samochod, w.data_wyp
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  WHERE w.data_odd IS NULL
  ORDER BY k.nazwisko ASC, k.imie ASC;

--17.3 W�r�d klient�w wypo�yczalni wyszukaj daty i kwoty wp�aconych przez nich kaucji. Wy�wietl imi� i nazwisko
--klienta oraz dat� wp�acenia kaucji (data wypo�yczenia samochodu jest r�wnocze�nie dat� wp�acenia kaucji) i jej
--wysoko�� (pomi� kaucje maj�ce warto�� NULL)
SELECT k.imie, k.nazwisko, w.data_wyp, w.kaucja
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  WHERE w.kaucja IS NOT NULL;

--18.1 Dla ka�dego klienta, kt�ry cho� raz wypo�yczy� samoch�d, wyszukaj jakie i kiedy wypo�yczy� samochody.
--Wy�wietl imi� i nazwisko klienta oraz dat� wypo�yczenia, mark� i typ wypo�yczonego samochodu. Wynik posortuj
--rosn�co po nazwisku i imieniu klienta oraz marce i typie samochodu.
SELECT k.imie, k.nazwisko, w.data_wyp, s.marka, s.typ
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient INNER JOIN samochod s
    ON s.id_samochod = w.id_samochod
  ORDER BY k.nazwisko ASC, k.imie ASC, s.marka ASC, s.typ ASC;

--18.2 Dla ka�dej filii wypo�yczalni samochod�w (tabela miejsce) wyszukaj jakie samochody by�y wypo�yczane.
--Wy�wietl adres filii (ulica i numer) oraz mark� i typ wypo�yczonego samochodu. Wyniki posortuj rosn�co wzgl�dem
--adresu filii, marki i typu samochodu.
SELECT DISTINCT m.ulica, m.numer, s.marka, s.typ
  FROM miejsce m INNER JOIN wypozyczenie w
  ON m.id_miejsce = w.id_miejsca_wyp INNER JOIN samochod s
    ON s.id_samochod=w.id_samochod
  ORDER BY m.ulica ASC, m.numer ASC, s.marka ASC, s.typ ASC;

--18.3 Dla ka�dego wypo�yczonego samochodu wyszukaj informacj� jacy klienci go wypo�yczali. Wy�wietl
--identyfikator, mark� i typ samochodu oraz imi� i nazwisko klienta. Wyniki posortuj rosn�co po identyfikatorze
--samochodu oraz nazwisku i imieniu klienta.
SELECT DISTINCT s.id_samochod, s.marka, s.typ, k.imie, k.nazwisko
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod INNER JOIN klient k
    ON k.id_klient=w.id_klient
  ORDER BY s.id_samochod ASC, k.nazwisko ASC, k.imie ASC;

--19.1 Znale�� najwi�ksz� pensj� pracownika wypo�yczalni samochod�w.
SELECT MAX(pensja) FROM pracownik;

--19.2 Znale�� �redni� pensj� pracownika wypo�yczalni samochod�w.
SELECT AVG(pensja) FROM pracownik;

--19.3 Znale�� najwcze�niejsz� dat� wyprodukowania samochodu.
SELECT MIN(data_prod) FROM samochod;

--20.1 Dla ka�dego klienta wypisz imi�, nazwisko i ��czn� ilo�� wypo�ycze� samochod�w (nie zapomnij o zerowej liczbie
--wypo�ycze�). Wynik posortuj malej�co wzgl�dem ilo�ci wypo�ycze�.
SELECT k.imie, k.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM klient k LEFT JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  GROUP BY k.imie, k.nazwisko
  ORDER BY ilosc_wypozyczen DESC;

--20.2 Dla ka�dego samochodu (identyfikator, marka, typ) oblicz ilo�� wypo�ycze�. Wynik posortuj rosn�co wzgl�dem
--ilo�ci wypo�ycze�. (Nie zapomnij o samochodach, kt�re ani razu nie zosta�y wypo�yczone.)
SELECT s.id_samochod, s.marka, s.typ, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM samochod s LEFT JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  GROUP BY s.id_samochod, s.marka, s.typ
  ORDER BY ilosc_wypozyczen ASC;

--20.3 Dla ka�dego pracownika oblicz ile wypo�yczy� samochod�w klientom. Wy�wietl imi� i nazwisko pracownika oraz
--ilo�� wypo�ycze�. Wynik posortuj malej�co po ilo�ci wypo�ycze�. (Nie zapomnij o pracownikach, kt�rzy nie
--wypo�yczyli �adnego samochodu.)
SELECT p.imie, p.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM pracownik p LEFT JOIN wypozyczenie w
  ON p.id_pracownik = w.id_pracow_wyp
  GROUP BY p.imie, p.nazwisko
  ORDER BY ilosc_wypozyczen DESC;

--21.1 Znajd� klient�w, kt�rzy co najmniej 2 razy wypo�yczyli samoch�d. Wypisz dla tych klient�w imi�, nazwisko i ilo��
--wypo�ycze�. Wynik posortuj rosn�co wzgl�dem nazwiska i imienia
SELECT k.imie, k.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  GROUP BY k.imie, k.nazwisko
  HAVING COUNT(w.data_wyp) >= 2
  ORDER BY k.nazwisko ASC, k.imie ASC;

--21.2 Znajd� samochody, kt�re by�y wypo�yczone co najmniej 5 razy. Wy�wietl identyfikator samochodu, mark�, typ i
--ilo�� wypo�ycze�. Wynik posortuj rosn�co wzgl�dem marki i typu samochodu
SELECT s.id_samochod, s.marka, s.typ, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  GROUP BY s.id_samochod, s.marka, s.typ
  HAVING COUNT(w.data_wyp) >=5
  ORDER BY s.marka ASC, s.typ ASC;

--21.3 Znajd� pracownik�w, kt�rzy klientom wypo�yczyli co najwy�ej 20 razy samoch�d. Wy�wietl imiona i nazwiska
--pracownik�w razem z ilo�ci� wypo�ycze�. Wynik posortuj rosn�co wzgl�dem ilo�ci wypo�ycze�, nazwiska i imienia
--pracownika. (Uwzgl�dnij pracownik�w, kt�rzy nie wypo�yczyli �adnego samochodu.)
SELECT p.imie, p.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM pracownik p LEFT JOIN wypozyczenie w
  ON p.id_pracownik = w.id_pracow_wyp
  GROUP BY p.imie, p.nazwisko
  HAVING COUNT(w.data_wyp) <= 20
  ORDER BY ilosc_wypozyczen ASC, p.nazwisko ASC, p.imie ASC;

--22.1 Wy�wietl imiona, nazwiska i pensje pracownik�w, kt�rzy posiadaj� najwy�sz� pensj�.
SELECT imie, nazwisko, pensja
  FROM pracownik
  WHERE pensja = (
    SELECT MAX(pensja) 
	FROM pracownik);

--22.2 Wy�wietl pracownik�w (imiona, nazwiska, pensje), kt�rzy zarabiaj� powy�ej �redniej pensji.
SELECT imie, nazwisko, pensja
  FROM pracownik
  WHERE pensja > (
    SELECT AVG(pensja)
	FROM pracownik);

--22.3 Wyszukaj samoch�d (marka, typ, data produkcji), kt�ry zosta� wyprodukowany najwcze�niej. Mo�e si� tak
--zdarzy�, �e kilka samochod�w zosta�o wyprodukowanych w ten sam "najwcze�niejszy" dzie�.
SELECT marka, typ, data_prod
  FROM samochod
  WHERE data_prod = (
    SELECT MIN(data_prod)
	FROM samochod);

--23.1 Wy�wietl wszystkie samochody (marka, typ, data produkcji), kt�re do tej pory nie zosta�y wypo�yczone.
SELECT marka, typ, data_prod
  FROM samochod
  WHERE id_samochod NOT IN
    (SELECT DISTINCT id_samochod
	FROM wypozyczenie);

--23.2 Wy�wietl klient�w (imi� i nazwisko), kt�rzy do tej pory nie wypo�yczyli �adnego samochodu. Wynik posortuj
--rosn�co wzgl�dem nazwiska i imienia klienta
SELECT imie, nazwisko
  FROM klient
  WHERE id_klient NOT IN
    (SELECT DISTINCT id_klient
	FROM wypozyczenie)
  ORDER BY nazwisko ASC, imie ASC;

--23.3 Znale�� pracownik�w (imi� i nazwisko), kt�rzy do tej pory nie wypo�yczyli �adnego samochodu klientowi.
SELECT imie, nazwisko
  FROM pracownik
  WHERE id_pracownik NOT IN
    (SELECT DISTINCT id_pracow_wyp
	FROM wypozyczenie);

--24.1 Znajd� samoch�d/samochody (id_samochod, marka, typ), kt�ry by� najcz�ciej wypo�yczany. Wynik posortuj
--rosn�co (leksykograficznie) wzgl�dem marki i typu.
SELECT s.id_samochod, s.marka, s.typ
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  GROUP BY s.id_samochod, s.marka, s.typ
  HAVING COUNT(w.id_samochod) = (
    SELECT TOP 1 COUNT(w.id_samochod) AS ilosc
	  FROM wypozyczenie w
	  GROUP BY w.id_samochod
	  ORDER BY ilosc DESC
  )
  ORDER BY s.marka ASC, s.typ ASC;

--24.2 Znajd� klienta/klient�w (id_klient, imie, nazwisko), kt�rzy najrzadziej wypo�yczali samochody. Wynik posortuj
--rosn�co wzgl�dem nazwiska i imienia. Nie uwzgl�dniaj klient�w, kt�rzy ani razu nie wypo�yczyli samochodu.
SELECT k.imie, k.nazwisko
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  GROUP BY k.id_klient, k.imie, k.nazwisko
  HAVING COUNT(w.id_klient) = (
    SELECT TOP 1 COUNT(w.id_klient) AS ilosc
	  FROM wypozyczenie w
	  GROUP BY w.id_klient
	  HAVING COUNT(w.id_klient) > 0
	  ORDER BY ilosc ASC
  )
  ORDER BY k.nazwisko ASC, k.imie ASC;

--24.3 Znajd� pracownika/pracownik�w (id_pracownik, nazwisko, imie), kt�ry wypo�yczy� najwi�cej samochod�w
--klientom. Wynik posortuj rosn�co (leksykograficznie) wzgl�dem nazwiska i imienia pracownika.
SELECT p.id_pracownik, p.nazwisko, p.imie
  FROM pracownik p INNER JOIN wypozyczenie w
  ON p.id_pracownik = w.id_pracow_wyp
  GROUP BY p.id_pracownik, p.nazwisko, p.imie
  HAVING COUNT(w.id_pracow_wyp) = (
    SELECT TOP 1 COUNT(w.id_pracow_wyp) AS ilosc
	  FROM wypozyczenie w
	  GROUP BY w.id_pracow_wyp
	  ORDER BY ilosc DESC
  )
  ORDER BY p.nazwisko ASC, p.imie ASC;

--25.1 Podwy�szy� o 10% pensj� pracownikom, kt�rzy zarabiaj� poni�ej �redniej.
UPDATE pracownik
  SET pensja = pensja * 1.1
  WHERE pensja < (
    SELECT AVG(pensja)
	  FROM pracownik
  );

--25.2 Pracownikom, kt�rzy w maju wypo�yczyli samoch�d klientowi zwi�ksz dodatek o 10 z�.
UPDATE pracownik
  SET dodatek = dodatek + 10
  WHERE id_pracownik IN (
    SELECT id_pracow_wyp
	  FROM wypozyczenie
	  WHERE MONTH(data_wyp) = 5
  );

--25.3 Obni�y� pensje o 5% wszystkim pracownikom kt�rzy nie wypo�yczyli klientowi samochodu w 1999 roku.
UPDATE pracownik
  SET pensja = pensja * 0.95
  WHERE id_pracownik IN (
    SELECT DISTINCT id_pracow_wyp
	  FROM wypozyczenie
	  WHERE YEAR(data_wyp) != 1999
  );

--26.1 Usun�� klient�w, kt�rzy nie wypo�yczyli �adnego samochodu
DELETE FROM klient
  WHERE id_klient NOT IN (
    SELECT DISTINCT id_klient
	  FROM wypozyczenie
  );
--alternatywnie, dotyczy te� kolejnych zada�
DELETE FROM klient
  WHERE id_klient != ALL (
    SELECT DISTINCT id_klient
	  FROM wypozyczenie
  );

--26.2 Usun�� samochody, kt�re nie zosta�y ani razu wypo�yczone.
DELETE FROM samochod
  WHERE id_samochod NOT IN (
    SELECT DISTINCT id_samochod
	  FROM wypozyczenie
  );

--26.3 Usun�� pracownik�w, kt�rzy klientom nie wypo�yczyli �adnego samochodu.
DELETE FROM pracownik
  WHERE id_pracownik NOT IN (
    SELECT DISTINCT id_pracow_wyp
	  FROM wypozyczenie
  );

--27.1 Wy�wietl razem wszystkie imiona i nazwiska pracownik�w i klient�w. (Suma dw�ch zbior�w.) Wynik posortuj
--wzgl�dem nazwiska i imienia. Rozpatrz dwa przypadki
--a) z pomini�ciem duplikat�w,
SELECT imie, nazwisko
  FROM pracownik
UNION
SELECT imie, nazwisko
  FROM klient
  ORDER BY nazwisko, imie;

--b) z wy�wietleniem duplikat�w (pe�na suma).
SELECT imie, nazwisko
  FROM pracownik
UNION ALL
SELECT imie, nazwisko
  FROM klient
  ORDER BY nazwisko, imie;

--27.2 Wy�wietl powtarzaj�ce si� imiona i nazwiska klient�w i pracownik�w. (Cz�� wsp�lna dw�ch zbior�w.)
SELECT imie, nazwisko
  FROM klient
INTERSECT
SELECT imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko, imie;

--27.3 Wy�wietl imiona i nazwiska klient�w, kt�rzy nazywaj� si� inaczej ni� pracownicy. (R�nica dw�ch zbior�w.)
--Wynik posortuj wzgl�dem nazwiska i imienia.
SELECT imie, nazwisko
  FROM klient
EXCEPT
SELECT imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko, imie;

--28.1 Utw�rz tabel� pracownik2(id_pracownik, imie, nazwisko, pesel, data_zatr, pensja), gdzie
--* id_pracownik � jest numerem pracownika nadawanym automatycznie, jest to klucz g��wny
--* imie i nazwisko � to niepuste �a�cuchy znak�w zmiennej d�ugo�ci,
--* pesel � unikatowy �a�cuch jedenastu znak�w sta�ej d�ugo�ci,
--* data_zatr � domy�lna warto�� daty zatrudnienia to bie��ca data systemowa,
--* pensja � nie mo�e by� ni�sza ni� 1000z�.
CREATE TABLE pracownik2 (
  id_pracownik INT IDENTITY(1, 1) PRIMARY KEY,
  imie VARCHAR(15) NOT NULL,
  nazwisko VARCHAR(20) NOT NULL,
  pesel VARCHAR(11) UNIQUE,
  data_zatr DATETIME DEFAULT GETDATE(),
  pensja DECIMAL(5, 2) CHECK(pensja >= 1000)
);

--28.2 Utw�rz tabel� naprawa2(id_naprawa, data_przyjecia, opis_usterki, zaliczka), gdzie
--* id_naprawa � jest unikatowym, nadawanym automatycznie numerem naprawy, jest to klucz g��wny,
--* data_przyjecia � nie mo�e by� p�niejsza ni� bie��ca data systemowa,
--* opis usterki � nie mo�e by� pusty, musi mie� d�ugo�� powy�ej 10 znak�w,
--* zaliczka � nie mo�e by� mniejsza ni� 100z� ani wi�ksza ni� 1000z�.
CREATE TABLE naprawa2 (
  id_naprawa INT IDENTITY(1, 1) PRIMARY KEY,
  data_przyjecia DATETIME CHECK(data_przyjecia <= GETDATE()),
  opis_usterki VARCHAR(100) NOT NULL CHECK(LEN(opis_usterki) > 10),
  zaliczka DECIMAL(5, 2) CHECK(zaliczka >= 100 AND zaliczka <= 1000) 
  --alternatywnie w tym przypadku mo�e by�: zaliczka BETWEEN 100 AND 1000
);

--28.3 Utw�rz tabel� wykonane_naprawy2(id_pracownik, id_naprawa, data_naprawy, opis_naprawy, cena), gdzie
--* id_pracownik � identyfikator pracownika wykonuj�cego napraw�, klucz obcy powi�zany z tabel� pracownik2,
--* id_naprawa � identyfikator zg�oszonej naprawy, klucz obcy powi�zany z tabel� naprawa2,
--* data_naprawy � domy�lna warto�� daty naprawy to bie��ca data systemowa,
--* opis_naprawy � niepusty opis informuj�cy o sposobie naprawy,
--* cena � cena naprawy.
CREATE TABLE naprawy2(
  id_pracownik INT REFERENCES pracownik2(id_pracownik),
  id_naprawa INT REFERENCES naprawa2(id_naprawa),
  data_naprawy DATETIME DEFAULT GETDATE(),
  opis_naprawy VARCHAR(100) NOT NULL,
  cena DECIMAL(5, 2)
);

--29.1 Dana jest tabela 
CREATE TABLE student2(
  id_student INT IDENTITY(1,1) PRIMARY KEY,
  nazwisko VARCHAR(20),
  nr_indeksu INT,
  stypendium MONEY);
--Wprowad� ograniczenia na tabel� student2:
--* nazwisko � niepusta kolumna,
--* nr_indeksu � unikatowa kolumna,
--* stypendium �nie mo�e by� ni�sze ni� 1000z�,
--* dodatkowo dodaj niepust� kolumn� imie.
ALTER TABLE student2 ALTER COLUMN nazwisko VARCHAR(20) NOT NULL;
ALTER TABLE student2 ADD CONSTRAINT indeks_uq UNIQUE(nr_indeksu);
ALTER TABLE student2 ADD CONSTRAINT stypendium_lo CHECK(stypendium >= 1000);
ALTER TABLE student2 ADD imie VARCHAR(15) NOT NULL;

--29.2 Dane s� tabele: 
CREATE TABLE dostawca2(id_dostawca INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE towar2(id_towar INT IDENTITY(1,1) PRIMARY KEY, kod_kreskowy INT, id_dostawca INT);
--Zmodyfikuj powy�sze tabele:
--* kolumna nazwa z tabeli dostawca2 powinna by� unikatowa,
--* do tabeli towar2 dodaj niepust� kolumn� nazwa,
--* kolumna kod_kreskowy w tabeli towar2 powinna by� unikatowa,
--* kolumna id_dostawca z tabeli towar2 jest kluczem obcym z tabeli dostawca2.
ALTER TABLE dostawca2 ADD CONSTRAINT nazwa_uq UNIQUE(nazwa);
ALTER TABLE towar2 ADD nazwa VARCHAR(40) NOT NULL;
ALTER TABLE towar2 ADD CONSTRAINT kod_kresowy_uq UNIQUE(kod_kreskowy);
ALTER TABLE towar2 ADD CONSTRAINT id_dostawca_fk FOREIGN KEY (id_dostawca) REFERENCES dostawca2(id_dostawca);

--29.3 Dane s� tabele:
CREATE TABLE kraj2(id_kraj INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE gatunek2(id_gatunek INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE zwierze2(id_zwierze INT IDENTITY(1,1) PRIMARY KEY, id_gatunek INT, id_kraj INT, cena MONEY);
--Zmodyfikuj powy�sze tabele:
--* kolumny nazwa z tabel kraj2 i gatunek2 maj� by� niepuste,
--* kolumna id_gatunek z tabeli zwierze2 jest kluczem obcym z tabeli gatunek2,
--* kolumna id_kraj z tabeli zwierze2 jest kluczem obcym z tabeli kraj2.
ALTER TABLE kraj2 ALTER COLUMN nazwa VARCHAR(30) NOT NULL;
ALTER TABLE gatunek2 ALTER COLUMN nazwa VARCHAR(30) NOT NULL;
ALTER TABLE zwierze2 ADD CONSTRAINT id_gatunek_fk FOREIGN KEY (id_gatunek) REFERENCES gatunek2(id_gatunek);
ALTER TABLE zwierze2 ADD CONSTRAINT id_kraj_fk FOREIGN KEY (id_kraj) REFERENCES kraj2(id_kraj);

--30.1 Dane s� tabele: 
CREATE TABLE kategoria2(id_kategoria INT PRIMARY KEY, nazwa VARCHAR(30) );
CREATE TABLE przedmiot2(id_przedmiot INT PRIMARY KEY, id_kategoria INT REFERENCES kategoria2(id_kategoria), nazwa VARCHAR(30));
--Napisa� instrukcje SQL, kt�re usun� tabele kategoria2 i przedmiot2.
--Wsk: Zwr�� uwag� na kolejno�� usuwania tabel.
DROP TABLE przedmiot2;
DROP TABLE kategoria2;
--Wersja trudniejsza: Czy potrafisz najpierw sprawdzi�, czy tabele istniej� i je�li istniej� to dopiero wtedy je usun��?
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='przedmiot2')
  DROP TABLE przedmiot2;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='kategoria2')
  DROP TABLE kategoria2;

--30.2 Dana jest tabela: 
CREATE TABLE osoba2(id_osoba INT, imie VARCHAR(15), imie2 VARCHAR(15) );
--Napisa� instrukcj� SQL, kt�ra z tabeli osoba2 usunie kolumn� imie2.
ALTER TABLE osoba2 DROP COLUMN imie2;

--30.3 Dana jest tabela: 
CREATE TABLE uczen2(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) CONSTRAINT uczen_nazwisko_unique UNIQUE);
--Napisa� instrukcj� SQL, kt�ra usunie narzucony warunek unikatowo�ci na kolumn� nazwisko.
ALTER TABLE uczen2 DROP CONSTRAINT uczen_nazwisko_unique;
--Wersja trudniejsza: Czy potrafi�by� zrobi� powy�sze zadanie dla definicji tabeli:
--CREATE TABLE uczen3(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) CONSTRAINT UNIQUE);
--? Tu chyba jest b��d, bo nie da si� stworzy� CONSTRAINT bez nazwy, a z samym UNIQUE jest prosto:
CREATE TABLE uczen3(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) UNIQUE);
ALTER TABLE uczen3 ALTER COLUMN nazwisko VARCHAR(20);