-- DDD1 [3 pkt]
-- ZnajdŸ producentów (nazwa producenta, identfikator producenta), dla których
-- nazwa nie zaczyna siê od spó³g³oski.
-- Wynik posortuj leksykograficznie po nazwie producenta.
-- Rozwi¹zanie:

SELECT nazwa, id_producent
  FROM producent
  WHERE nazwa LIKE '[^bcædfghjkl³mnñpqrsœtvwxzŸ¿]%'  -- znaczek ^ oznacza negacjê
  -- alternatywnie: 
  --WHERE nazwa NOT LIKE '[bcædfghjkl³mnñpqrsœtvwxzŸ¿]%'  -- bez znaczka ^, ale jest NOT
  ORDER BY nazwa ASC;

-- DDD2 [3 pkt]
-- Dla ka¿dego statusu (tabela status kolumna nazwa), wyœwietl informacjê
-- ile razy zosta³ on przyjêty (zobacz tabela zamowienie_status).
-- Uwzglêdnij te¿ te statusy, które ani razu nie zosta³y przyjête.
-- Wynik posortuj malej¹co po oblicznej iloœci, a dla takiej samej
-- iloœci posortuj leksykograficznie po nazwie statusu.
-- Rozwi¹zanie:

SELECT s.nazwa, COALESCE(COUNT(z.id_status), 0) AS ilosc_przyjec
  FROM status s LEFT JOIN zamowienie_status z
  ON s.id_status = z.id_status
  GROUP BY s.nazwa
  ORDER BY s.nazwa ASC;

-- DDD3 [4 pkt]
-- ZnajdŸ producenta (jednego lub kilku, wystaczy wyœwietliæ nazwê prodcenta),
-- który posiada najwiêksz¹ iloœæ produktów w tabeli produkt.
-- Proszê nie u¿ywaæ konstrukcji TOP 1 WITH TIES.
-- Rozwi¹zanie:

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