MODULE readcsv;

    IMPORT frame, Files, Out;


    PROCEDURE OpenCSVFile(fileName: ARRAY OF CHAR; VAR f: Files.File; VAR r: Files.Rider);
    BEGIN
        f := Files.Old(fileName);
        Files.Set(r, f, 0);
    END OpenCSVFile;

    PROCEDURE isEOL(ch: CHAR): BOOLEAN;
    BEGIN
      IF (ch = CHR(13)) OR (ch = CHR(10)) THEN RETURN TRUE ELSE RETURN FALSE END
    END isEOL;

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
        b := ((ch = ",") OR isEOL(ch) OR rider.eof);
        IF ~b THEN
          INC(i)
        END;
      UNTIL b;
      cellData[i] := 0X;
    END ReadCell;

    PROCEDURE discoverAndSetSize(f: frame.frm; R: Files.Rider);
    VAR
      eol, comma: BOOLEAN;
      ch: CHAR;
      colCnt, rowCnt, commaCnt: INTEGER;
    BEGIN
      commaCnt := 1; rowCnt := 0;
      eol := FALSE; ch := 0X;
      REPEAT
        Files.Read(R, ch);
        IF ch = ',' THEN
          INC(commaCnt);
        ELSIF isEOL(ch) THEN 
          INC(rowCnt);
        END;
          colCnt := commaCnt DIV rowCnt + 1;
      UNTIL R.eof;
      Out.String("colCnt = "); Out.Int(colCnt, 0); Out.Ln;
      Out.String("rowCnt = "); Out.Int(rowCnt, 0); Out.Ln;
    END discoverAndSetSize;

    PROCEDURE ReadCSVFile*(f: frame.frm; fileName: ARRAY OF CHAR);
    VAR
        csvFile: Files.File;
        rider: Files.Rider;
        data: ARRAY 32 OF CHAR;
    BEGIN
      OpenCSVFile(fileName, csvFile, rider);
      discoverAndSetSize(f, rider);
        (*
        ReadCell(data, rider);
        Out.Ln; Out.Ln;
        Out.String(data); Out.Ln;
        Out.Ln;
        *)
 END ReadCSVFile;

END readcsv.
