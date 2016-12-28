--Zadanie projektowe
--1. Wybierz temat indywidualnej bazy danych.
--2. Zaprojektuj bazę danych dla wybranego tematu.  [2 pkt]
--(Narysuj diagram ERD, obowiązuje notacja Martina, minimum 5 encji.)
--3. Napisać skrypt SQL, który generuje strukturę zaprojektowanej bazy danych.
--Szczególną uwagę zwróć na ograniczenia tabel i kolumn (CHECK, UNIQUE, DEFAULT, NOT NULL) oraz klucze główne i obce.
--Nie zapomnij o autoinkrementacji. [3 pkt]
--4. Do utworzonych tabel dodaj po co najmniej 5 rekordów. [brak=-1pkt]
--5. Napisz 4 ciekawe zapytania SELECT wykorzystujących złączenia tabel,  funkcje agregujące i podzapytania. [1 pkt]
--6. Oprogramuj bazę danych. Napisz co najmniej 2 funkcje [1 pkt], 2 procedury [1 pkt] i 4 wyzwalacze [2 pkt] oraz udowodnij, 
--że działają (napisz instrukcję, która wykorzystuje lub inicjuje implementowaną składową).acze [2 pkt] oraz udowodnij, że działają 
--(napisz instrukcję, która wykorzystuje lub inicjuje implementowaną składową).

--===================================================================================================================================================
SET DATEFORMAT ymd;
GO

--usuwanie kluczy obcych z bazy
DECLARE @sql NVARCHAR(300)
WHILE EXISTS(SELECT TOP 1 1 
             FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
             WHERE TABLE_CATALOG=DB_NAME() AND 
                   CONSTRAINT_TYPE='FOREIGN KEY')
BEGIN
  SELECT @sql='ALTER TABLE ' + TABLE_NAME + 
         ' DROP CONSTRAINT ' + CONSTRAINT_NAME 
  FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
  WHERE TABLE_CATALOG=DB_NAME() AND 
        CONSTRAINT_TYPE='FOREIGN KEY'
  EXEC sp_executesql @sql
END
GO

--usuwanie tabel
DROP TABLE gra;
GO
DROP TABLE mapa;
GO
DROP TABLE druzyna;
GO
DROP TABLE adres;
GO
DROP TABLE gracz;
GO
DROP TABLE komentator;
GO
DROP TABLE turniej;
GO
DROP TABLE mecz;
GO
DROP TABLE rozgrywka;
GO
--===================================================================================================================================================
--tworzenie tabel
CREATE TABLE gra (
  id_gra INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  nazwa VARCHAR(200) NOT NULL,
  gatunek VARCHAR(200) NOT NULL,
  platforma VARCHAR(200) NOT NULL,
  data_prod DATETIME NOT NULL CHECK(data_prod <= GETDATE())
);
GO

CREATE TABLE mapa (
  id_mapa INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  id_gra INTEGER NOT NULL REFERENCES gra(id_gra),
  typ VARCHAR(100) NOT NULL,
  max_graczy INTEGER NOT NULL,
  nazwa VARCHAR(50) NOT NULL
);
GO

CREATE TABLE druzyna (
  id_druzyna INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  nazwa VARCHAR(50) NOT NULL UNIQUE
);
GO

CREATE TABLE adres (
  id_adres INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  kraj VARCHAR(100) NOT NULL,
  miasto VARCHAR(100),
  ulica VARCHAR(100),
  numer VARCHAR(100),
  kod VARCHAR(100)
);
GO

CREATE TABLE gracz (
  id_gracz INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  imie VARCHAR(100) NOT NULL,
  nazwisko VARCHAR(100) NOT NULL,
  ksywa VARCHAR(100) NOT NULL,
  id_adres INTEGER NOT NULL REFERENCES adres(id_adres),
  id_druzyna INTEGER NOT NULL REFERENCES druzyna(id_druzyna)
);
GO

CREATE TABLE komentator (
  id_komentator INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  imie VARCHAR(100) NOT NULL,
  nazwisko VARCHAR(100) NOT NULL,
  ksywa VARCHAR(100) NOT NULL,
  id_adres INTEGER NOT NULL REFERENCES adres(id_adres)
);
GO

