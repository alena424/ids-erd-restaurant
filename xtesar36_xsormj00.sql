-- Projekt IDS - RESTAURACE
-- Jan Sorm (xsormj00), Alena Tesarova (xtesar36)
-- 2018


-- zruseni tabulek
DROP TABLE Zamestnanec CASCADE CONSTRAINTS;
DROP TABLE Rezervace CASCADE CONSTRAINTS;
DROP TABLE Objednavka CASCADE CONSTRAINTS;
DROP TABLE Stul CASCADE CONSTRAINTS;
DROP TABLE Uctenka CASCADE CONSTRAINTS;
DROP TABLE Potravina CASCADE CONSTRAINTS;
DROP TABLE Surovina CASCADE CONSTRAINTS;
DROP TABLE Objednavka_pro_stul CASCADE CONSTRAINTS;
DROP TABLE Rezervace_na_stul CASCADE CONSTRAINTS;
DROP TABLE Obsahuje_potravina CASCADE CONSTRAINTS;
DROP TABLE Obsahuje_surovina CASCADE CONSTRAINTS;

-- zruseni sekvenci
DROP SEQUENCE Zamestnanec_seq;
DROP SEQUENCE Rezervace_seq;
DROP SEQUENCE Objednavka_seq;
DROP SEQUENCE Stul_seq;
DROP SEQUENCE Uctenka_seq;
DROP SEQUENCE Potravina_seq;
DROP SEQUENCE Surovina_seq;

CREATE TABLE Zamestnanec(
    id_zam NUMBER, --NOT NULL,
    jmeno VARCHAR2(30) CONSTRAINT zamestnanec_jmeno_NN NOT NULL, 
    prijmeni VARCHAR2(30) CONSTRAINT zamestnanec_prijmeni_NN NOT NULL,
    rodne_cislo NUMBER CONSTRAINT zamestnanec_rc_NN NOT NULL,
    adresa VARCHAR2(50),
    pozice VARCHAR2(30),
    CONSTRAINT PK_zamestnanec PRIMARY KEY (id_zam)
    --CONSTRAINT CHK_zamestanec_rc CHECK (MOD(rodne_cislo, 11) = 0 AND ( (SUBSTR(rodne_cislo, 3, 2) < 13 AND SUBSTR(rodne_cislo, 3, 2) > 0) OR (SUBSTR(rodne_cislo, 3, 2) < 63 AND SUBSTR(rodne_cislo, 3, 2) > 50) ) )
);

-- tvorba tabulek
CREATE TABLE Rezervace(
    id_rezervace NUMBER,
    datum DATE,
    jmeno_zakaznika VARCHAR2(30) CONSTRAINT rezervace_jmeno_NN NOT NULL,
    prijmeni_zakaznika VARCHAR2(30) CONSTRAINT rezervace_prijmeni_NN NOT NULL,
    kontakt_zakaznika VARCHAR2(30),
    vlozil NUMBER CONSTRAINT rezervace_vlozil_NN NOT NULL,
    CONSTRAINT PK_rezervace PRIMARY KEY (id_rezervace),
    CONSTRAINT FK_rezervace_vlozil FOREIGN KEY (vlozil)
        REFERENCES Zamestnanec(id_zam) ON DELETE CASCADE
);


CREATE TABLE Objednavka(
    id_objednavka NUMBER NOT NULL,
    --CONSTRAINT Objednavka_bez_stolu check ( select 1 from Objednavka_pro_Stul where id = id )-- kontrola, ze existuje zaznam ve Objednavka pro stul
    datum DATE,
    suma FLOAT,
    vytvoril NUMBER CONSTRAINT objednavka_vytvoril_NN NOT NULL,
    rezervace NUMBER,
    CONSTRAINT PK_objednavka PRIMARY KEY (id_objednavka),
    CONSTRAINT FK_objednavka_vytvoril FOREIGN KEY (vytvoril)
                REFERENCES Zamestnanec(id_zam) ON DELETE CASCADE,
    CONSTRAINT FK_objednavka_rezervace FOREIGN KEY (rezervace)
                REFERENCES Rezervace(id_rezervace) ON DELETE CASCADE
);


