﻿--Zadanie projektowe
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
WHILE EXISTS (
  SELECT TOP 1 1 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE TABLE_CATALOG=DB_NAME() AND 
		  CONSTRAINT_TYPE='FOREIGN KEY'
)
BEGIN
  SELECT @sql='ALTER TABLE ' + TABLE_NAME + ' DROP CONSTRAINT ' + CONSTRAINT_NAME 
    FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
    WHERE TABLE_CATALOG=DB_NAME() AND 
          CONSTRAINT_TYPE='FOREIGN KEY'
    EXEC sp_executesql @sql
END
GO

--usuwanie tabel
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='gra')
DROP TABLE gra;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='mapa')
DROP TABLE mapa;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='druzyna')
DROP TABLE druzyna;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='adres')
DROP TABLE adres;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='gracz')
DROP TABLE gracz;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='komentator')
DROP TABLE komentator;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='turniej')
DROP TABLE turniej;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='mecz')
DROP TABLE mecz;
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE table_name='rozgrywka')
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
  wynik_druz_1 INT NOT NULL DEFAULT 0 CHECK(wynik_druz_1 >= 0),
  wynik_druz_2 INT NOT NULL DEFAULT 0 CHECK(wynik_druz_2 >= 0),
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
VALUES (@id_druzyna_virtus_pro_cs, @id_druzyna_astralis, @id_komentator_hexagrams, @id_komentator_brak, @id_turniej_eleague, 2, '2016-10-21', 2, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_mirage, 20, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_dust2, 12, 10);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_virtus_pro_cs, @id_druzyna_astralis, @id_komentator_hexagrams, @id_komentator_shye, @id_turniej_eleague, 2, '2016-10-22', 2, 1);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_mirage, 14, 12);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_dust2, 12, 20);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_cache, 22, 10);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_virtus_pro_cs, @id_druzyna_astralis, @id_komentator_shye, @id_komentator_hexagrams, @id_turniej_eleague, 2, '2016-10-25', 2, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_mirage, 10, 5);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_de_dust2, 22, 21);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_immortals, @id_druzyna_skt_t1, @id_komentator_shye, @id_komentator_scr1be, @id_turniej_gsi, 2, '2016-10-22', 2, 1);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 3, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 2, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 2, 0);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_immortals, @id_druzyna_skt_t1, @id_komentator_shye, @id_komentator_hexagrams, @id_turniej_gsi, 2, '2016-11-25', 1, 2);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 2, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 2, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 0, 2);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_immortals, @id_druzyna_skt_t1, @id_komentator_shye, @id_komentator_scr1be, @id_turniej_gsi, 2, '2016-11-26', 0, 2);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 1, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 0, 3);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_envyus, @id_druzyna_misfits, @id_komentator_scr1be, @id_komentator_hexagrams, @id_turniej_gsi, 2, '2016-11-20', 0, 2);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 2, 3);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 2, 3);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_envyus, @id_druzyna_misfits, @id_komentator_hexagrams, @id_komentator_brak, @id_turniej_gsi, 2, '2016-11-21', 2, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 3, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_hollywood, 2, 0);

INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (@id_druzyna_envyus, @id_druzyna_misfits, @id_komentator_shye, @id_komentator_hexagrams, @id_turniej_gsi, 2, '2016-11-24', 2, 0);
SET @id_mecz = (SELECT IDENT_CURRENT('mecz'))
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_numbani, 2, 1);
INSERT INTO rozgrywka(id_mecz, id_mapa, wynik_druz_1, wynik_druz_2) VALUES (@id_mecz, @id_mapa_ilios, 1, 0);

GO
--===================================================================================================================================================
--zapytania
--kto grał (zawodnicy) w meczu 2016-11-26?
SELECT g.ksywa, g.id_druzyna
  FROM gracz g INNER JOIN mecz m
  ON g.id_druzyna = m.id_druzyna1
  WHERE m.data_meczu = '2016-11-26'
UNION
SELECT g.ksywa, g.id_druzyna
  FROM gracz g INNER JOIN mecz m
  ON g.id_druzyna = m.id_druzyna2
  WHERE m.data_meczu = '2016-11-26'
  ORDER BY g.id_druzyna ASC, g.ksywa ASC;

