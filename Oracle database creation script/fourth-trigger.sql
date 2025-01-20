-- Mark -- 30 Nov --

-- Mark -- 30 Nov -- 1. Create INSERT triger for Artist_View
CREATE OR REPLACE TRIGGER trg_Insert_Artist
INSTEAD OF INSERT ON Artist_View
FOR EACH ROW
DECLARE
    is_type_exists NUMBER;
BEGIN

    SELECT COUNT(*) INTO is_type_exists
    FROM Type
    WHERE Type = :NEW.Type;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        is_type_exists := 0;

    IF is_type_exists = 0 THEN
        INSERT INTO Type (Type)
        VALUES (:NEW.Type);
    END IF;

    INSERT INTO Artist (Name, Country)
    VALUES (:NEW.Name, :NEW.Country);

    INSERT INTO ArtistType (StartDate, EndDate, ArtistID, TypeID, HistoryType)
    VALUES (SYSTIMESTAMP, NULL, 
            (SELECT ArtistID FROM Artist 
            WHERE Name = :NEW.Name AND Country = :NEW.Country AND ROWNUM = 1),
            (SELECT TypeID FROM Type
            WHERE Type = :NEW.Type AND ROWNUM = 1),
            :NEW.Type);

END;
/

-- Mark -- 30 Nov -- 2. Create UPDATE triger for Artist_View
CREATE OR REPLACE TRIGGER trg_Update_Artist
INSTEAD OF UPDATE ON Artist_View
FOR EACH ROW
DECLARE
    is_type_exists NUMBER;
    old_type_id NUMBER;
    new_type_id NUMBER;
BEGIN

    SELECT COUNT(*) INTO is_type_exists
    FROM Type
    WHERE Type = :NEW.Type;

    IF is_type_exists = 0 THEN
        INSERT INTO Type (Type)
        VALUES (:NEW.Type);
    END IF;

    SELECT atp.TypeID INTO old_type_id
    FROM ArtistType atp
        LEFT JOIN Type t ON atp.TypeID = t.TypeID
    WHERE atp.ArtistID = :OLD.ArtistID
      AND atp.EndDate IS NULL;

    SELECT TypeID INTO new_type_id
    FROM Type
    WHERE Type = :NEW.Type;

    IF old_type_id != new_type_id THEN
        UPDATE ArtistType
        SET EndDate = SYSTIMESTAMP
        WHERE ArtistID = :OLD.ArtistID
          AND EndDate IS NULL;

        INSERT INTO ArtistType (StartDate, EndDate, ArtistID, TypeID, HistoryType)
        VALUES (SYSTIMESTAMP, NULL, :OLD.ArtistID, new_type_id, :NEW.Type);
    END IF;

END;
/

-- Mark -- 30 Nov -- 3. Create DELETE triger for Artist_View
CREATE OR REPLACE TRIGGER trg_Delete_Artist
INSTEAD OF DELETE ON Artist_View
FOR EACH ROW
DECLARE
    type_id NUMBER;
BEGIN

    SELECT TypeID INTO type_id
    FROM Type
    WHERE Type = :OLD.Type;

    UPDATE ArtistType
    SET EndDate = SYSTIMESTAMP
    WHERE ArtistID = :OLD.ArtistID
      AND TypeID = type_id
      AND EndDate IS NULL;

END;
/

-- Mark -- 30 Nov -- 4. Create INSERT triger for Album_View
CREATE OR REPLACE TRIGGER trg_Insert_Album
INSTEAD OF INSERT ON Album_View
FOR EACH ROW
DECLARE
    is_genre_exists NUMBER;
BEGIN

    SELECT COUNT(*) INTO is_genre_exists
    FROM Genre
    WHERE Genre = :NEW.Genre;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        is_genre_exists := 0;

    IF is_genre_exists = 0 THEN
        INSERT INTO Genre (Genre)
        VALUES (:NEW.Genre);
    END IF;

    INSERT INTO Album (Title, ReleaseDate, ArtistID)
    VALUES (:NEW.Title, :NEW.ReleaseDate, :NEW.ArtistID);

    INSERT INTO AlbumGenre (StartDate, EndDate, AlbumID, GenreID, HistoryGenre)
    VALUES (SYSTIMESTAMP, NULL,
            (SELECT AlbumID FROM Album WHERE Title = :NEW.Title AND ROWNUM = 1),
            (SELECT GenreID FROM Genre WHERE Genre = :NEW.Genre AND ROWNUM = 1),
            :NEW.Genre);
END;
/

-- Mark -- 30 Nov -- 5. Create UPDATE triger for Album_View
CREATE OR REPLACE TRIGGER trg_Update_Album
INSTEAD OF UPDATE ON Album_View
FOR EACH ROW
DECLARE
    is_genre_exists NUMBER;
    old_genre_id NUMBER;
    new_genre_id NUMBER;
