unit DJOM.Converters;

interface

uses
  System.SysUtils, System.Rtti, DJOM.Types;

type
  TConverters = class
  public
    class function Trim(Unused: Boolean = False): TJsonValueConverter; static;
    class function UpperCase(Unused: Boolean = False): TJsonValueConverter; static;
    class function ToDate(Unused: Boolean = False): TJsonValueConverter; static;
    class function ToInteger(Unused: Boolean = False): TJsonValueConverter; static;
    class function ToFloat(Unused: Boolean = False): TJsonValueConverter; static;
    class function ToBoolean(Unused: Boolean = False): TJsonValueConverter; static;
  end;

implementation

{ TConverters }

class function TConverters.Trim(Unused: Boolean): TJsonValueConverter;
begin
  Result :=
    function(const V: TValue): TValue
    begin
      Result := System.SysUtils.Trim(V.ToString);
    end;
end;

class function TConverters.UpperCase(Unused: Boolean): TJsonValueConverter;
begin
  Result :=
    function(const V: TValue): TValue
    begin
      Result := System.SysUtils.UpperCase(System.SysUtils.Trim(V.ToString));
    end;
end;

class function TConverters.ToDate(Unused: Boolean): TJsonValueConverter;
begin
  Result :=
    function(const V: TValue): TValue
    begin
      Result := System.SysUtils.StrToDate(System.SysUtils.Trim(V.ToString));
    end;
end;

class function TConverters.ToInteger(Unused: Boolean): TJsonValueConverter;
begin
  Result :=
    function(const V: TValue): TValue
    begin
      Result := System.SysUtils.StrToIntDef(System.SysUtils.Trim(V.ToString), 0);
    end;
end;

class function TConverters.ToFloat(Unused: Boolean): TJsonValueConverter;
begin
  Result :=
    function(const V: TValue): TValue
    begin
      Result := System.SysUtils.StrToFloatDef(System.SysUtils.Trim(V.ToString), 0);
    end;
end;

class function TConverters.ToBoolean(Unused: Boolean): TJsonValueConverter;
begin
  Result :=
    function(const V: TValue): TValue
    var
      S: string;
    begin
      S := LowerCase(System.SysUtils.Trim(V.ToString));
      Result := (S = 'true') or (S = '1') or (S = 'yes') or (S = 'sim');
    end;
end;

end.

