unit DJOM.Fields.Mapper;

interface

uses
  System.JSON, System.Rtti, System.SysUtils, System.Generics.Collections;

type
  TFieldMapping = class
    JsonField: string;
    PropName: string;
    HasDefault: Boolean;
    DefaultValue: TValue;
    Converter: TFunc<TValue, TValue>;
    Validator: TFunc<TValue, Boolean>;
end;


implementation

end.
