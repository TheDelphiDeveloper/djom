unit DJOM.Interfaces.Mapper;

interface

uses
  System.Rtti, DJOM.Types;

type
  IJsonMapper<T: class> = interface
    function Field(const JsonField: string): IJsonMapper<T>;
    function ToProp(const PropName: string): IJsonMapper<T>;
    function WithDefault(const Value: TValue): IJsonMapper<T>;
    function WithConverter(Func: TJsonValueConverter): IJsonMapper<T>;
    function Validate(Func: TJsonValueValidator): IJsonMapper<T>;
    function Apply(const JsonStr: string): T;
    function ToJsonDJOM(const Obj: T): string;
  end;

implementation

end.