CREATE TABLE turniej (
  id_turniej INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  nazwa VARCHAR(100) NOT NULL,
  data_rozp DATETIME NOT NULL CHECK(data_rozp <= GETDATE()),
  data_zak DATETIME NOT NULL CHECK(data_zak <= GETDATE()),
  id_adres INTEGER NOT NULL REFERENCES adres(id_adres)
);
GO

CREATE TABLE mecz (
  id_mecz INTEGER NOT NULL IDENTITY(1, 1) PRIMARY KEY,
  id_druzyna1 INTEGER NOT NULL REFERENCES druzyna(id_druzyna),
  id_druzyna2 INTEGER NOT NULL REFERENCES druzyna(id_druzyna),
  id_komentator1 INTEGER NOT NULL REFERENCES komentator(id_komentator),
  id_komentator2 INTEGER NOT NULL REFERENCES komentator(id_komentator),
  ilosc_map INTEGER NOT NULL DEFAULT 0 CHECK(ilosc_map >= 0),
  data_meczu DATETIME NOT NULL CHECK(data_meczu <= GETDATE()),
  wynik_calk_druz_1 INT NOT NULL DEFAULT 0,
  wynik_calk_druz_2 INT NOT NULL DEFAULT 0,
  id_turniej INTEGER NOT NULL REFERENCES turniej(id_turniej)
);
GO

CREATE TABLE rozgrywka (
  id_mecz INTEGER NOT NULL REFERENCES mecz(id_mecz),
  id_mapa INTEGER NOT NULL REFERENCES mapa(id_mapa),
  wynik_druz_1 INT NOT NULL DEFAULT 0,
  wynik_druz_2 INT NOT NULL DEFAULT 0,
  PRIMARY KEY(id_mecz, id_mapa)
);
GO
--===================================================================================================================================================
--dodawanie gier
INSERT INTO gra(nazwa, gatunek, platforma, data_prod) VALUES ('Overwatch', 'FPS', 'PC', '2016-05-23');
INSERT INTO gra(nazwa, gatunek, platforma, data_prod) VALUES ('Starcraft 2', 'RTS', 'PC', '2010-07-27');
INSERT INTO gra(nazwa, gatunek, platforma, data_prod) VALUES ('League of Legends', 'MOBA', 'PC', '2009-10-27');
INSERT INTO gra(nazwa, gatunek, platforma, data_prod) VALUES ('Counter-Strike: Global Offensive', 'FPS', 'PC', '2012-08-21');
GO

--dodawanie map gier
DECLARE @id_gra INT
SET @id_gra = (SELECT TOP 1 id_gra FROM gra WHERE nazwa = 'Overwatch' AND platforma LIKE 'PC')
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Assault', 12, 'Hanamura');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Assault', 12, 'Temple of Anubis');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Assault', 12, 'Volskaya Industries');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Escort', 12, 'Dorado');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Escort', 12, 'Route 66');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Escort', 12, 'Watchpoint: Gibraltar');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Hybrid', 12, 'Hollywood');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Hybrid', 12, 'King''s Row');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Hybrid', 12, 'Numbani');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Hybrid', 12, 'Eichenwalde');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Control', 12, 'Ilios');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Control', 12, 'Lijiang Tower');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Control', 12, 'Nepal');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Control', 12, 'Oasis');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Arena', 6, 'Ecopoint: Antarctica');
GO

DECLARE @id_gra INT
SET @id_gra = (SELECT TOP 1 id_gra FROM gra WHERE nazwa = 'Starcraft 2' AND platforma LIKE 'PC')
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Overgrowth');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Vaani Research Station');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Daybreak');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Habitation Station');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Whirlwind');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Newkirk Precinct');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Echo');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Frozen Temple');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Galactic Process LE');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'New Gettysburg LE');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Apotheosis LE');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Dasan Station LE');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'King Sejong Station');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Frost');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Solo', 2, 'Overgrowth');
GO

DECLARE @id_gra INT
SET @id_gra = (SELECT TOP 1 id_gra FROM gra WHERE nazwa = 'League of Legends' AND platforma LIKE 'PC')
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Main map', 10, 'Main map');
GO

DECLARE @id_gra INT
SET @id_gra = (SELECT TOP 1 id_gra FROM gra WHERE nazwa = 'Counter-Strike: Global Offensive' AND platforma LIKE 'PC')
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_mirage');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_dust2');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_cache');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_cobblestone');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_overpass');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_train');
INSERT INTO mapa(id_gra, typ, max_graczy, nazwa) VALUES (@id_gra, 'Bomb/Defuse', 10, 'de_nuke');
GO

