MODULE writecsv;

IMPORT Out, frame, Files, SYSTEM;

PROCEDURE saveDataFrameToCSV*(f: frame.frm; filename: ARRAY OF CHAR);
VAR
  file: Files.File;
  rider: Files.Rider;
  c, r: LONGINT;
  celll: frame.cell;
  res: INTEGER;
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
(*
  FOR r := 0 TO f^.height - 1 DO
    FOR c := 0 TO f^.width - 1 DO
      celll := frame.read(f, c, r);
      IF celll = NIL THEN
        (* assuming this is wrong syntax below *)
        Files.WriteString(file, '" "');
      ELSIF celll IS frame.strCell THEN
        Files.WriteString(file, celll(frame.strCell)^.string);
      ELSIF celll IS frame.intCell THEN
        (* why? *)
        SYSTEM.VAL(INTEGER, Files.WriteInt(file, celll(frame.intCell)^.int));
      ELSE
        Files.WriteString(file, 'Unknown');
      END;
      IF c < f^.width - 1 THEN
        Files.WriteString(file, ', ');
      ELSE
        Files.WriteLn(file);
      END;
    END;
  END;

  Files.Close(file);
  *)
  Files.Register(file)
END saveDataFrameToCSV;

END writecsv.