CREATE TABLE Stul(
    id_stul NUMBER NOT NULL,
    umisteni VARCHAR2(30),
    pocet_osob NUMBER,
    CONSTRAINT PK_stul PRIMARY KEY (id_stul)
);

CREATE TABLE Objednavka_pro_stul(
    stul NUMBER CONSTRAINT objednavka_pro_stul_stul_NN NOT NULL,
    objednavka NUMBER CONSTRAINT objednavka_pro_stul_objednavka_NN NOT NULL,
    CONSTRAINT FK_objednavka_pro_stul_stul FOREIGN KEY (stul)
                    REFERENCES Stul(id_stul),
    CONSTRAINT FK_objednavka_pro_stul_objednavka FOREIGN KEY (objednavka)
                    REFERENCES Objednavka(id_objednavka)
    --CONSTRAINT PK_objednavka_pro_stul PRIMARY KEY (stul, objednavka)
);

CREATE TABLE Rezervace_na_stul(
    stul NUMBER CONSTRAINT rezervace_na_stul_stul_NN NOT NULL,
    rezervace NUMBER CONSTRAINT rezervace_na_stul_rezervace_NN NOT NULL,
    CONSTRAINT FK_rezervace_na_stul_stul FOREIGN KEY (stul)
                    REFERENCES Stul(id_stul),
    CONSTRAINT FK_objednavka_na_stul_rezervace FOREIGN KEY (rezervace)
                    REFERENCES Rezervace(id_rezervace),
    CONSTRAINT PK_rezervace_na_stul PRIMARY KEY (stul, rezervace)
);

CREATE TABLE Uctenka(
    id_ucet NUMBER NOT NULL,
    datum DATE NOT NULL,
    konecna_suma FLOAT NOT NULL,
    objednavka NUMBER NOT NULL,
    CONSTRAINT PK_uctenka PRIMARY KEY (id_ucet),
    CONSTRAINT FK_uctenka_objednavka FOREIGN KEY (objednavka)
                    REFERENCES Objednavka(id_objednavka)
);

CREATE TABLE Surovina(
    id_surovina NUMBER NOT NULL,
    jmeno_suroviny VARCHAR2(50),
    CONSTRAINT PK_surovina PRIMARY KEY (id_surovina)
);


CREATE TABLE Potravina(
    id_jidlo NUMBER NOT NULL,
    nazev VARCHAR2(50),
    cena NUMBER,
    pocet_porci NUMBER,
    mnozstvi_sacharidu NUMBER,
    energie_hodnota NUMBER,
    bilkoviny NUMBER,
    tuky NUMBER,
    expirace DATE,
    typ_sklenice VARCHAR2(30),
    pribor VARCHAR2(30),
    CONSTRAINT PK_potravina PRIMARY KEY (id_jidlo),
    CONSTRAINT CHK_potravina CHECK (typ_sklenice IS NULL OR pribor IS NULL)
);

CREATE TABLE Obsahuje_surovina(
    surovina NUMBER NOT NULL,
    potravina NUMBER NOT NULL,
    mnozstvi VARCHAR2(10),
    CONSTRAINT FK_obsahuje_surovina_surovina FOREIGN KEY (surovina)
                    REFERENCES Surovina(id_surovina),
    CONSTRAINT FK_obsahuje_surovina_potravina FOREIGN KEY (potravina)
                    REFERENCES Potravina(id_jidlo),
    CONSTRAINT PK_obsahuje_surovina PRIMARY KEY (surovina, potravina)
);