--dodawanie druzyn
INSERT INTO druzyna(nazwa) VALUES ('Astralis'), ('OpTic Gaming'), ('Luminosity Gaming'), ('FaZe Clan'), ('SK Gaming'), ('Ninjas in Pyjamas');
INSERT INTO druzyna(nazwa) VALUES ('Virtus.Pro.CS'), ('Team EnVyUs'), ('Immortals.cs'), ('Team Dignitas.CS'), ('Cloud9.CS'), ('G2 Esports');
INSERT INTO druzyna(nazwa) VALUES ('SKT T1'), ('ROX Tigers'), ('Samsung Galaxy'), ('Edward Gaming'), ('Immortals'), ('H2K Gaming');
INSERT INTO druzyna(nazwa) VALUES ('Team Solomid'), ('Royal Never Give Up'), ('Flash Wolves'), ('ahq e-Sports Club'), ('Cloud 9'), ('KT Rolster');
INSERT INTO druzyna(nazwa) VALUES ('EnVyUs'), ('Cloud9.gg'), ('MisfitsGG'), ('FaZe Clan.'), ('fnatic.ow'), ('Ninjas in Pyjamas OW');
INSERT INTO druzyna(nazwa) VALUES ('Rogue'), ('compLexity.OW'), ('Lunatic Hai 루나틱하이'), ('Immortals.gg'), ('Afreeca Freecs Blue'), ('LuxuryWatch Red');
INSERT INTO druzyna(nazwa) VALUES ('Team Prime'), ('SK Telecom T1'), ('KT Rolster SC2'), ('Jin Air Green Wings'), ('For Our Utopia'), ('MVP');
INSERT INTO druzyna(nazwa) VALUES ('Acer'), ('Bez drużyny'), ('CJ Entus SC2'), ('Samsung Galaxy SC2'), ('CMStorm SC2'), ('SouL');

--dodawanie adresów
INSERT INTO adres(kraj) VALUES ('Polska'), ('Niemcy'), ('Francja'), ('Szwecja'), ('Norwegia'), ('USA');
INSERT INTO adres(kraj) VALUES ('Korea Południowa'), ('Kanada'), ('Rosja'), ('Ukraina'), ('Chiny'), ('Wielka Brytania');
INSERT INTO adres(kraj) VALUES ('Finlandia'), ('Belgia'), ('Holandia'), ('Czechy'), ('Hiszpania'), ('Rumunia');
INSERT INTO adres(kraj) VALUES ('Tajlandia'), ('Kanada'), ('Dania'), ('Holandia'), ('Belgia'), ('Online');
INSERT INTO adres(kraj, miasto) VALUES ('Polska', 'Katowice');
INSERT INTO adres(kraj, miasto) VALUES ('Korea Południowa', 'Seul');
INSERT INTO adres(kraj, miasto) VALUES ('Chiny', 'Szanghaj');
INSERT INTO adres(kraj, miasto) VALUES ('Wielka Brytania', 'Londyn');
GO
--dodawanie graczy
DECLARE @id_adres_korea_pd INT SET @id_adres_korea_pd = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Korea Południowa' AND miasto IS NULL)
DECLARE @id_adres_usa INT SET @id_adres_usa = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'USA' AND miasto IS NULL)
DECLARE @id_adres_polska INT SET @id_adres_polska = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Polska' AND miasto IS NULL)
DECLARE @id_adres_niemcy INT SET @id_adres_niemcy = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Niemcy' AND miasto IS NULL)
DECLARE @id_adres_szwecja INT SET @id_adres_szwecja = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Szwecja' AND miasto IS NULL)
DECLARE @id_adres_hiszpania INT SET @id_adres_hiszpania = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Hiszpania' AND miasto IS NULL)
DECLARE @id_adres_tajlandia INT SET @id_adres_tajlandia = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Tajlandia' AND miasto IS NULL)
DECLARE @id_adres_finlandia INT SET @id_adres_finlandia = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Finlandia' AND miasto IS NULL)
DECLARE @id_adres_kanada INT SET @id_adres_kanada = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Kanada' AND miasto IS NULL)
DECLARE @id_adres_dania INT SET @id_adres_dania = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Dania' AND miasto IS NULL)
DECLARE @id_adres_holandia INT SET @id_adres_holandia = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Holandia' AND miasto IS NULL)
DECLARE @id_adres_belgia INT SET @id_adres_belgia = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Belgia' AND miasto IS NULL)
DECLARE @id_adres_online INT SET @id_adres_online = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Online' AND miasto IS NULL)
DECLARE @id_adres_londyn INT SET @id_adres_londyn = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Wielka Brytania' AND miasto = 'Londyn')
DECLARE @id_adres_seul INT SET @id_adres_seul = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Korea Południowa' AND miasto = 'Seul')
DECLARE @id_adres_szanghaj INT SET @id_adres_szanghaj = (SELECT TOP 1 id_adres FROM adres WHERE kraj = 'Chiny' AND miasto = 'Szanghaj')