--który komentatorzy występowali najczęściej w roku 2016 jako pierwszy i drugi komentator?
SELECT k.imie, k.ksywa, k.nazwisko, COUNT(m.id_komentator1) AS ilosc
  FROM komentator k INNER JOIN mecz m
  ON k.id_komentator = m.id_komentator1 
  GROUP BY k.imie, k.ksywa, k.nazwisko
  HAVING COUNT(m.id_komentator1) = (
    SELECT TOP 1 COUNT(mm.id_komentator1) AS ilosc
	  FROM mecz mm
	  WHERE YEAR(mm.data_meczu) = 2016 AND k.imie != '-'
	  GROUP BY mm.id_komentator1
	  ORDER BY ilosc DESC
  )

 SELECT k.imie, k.ksywa, k.nazwisko, COUNT(m.id_komentator2) AS ilosc
  FROM komentator k INNER JOIN mecz m
  ON k.id_komentator = m.id_komentator2 
  GROUP BY k.imie, k.ksywa, k.nazwisko
  HAVING COUNT(m.id_komentator2) = (
    SELECT TOP 1 COUNT(mm.id_komentator2) AS ilosc
	  FROM mecz mm
	  WHERE YEAR(mm.data_meczu) = 2016 AND k.imie != '-'
	  GROUP BY mm.id_komentator2
	  ORDER BY ilosc DESC
  );

--w którym turnieju rozegrano najwięcej meczów?
SELECT t.nazwa
  FROM turniej t INNER JOIN mecz m
  ON t.id_turniej = m.id_turniej
  GROUP BY t.nazwa
  HAVING COUNT(m.id_turniej) = (
    SELECT TOP 1 COUNT(mm.id_turniej) AS ilosc
	  FROM mecz mm
	  GROUP BY mm.id_turniej
	  ORDER BY ilosc DESC
  );

--z jakiego kraju jest najwięcej zawodników? Wyświetl ich imię, nazwisko i ksywę.
SELECT g.imie, g.nazwisko, g.ksywa
  FROM gracz g
  WHERE g.id_adres IN (
    SELECT a.id_adres
      FROM gracz g INNER JOIN adres a
      ON g.id_adres = a.id_adres
      GROUP BY a.id_adres
      HAVING COUNT(g.id_adres) IN (
        SELECT TOP 1 COUNT(aa.id_adres) AS ilosc
	      FROM gracz aa
	      GROUP BY aa.id_adres
	      ORDER BY ilosc DESC
      )
  );

--================================
SELECT * FROM rozgrywka;
SELECT * FROM mecz;
SELECT * FROM turniej;
SELECT * FROM komentator;
SELECT * FROM gracz;
SELECT * FROM adres;
SELECT * FROM druzyna ORDER BY id_druzyna;
SELECT * FROM gra;
SELECT * from mapa;

--================================
--procedura nr 1
DROP PROCEDURE wypisz_graczy;
GO
CREATE PROCEDURE wypisz_graczy @kraj INT
AS
SELECT * FROM gracz WHERE id_adres=@kraj;
GO
DECLARE @id_kraj INT SET @id_kraj = (SELECT id_adres FROM adres WHERE kraj = 'USA' AND miasto IS NULL)
EXECUTE wypisz_graczy @id_kraj;

--procedura nr 2
DROP PROCEDURE zmien_druzyne;
GO
CREATE PROCEDURE zmien_druzyne @druzyna_poprz INT, @druzyna_obec INT
AS
  UPDATE gracz 
    SET id_druzyna = @druzyna_obec 
	WHERE id_gracz IN (
	  SELECT id_gracz FROM gracz WHERE id_druzyna = @druzyna_poprz
	);
GO
SELECT * FROM gracz;
DECLARE @id_druzyna_poprz INT SET @id_druzyna_poprz = (SELECT id_druzyna FROM druzyna WHERE nazwa = 'Astralis')
DECLARE @id_druzyna_obec INT SET @id_druzyna_obec = (SELECT id_druzyna FROM druzyna WHERE nazwa = 'Virtus.Pro.CS')
EXECUTE zmien_druzyne @id_druzyna_poprz, 7;
SELECT * FROM gracz;