BEGIN

    SELECT COUNT(*) INTO is_genre_exists
    FROM Genre
    WHERE Genre = :NEW.Genre;

    IF is_genre_exists = 0 THEN
        INSERT INTO Genre (Genre)
        VALUES (:NEW.Genre);
    END IF;

    SELECT ag.GenreID INTO old_genre_id
    FROM AlbumGenre ag
        LEFT JOIN Genre g ON ag.GenreID = g.GenreID
    WHERE ag.AlbumID = :OLD.AlbumID
      AND ag.EndDate IS NULL;

    SELECT GenreID INTO new_genre_id
    FROM Genre
    WHERE Genre = :NEW.Genre;

    IF old_genre_id != new_genre_id THEN
        UPDATE AlbumGenre
        SET EndDate = SYSTIMESTAMP
        WHERE AlbumID = :OLD.AlbumID
          AND EndDate IS NULL;

        INSERT INTO AlbumGenre (StartDate, EndDate, AlbumID, GenreID, HistoryGenre)
        VALUES (SYSTIMESTAMP, NULL, :OLD.AlbumID, new_genre_id, :NEW.Genre);
    END IF;
END;
/

-- Mark -- 30 Nov -- 6. Create DELETE triger for Album_View
CREATE OR REPLACE TRIGGER trg_Delete_Album
INSTEAD OF DELETE ON Album_View
FOR EACH ROW
DECLARE
    genre_id NUMBER;
BEGIN

    SELECT GenreID INTO genre_id
    FROM Genre
    WHERE Genre = :OLD.Genre;

    UPDATE AlbumGenre
    SET EndDate = SYSTIMESTAMP
    WHERE AlbumID = :OLD.AlbumID
      AND GenreID = genre_id
      AND EndDate IS NULL;
END;
/

-- Mark -- 30 Nov -- 7. Create INSERT triger for Song_View
CREATE OR REPLACE TRIGGER trg_Insert_Song
INSTEAD OF INSERT ON Song_View
FOR EACH ROW
DECLARE
    is_track_exists NUMBER;
BEGIN

    SELECT COUNT(*) INTO is_track_exists
    FROM TrackNumber
    WHERE TrackNumber = :NEW.TrackNumber;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        is_track_exists := 0;

    IF is_track_exists = 0 THEN
        INSERT INTO TrackNumber (TrackNumber)
        VALUES (:NEW.TrackNumber);
    END IF;

    INSERT INTO Song (Title, DurationInSeconds, Language, IsExplicit, AlbumID)
    VALUES (:NEW.Title, :NEW.DurationInSeconds, :NEW.Language, :NEW.IsExplicit, :NEW.AlbumID);

    INSERT INTO SongTrackNumber (StartDate, EndDate, SongID, TrackNumberID, HistoryTrackNumber)
    VALUES (SYSTIMESTAMP, NULL,
            (SELECT SongID FROM Song WHERE Title = :NEW.Title AND ROWNUM = 1),
            (SELECT TrackNumberID FROM TrackNumber WHERE TrackNumber = :NEW.TrackNumber AND ROWNUM = 1),
            :NEW.TrackNumber);
END;
/

-- Mark -- 30 Nov -- 8. Create INSERT triger for Song_View
CREATE OR REPLACE TRIGGER trg_Update_Song
INSTEAD OF UPDATE ON Song_View
FOR EACH ROW
DECLARE
    is_track_exists NUMBER;
    old_track_id NUMBER;
    new_track_id NUMBER;
BEGIN

    SELECT COUNT(*) INTO is_track_exists
    FROM TrackNumber
    WHERE TrackNumber = :NEW.TrackNumber;

    IF is_track_exists = 0 THEN
        INSERT INTO TrackNumber (TrackNumber)
        VALUES (:NEW.TrackNumber);
    END IF;

    SELECT st.TrackNumberID INTO old_track_id
    FROM SongTrackNumber st
        LEFT JOIN TrackNumber t ON st.TrackNumberID = t.TrackNumberID
    WHERE st.SongID = :OLD.SongID
      AND st.EndDate IS NULL;

    SELECT TrackNumberID INTO new_track_id
    FROM TrackNumber
    WHERE TrackNumber = :NEW.TrackNumber;

    IF old_track_id != new_track_id THEN
        UPDATE SongTrackNumber
        SET EndDate = SYSTIMESTAMP
        WHERE SongID = :OLD.SongID
          AND EndDate IS NULL;

        INSERT INTO SongTrackNumber (StartDate, EndDate, SongID, TrackNumberID, HistoryTrackNumber)
        VALUES (SYSTIMESTAMP, NULL, :OLD.SongID, new_track_id, :NEW.TrackNumber);
    END IF;
END;
/

-- Mark -- 30 Nov -- 9. Create DELETE triger for Song_View
CREATE OR REPLACE TRIGGER trg_Delete_Song
INSTEAD OF DELETE ON Song_View
FOR EACH ROW
DECLARE
    track_number_id NUMBER;
BEGIN

    SELECT TrackNumberID INTO track_number_id
    FROM TrackNumber
    WHERE TrackNumber = :OLD.TrackNumber;

    UPDATE SongTrackNumber
    SET EndDate = SYSTIMESTAMP
    WHERE SongID = :OLD.SongID
      AND TrackNumberID = track_number_id
      AND EndDate IS NULL;
END;
/
