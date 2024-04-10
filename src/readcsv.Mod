MODULE readcsv;

    IMPORT frame, Files, Out;


    PROCEDURE OpenCSVFile(fileName: ARRAY OF CHAR; VAR f: Files.File; VAR r: Files.Rider);
    BEGIN
        f := Files.Old(fileName);
        Files.Set(r, f, 0);
    END OpenCSVFile;

    PROCEDURE ReadCell(VAR cellData: ARRAY OF CHAR; VAR rider: Files.Rider);
    VAR
        ch: CHAR;
        i: INTEGER;
        b: BOOLEAN;
    BEGIN
      i := 0;
      ch := 0X;
      b := FALSE;
      REPEAT
        Files.Read(rider, ch);
        cellData[i] := ch;
        b := ((ch = ",") OR (ch = CHR(13)) OR (ch = CHR(10)) OR rider.eof);
        IF ~b THEN
          INC(i)
        END;
      UNTIL b;
      cellData[i] := 0X;
    END ReadCell;

    PROCEDURE ReadCSVFile*(f: frame.frm; fileName: ARRAY OF CHAR);
    VAR
        csvFile: Files.File;
        rider: Files.Rider;
        data: ARRAY 32 OF CHAR;

    BEGIN
      OpenCSVFile(fileName, csvFile, rider);
        ReadCell(data, rider);
        Out.Ln; Out.Ln;
        Out.String(data); Out.Ln;
        Out.Ln;
 END ReadCSVFile;

END readcsv.
