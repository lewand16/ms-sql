--1.1 Wyœwietliæ zawartoœæ wszystkich kolumn z tabeli pracownik.
SELECT * FROM pracownik;

--1.2 Z tabeli pracownik wyœwietliæ same imiona pracowników.
SELECT imie FROM pracownik;

--1.3 Wyœwietliæ zawartoœæ kolumn imiê, nazwisko i dzia³ z tabeli pracownik.
SELECT imie, nazwisko, dzial FROM pracownik;

--2.1 Wyœwietliæ zawartoœæ kolumn imiê, nazwisko i pensja z tabeli pracownik. Wynik posortuj malej¹co wzglêdem pensji.
SELECT imie, nazwisko, pensja 
FROM pracownik 
ORDER BY pensja DESC;

--2.2 Wyœwietl zawartoœæ kolumn nazwisko i imiê z tabeli pracownik. Wynik posortuj rosn¹co (leksykograficznie) 
--wzglêdem nazwiska i imienia.
SELECT nazwisko, imie 
FROM pracownik 
ORDER BY nazwisko ASC, imie ASC;

--2.3 Wyœwietliæ zawartoœæ kolumn nazwisko, dzia³, stanowisko z tabeli pracownik. Wynik posortuj rosn¹co wzglêdem 
--dzia³u, a dla tych samych nazw dzia³ów malej¹co wzglêdem stanowiska.
SELECT nazwisko, dzial, stanowisko 
FROM pracownik 
ORDER BY dzial ASC, stanowisko DESC;

--3.1 Wyœwietliæ niepowtarzaj¹ce siê wartoœci kolumny dzia³ z tabeli pracownik.
SELECT DISTINCT dzial FROM pracownik;

--3.2 Wyœwietliæ unikatowe wiersze zawieraj¹ce wartoœci kolumn dzia³ i stanowisko w tabeli pracownik.
SELECT DISTINCT dzial, stanowisko FROM pracownik;

--3.3 Wyœwietliæ unikatowe wiersze zawieraj¹ce wartoœci kolumn dzia³ i stanowisko w tabeli pracownik. Wynik posortuj
--malej¹co wzglêdem dzia³u i stanowiska.
SELECT DISTINCT dzial, stanowisko FROM pracownik
ORDER BY dzial DESC, stanowisko DESC;

--4.1 ZnajdŸ pracowników o imieniu Jan. Wyœwietl ich imiona i nazwiska.
SELECT imie FROM pracownik WHERE imie = 'Jan';

--4.2 Wyœwietliæ imiona i nazwiska pracowników pracuj¹cych na stanowisku sprzedawca.
SELECT imie, nazwisko 
	FROM pracownik 
	WHERE stanowisko = 'sprzedawca';

--4.3 Wyœwietliæ imiona, nazwiska, pensje pracowników, którzy zarabiaj¹ powy¿ej 1500 z³. Wynik posortuj malej¹co
--wzglêdem pensji.
SELECT imie, nazwisko, pensja 
	FROM pracownik 
	WHERE pensja > 1500 
	ORDER BY pensja DESC;

--5.1 Z tabeli pracownik wyœwietliæ imiona, nazwiska, dzia³y, stanowiska tych pracowników, którzy pracuj¹ w dziale
--obs³ugi klienta na stanowisku sprzedawca.
SELECT imie, nazwisko, dzial, stanowisko
	FROM pracownik
	WHERE dzial = 'obs³uga klienta' AND
		stanowisko = 'sprzedawca';

--5.2 ZnaleŸæ pracowników pracuj¹cych w dziale technicznym na stanowisku kierownika lub sprzedawcy. Wyœwietl
--imiê, nazwisko, dzia³, stanowisko.
SELECT imie, nazwisko, dzial, stanowisko
	FROM pracownik
	WHERE 
		dzial = 'techniczny' AND (
		stanowisko = 'kierownik' OR
		stanowisko = 'sprzedawca'
		);

--5.3 ZnaleŸæ samochody, które nie s¹ marek fiat i ford.
SELECT marka 
	FROM samochod
	WHERE 
		marka != 'fiat' AND
		marka != 'ford';

--6.1 ZnaleŸæ samochody marek mercedes, seat i opel.
SELECT * 
	FROM samochod
	WHERE marka IN ('mercedes', 'seat', 'opel');

--6.2 ZnajdŸ pracowników o imionach Anna, Marzena i Alicja. Wyœwietl ich imiona, nazwiska i daty zatrudnienia.
SELECT imie, nazwisko, data_zatr
	FROM pracownik
	WHERE imie IN ('Anna', 'Marzena', 'Alicja');

--6.3 ZnajdŸ klientów, którzy nie mieszkaj¹ w Warszawie lub we Wroc³awiu. Wyœwietl ich imiona, nazwiska i miasta
--zamieszkania.
SELECT imie, nazwisko, miasto
	FROM klient
	WHERE miasto NOT IN ('Warszawa', 'Wroc³aw');

--7.1 Wyœwietliæ imiona i nazwiska klientów, których nazwisko zawiera literê K.
SELECT imie, nazwisko
	FROM klient
	WHERE nazwisko LIKE '%K%';

