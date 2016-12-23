--CCC1 [3 pkt]
--Znajdź klientów (nazwisko, imie, telefon), których nazwiska
--rozpoczynają się od spółgłoski.
--Wynik posortuj leksykograficznie po nazwie nazwisku i imieniu klienta.
--Rozwiązanie:

SELECT nazwisko, imie, telefon
  FROM klient
  WHERE nazwisko LIKE '[bcćdfghjklłmnńpqrsśtvwxzźż]%'
  ORDER BY nazwisko ASC, imie ASC;

--CCC2 [3 pkt]
--Dla każdego producenta (tabela producent kolumna nazwa), wyświetl informację 
--ile znajduje się jego produktów w tabeli produkt.
--Uwzględnij też tych producentów, którzy nie posiadają żadnego produktu 
--w tabeli produkt.
--Wynik posortuj malejąco po obliczonej ilości, a dla takiej samej 
--ilości posortuj leksykograficznie po nazwie producenta.
--Rozwiązanie:

SELECT p.nazwa, COALESCE(COUNT(pr.id_producent), 0) AS ilosc_produktow
  FROM producent p LEFT JOIN produkt pr
  ON p.id_producent=pr.id_producent
  GROUP BY p.nazwa
  ORDER BY ilosc_produktow DESC, p.nazwa ASC;

--CCC3 [4 pkt]
--Znajdź zamówienie (jedno lub kilka, wystarczy wyświetlić zawartości kolumn: 
--id_zamowienie, data_zamowienia), które posiada najwięcej pozycji w tabeli koszyk.
--Proszę nie używać konstrukcji TOP 1 WITH TIES.
--Rozwiązanie:

SELECT z.id_zamowienie, z.data_zamowienia
  FROM zamowienie z INNER JOIN koszyk k
  ON z.id_zamowienie = k.id_zamowienie
  GROUP BY z.id_zamowienie, z.data_zamowienia
  HAVING SUM(k.ilosc_sztuk) = (
    SELECT TOP 1 SUM(kk.ilosc_sztuk) AS ilosc
	  FROM koszyk kk
	  GROUP BY kk.id_zamowienie
	  ORDER BY ilosc DESC
  );