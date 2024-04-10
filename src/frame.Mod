MODULE frame;

IMPORT Out;

TYPE
  cell* = POINTER TO cellDesc;
  cellDesc* = RECORD
    (* abstract *)
    END;

  strCell* = POINTER TO strCellDesc;
  strCellDesc* = RECORD(cellDesc)
    string*: ARRAY 16 OF CHAR
  END;

  intCell* = POINTER TO intCellDesc;
  intCellDesc* = RECORD(cellDesc)
    int*: INTEGER
  END;



  columnName* = ARRAY 32 OF CHAR;
  cnames* = POINTER TO ARRAY OF columnName;
  column = POINTER TO ARRAY OF cell;
  matrix = POINTER TO ARRAY OF column;
  frm* = POINTER TO frmDesc;
  Tloader* = PROCEDURE (f: frm; filename: ARRAY OF CHAR);
  frmDesc* = RECORD
    height-, width-: INTEGER;
    mtrx*: matrix;
    columnNames*: cnames;
    load-: Tloader
    END;

PROCEDURE setLoader*(f: frm; l: Tloader);
BEGIN
  f^.load := l
END setLoader;

PROCEDURE create*(w, h: INTEGER): frm;
VAR
  f: frm;
  i: INTEGER;
BEGIN
  NEW(f);
  f^.width := w; f^.height := h;

  NEW(f^.mtrx, w);
  i := 0;
  REPEAT
    NEW(f^.mtrx[i], h);
    Out.String("i="); Out.Int(i,0); Out.Ln;
    INC(i)
  UNTIL i = w;

  NEW(f^.columnNames, h);

  RETURN f;
END create;

PROCEDURE write*(f: frm; cl:cell; c, r: INTEGER);
BEGIN
  f^.mtrx[c]^[r] := cl
END write;

PROCEDURE read*(f: frm; c, r: INTEGER): cell;
BEGIN
  RETURN f^.mtrx[c]^[r]
END read;

(*
PROCEDURE nameColumn*(f: frm; i: INTEGER; name: ARRAY OF CHAR);
BEGIN
  f^.columnNames^[i] := name
END nameColumn;
*)

PROCEDURE nameColumns*(f: frm; VAR names: cnames);
VAR
  i: INTEGER;
BEGIN
  f^.columnNames := names;
END nameColumns;

PROCEDURE printDataFrame*(f: frm);
VAR
  c, r: INTEGER;
  celll: cell;
BEGIN
  Out.Int(f^.width, 0); Out.Char('x'); Out.Int(f^.height, 0); Out.Ln;
  IF f^.columnNames # NIL THEN
    r := 0;
    REPEAT
      Out.String(f^.columnNames^[r]); Out.Char(' ');;
      INC(r)
    UNTIL r = LEN(f^.columnNames^);
    Out.Ln
  ELSE
    Out.String("column names are not set"); Out.Ln;
  END;
  r := 0;
  REPEAT
    c := 0;
    REPEAT
      celll := read(f, c, r);
      IF celll = NIL THEN
        Out.String("NIL");
      ELSIF celll IS strCell THEN
        Out.String(celll(strCell)^.string);
      ELSIF celll IS intCell THEN
        Out.Int(celll(intCell)^.int, 0);
      ELSE
        Out.String("Unknown");
      END;
      Out.Char(' ');
      INC(c)
    UNTIL c = f^.width;
    Out.Ln;
    INC(r);
  UNTIL r = f^.height;
  Out.Ln;
END printDataFrame;

END frame.
