-- Mark -- 30 Nov -- 1. to 6. Create six views to retrieve either current or past data
-- Mark -- 30 Nov -- 7. Delete the other views

-- Mark -- 30 Nov -- 1. Create Artist view to retrieve current type
CREATE VIEW Artist_View AS
SELECT a.ArtistID, a.Name, a.Country, t.Type
FROM Artist a
    LEFT JOIN ArtistType atp
        ON a.ArtistID = atp.ArtistID
    LEFT JOIN Type t
        ON atp.TypeID = t.TypeID
WHERE (atp.EndDate IS NULL);

-- Mark -- 30 Nov -- 2. Create Artist History view to retrieve past types
CREATE VIEW Artist_History_View AS
SELECT a.ArtistID, t.Type, atp.StartDate, atp.EndDate
FROM Artist a
    LEFT JOIN ArtistType atp
        ON a.ArtistID = atp.ArtistID
    LEFT JOIN Type t
        ON atp.TypeID = t.TypeID
WHERE (atp.EndDate IS NOT NULL);

-- Mark -- 30 Nov -- 3. Create Album view to retrieve current genre
CREATE VIEW Album_View AS
SELECT a.AlbumID, a.Title, a.ReleaseDate, a.ArtistID, g.Genre
FROM Album a
    LEFT JOIN AlbumGenre ag
        ON a.AlbumID = ag.AlbumID
    LEFT JOIN Genre g
        ON ag.GenreID = g.GenreID
WHERE (ag.EndDate IS NULL);

-- Mark -- 30 Nov -- 4. Create Album History view to retrieve past genres
CREATE VIEW Album_History_View AS
SELECT a.AlbumID, g.Genre, ag.StartDate, ag.EndDate
FROM Album a
    LEFT JOIN AlbumGenre ag
        ON a.AlbumID = ag.AlbumID
    LEFT JOIN Genre g
        ON ag.GenreID = g.GenreID
WHERE (ag.EndDate IS NOT NULL);

-- Mark -- 30 Nov -- 5. Create Song view to retrieve current track number
CREATE VIEW Song_View AS
SELECT s.SongID, s.Title, s.DurationInSeconds, s.Language, s.IsExplicit, s.AlbumID,t.TrackNumber
FROM Song s
    LEFT JOIN SongTrackNumber st
        ON s.SongID = st.SongID
    LEFT JOIN TrackNumber t
        ON st.TrackNumberID = t.TrackNumberID
WHERE (st.EndDate IS NULL);

-- Mark -- 30 Nov -- 6. Create Song History view to retrieve past track numbers
CREATE VIEW Song_History_View AS
SELECT s.SongID, t.TrackNumber, st.StartDate, st.EndDate
FROM Song s
    LEFT JOIN SongTrackNumber st
        ON s.SongID = st.SongID
    LEFT JOIN TrackNumber t
        ON st.TrackNumberID = t.TrackNumberID
WHERE (st.EndDate IS NOT NULL);

/*
-- This view displays the most recent type ('solo' or 'group') 
-- for each artist along with basic artist information.
CREATE OR REPLACE VIEW Artist_View AS
SELECT 
    a.ArtistID,
    a.Name,
    a.Country,
    ath.Type AS ArtistType, -- Current type of the artist
    ath.StartTime AS TypeStartTime -- When this type became effective
FROM 
    Artist a
LEFT JOIN ArtistTypeHistory ath 
    ON a.ArtistID = ath.ArtistID
WHERE 
    ath.EndTime IS NULL;

-- This view displays the albums and their associated songs, 
-- including the current track number for each song.
CREATE OR REPLACE VIEW Album_View AS
SELECT 
    a.AlbumID,
    a.Title AS AlbumTitle,
    s.SongID,
    s.Title AS SongTitle,
    tsh.TrackNumber, -- Current track number of the song in the album
    tsh.StartTime AS TrackStartTime -- When this track number became effective
FROM 
    Album a
LEFT JOIN TrackSongHistory tsh 
    ON a.AlbumID = tsh.AlbumID
LEFT JOIN Song s 
    ON tsh.SongID = s.SongID
WHERE 
    tsh.EndTime IS NULL;

-- This view displays contributors, the albums they are associated with, 
-- and the current genre of the albums.
CREATE OR REPLACE VIEW Contributor_View AS
SELECT 
    c.ContributorID,
    c.Name AS ContributorName,
    a.AlbumID,
    a.Title AS AlbumTitle,
    agh.Genre AS AlbumGenre, -- Current genre of the album
    agh.StartTime AS GenreStartTime -- When this genre became effective
FROM 
    Contributor c
LEFT JOIN AlbumGenreHistory agh 
    ON c.ContributorID = agh.AlbumID
LEFT JOIN Album a 
    ON agh.AlbumID = a.AlbumID
WHERE 
    agh.EndTime IS NULL;
*/
