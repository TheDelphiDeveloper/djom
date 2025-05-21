unit DJOM.Validations;

interface

uses
  System.SysUtils, System.Rtti, System.Generics.Collections, DJOM.Types;

type
  TValidations = class
  public
    class function MaxLength(MaxLen: Integer): TJsonValueValidator; static;
    class function Range(MinValue, MaxValue: Integer): TJsonValueValidator; static;
    class function InSet(const Values: array of string): TJsonValueValidator; static;
    class function Required(AValue: Boolean = False): TJsonValueValidator; static;
    class function NotEmpty(AValue: Boolean = False): TJsonValueValidator; static;

  end;

implementation

{ TValidations }

class function TValidations.MaxLength(MaxLen: Integer): TJsonValueValidator;
begin
  Result :=
    function(const V: TValue): Boolean
    begin
      Result := Length(Trim(V.ToString)) <= MaxLen;
    end;
end;

class function TValidations.NotEmpty(AValue: Boolean): TJsonValueValidator;
begin
  Result := TJsonValueValidator(
    function(const V: TValue): Boolean
    begin
      Result := Trim(V.ToString) <> '';
    end
  );
end;

class function TValidations.Range(MinValue, MaxValue: Integer): TJsonValueValidator;
begin
  Result :=
    function(const V: TValue): Boolean
    var
      I: Integer;
    begin
      if not TryStrToInt(Trim(V.ToString), I) then
        Exit(False);
      Result := (I >= MinValue) and (I <= MaxValue);
    end;
end;

class function TValidations.Required(AValue: Boolean): TJsonValueValidator;
begin
  Result := TJsonValueValidator(
    function(const V: TValue): Boolean
    begin
      Result := not V.IsEmpty;
    end
  );
end;

class function TValidations.InSet(const Values: array of string): TJsonValueValidator;
var
  Accepted: TArray<string>;
  I: Integer;
begin
  SetLength(Accepted, Length(Values));
  for I := 0 to High(Values) do
    Accepted[I] := LowerCase(Trim(Values[I]));

  Result :=
    function(const V: TValue): Boolean
    var
      Item: string;
    begin
      Result := False;
      for Item in Accepted do
        if LowerCase(Trim(V.ToString)) = Item then
          Exit(True);
    end;
end;

end.

