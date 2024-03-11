MODULE frame;

IMPORT Out;

TYPE 
  cell* = POINTER TO cellDesc;
  cellDesc* = RECORD 
    (* abstract *)
    END;
  
  column = POINTER TO ARRAY OF cell; 
  matrix = POINTER TO ARRAY OF column; 

  frm* = POINTER TO frmDesc;
  frmDesc* = RECORD
    height-, width-: INTEGER;
    mtrx: matrix; 
    END;

PROCEDURE create*(w, h: INTEGER): frm;
VAR
  f: frm;
  i: INTEGER;
BEGIN
  NEW(f);
  f^.width := w; f^.height := h;

  NEW(f^.mtrx, h);
  i:= 0;
  REPEAT
    NEW(f^.mtrx[i], w);

  UNTIL i = h - 1;
END create;

PROCEDURE write*(f: frm; cl: cell; c, r: INTEGER);
BEGIN
  f^.mtrx[c]^[r] := cl
END write;

PROCEDURE read*(f: frm; c, r: INTEGER): cell;
BEGIN
  RETURN f^.mtrx[c]^[r]
END read;

END frame.