--================================
--funkcja nr 1
DROP FUNCTION dbo.ile_meczy_gracza;
GO
CREATE FUNCTION dbo.ile_meczy_gracza (@id_gracz INT) RETURNS INT
BEGIN
  RETURN (SELECT ((
    SELECT COUNT(*) 
	  FROM mecz m INNER JOIN gracz g
	  ON m.id_druzyna1 = g.id_druzyna
      WHERE g.id_gracz=@id_gracz
  ) + (
	SELECT COUNT(*) 
	  FROM mecz m INNER JOIN gracz g
	  ON m.id_druzyna2 = g.id_druzyna
      WHERE g.id_gracz=@id_gracz
  )))
END;
GO
SELECT dbo.ile_meczy_gracza(40) AS ile_meczy;

--funkcja nr 2
DROP FUNCTION dbo.ile_map_meczu;
GO
CREATE FUNCTION dbo.ile_map_meczu (@id_mecz INT) RETURNS VARCHAR(50)
BEGIN
  RETURN (
    SELECT COUNT(*)
	  FROM rozgrywka r
      WHERE r.id_mecz=@id_mecz
  )
END;
GO
SELECT dbo.ile_map_meczu(2) AS ile_map;

--================================
--wyzwalacz nr 1
DROP TRIGGER turniej_ins;
GO
CREATE TRIGGER turniej_ins ON turniej
AFTER INSERT AS
BEGIN
  DECLARE @data_rozp DATETIME, @data_zak DATETIME
  SET @data_rozp = GETDATE()
  SET @data_zak = GETDATE()
    SELECT @data_rozp = data_rozp, @data_zak = data_zak FROM INSERTED WHERE data_rozp > data_zak
  IF @data_rozp > @data_zak
  BEGIN
    RAISERROR('Data rozpoczęcia nie może być późniejsza od daty zakończenia!', 1, 2)
    ROLLBACK
  END
END
GO
SELECT * FROM turniej;
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('DreamHack Winter 2015', '2015-12-09', '2015-11-26', 1);
INSERT INTO turniej(nazwa, data_rozp, data_zak, id_adres) VALUES ('ELEAGUE Season 3', '2016-11-21', '2016-12-19', 3);
SELECT * FROM turniej;

--wyzwalacz nr 2
DROP TRIGGER mecz_ins;
GO
CREATE TRIGGER mecz_ins ON mecz
AFTER INSERT AS
BEGIN
  DECLARE @id_druzyna1 INT, @id_druzyna2 INT, @id_komentator1 INT, @id_komentator2 INT
  SET @id_druzyna1 = -1
  SET @id_druzyna2 = -2
  SET @id_komentator1 = -3
  SET @id_komentator2 = -4
    SELECT @id_druzyna1 = id_druzyna1, @id_druzyna2 = id_druzyna2, @id_komentator1 = id_komentator1, @id_komentator2 = id_komentator2 
	FROM INSERTED WHERE id_druzyna1 = id_druzyna2 OR id_komentator1 = id_komentator2
  IF @id_druzyna1 = @id_druzyna2 OR @id_komentator1 = @id_komentator2
  BEGIN
    RAISERROR('Nie można dodać takiej samej drużyny po obu stronach lub takich samych komentatorów!', 1, 2)
    ROLLBACK
  END
END
GO
SELECT * FROM mecz;
INSERT INTO mecz(id_druzyna1, id_druzyna2, id_komentator1, id_komentator2, id_turniej, ilosc_map, data_meczu, wynik_calk_druz_1, wynik_calk_druz_2)
VALUES (1, 2, 1, 1, 4, 2, '2016-11-21', 2, 0);
SELECT * FROM mecz;

--wyzwalacz nr 3
DROP TRIGGER mecz_del_zabron;
GO
CREATE TRIGGER mecz_del_zabron ON mecz
FOR DELETE AS
BEGIN
  RAISERROR('Usuwanie meczów jest zabronione!', 1, 2)
  ROLLBACK
END
GO
SELECT * FROM mecz;
DELETE FROM mecz; --zadziała, gdy usunie się klucze obce
SELECT * FROM mecz;

--wyzwalacz nr 4
DROP TRIGGER gracz_del_zabron;
GO
CREATE TRIGGER gracz_del_zabron ON gracz
FOR DELETE AS
BEGIN
  RAISERROR('Usuwanie graczy jest zabronione!', 1, 2)
  ROLLBACK
END
GO
SELECT * FROM gracz;
DELETE FROM gracz;
SELECT * FROM gracz;