CREATE TABLE Obsahuje_potravina(
    potravina NUMBER NOT NULL,
    objednavka NUMBER NOT NULL,
    mnozstvi VARCHAR2(10),
    CONSTRAINT FK_obsahuje_potravina_potravina FOREIGN KEY (potravina)
                    REFERENCES Potravina(id_jidlo),
    CONSTRAINT FK_obsahuje_potravina_objednavka FOREIGN KEY (objednavka)
                    REFERENCES Objednavka(id_objednavka),
    CONSTRAINT PK_obsahuje_potravina PRIMARY KEY (potravina, objednavka)
);

-- tvorba sekcenci
CREATE SEQUENCE Zamestnanec_seq
    START WITH 1;
CREATE SEQUENCE Rezervace_seq;
CREATE SEQUENCE Objednavka_seq;
CREATE SEQUENCE Stul_seq;
CREATE SEQUENCE Uctenka_seq;
CREATE SEQUENCE Potravina_seq;
CREATE SEQUENCE Surovina_seq;

----------------------------------------------------------------------
-- role
--CREATE ROLE xsormj00; nemame dostatek opravneni

GRANT ALL ON Zamestnanec TO xsormj00;
GRANT ALL ON Rezervace TO xsormj00;
GRANT ALL ON Objednavka TO xsormj00;
GRANT ALL ON Potravina TO xsormj00;
GRANT ALL ON Stul TO xsormj00;
GRANT ALL ON Uctenka TO xsormj00;
GRANT ALL ON Surovina TO xsormj00;

GRANT ALL ON Objednavka_pro_stul TO xsormj00;
GRANT ALL ON Rezervace_na_stul TO xsormj00;
GRANT ALL ON Obsahuje_surovina TO xsormj00;
GRANT ALL ON Obsahuje_potravina TO xsormj00;


-----------------------------------------------------------------------
-- triggery
-- automaticke generovani primarniho klice tabulky Zamestnanec ze sekvence
CREATE OR REPLACE TRIGGER Zamestnanec_trigger_ID
BEFORE INSERT ON Zamestnanec
FOR EACH ROW
BEGIN
    IF :new.id_zam IS NULL THEN 
    SELECT Zamestnanec_seq.NEXTVAL
    INTO :NEW.id_zam
    FROM dual;
    END IF;
END Zamestnanec_trigger_ID;
/

-- kontrola rodneho cisla
--CONSTRAINT CHK_zamestanec_rc CHECK (MOD(rodne_cislo, 11) = 0 AND ( (SUBSTR(rodne_cislo, 3, 2) < 13 AND SUBSTR(rodne_cislo, 3, 2) > 0) OR (SUBSTR(rodne_cislo, 3, 2) < 63 AND SUBSTR(rodne_cislo, 3, 2) > 50) ) )
CREATE OR REPLACE TRIGGER Zamestnanec_trigger_RC
BEFORE INSERT OR UPDATE OF rodne_cislo ON Zamestnanec
FOR EACH ROW
BEGIN
    IF  ( MOD (:new.rodne_cislo, 11) != 0 OR ( ( SUBSTR(:new.rodne_cislo, 3, 2) > 13 OR SUBSTR(:new.rodne_cislo, 3, 2) < 0) AND (SUBSTR(:new.rodne_cislo, 3, 2) > 63 OR SUBSTR(:new.rodne_cislo, 3, 2) < 50) ) ) THEN
       RAISE_APPLICATION_ERROR(-20001,'Neplatne rodne cislo');
    END IF;
END Zamestnanec_trigger_RC;
/

-- PROCEDURY

-- pocet a informace o obsazenych stolech k danemu datu
CREATE OR REPLACE PROCEDURE informace_obsazene_stoly_k_datu( datum_zvolene in DATE)
is
    CURSOR obsazene_stoly IS
        
        SELECT DISTINCT id_stul, umisteni, pocet_osob, to_char( Objednavka.datum , 'YYYYMMDDHH') datum
        FROM Stul, Objednavka, Objednavka_pro_stul 
        WHERE Stul.id_stul = Objednavka_pro_stul.stul
            AND Objednavka.id_objednavka = Objednavka_pro_stul.objednavka;       
            
    obsazene_stoly_rec     obsazene_stoly%ROWTYPE;
    pocet_stolu             NUMBER;
    pocet_stolu_celkem      NUMBER;
    umisteni_stolu          Stul.umisteni%TYPE ;
    pocet_osob              Stul.pocet_osob%TYPE ;
