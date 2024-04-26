MODULE stats;

IMPORT frame, Out;

PROCEDURE mean*(f: frame.frm; c: INTEGER);
VAR
  celll: frame.cell;
  i: INTEGER;
  intCount: INTEGER;
  intSum: LONGINT;
  mean: REAL;
BEGIN
  i := 0;
  intCount := 0;
  intSum := 0;
  REPEAT
  celll := frame.read(f, c, i);
  IF celll IS frame.intCell THEN
    INC(intCount);
    intSum := intSum + celll(frame.intCell)^.int;
  END;
  INC(i);
  UNTIL i = f^.height;
  IF intCount = 0 THEN
  Out.String("No integer values found"); Out.Ln;
  ELSE
    IF i < f^.height THEN
      Out.String("Attention! Non integer values are present in the column"); Out.Ln;
    END;
    mean := intSum DIV intCount;
    Out.String("mean = "); Out.Real(mean, 0); Out.Ln;
    Out.String("String cell is present in the column, mean is not informative"); Out.Ln;
  END;

END mean;

END stats.