--7.2 Wyœwietliæ imiona i nazwiska klientów, dla których nazwisko zaczyna siê na D, a koñczy siê na SKI.
SELECT imie, nazwisko
	FROM klient
	WHERE nazwisko LIKE 'D%SKI';

--7.3 ZnaleŸæ imiona i nazwiska klientów, których nazwisko zawiera drug¹ literê O lub A.
SELECT imie, nazwisko
	FROM klient
	WHERE nazwisko LIKE '_[ao]%';

--8.1 Z tabeli samochód wyœwietliæ wiersze, dla których pojemnoœæ silnika jest z przedzia³u [1100,1600].
SELECT *
	FROM samochod
	WHERE poj_silnika BETWEEN 1100 AND 1600;

--8.2 ZnaleŸæ pracowników, którzy zostali zatrudnieni pomiêdzy datami 1997-01-01 a 1997-12-31.
SELECT *
	FROM pracownik
	WHERE data_zatr BETWEEN '1997-01-01' AND '1997-12-31';

--8.3 ZnaleŸæ samochody, dla których przebieg jest pomiêdzy 10000 a 20000 km lub pomiêdzy 30000 a 40000 km.
SELECT *
	FROM samochod
	WHERE przebieg BETWEEN 10000 AND 20000 
	OR (przebieg BETWEEN 30000 AND 40000);

--9.1 ZnaleŸæ pracowników, którzy nie maj¹ okreœlonego dodatku do pensji.
SELECT *
  FROM pracownik
  WHERE dodatek IS NULL;

--9.2 Wyœwietliæ klientów, którzy posiadaj¹ kartê kredytow¹.
SELECT *
  FROM klient
  WHERE nr_karty_kredyt IS NOT NULL;

--9.3 Dla ka¿dego pracownika wyœwietl imiê, nazwisko i wysokoœæ dodatku. Wartoœæ NULL z kolumny dodatek powinna
--byæ wyœwietlona jako 0. Wskazówka: U¿yj funkcji COALESCE.
SELECT imie, nazwisko, COALESCE (dodatek, 0) AS dodatek
  FROM pracownik;

--10.1 Wyœwietliæ imiona, nazwiska pracowników ich pensje i dodatki oraz kolumnê wyliczeniow¹ do_zap³aty,
--zawieraj¹c¹ sumê pensji i dodatku. Wskazówka: Wartoœæ NULL z kolumny dodatek powinna byæ wyœwietlona jako
--zero
SELECT imie, nazwisko, pensja, COALESCE (dodatek, 0) AS dodatek, (pensja + COALESCE (dodatek, 0)) AS do_zaplaty
  FROM pracownik;

--10.2 Dla ka¿dego pracownika wyœwietl imiê, nazwisko i wyliczeniow¹ kolumnê nowa_pensja, która bêdzie mia³a o
--50% wiêksz¹ wartoœæ ni¿ dotychczasowa pensja.
SELECT imie, nazwisko, (pensja * 1.5) AS nowa_pensja
  FROM pracownik;

--10.3 Dla ka¿dego pracownika oblicz ile wynosi 1% zarobków (pensja + dodatek). Wyœwietl imiê, nazwisko i obliczony
--1%. Wyniki posortuj rosn¹co wzglêdem obliczonego 1%.
SELECT imie, nazwisko, ((pensja + COALESCE (dodatek, 0)) * 0.01) AS procent
  FROM pracownik;

--11.1 ZnajdŸ imiê i nazwisko pracownika, który jako pierwszy zosta³ zatrudniony w wypo¿yczalni samochodów.
--(Jest tylko jeden taki pracownik.)
SELECT TOP 1 imie, nazwisko
  FROM pracownik
  ORDER BY data_zatr ASC;

--11.2 Wyœwietl pierwszych czterech pracowników z alfabetycznej listy (nazwiska i imiona) wszystkich pracowników.
--(W tym zadaniu nie musisz siê przejmowaæ powtórkami imion i nazwisk, ale gdybyœ chcia³ to sprawdŸ konstrukcjê
--SELECT TOP x WITH TIES …)
SELECT TOP 4 imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko ASC, imie ASC;

-- SELECT TOP x WITH TIES spowoduje, ¿e nawet ograniczona lista powiêkszy siê, jeœli na ostatniej pozycji bêdzie 
--kilka identycznych
SELECT TOP 3 WITH TIES imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko ASC, imie ASC;

--11.3 Wyszukaj informacjê o ostatnim wypo¿yczeniu samochodu.
SELECT TOP 1 *
  FROM wypozyczenie
  ORDER BY data_wyp DESC;

--12.1 Wyszukaj pracowników zatrudnionych w maju. Wyœwietl ich imiona, nazwiska i datê zatrudnienia. Wynik
--posortuj rosn¹co wzglêdem nazwiska i imienia.
--Wskazówka: Zajrzyj do dokumentacji MS SQL i poczytaj o funkcjach: DAY, MONTH, YEAR, GETDATE, DATEDIFF.
SELECT imie, nazwisko, data_zatr
  FROM pracownik
  WHERE MONTH(data_zatr) = 5
  ORDER BY nazwisko ASC, imie ASC;

