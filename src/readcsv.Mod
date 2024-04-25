MODULE readcsv;

    IMPORT frame, Files, Out, oocIntStr, SYSTEM;

    CONST cellLength = 64;

    PROCEDURE OpenCSVFile(fileName: ARRAY OF CHAR; VAR f: Files.File; VAR r: Files.Rider);
    BEGIN
        f := Files.Old(fileName);
        Files.Set(r, f, 0);
    END OpenCSVFile;

    PROCEDURE isEOL(ch: CHAR): BOOLEAN;
    BEGIN
      IF (ch = CHR(13)) OR (ch = CHR(10)) THEN RETURN TRUE ELSE RETURN FALSE END
    END isEOL;

    PROCEDURE ReadCell(VAR cellData: ARRAY OF CHAR; VAR rider: Files.Rider; VAR eol: BOOLEAN);
    VAR
        ch: CHAR;
        i: INTEGER;
        b, quoted: BOOLEAN;
    BEGIN
      i := 0;
      ch := 0X;
      b := FALSE;
      quoted := FALSE;
      REPEAT
        Files.Read(rider, ch);
        IF ch = '"' THEN 
          quoted := ~quoted;
        END;
        cellData[i] := ch;
           (*  Out.String("i="); Out.Int(i, 0); Out.String(" ch="); Out.Char(ch); Out.Char(' '); *)
        eol := isEOL(ch);
            (* IF eol THEN Out.String("  EOL"); Out.Ln END; *)
        b := ((~ quoted) & (ch = ",")) OR eol OR rider.eof;
        IF ~b THEN
          INC(i)
        END;
      UNTIL b;
      cellData[i] := 0X;
    END ReadCell;

    PROCEDURE discoverWidth(r: Files.Rider): LONGINT;
    VAR
      count: INTEGER;
      tmpStr: ARRAY cellLength OF CHAR;
      eol: BOOLEAN;
    BEGIN
    count := 0;
    REPEAT
      ReadCell(tmpStr, r, eol);
      INC(count)
    UNTIL eol;

    RETURN count
    END discoverWidth;

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
      frame.setSize(f, colCnt, rowCnt + 1)
    END discoverAndSetSize;

    PROCEDURE ReadCSVFile*(f: frame.frm; fileName: ARRAY OF CHAR; hasColumnNames: BOOLEAN);
    VAR
        csvFile: Files.File;
        rider: Files.Rider;
        data: ARRAY cellLength OF CHAR;
        int: LONGINT;
        icell: frame.intCell;
        scell: frame.strCell;
        fld, row: INTEGER;
        res: SHORTINT;
        w: LONGINT;
        cn: frame.columnName;
        cns: frame.cnames;
        i: LONGINT;
        eol: BOOLEAN;
    BEGIN
      OpenCSVFile(fileName, csvFile, rider);
      IF hasColumnNames THEN
        w := discoverWidth(rider);
        (*Out.String("discovered width = "); Out.Int(w, 0); Out.Ln;*)
        NEW(cns, w);
        i := 0;
        REPEAT
          ReadCell(cn, rider, eol);
          COPY(cn, cns^[i]);
          INC(i)
        UNTIL i = w;
        frame.setColNames(f, cns);
      END;
      discoverAndSetSize(f, rider);
      Out.String("f^.width = "); Out.Int(f^.width, 0); Out.Ln;
      Out.String("f^.height = "); Out.Int(f^.height, 0); Out.Ln;
        row := 0;
        REPEAT
          fld := 0;
          REPEAT
            (*Out.String("fld = "); Out.Int(fld, 0); Out.Ln;
            Out.String("row = "); Out.Int(row, 0); Out.Ln;*)
            ReadCell(data, rider, eol);
            oocIntStr.StrToInt(data, int, res);
            IF res = oocIntStr.strAllRight THEN 
              NEW(icell);
              icell.int := int;
              frame.write(f, icell, fld, row);
              (*Out.String("Its int!!!!!"); Out.Ln;
              Out.Int(int, 0); Out.Ln; Out. Ln;*)
            ELSE
              NEW(scell);
              COPY(data, scell.string); 
              frame.write(f, scell, fld, row);
              (*Out.String("Its string!!!"); Out.Ln;
              Out.String(scell.string); Out.Ln; Out.Ln;*)
            END;
            INC(fld);
          UNTIL fld = f^.width;
        INC(row)
          UNTIL row = f^.height;
        ReadCell(data, rider, eol);

        Out.Ln; Out.Ln;
        Out.String(data); Out.Ln;
        Out.Ln;
 END ReadCSVFile;

END readcsv.
