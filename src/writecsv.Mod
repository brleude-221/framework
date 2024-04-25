MODULE writecsv;

IMPORT Out, frame, Files, SYSTEM, oocIntStr;

PROCEDURE saveDataFrameToCSV*(f: frame.frm; filename: ARRAY OF CHAR);
VAR
  file: Files.File;
  rider: Files.Rider;
  c, r: LONGINT;
  celll: frame.cell;
  res: INTEGER;
  strFromInt: ARRAY 256 OF CHAR;
BEGIN
  file := Files.New(filename);
  IF file = NIL THEN
    Out.String("can't create file"); Out.Ln;
    HALT(8)
  END;
  ASSERT (file # NIL);
  Files.Set(rider, file, 0);
  IF f^.hasColumnNames THEN
    IF f^.columnNames # NIL THEN
      FOR c := 0 TO LEN(f^.columnNames^) - 1 DO
        Files.WriteString(rider, f^.columnNames^[c]);
        IF c < LEN(f^.columnNames^) - 1 THEN
          Files.WriteString(rider, f^.columnNames[c]); Files.Write(rider, 020X);
          Files.WriteString(rider, ', ');
        ELSE
          Files.Write(rider, 0AX);
        END;
      END;
    END;
  END;

  FOR r := 0 TO f^.height - 1 DO
    FOR c := 0 TO f^.width - 1 DO
      celll := frame.read(f, SHORT(c), SHORT(r));
      IF celll = NIL THEN
        (* assuming this is wrong syntax below *)
        Files.WriteString(rider, '" "');
      ELSIF celll IS frame.strCell THEN
        Files.WriteString(rider, celll(frame.strCell)^.string);
      ELSIF celll IS frame.intCell THEN
        (* why? *)
        (*Out.Int(celll(frame.intCell)^.int, 0); Out.Ln;*)
        (*Files.WriteLInt(rider, celll(frame.intCell)^.int);*)
        oocIntStr.IntToStr(celll(frame.intCell)^.int, strFromInt);
        Files.WriteString(rider, strFromInt);
      ELSE
        Files.WriteString(rider, 'Unknown');
      END;
      IF c < f^.width - 1 THEN
        Files.WriteString(rider, ', ');
      ELSE
        Files.Write(rider, 0AX);
      END;
    END;
  END;

  Files.Close(file);
  
  Files.Register(file)
END saveDataFrameToCSV;

END writecsv.