--12.2 Dla ka¿dego pracownika (imiê i nazwisko) oblicz ile ju¿ pracuje dni. Wynik posortuj malej¹co wed³ug iloœci
--przepracowanych dni.
 SELECT imie, nazwisko, (DATEDIFF(DAY, data_zatr, GETDATE())) AS liczba_dni_zatrudnienia
   FROM pracownik
   ORDER BY liczba_dni_zatrudnienia DESC;

--12.3 Dla ka¿dego samochodu (marka, typ) oblicz ile lat up³ynê³o od jego produkcji. Wynik posortuj malej¹co po iloœci
--lat.
SELECT marka, typ, (DATEDIFF(YEAR, data_prod, GETDATE())) AS liczba_lat_od_produkcji
  FROM samochod
  ORDER BY liczba_lat_od_produkcji DESC;

--13.1 Wyœwietl imiê, nazwisko i inicja³y ka¿dego klienta. Wynik posortuj wzglêdem inicja³ów, nazwiska i imienia
--klienta.
--Wskazówka: Zajrzyj do dokumentacji MS SQL i poczytaj o funkcjach: LEFT, RIGHT, LEN, UPPER, LOWER, STUFF.
SELECT imie, nazwisko, (LEFT(imie, 1) + '. ' + LEFT(nazwisko, 1)) AS inicjaly
  FROM pracownik
  ORDER BY inicjaly ASC, nazwisko ASC, imie ASC;

--13.2 Wyœwietl imiona i nazwiska klientów w taki sposób, aby pierwsza litera imienia i nazwiska by³a wielka, a
--pozosta³e ma³e.
SELECT (UPPER(LEFT(imie, 1)) + LOWER(RIGHT(imie, LEN(imie) - 1))) AS imie, (UPPER(LEFT(nazwisko, 1)) + LOWER(RIGHT(nazwisko, LEN(nazwisko) - 1))) AS nazwisko
  FROM pracownik;

--13.3 Wyœwietl imiona, nazwiska i numery kart kredytowych klientów. Ka¿da z ostatnich szeœciu cyfr wyœwietlanego
--numeru karty kredytowej klienta powinna byæ zast¹piona znakiem x .
SELECT imie, nazwisko, (LEFT(nr_karty_kredyt, LEN(nr_karty_kredyt) - 6) + 'xxxxxx') AS nr_karty_kredytowej
  FROM klient;

--14.1 Pracownikom, którzy nie maj¹ okreœlonej wysokoœci dodatku nadaj dodatek w wysokoœci 50 z³.
SELECT dodatek FROM pracownik; --przed zmianami

UPDATE pracownik
  SET dodatek = 50
  WHERE dodatek IS NULL;

SELECT dodatek FROM pracownik; --po zmianach

--14.2 Klientowi o identyfikatorze równym 10 zmieñ imiê i nazwisko na Jerzy Nowak.
SELECT imie, nazwisko FROM pracownik; --przed zmianami

UPDATE pracownik
  SET imie = 'Jerzy', nazwisko = 'Nowak'
  WHERE id_pracownik = 10;

SELECT imie, nazwisko FROM pracownik; --po zmianach

--14.3 Zwiêksz o 100 z³ dodatek pracownikom, których pensja jest mniejsza ni¿ 1500 z³.
SELECT pensja, dodatek FROM pracownik; --przed zmianami

UPDATE pracownik
  SET dodatek = dodatek + 100
  WHERE pensja < 1500;

SELECT pensja, dodatek FROM pracownik; --po zmianach

--15.1 Usun¹æ klienta o identyfikatorze równym 17.
SELECT * FROM klient; --przed zmianami

DELETE FROM klient
  WHERE id_klient = 17;

SELECT * FROM klient; --po zmianach

--15.2 Usun¹æ wszystkie informacje o wypo¿yczeniach dla klienta o identyfikatorze równym 17.
SELECT * FROM wypozyczenie ORDER BY id_klient ASC; --przed zmianami

DELETE FROM wypozyczenie
  WHERE id_klient = 17;

SELECT * FROM wypozyczenie ORDER BY id_klient ASC; --po zmianach

--15.3 Usuñ wszystkie samochody o przebiegu wiêkszym ni¿ 60000.
SELECT * FROM samochod ORDER BY przebieg ASC; --przed zmianami

DELETE FROM samochod
  WHERE przebieg > 60000;

SELECT * FROM samochod ORDER BY przebieg ASC; --po zmianach

--16.1 Dodaj do bazy danych klienta o identyfikatorze równym 121: Adam Cichy zamieszka³y ul. Korzenna 12, 00-950
--Warszawa, tel. 123-454-321.
INSERT INTO klient(id_klient, imie, nazwisko, ulica, numer, kod, miasto, telefon)
  VALUES(121, 'Adam', 'Cichy', 'Korzenna', '12', '00-950', 'Warszawa', '123-454-321');

SELECT * FROM klient WHERE id_klient = 121; --sprawdzenie po zmianach