BEGIN    
    -- open cursor and loop data
    pocet_stolu := 0;
    SELECT count(*) INTO pocet_stolu_celkem FROM Stul;
    --dbms_output.put_line( ', DATUM: ' || datum_zvolene );
    OPEN obsazene_stoly;
    LOOP
        FETCH obsazene_stoly into obsazene_stoly_rec;
        EXIT WHEN obsazene_stoly%NOTFOUND;      
        if ( obsazene_stoly_rec.datum =  TO_CHAR(datum_zvolene, 'YYYYMMDDHH') ) THEN
            pocet_stolu := pocet_stolu + 1 ;
            dbms_output.put_line('Stul ID: ' || obsazene_stoly_rec.id_stul || ', Pocet osob: ' || obsazene_stoly_rec.pocet_osob || ', Umisteni: ' || obsazene_stoly_rec.umisteni  );  
        END IF;
    END LOOP;
        dbms_output.put_line('Pocet obsazenych stolu: ' || pocet_stolu || '/' || pocet_stolu_celkem || ', Obsazenost: ' || ROUND( (pocet_stolu * 100 )/ pocet_stolu_celkem, 2) || '%' );
     EXCEPTION
    WHEN ZERO_DIVIDE THEN
        dbms_output.put_line('Pocet obsazenych stolu: ' || pocet_stolu || '/' || pocet_stolu_celkem || ', Obsazenost: ' || 0 || '%' );
     WHEN OTHERS THEN
        Raise_Application_Error(-20002, 'Neznama chyba');
END;
/

-- kolik objednavek a jaka je celkova suma za dane obdobi
CREATE OR REPLACE PROCEDURE statistika_objednavek_za_obdobi( datum_od in DATE, datum_do in DATE)
is
    CURSOR objednavky IS     
        SELECT suma, to_char( datum, 'YYYYMMDD' ) datum
        FROM Objednavka;      
            
    objednavky_rec       objednavky%ROWTYPE;
    suma                 Objednavka.suma%TYPE;
    pocet_dni            NUMBER;  
    pocet_objednavek     NUMBER;

BEGIN    
    -- open cursor and loop data
    suma := 0;
    pocet_objednavek := 0;
    pocet_dni :=  TO_CHAR(datum_do, 'YYYYMMDD') - TO_CHAR(datum_od, 'YYYYMMDD');
    OPEN objednavky;
    LOOP
        FETCH objednavky into objednavky_rec;
        EXIT WHEN objednavky%NOTFOUND;      
        if ( objednavky_rec.datum >= TO_CHAR(datum_od, 'YYYYMMDD') AND objednavky_rec.datum <= TO_CHAR(datum_do, 'YYYYMMDD') ) THEN
            suma := suma + objednavky_rec.suma ;
            pocet_objednavek := pocet_objednavek + 1;     
        END IF;
    END LOOP;
        dbms_output.put_line('Celkovy pocet dni: ' || pocet_dni || ', Pocet objednavek: ' || pocet_objednavek || ', Celkova suma: ' || suma );
     EXCEPTION
     WHEN OTHERS THEN
        Raise_Application_Error(-20002, 'Neznama chyba');
END;
/

-- xsormj00 dostane i prava spousten dane procedury
GRANT EXECUTE ON statistika_objednavek_za_obdobi TO xsormj00;
GRANT EXECUTE ON informace_obsazene_stoly_k_datu TO xsormj00;


------------------------------------------------------------
-- spousteni procedur

-- informace o obsazenych stolech k danemu datu
exec informace_obsazene_stoly_k_datu ( TO_DATE('20180326184705', 'yyyymmddhh24miss'));

