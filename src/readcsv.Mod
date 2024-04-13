MODULE readcsv;

    IMPORT frame, Files, Out, oocIntStr;


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
          IF rowCnt = 0 THEN 
            colCnt := commaCnt;
          ELSIF colCnt # commaCnt THEN
            ASSERT(TRUE);
          END;
          INC(rowCnt);
        END;
      UNTIL R.eof;
      frame.setSize(f, colCnt, rowCnt)
    END discoverAndSetSize;

    PROCEDURE ReadCSVFile*(f: frame.frm; fileName: ARRAY OF CHAR);
    VAR
        csvFile: Files.File;
        rider: Files.Rider;
        data: ARRAY 32 OF CHAR;
        int: LONGINT;
        icell: frame.intCell;
        scell: frame.strCell;
        fld, row: INTEGER;
        res: SHORTINT;
    BEGIN
      OpenCSVFile(fileName, csvFile, rider);
      discoverAndSetSize(f, rider);
        row := 0;
        REPEAT
          fld := 0;
          REPEAT 
            ReadCell(data, rider);
            oocIntStr.StrToInt(data, int, res);
            IF res = oocIntStr.strAllRight THEN 
              NEW(icell);
              icell.int := int;
              frame.write(f, icell, fld, row);
              Out.String("Its int!!!!!"); Out.Ln;
              Out.Int(int, 0); Out.Ln;
            ELSE
              NEW(scell);
              COPY(data, scell.string); 
              frame.write(f, scell, fld, row);
              Out.String("Its string!!!"); Out.Ln;
              Out.String(scell.string); Out.Ln;
            END;
            INC(fld);
            Out.String("fld = "); Out.Int(fld, 0); Out.Ln;
            Out.String("row = "); Out.Int(row, 0); Out.Ln;
          UNTIL fld = f^.width - 1;
        INC(row)
          UNTIL row = f^.height - 1;
        ReadCell(data, rider);

        Out.Ln; Out.Ln;
        Out.String(data); Out.Ln;
        Out.Ln;
 END ReadCSVFile;

END readcsv.