--16.2 Dodaj do bazy danych nowy samochód o identyfikatorze równym 50: srebrna skoda octavia o pojemnoœci silnika
--1896 cm3 wyprodukowana 1 wrzeœnia 2012 r. i o przebiegu 5 000 km.
INSERT INTO samochod(id_samochod, kolor, marka, typ, poj_silnika, data_prod, przebieg)
  VALUES(50, 'srebrny', 'skoda', 'octavia', 1896, '2012-09-01', 5000);

SELECT * FROM samochod WHERE id_samochod = 50; --sprawdzenie po zmianach

--16.3 Dodaj do bazy danych pracownika: Alojzy Mikos zatrudniony od 11 sierpnia 2010 r. w dziale zaopatrzenie na
--stanowisku magazyniera z pensj¹ 3000 z³ i dodatkiem 50 z³, telefon do pracownika: 501-501-501, pracownik pracuje w
--Warszawie na ul. Lewartowskiego 12, kod pocztowy: 00-950.
INSERT INTO miejsce(id_miejsce, miasto, ulica, numer, kod)
  VALUES((SELECT TOP 1 id_miejsce FROM miejsce ORDER BY id_miejsce DESC) + 1 , 'Warszawa', 'Lewartowskiego', '12', '00-950');
INSERT INTO pracownik(id_pracownik, imie, nazwisko, data_zatr, dzial, stanowisko, pensja, dodatek, telefon, id_miejsce)
  VALUES((SELECT TOP 1 id_pracownik FROM pracownik ORDER BY id_pracownik DESC) + 1 ,'Alojzy', 'Mikos', '2010-08-11', 'zaopatrzenie', 'magazynier', 3000, 50, '501-501-501', (SELECT id_miejsce FROM miejsce WHERE miasto = 'Warszawa' AND ulica = 'Lewartowskiego' AND numer = '12' AND kod = '00-950'));
  --lub proœciej
INSERT INTO miejsce(id_miejsce, miasto, ulica, numer, kod)
  VALUES((SELECT TOP 1 id_miejsce FROM miejsce ORDER BY id_miejsce DESC) + 1 , 'Warszawa', 'Lewartowskiego', '12', '00-950');
INSERT INTO pracownik(id_pracownik, imie, nazwisko, data_zatr, dzial, stanowisko, pensja, dodatek, telefon, id_miejsce)
  VALUES((SELECT TOP 1 id_pracownik FROM pracownik ORDER BY id_pracownik DESC) + 1 ,'Alojzy', 'Mikos', '2010-08-11', 'zaopatrzenie', 'magazynier', 3000, 50, '501-501-501', (SELECT TOP 1 id_miejsce FROM miejsce ORDER BY id_miejsce DESC));
SELECT * FROM pracownik; --sprawdzenie po zmianach
SELECT * FROM miejsce; --sprawdzenie po zmianach

--17.1 Wyszukaj samochody, które nie zosta³y zwrócone. (Data oddania samochodu ma mieæ wartoœæ NULL.) Wyœwietl
--identyfikator, markê i typ samochodu oraz jego datê wypo¿yczenia i oddania.
SELECT s.id_samochod, s.marka, s.typ, w.data_wyp, w.data_odd
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  WHERE w.data_odd IS NULL;

--17.2 Wyszukaj klientów, którzy nie zwrócili jeszcze samochodu. (Data oddania samochodu ma mieæ wartoœæ NULL.)
--Wyœwietl imiê i nazwisko klienta oraz identyfikator samochodu i datê wypo¿yczenia nie zwróconego jeszcze
--samochodu. Wynik posortuj rosn¹co wzglêdem nazwiska i imienia klienta.
SELECT k.imie, k.nazwisko, w.id_samochod, w.data_wyp
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  WHERE w.data_odd IS NULL
  ORDER BY k.nazwisko ASC, k.imie ASC;

--17.3 Wœród klientów wypo¿yczalni wyszukaj daty i kwoty wp³aconych przez nich kaucji. Wyœwietl imiê i nazwisko
--klienta oraz datê wp³acenia kaucji (data wypo¿yczenia samochodu jest równoczeœnie dat¹ wp³acenia kaucji) i jej
--wysokoœæ (pomiñ kaucje maj¹ce wartoœæ NULL)
SELECT k.imie, k.nazwisko, w.data_wyp, w.kaucja
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  WHERE w.kaucja IS NOT NULL;

--18.1 Dla ka¿dego klienta, który choæ raz wypo¿yczy³ samochód, wyszukaj jakie i kiedy wypo¿yczy³ samochody.
--Wyœwietl imiê i nazwisko klienta oraz datê wypo¿yczenia, markê i typ wypo¿yczonego samochodu. Wynik posortuj
--rosn¹co po nazwisku i imieniu klienta oraz marce i typie samochodu.
SELECT k.imie, k.nazwisko, w.data_wyp, s.marka, s.typ
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient INNER JOIN samochod s
    ON s.id_samochod = w.id_samochod
  ORDER BY k.nazwisko ASC, k.imie ASC, s.marka ASC, s.typ ASC;