-- informace o obsazenych stolech k danemu datu
exec informace_obsazene_stoly_k_datu ( TO_DATE('20180324183350', 'yyyymmddhh24miss') );

-- informace o obsazenych stolech k danemu datu, deleni nulou
exec informace_obsazene_stoly_k_datu ( TO_DATE('20190324183350', 'yyyymmddhh24miss'));

-- statistika za obdobi
exec statistika_objednavek_za_obdobi( TO_DATE('20180324183350', 'yyyymmddhh24miss') , TO_DATE('20180326184705', 'yyyymmddhh24miss')  );

-----------------------------------------------------------------

    
-- priklad prvniho triggeru:
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES (  'Jan', 'Sorm', '9911111111', 'Tyrsova 70, Brno-Kralovo Pole', 'spoluxsormj00');
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES (  'Alena', 'Tesarova', '9951151111', 'Alencina 42, Brno-Lisen', 'spoluxsormj00');
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES (  'Vaclav', 'Kraus', '8811111111', 'U Alenky 2, Brno-Medlanky', 'sefkuchar');
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES (  'Daniel', 'Uhricek', '0011111111', 'Kolejni 4, Brno-Kralovo Pole', 'kuchar');
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES (  'Zuzana', 'Cisarova', '6651261111', 'Kolejni 4, Brno-Kralovo Pole', 'servirka');
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES ( 'Arina', 'Starastsina', '6651261111', 'Jegora Pavlovice 4, Minsk', 'servirka');
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES ( 'Jan', 'Konstant', '7751261111', 'Trnita 7 Brno-Lisen', 'kuchar');

--priklad na druhy trigger, spatne RC, detekce chyby
INSERT INTO Zamestnanec (jmeno, prijmeni, rodne_cislo, adresa, pozice)
VALUES ( 'Jan', 'Smoula', '7851261111', 'Ulita 785 Brno-Lisen', 'kuchar cisnik');


INSERT INTO Rezervace
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180324150000', 'yyyymmddhh24miss'), 'Jiri', 'Matejka', 'jiri@matejka.cz', 3);
INSERT INTO Rezervace
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180325163000', 'yyyymmddhh24miss'), 'Ondrej', 'Slimak', 'ondrej@slimak.cz', 3);
INSERT INTO Rezervace
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180325150000', 'yyyymmddhh24miss'), 'Denisa', 'Sramkova', '+420 776 666 666', 2);
INSERT INTO Rezervace
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180326180000', 'yyyymmddhh24miss'), 'Jiri', 'Kadlec', 'jiri@kadlec.cz', 1);
INSERT INTO Rezervace
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180324143000', 'yyyymmddhh24miss'), 'Timotej', 'Sujan', '+420 776 776 776', 2);
INSERT INTO Rezervace
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180326170000', 'yyyymmddhh24miss'), 'Jiri', 'Martinek', 'jiri@martinek.cz', 3);

INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180324163300', 'yyyymmddhh24miss'), 100.0, 5, NULL);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180324150100', 'yyyymmddhh24miss'), 220.0, 5, 1);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180324150954', 'yyyymmddhh24miss'), 151.0, 5, 1);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180325163300', 'yyyymmddhh24miss'), 100.0, 6, 2);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180325163350', 'yyyymmddhh24miss'), 57.0, 6, 2);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180324173301', 'yyyymmddhh24miss'), 400.0, 6, NULL);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180324183350', 'yyyymmddhh24miss'), 1000.0, 6, NULL);
INSERT INTO Objednavka
VALUES ( Objednavka_seq.NEXTVAL, TO_DATE('20180326180105', 'yyyymmddhh24miss'), 333.0, 5, 6);