DECLARE @id_druzyna_envyus INT SET @id_druzyna_envyus = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'EnVyUs')
DECLARE @id_druzyna_misfits INT SET @id_druzyna_misfits = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'MisfitsGG')
DECLARE @id_druzyna_bez_druzyny INT SET @id_druzyna_bez_druzyny = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'Bez drużyny')
DECLARE @id_druzyna_kt_rolster_sc2 INT SET @id_druzyna_kt_rolster_sc2 = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'KT Rolster SC2')
DECLARE @id_druzyna_jin_air_green_wings INT SET @id_druzyna_jin_air_green_wings = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'Jin Air Green Wings')
DECLARE @id_druzyna_team_prime INT SET @id_druzyna_team_prime = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'Team Prime')
DECLARE @id_druzyna_skt_t1 INT SET @id_druzyna_skt_t1 = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'SKT T1')
DECLARE @id_druzyna_immortals INT SET @id_druzyna_immortals = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'Immortals')
DECLARE @id_druzyna_astralis INT SET @id_druzyna_astralis = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'Astralis')
DECLARE @id_druzyna_virtus_pro_cs INT SET @id_druzyna_virtus_pro_cs = (SELECT TOP 1 id_druzyna FROM druzyna WHERE nazwa = 'Virtus.Pro.CS')

INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Byun Hyun', 'Woo', 'ByuN', @id_adres_korea_pd, @id_druzyna_team_prime);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Park Ryung', 'Woo', 'DarkSC2', @id_adres_korea_pd, @id_druzyna_bez_druzyny);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Kim Dae', 'Yeob', 'Stats', @id_adres_korea_pd, @id_druzyna_kt_rolster_sc2);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Alex', 'Sunderhaft', 'Neeblet', @id_adres_usa, @id_druzyna_bez_druzyny);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Artur', 'Bloch', 'Nerchio ', @id_adres_polska, @id_druzyna_bez_druzyny);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Ji Hyun', 'Jo', 'Patience  ', @id_adres_korea_pd, @id_druzyna_bez_druzyny);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Jun Tae', 'Yang', 'TY', @id_adres_korea_pd, @id_druzyna_kt_rolster_sc2);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Yoo Jin', 'Kim', 'sOs', @id_adres_korea_pd, @id_druzyna_jin_air_green_wings);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Dennis', 'Hawelka', 'INTERNETHULK', @id_adres_niemcy, @id_druzyna_envyus);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Christian', 'Jonsson', 'cocco', @id_adres_szwecja, @id_druzyna_envyus);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Sebastian', 'Widlund', 'chipshajen', @id_adres_szwecja, @id_druzyna_envyus);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Jonathan Tejedor', 'Rua', 'harryhook', @id_adres_hiszpania, @id_druzyna_envyus);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Timo', 'Kettunen', 'Taimou', @id_adres_finlandia, @id_druzyna_envyus);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Pongphop', 'Rattanasangchod', 'Mickie', @id_adres_tajlandia, @id_druzyna_envyus);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Sebastian', 'Olsson', 'Zebbosai', @id_adres_szwecja, @id_druzyna_misfits);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Andreas', 'Karlsson', 'Nevix', @id_adres_szwecja, @id_druzyna_misfits);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Kevin', 'Lindström', 'TviQ', @id_adres_szwecja, @id_druzyna_misfits);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Jonathan', 'Larsson', 'Reinforce', @id_adres_szwecja, @id_druzyna_misfits);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Tim', 'Byhlund', 'Mannetens', @id_adres_szwecja, @id_druzyna_misfits);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Kalle Haag', 'Nilsson', 'Zave', @id_adres_szwecja, @id_druzyna_misfits);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Seong-Ung', 'Bae', 'bengi', @id_adres_korea_pd, @id_druzyna_skt_t1);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Sang-hyeok', 'Lee', 'Faker', @id_adres_korea_pd, @id_druzyna_skt_t1);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('JaeWan', 'Lee', 'Wolf', @id_adres_korea_pd, @id_druzyna_skt_t1);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('HoSeong', 'Lee', 'Duke', @id_adres_korea_pd, @id_druzyna_skt_t1);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('JunSik', 'Bae', 'Bang', @id_adres_korea_pd, @id_druzyna_skt_t1);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Eugene', 'Park', 'Pobelter', @id_adres_usa, @id_druzyna_immortals);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Jason', 'Tran', 'WildTurtle', @id_adres_kanada, @id_druzyna_immortals);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('EuiJin', 'Kim', 'Reignover', @id_adres_korea_pd, @id_druzyna_immortals);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('SeungHun', 'Heo', 'Huni', @id_adres_korea_pd, @id_druzyna_immortals);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Adrian', 'Ma', 'Adrian', @id_adres_usa, @id_druzyna_immortals);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Peter', 'Rasmussen', 'dupreeh', @id_adres_dania, @id_druzyna_astralis);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Nicolai', 'Reedtz', 'device', @id_adres_dania, @id_druzyna_astralis);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Andreas', 'Højsleth', 'Xyp9x', @id_adres_dania, @id_druzyna_astralis);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Markus', 'Kjærbye', 'Kjaerbye', @id_adres_dania, @id_druzyna_astralis);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Lukas', 'Rossander', 'gla1ve', @id_adres_dania, @id_druzyna_astralis);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Filip', 'Kubski', 'Neo', @id_adres_polska, @id_druzyna_virtus_pro_cs);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Janusz', 'Pogorzelski', 'Snax', @id_adres_polska, @id_druzyna_virtus_pro_cs);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Paweł', 'Bieliński', 'byali', @id_adres_polska, @id_druzyna_virtus_pro_cs);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Jarosław', 'Jarząbkowski', 'pashaBiceps', @id_adres_polska, @id_druzyna_virtus_pro_cs);
INSERT INTO gracz(imie, nazwisko, ksywa, id_adres, id_druzyna) VALUES ('Wiktor', 'Wojtas', 'TaZ', @id_adres_polska, @id_druzyna_virtus_pro_cs);

--dodawanie komentatorów
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Robbert', 'Broeder', 'Troost', @id_adres_holandia);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Wilson', 'Xu', 'Scr1be', @id_adres_usa);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Robert', 'Kirkbride', 'Hexagrams', @id_adres_usa);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Malin', 'Söderberg', 'Shye', @id_adres_szwecja);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Dries', 'Thys', 'TCO', @id_adres_belgia);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Spencer', 'Hibnick', 'Pesto_Enthusiast', @id_adres_usa);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Thom', 'Vroegindewey', 'TiddlyThom', @id_adres_kanada);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Ben', 'Goldhaber', 'FishStix', @id_adres_usa);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Harsha', 'Bandi', 'ggHarsha', @id_adres_usa);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('Joshy', 'Sutherland', 'AskJoshy', @id_adres_usa);
INSERT INTO komentator(imie, nazwisko, ksywa, id_adres) VALUES ('-', '-', '-', @id_adres_usa);

--dodawanie turniejów
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('DreamHack Winter 2016', '2016-10-09', '2016-11-26', @id_adres_online);
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('Masters Gaming Arena', '2016-10-04', '2016-10-21', @id_adres_londyn);
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('2016 Global StarCraft II League Season 2', '2016-05-27', '2016-05-27', @id_adres_seul);
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('Gold Series International 2016', '2016-10-09', '2016-11-26', @id_adres_szanghaj);
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('ELEAGUE Season 2', '2016-10-21', '2016-11-19', @id_adres_online);