--18.2 Dla ka¿dej filii wypo¿yczalni samochodów (tabela miejsce) wyszukaj jakie samochody by³y wypo¿yczane.
--Wyœwietl adres filii (ulica i numer) oraz markê i typ wypo¿yczonego samochodu. Wyniki posortuj rosn¹co wzglêdem
--adresu filii, marki i typu samochodu.
SELECT DISTINCT m.ulica, m.numer, s.marka, s.typ
  FROM miejsce m INNER JOIN wypozyczenie w
  ON m.id_miejsce = w.id_miejsca_wyp INNER JOIN samochod s
    ON s.id_samochod=w.id_samochod
  ORDER BY m.ulica ASC, m.numer ASC, s.marka ASC, s.typ ASC;

--18.3 Dla ka¿dego wypo¿yczonego samochodu wyszukaj informacjê jacy klienci go wypo¿yczali. Wyœwietl
--identyfikator, markê i typ samochodu oraz imiê i nazwisko klienta. Wyniki posortuj rosn¹co po identyfikatorze
--samochodu oraz nazwisku i imieniu klienta.
SELECT DISTINCT s.id_samochod, s.marka, s.typ, k.imie, k.nazwisko
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod INNER JOIN klient k
    ON k.id_klient=w.id_klient
  ORDER BY s.id_samochod ASC, k.nazwisko ASC, k.imie ASC;

--19.1 ZnaleŸæ najwiêksz¹ pensjê pracownika wypo¿yczalni samochodów.
SELECT MAX(pensja) FROM pracownik;

--19.2 ZnaleŸæ œredni¹ pensjê pracownika wypo¿yczalni samochodów.
SELECT AVG(pensja) FROM pracownik;

--19.3 ZnaleŸæ najwczeœniejsz¹ datê wyprodukowania samochodu.
SELECT MIN(data_prod) FROM samochod;

--20.1 Dla ka¿dego klienta wypisz imiê, nazwisko i ³¹czn¹ iloœæ wypo¿yczeñ samochodów (nie zapomnij o zerowej liczbie
--wypo¿yczeñ). Wynik posortuj malej¹co wzglêdem iloœci wypo¿yczeñ.
SELECT k.imie, k.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM klient k LEFT JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  GROUP BY k.imie, k.nazwisko
  ORDER BY ilosc_wypozyczen DESC;

--20.2 Dla ka¿dego samochodu (identyfikator, marka, typ) oblicz iloœæ wypo¿yczeñ. Wynik posortuj rosn¹co wzglêdem
--iloœci wypo¿yczeñ. (Nie zapomnij o samochodach, które ani razu nie zosta³y wypo¿yczone.)
SELECT s.id_samochod, s.marka, s.typ, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM samochod s LEFT JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  GROUP BY s.id_samochod, s.marka, s.typ
  ORDER BY ilosc_wypozyczen ASC;

--20.3 Dla ka¿dego pracownika oblicz ile wypo¿yczy³ samochodów klientom. Wyœwietl imiê i nazwisko pracownika oraz
--iloœæ wypo¿yczeñ. Wynik posortuj malej¹co po iloœci wypo¿yczeñ. (Nie zapomnij o pracownikach, którzy nie
--wypo¿yczyli ¿adnego samochodu.)
SELECT p.imie, p.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM pracownik p LEFT JOIN wypozyczenie w
  ON p.id_pracownik = w.id_pracow_wyp
  GROUP BY p.imie, p.nazwisko
  ORDER BY ilosc_wypozyczen DESC;

--21.1 ZnajdŸ klientów, którzy co najmniej 2 razy wypo¿yczyli samochód. Wypisz dla tych klientów imiê, nazwisko i iloœæ
--wypo¿yczeñ. Wynik posortuj rosn¹co wzglêdem nazwiska i imienia
SELECT k.imie, k.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM klient k INNER JOIN wypozyczenie w
  ON k.id_klient = w.id_klient
  GROUP BY k.imie, k.nazwisko
  HAVING COUNT(w.data_wyp) >= 2
  ORDER BY k.nazwisko ASC, k.imie ASC;

--21.2 ZnajdŸ samochody, które by³y wypo¿yczone co najmniej 5 razy. Wyœwietl identyfikator samochodu, markê, typ i
--iloœæ wypo¿yczeñ. Wynik posortuj rosn¹co wzglêdem marki i typu samochodu
SELECT s.id_samochod, s.marka, s.typ, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM samochod s INNER JOIN wypozyczenie w
  ON s.id_samochod = w.id_samochod
  GROUP BY s.id_samochod, s.marka, s.typ
  HAVING COUNT(w.data_wyp) >=5
  ORDER BY s.marka ASC, s.typ ASC;

