unit DJOM.Types;

interface

uses
  System.Rtti;

type
  TJsonValueConverter = reference to function(const V: TValue): TValue;
  TJsonValueValidator = reference to function(const V: TValue): Boolean;

implementation

end.