INSERT INTO Stul
VALUES ( Stul_seq.NEXTVAL, 'zahradka', 4);
INSERT INTO Stul
VALUES ( Stul_seq.NEXTVAL, 'zahradka', 8);
INSERT INTO Stul
VALUES ( Stul_seq.NEXTVAL, 'uvnitr', 12);
INSERT INTO Stul
VALUES ( Stul_seq.NEXTVAL, 'uvnitr', 4);
INSERT INTO Stul
VALUES ( Stul_seq.NEXTVAL, 'uvnitr', 4);
INSERT INTO Stul
VALUES ( Stul_seq.NEXTVAL, 'uvnitr', 2);

INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180324164800', 'yyyymmddhh24miss'), 70, 1);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180324164800', 'yyyymmddhh24miss'), 30, 1);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180324145010', 'yyyymmddhh24miss'), 220, 2);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180325163900', 'yyyymmddhh24miss'), 151, 3);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180325165350', 'yyyymmddhh24miss'), 60, 4);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180325165350', 'yyyymmddhh24miss'), 40, 4);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180325164351', 'yyyymmddhh24miss'), 57, 5);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180324180001', 'yyyymmddhh24miss'), 400, 6);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180324184950', 'yyyymmddhh24miss'), 1000, 7);
INSERT INTO Uctenka
VALUES ( Uctenka_seq.NEXTVAL, TO_DATE('20180326184705', 'yyyymmddhh24miss'), 333, 8);

INSERT INTO Potravina
VALUES ( Potravina_seq.NEXTVAL, 'kure s brambory', 120, 21, 74, 455, 20, 12, TO_DATE('20180326184705', 'yyyymmddhh24miss'), NULL, 'normalni');
INSERT INTO Potravina
VALUES ( Potravina_seq.NEXTVAL, 'kure s ryzi', 111, 21, 74, 455, 20, 12, TO_DATE('20180326184705', 'yyyymmddhh24miss'), NULL, 'normalni');
INSERT INTO Potravina
VALUES ( Potravina_seq.NEXTVAL, 'bolonske spagety', 80, 21, 74, 455, 20, 12, TO_DATE('20180326184705', 'yyyymmddhh24miss'), NULL, 'vidlicka a lzicka');
INSERT INTO Potravina
VALUES ( Potravina_seq.NEXTVAL, 'pivo', 20, 100, 74, 455, 20, 12, TO_DATE('20180326184705', 'yyyymmddhh24miss'), 'pullitr', NULL);
INSERT INTO Potravina
VALUES ( Potravina_seq.NEXTVAL, 'vino', 25, 21, 74, 455, 20, 12, TO_DATE('20180326184705', 'yyyymmddhh24miss'), 'na vino', NULL);
INSERT INTO Potravina
VALUES ( Potravina_seq.NEXTVAL, 'vodka', 70, 22, 55, 34, 20, 12, TO_DATE('20180329184705', 'yyyymmddhh24miss'), 'panak', NULL);

INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'kure' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'brambory' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'ryze' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'spagety' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'syr' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'chmel' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'psenice' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'voda' );
INSERT INTO Surovina
VALUES ( Surovina_seq.NEXTVAL, 'hrozny' );

INSERT INTO Obsahuje_surovina
VALUES ( 1, 1, 100 );
INSERT INTO Obsahuje_surovina
VALUES ( 2, 1, 100 );
INSERT INTO Obsahuje_surovina
VALUES ( 1, 2, 120 );
INSERT INTO Obsahuje_surovina
VALUES ( 3, 2, 80 );
INSERT INTO Obsahuje_surovina
VALUES ( 4, 3, 150 );
INSERT INTO Obsahuje_surovina
VALUES ( 5, 3, 20 );
INSERT INTO Obsahuje_surovina
VALUES ( 6, 4, 50 );
INSERT INTO Obsahuje_surovina
VALUES ( 7, 4, 30 );
INSERT INTO Obsahuje_surovina
VALUES ( 8, 4, 20 );
INSERT INTO Obsahuje_surovina
VALUES ( 9, 5, 50 );