--21.3 ZnajdŸ pracowników, którzy klientom wypo¿yczyli co najwy¿ej 20 razy samochód. Wyœwietl imiona i nazwiska
--pracowników razem z iloœci¹ wypo¿yczeñ. Wynik posortuj rosn¹co wzglêdem iloœci wypo¿yczeñ, nazwiska i imienia
--pracownika. (Uwzglêdnij pracowników, którzy nie wypo¿yczyli ¿adnego samochodu.)
SELECT p.imie, p.nazwisko, COALESCE(COUNT(w.data_wyp), 0) AS ilosc_wypozyczen
  FROM pracownik p LEFT JOIN wypozyczenie w
  ON p.id_pracownik = w.id_pracow_wyp
  GROUP BY p.imie, p.nazwisko
  HAVING COUNT(w.data_wyp) <= 20
  ORDER BY ilosc_wypozyczen ASC, p.nazwisko ASC, p.imie ASC;

--22.1 Wyœwietl imiona, nazwiska i pensje pracowników, którzy posiadaj¹ najwy¿sz¹ pensjê.
SELECT imie, nazwisko, pensja
  FROM pracownik
  WHERE pensja = (
    SELECT MAX(pensja) 
	FROM pracownik);

--22.2 Wyœwietl pracowników (imiona, nazwiska, pensje), którzy zarabiaj¹ powy¿ej œredniej pensji.
SELECT imie, nazwisko, pensja
  FROM pracownik
  WHERE pensja > (
    SELECT AVG(pensja)
	FROM pracownik);

--22.3 Wyszukaj samochód (marka, typ, data produkcji), który zosta³ wyprodukowany najwczeœniej. Mo¿e siê tak
--zdarzyæ, ¿e kilka samochodów zosta³o wyprodukowanych w ten sam "najwczeœniejszy" dzieñ.
SELECT marka, typ, data_prod
  FROM samochod
  WHERE data_prod = (
    SELECT MIN(data_prod)
	FROM samochod);

--23.1 Wyœwietl wszystkie samochody (marka, typ, data produkcji), które do tej pory nie zosta³y wypo¿yczone.
SELECT marka, typ, data_prod
  FROM samochod
  WHERE id_samochod NOT IN
    (SELECT DISTINCT id_samochod
	FROM wypozyczenie);

--23.2 Wyœwietl klientów (imiê i nazwisko), którzy do tej pory nie wypo¿yczyli ¿adnego samochodu. Wynik posortuj
--rosn¹co wzglêdem nazwiska i imienia klienta
SELECT imie, nazwisko
  FROM klient
  WHERE id_klient NOT IN
    (SELECT DISTINCT id_klient
	FROM wypozyczenie)
  ORDER BY nazwisko ASC, imie ASC;

--23.3 ZnaleŸæ pracowników (imiê i nazwisko), którzy do tej pory nie wypo¿yczyli ¿adnego samochodu klientowi.
SELECT imie, nazwisko
  FROM pracownik
  WHERE id_pracownik NOT IN
    (SELECT DISTINCT id_pracow_wyp
	FROM wypozyczenie);

--24.1 ZnajdŸ samochód/samochody (id_samochod, marka, typ), który by³ najczêœciej wypo¿yczany. Wynik posortuj
--rosn¹co (leksykograficznie) wzglêdem marki i typu.
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

--24.2 ZnajdŸ klienta/klientów (id_klient, imie, nazwisko), którzy najrzadziej wypo¿yczali samochody. Wynik posortuj
--rosn¹co wzglêdem nazwiska i imienia. Nie uwzglêdniaj klientów, którzy ani razu nie wypo¿yczyli samochodu.
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

--24.3 ZnajdŸ pracownika/pracowników (id_pracownik, nazwisko, imie), który wypo¿yczy³ najwiêcej samochodów
--klientom. Wynik posortuj rosn¹co (leksykograficznie) wzglêdem nazwiska i imienia pracownika.
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

--25.1 Podwy¿szyæ o 10% pensjê pracownikom, którzy zarabiaj¹ poni¿ej œredniej.
UPDATE pracownik
  SET pensja = pensja * 1.1
  WHERE pensja < (
    SELECT AVG(pensja)
	  FROM pracownik
  );

--25.2 Pracownikom, którzy w maju wypo¿yczyli samochód klientowi zwiêksz dodatek o 10 z³.
UPDATE pracownik
  SET dodatek = dodatek + 10
  WHERE id_pracownik IN (
    SELECT id_pracow_wyp
	  FROM wypozyczenie
	  WHERE MONTH(data_wyp) = 5
  );

--25.3 Obni¿yæ pensje o 5% wszystkim pracownikom którzy nie wypo¿yczyli klientowi samochodu w 1999 roku.
UPDATE pracownik
  SET pensja = pensja * 0.95
  WHERE id_pracownik IN (
    SELECT DISTINCT id_pracow_wyp
	  FROM wypozyczenie
	  WHERE YEAR(data_wyp) != 1999
  );

--26.1 Usun¹æ klientów, którzy nie wypo¿yczyli ¿adnego samochodu
DELETE FROM klient
  WHERE id_klient NOT IN (
    SELECT DISTINCT id_klient
	  FROM wypozyczenie
  );
--alternatywnie, dotyczy te¿ kolejnych zadañ
DELETE FROM klient
  WHERE id_klient != ALL (
    SELECT DISTINCT id_klient
	  FROM wypozyczenie
  );