--dodawanie meczów i rozgrywek
DECLARE @id_komentator_hexagrams INT SET @id_komentator_hexagrams = (SELECT TOP 1 id_komentator FROM komentator WHERE ksywa = 'Hexagrams')
DECLARE @id_komentator_shye INT SET @id_komentator_shye = (SELECT TOP 1 id_komentator FROM komentator WHERE ksywa = 'Shye')
DECLARE @id_komentator_scr1be INT SET @id_komentator_scr1be = (SELECT TOP 1 id_komentator FROM komentator WHERE ksywa = 'Scr1be')
DECLARE @id_komentator_brak INT SET @id_komentator_brak = (SELECT TOP 1 id_komentator FROM komentator WHERE ksywa = '-')

DECLARE @id_turniej_eleague INT SET @id_turniej_eleague = (SELECT TOP 1 id_turniej FROM turniej WHERE nazwa = 'ELEAGUE Season 2')
DECLARE @id_turniej_gsi INT SET @id_turniej_gsi = (SELECT TOP 1 id_turniej FROM turniej WHERE nazwa = 'Gold Series International 2016')
DECLARE @id_turniej_dhw INT SET @id_turniej_dhw = (SELECT TOP 1 id_turniej FROM turniej WHERE nazwa = 'DreamHack Winter 2016')

DECLARE @id_mapa_de_mirage INT SET @id_mapa_de_mirage = (SELECT TOP 1 id_mapa FROM mapa WHERE nazwa = 'de_mirage')
DECLARE @id_mapa_de_dust2 INT SET @id_mapa_de_dust2 = (SELECT TOP 1 id_mapa FROM mapa WHERE nazwa = 'de_dust2')
DECLARE @id_mapa_de_cache INT SET @id_mapa_de_cache = (SELECT TOP 1 id_mapa FROM mapa WHERE nazwa = 'de_cache')
DECLARE @id_mapa_hollywood INT SET @id_mapa_hollywood = (SELECT TOP 1 id_mapa FROM mapa WHERE nazwa = 'Hollywood')
DECLARE @id_mapa_numbani INT SET @id_mapa_numbani = (SELECT TOP 1 id_mapa FROM mapa WHERE nazwa = 'Numbani')
DECLARE @id_mapa_ilios INT SET @id_mapa_ilios = (SELECT TOP 1 id_mapa FROM mapa WHERE nazwa = 'Ilios')

DECLARE @id_mecz INT
INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_virtus_pro_cs, @id_druzyna_astralis, @id_komentator_hexagrams, @id_komentator_brak, @id_turniej_eleague, 2, '2016-10-21', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_mirage, 20, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_dust2, 12, 10);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_virtus_pro_cs, @id_druzyna_astralis, @id_komentator_hexagrams, @id_komentator_shye, @id_turniej_eleague, 2, '2016-10-22', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_mirage, 14, 12);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_dust2, 12, 20);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_cache, 22, 10);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_virtus_pro_cs, @id_druzyna_astralis, @id_komentator_shye, @id_komentator_brak, @id_turniej_eleague, 2, '2016-10-25', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_mirage, 10, 5);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_dust2, 22, 21);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_immortals, @id_druzyna_skt_t1, @id_komentator_shye, @id_komentator_scr1be, @id_turniej_gsi, 2, '2016-10-25', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 3, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 2, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 2, 0);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_immortals, @id_druzyna_skt_t1, @id_komentator_shye, @id_komentator_hexagrams, @id_turniej_gsi, 2, '2016-11-25', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 2, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 2, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 0, 2);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_immortals, @id_druzyna_skt_t1, @id_komentator_shye, @id_komentator_scr1be, @id_turniej_gsi, 2, '2016-11-26', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 1, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 0, 3);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_envyus, @id_druzyna_misfits, @id_komentator_hexagrams, @id_komentator_scr1be, @id_turniej_gsi, 2, '2016-11-26', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 2, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 2, 3);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_envyus, @id_druzyna_misfits, @id_komentator_hexagrams, @id_komentator_brak, @id_turniej_gsi, 2, '2016-11-26', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 3, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 2, 0);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_envyus, @id_druzyna_misfits, @id_komentator_hexagrams, @id_komentator_shye, @id_turniej_gsi, 2, '2016-11-26', 0, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 2, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 1, 0);

GO
--===================================================================================================================================================

SELECT * FROM rozgrywka;
SELECT * FROM mecz;
SELECT * FROM turniej;
SELECT * FROM komentator;
SELECT * FROM gracz;
SELECT * FROM adres;
SELECT * FROM druzyna ORDER BY id_druzyna;
SELECT * FROM gra;
SELECT * from mapa;