INSERT INTO Obsahuje_potravina
VALUES ( 1, 1, 10 );
INSERT INTO Obsahuje_potravina
VALUES ( 5, 1, 10 );
INSERT INTO Obsahuje_potravina
VALUES ( 1, 2, 1 );
INSERT INTO Obsahuje_potravina
VALUES ( 2, 2, 1 );
INSERT INTO Obsahuje_potravina
VALUES ( 4, 2, 2 );
INSERT INTO Obsahuje_potravina
VALUES ( 3, 3, 4 );
INSERT INTO Obsahuje_potravina
VALUES ( 3, 4, 4 );

INSERT INTO Objednavka_pro_stul
VALUES ( 1, 1 );
INSERT INTO Objednavka_pro_stul
VALUES ( 2, 1 );
INSERT INTO Objednavka_pro_stul
VALUES ( 2, 2 );
INSERT INTO Objednavka_pro_stul
VALUES ( 3, 2 );
INSERT INTO Objednavka_pro_stul
VALUES ( 2, 3 );
INSERT INTO Objednavka_pro_stul
VALUES ( 2, 4 );
INSERT INTO Objednavka_pro_stul
VALUES ( 2, 5 );
INSERT INTO Objednavka_pro_stul
VALUES ( 3, 6 );
INSERT INTO Objednavka_pro_stul
VALUES ( 2, 7 );
INSERT INTO Objednavka_pro_stul
VALUES ( 4, 8 );
INSERT INTO Objednavka_pro_stul
VALUES ( 1, 8 );

INSERT INTO Rezervace_na_stul
VALUES ( 1, 1 );
INSERT INTO Rezervace_na_stul
VALUES ( 2, 2 );
INSERT INTO Rezervace_na_stul
VALUES ( 3, 2 );
INSERT INTO Rezervace_na_stul
VALUES ( 4, 3 );
INSERT INTO Rezervace_na_stul
VALUES ( 1, 4 );
INSERT INTO Rezervace_na_stul
VALUES ( 2, 4 );
INSERT INTO Rezervace_na_stul
VALUES ( 2, 5 );
INSERT INTO Rezervace_na_stul
VALUES ( 3, 6 );



-- 2 dotazy pro 2 tabulky
--vypise info o vsech rezervacich dne 25.3. (tj. jestli byla rezervace a kdy byly vyuctovany)
SELECT rez.jmeno_zakaznika || ' ' || rez.prijmeni_zakaznika zakaznik,
    rez.kontakt_zakaznika kontakt,
    TO_CHAR(rez.datum,'DD.MM.YYYY HH24:MI') datum,
    zam.jmeno || ' ' || zam.prijmeni vytvoril
FROM Rezervace rez,
    Zamestnanec zam
WHERE rez.datum BETWEEN TO_DATE ('2018/03/25', 'yyyy/mm/dd') AND TO_DATE ('2018/03/26', 'yyyy/mm/dd')
    AND zam.id_zam = rez.vlozil
ORDER BY rez.datum;

-- vypise vsechno piti, ktere si nekdo objednal
SELECT DISTINCT potr.nazev, potr.cena, potr.pocet_porci
FROM Obsahuje_potravina spoj,
    Potravina potr
WHERE potr.id_jidlo = spoj.potravina
    AND typ_sklenice IS NOT NULL
ORDER BY potr.nazev;


-- 1 dotaz na tri tabulky
--vypise info o vsech rezervovanych stolech dne 26.3. (tj. jestli byla rezervace a kdy byly vyuctovany)
SELECT stul.*,
    TO_CHAR(rez.datum,'HH24:MI') cas
FROM Rezervace rez,
    Stul stul,
    Rezervace_na_stul spoj
WHERE stul.id_stul = spoj.stul
    AND spoj.rezervace = rez.id_rezervace
    AND rez.datum BETWEEN TO_DATE ('2018/03/26', 'yyyy/mm/dd') AND TO_DATE ('2018/03/27', 'yyyy/mm/dd')