--26.2 Usun¹æ samochody, które nie zosta³y ani razu wypo¿yczone.
DELETE FROM samochod
  WHERE id_samochod NOT IN (
    SELECT DISTINCT id_samochod
	  FROM wypozyczenie
  );

--26.3 Usun¹æ pracowników, którzy klientom nie wypo¿yczyli ¿adnego samochodu.
DELETE FROM pracownik
  WHERE id_pracownik NOT IN (
    SELECT DISTINCT id_pracow_wyp
	  FROM wypozyczenie
  );

--27.1 Wyœwietl razem wszystkie imiona i nazwiska pracowników i klientów. (Suma dwóch zbiorów.) Wynik posortuj
--wzglêdem nazwiska i imienia. Rozpatrz dwa przypadki
--a) z pominiêciem duplikatów,
SELECT imie, nazwisko
  FROM pracownik
UNION
SELECT imie, nazwisko
  FROM klient
  ORDER BY nazwisko, imie;

--b) z wyœwietleniem duplikatów (pe³na suma).
SELECT imie, nazwisko
  FROM pracownik
UNION ALL
SELECT imie, nazwisko
  FROM klient
  ORDER BY nazwisko, imie;

--27.2 Wyœwietl powtarzaj¹ce siê imiona i nazwiska klientów i pracowników. (Czêœæ wspólna dwóch zbiorów.)
SELECT imie, nazwisko
  FROM klient
INTERSECT
SELECT imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko, imie;

--27.3 Wyœwietl imiona i nazwiska klientów, którzy nazywaj¹ siê inaczej ni¿ pracownicy. (Ró¿nica dwóch zbiorów.)
--Wynik posortuj wzglêdem nazwiska i imienia.
SELECT imie, nazwisko
  FROM klient
EXCEPT
SELECT imie, nazwisko
  FROM pracownik
  ORDER BY nazwisko, imie;

--28.1 Utwórz tabelê pracownik2(id_pracownik, imie, nazwisko, pesel, data_zatr, pensja), gdzie
--* id_pracownik – jest numerem pracownika nadawanym automatycznie, jest to klucz g³ówny
--* imie i nazwisko – to niepuste ³añcuchy znaków zmiennej d³ugoœci,
--* pesel – unikatowy ³añcuch jedenastu znaków sta³ej d³ugoœci,
--* data_zatr – domyœlna wartoœæ daty zatrudnienia to bie¿¹ca data systemowa,
--* pensja – nie mo¿e byæ ni¿sza ni¿ 1000z³.
CREATE TABLE pracownik2 (
  id_pracownik INT IDENTITY(1, 1) PRIMARY KEY,
  imie VARCHAR(15) NOT NULL,
  nazwisko VARCHAR(20) NOT NULL,
  pesel VARCHAR(11) UNIQUE,
  data_zatr DATETIME DEFAULT GETDATE(),
  pensja DECIMAL(5, 2) CHECK(pensja >= 1000)
);

--28.2 Utwórz tabelê naprawa2(id_naprawa, data_przyjecia, opis_usterki, zaliczka), gdzie
--* id_naprawa – jest unikatowym, nadawanym automatycznie numerem naprawy, jest to klucz g³ówny,
--* data_przyjecia – nie mo¿e byæ póŸniejsza ni¿ bie¿¹ca data systemowa,
--* opis usterki – nie mo¿e byæ pusty, musi mieæ d³ugoœæ powy¿ej 10 znaków,
--* zaliczka – nie mo¿e byæ mniejsza ni¿ 100z³ ani wiêksza ni¿ 1000z³.
CREATE TABLE naprawa2 (
  id_naprawa INT IDENTITY(1, 1) PRIMARY KEY,
  data_przyjecia DATETIME CHECK(data_przyjecia <= GETDATE()),
  opis_usterki VARCHAR(100) NOT NULL CHECK(LEN(opis_usterki) > 10),
  zaliczka DECIMAL(5, 2) CHECK(zaliczka >= 100 AND zaliczka <= 1000) 
  --alternatywnie w tym przypadku mo¿e byæ: zaliczka BETWEEN 100 AND 1000
);

--28.3 Utwórz tabelê wykonane_naprawy2(id_pracownik, id_naprawa, data_naprawy, opis_naprawy, cena), gdzie
--* id_pracownik – identyfikator pracownika wykonuj¹cego naprawê, klucz obcy powi¹zany z tabel¹ pracownik2,
--* id_naprawa – identyfikator zg³oszonej naprawy, klucz obcy powi¹zany z tabel¹ naprawa2,
--* data_naprawy – domyœlna wartoœæ daty naprawy to bie¿¹ca data systemowa,
--* opis_naprawy – niepusty opis informuj¹cy o sposobie naprawy,
--* cena – cena naprawy.
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
--WprowadŸ ograniczenia na tabelê student2:
--* nazwisko – niepusta kolumna,
--* nr_indeksu – unikatowa kolumna,
--* stypendium –nie mo¿e byæ ni¿sze ni¿ 1000z³,
--* dodatkowo dodaj niepust¹ kolumnê imie.
ALTER TABLE student2 ALTER COLUMN nazwisko VARCHAR(20) NOT NULL;
ALTER TABLE student2 ADD CONSTRAINT indeks_uq UNIQUE(nr_indeksu);
ALTER TABLE student2 ADD CONSTRAINT stypendium_lo CHECK(stypendium >= 1000);
ALTER TABLE student2 ADD imie VARCHAR(15) NOT NULL;

