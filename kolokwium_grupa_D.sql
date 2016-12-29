-- DDD1 [3 pkt]
-- Znajd� producent�w (nazwa producenta, identfikator producenta), dla kt�rych
-- nazwa nie zaczyna si� od sp�g�oski.
-- Wynik posortuj leksykograficznie po nazwie producenta.
-- Rozwi�zanie:

SELECT nazwa, id_producent
  FROM producent
  WHERE nazwa LIKE '[^bc�dfghjkl�mn�pqrs�tvwxz��]%'  -- znaczek ^ oznacza negacj�
  -- alternatywnie: 
  --WHERE nazwa NOT LIKE '[bc�dfghjkl�mn�pqrs�tvwxz��]%'  -- bez znaczka ^, ale jest NOT
  ORDER BY nazwa ASC;

-- DDD2 [3 pkt]
-- Dla ka�dego statusu (tabela status kolumna nazwa), wy�wietl informacj�
-- ile razy zosta� on przyj�ty (zobacz tabela zamowienie_status).
-- Uwzgl�dnij te� te statusy, kt�re ani razu nie zosta�y przyj�te.
-- Wynik posortuj malej�co po oblicznej ilo�ci, a dla takiej samej
-- ilo�ci posortuj leksykograficznie po nazwie statusu.
-- Rozwi�zanie:

SELECT s.nazwa, COALESCE(COUNT(z.id_status), 0) AS ilosc_przyjec
  FROM status s LEFT JOIN zamowienie_status z
  ON s.id_status = z.id_status
  GROUP BY s.nazwa
  ORDER BY s.nazwa ASC;

-- DDD3 [4 pkt]
-- Znajd� producenta (jednego lub kilku, wystaczy wy�wietli� nazw� prodcenta),
-- kt�ry posiada najwi�ksz� ilo�� produkt�w w tabeli produkt.
-- Prosz� nie u�ywa� konstrukcji TOP 1 WITH TIES.
-- Rozwi�zanie:

SELECT p.nazwa, p.id_producent
  FROM producent p INNER JOIN produkt pkt
  ON p.id_producent = pkt.id_producent
  GROUP BY p.nazwa, p.id_producent
  HAVING SUM(pkt.ilosc_sztuk_magazyn) = (
    SELECT TOP 1 SUM(pt.ilosc_sztuk_magazyn) AS ilosc
	  FROM produkt pt
	  GROUP BY pt.id_producent
	  ORDER BY ilosc DESC
  );