ORDER BY rez.datum;



-- 2 dotazy GROUP BY a agregacni funkci
-- vypise jmeno zamestnance a celkovou sumu u jim vytvorenych objednavek
SELECT zam.jmeno, zam.prijmeni, SUM( obj.suma )
FROM Zamestnanec zam,
    Objednavka obj
WHERE zam.id_zam = obj.vytvoril
GROUP BY zam.prijmeni, zam.jmeno;

-- vypise pocet mist u nejvetsiho stolu v zavislosti na lokaci
SELECT st.umisteni, MAX( st.pocet_osob )
FROM Stul st
GROUP BY st.umisteni;


-- 1 dotaz EXISTS
-- vypise jmeno, prijmeni a pozici zamestnancu, kteri nevytvorili zadnou objednavku
SELECT  zam.jmeno, zam.prijmeni, zam.pozice
FROM Zamestnanec zam
WHERE NOT EXISTS (
    SELECT id_objednavka
    FROM Objednavka
    WHERE zam.id_zam = vytvoril
);


-- 1 dotaz IN
-- vypise vsechny suroviny, ktere jsou pouzity v pive (id 4)
SELECT sur.jmeno_suroviny surovina
FROM Surovina sur
WHERE sur.id_surovina IN (
    SELECT surovina
    FROM Obsahuje_surovina
    WHERE potravina = 4
);

-- vsechny stoly k objednavkam
SELECT DISTINCT id_stul, umisteni, pocet_osob, Objednavka.datum
        FROM Stul, Objednavka, Objednavka_pro_stul 
        WHERE Stul.id_stul = Objednavka_pro_stul.stul
            AND Objednavka.id_objednavka = Objednavka_pro_stul.objednavka;


-------------------------------------------------------------------
-- EXPLAN PLAN

EXPLAIN PLAN FOR
SELECT id_objednavka, sum(Objednavka.suma)
FROM Objednavka, Stul, Objednavka_pro_stul
WHERE Objednavka.id_objednavka = Objednavka_pro_stul.objednavka
    AND Objednavka_pro_stul.stul = Stul.id_stul
GROUP BY id_objednavka;
    
SELECT * FROM TABLE(DBMS_XPLAN.display); 

CREATE INDEX index_objednavka_stul ON Objednavka_pro_stul(objednavka, stul);

EXPLAIN PLAN FOR
SELECT id_objednavka, sum(Objednavka.suma)
FROM Objednavka, Stul, Objednavka_pro_stul
WHERE Objednavka.id_objednavka = Objednavka_pro_stul.objednavka
    AND Objednavka_pro_stul.stul = Stul.id_stul
GROUP BY id_objednavka;
 
SELECT * FROM TABLE(DBMS_XPLAN.display);   

-------------------------------------------------------------------
-- Materializovany pohled
-- kolik vytvoril zamestnanec rezervaci
DROP MATERIALIZED VIEW zamestnanec_rezervace;

CREATE MATERIALIZED VIEW zamestnanec_rezervace
    CACHE -- pro lepsi nacitani z pohledu
    REFRESH ON COMMIT -- pohled s obnovou po commitu nad zdrojovou tabulkou
    AS
    SELECT prijmeni, count(id_rezervace)
    FROM Rezervace, Zamestnanec
    WHERE Rezervace.vlozil = Zamestnanec.id_zam
    GROUP BY prijmeni;

GRANT ALL ON zamestnanec_rezervace TO xsormj00;

-- demonstrace pohledu
INSERT INTO Rezervace (id_rezervace,datum, jmeno_zakaznika, prijmeni_zakaznika, kontakt_zakaznika, vlozil) 
VALUES ( Rezervace_seq.NEXTVAL, TO_DATE('20180329150000', 'yyyymmddhh24miss'), 'Jana', 'Spanelova', 'hopskulka@seznam.cz', 3);

COMMIT;

SELECT * FROM zamestnanec_rezervace;