--29.2 Dane s¹ tabele: 
CREATE TABLE dostawca2(id_dostawca INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE towar2(id_towar INT IDENTITY(1,1) PRIMARY KEY, kod_kreskowy INT, id_dostawca INT);
--Zmodyfikuj powy¿sze tabele:
--* kolumna nazwa z tabeli dostawca2 powinna byæ unikatowa,
--* do tabeli towar2 dodaj niepust¹ kolumnê nazwa,
--* kolumna kod_kreskowy w tabeli towar2 powinna byæ unikatowa,
--* kolumna id_dostawca z tabeli towar2 jest kluczem obcym z tabeli dostawca2.
ALTER TABLE dostawca2 ADD CONSTRAINT nazwa_uq UNIQUE(nazwa);
ALTER TABLE towar2 ADD nazwa VARCHAR(40) NOT NULL;
ALTER TABLE towar2 ADD CONSTRAINT kod_kresowy_uq UNIQUE(kod_kreskowy);
ALTER TABLE towar2 ADD CONSTRAINT id_dostawca_fk FOREIGN KEY (id_dostawca) REFERENCES dostawca2(id_dostawca);

--29.3 Dane s¹ tabele:
CREATE TABLE kraj2(id_kraj INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE gatunek2(id_gatunek INT IDENTITY(1,1) PRIMARY KEY, nazwa VARCHAR(30));
CREATE TABLE zwierze2(id_zwierze INT IDENTITY(1,1) PRIMARY KEY, id_gatunek INT, id_kraj INT, cena MONEY);
--Zmodyfikuj powy¿sze tabele:
--* kolumny nazwa z tabel kraj2 i gatunek2 maj¹ byæ niepuste,
--* kolumna id_gatunek z tabeli zwierze2 jest kluczem obcym z tabeli gatunek2,
--* kolumna id_kraj z tabeli zwierze2 jest kluczem obcym z tabeli kraj2.
ALTER TABLE kraj2 ALTER COLUMN nazwa VARCHAR(30) NOT NULL;
ALTER TABLE gatunek2 ALTER COLUMN nazwa VARCHAR(30) NOT NULL;
ALTER TABLE zwierze2 ADD CONSTRAINT id_gatunek_fk FOREIGN KEY (id_gatunek) REFERENCES gatunek2(id_gatunek);
ALTER TABLE zwierze2 ADD CONSTRAINT id_kraj_fk FOREIGN KEY (id_kraj) REFERENCES kraj2(id_kraj);

--30.1 Dane s¹ tabele: 
CREATE TABLE kategoria2(id_kategoria INT PRIMARY KEY, nazwa VARCHAR(30) );
CREATE TABLE przedmiot2(id_przedmiot INT PRIMARY KEY, id_kategoria INT REFERENCES kategoria2(id_kategoria), nazwa VARCHAR(30));
--Napisaæ instrukcje SQL, które usun¹ tabele kategoria2 i przedmiot2.
--Wsk: Zwróæ uwagê na kolejnoœæ usuwania tabel.
DROP TABLE przedmiot2;
DROP TABLE kategoria2;
--Wersja trudniejsza: Czy potrafisz najpierw sprawdziæ, czy tabele istniej¹ i jeœli istniej¹ to dopiero wtedy je usun¹æ?
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='przedmiot2')
  DROP TABLE przedmiot2;
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='kategoria2')
  DROP TABLE kategoria2;

--30.2 Dana jest tabela: 
CREATE TABLE osoba2(id_osoba INT, imie VARCHAR(15), imie2 VARCHAR(15) );
--Napisaæ instrukcjê SQL, która z tabeli osoba2 usunie kolumnê imie2.
ALTER TABLE osoba2 DROP COLUMN imie2;

--30.3 Dana jest tabela: 
CREATE TABLE uczen2(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) CONSTRAINT uczen_nazwisko_unique UNIQUE);
--Napisaæ instrukcjê SQL, która usunie narzucony warunek unikatowoœci na kolumnê nazwisko.
ALTER TABLE uczen2 DROP CONSTRAINT uczen_nazwisko_unique;
--Wersja trudniejsza: Czy potrafi³byœ zrobiæ powy¿sze zadanie dla definicji tabeli:
--CREATE TABLE uczen3(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) CONSTRAINT UNIQUE);
--? Tu chyba jest b³¹d, bo nie da siê stworzyæ CONSTRAINT bez nazwy, a z samym UNIQUE jest prosto:
CREATE TABLE uczen3(id_uczen INT PRIMARY KEY, imie VARCHAR(15), nazwisko VARCHAR(20) UNIQUE);
ALTER TABLE uczen3 ALTER COLUMN nazwisko VARCHAR(20);