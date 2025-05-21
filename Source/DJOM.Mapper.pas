unit DJOM.Mapper;

interface

uses
  System.JSON, System.Rtti, System.SysUtils, System.Generics.Collections,
  DJOM.Types, DJOM.Fields.Mapper, DJOM.Interfaces.Mapper;

type
  TJsonMapper<T: class, constructor> = class(TInterfacedObject, IJsonMapper<T>)
  private
    FFields: TObjectList<TFieldMapping>;
    FCurrentMapping: TFieldMapping;
    function WithConverterLocal(const Func: TFunc<TValue, TValue>): IJsonMapper<T>;
    function ValidateLocal(Func: TFunc<TValue, Boolean>): IJsonMapper<T>;
  public
    constructor Create;
    destructor Destroy; override;

    // IJsonMapper<T>
    function Field(const JsonField: string): IJsonMapper<T>;
    function ToProp(const PropName: string): IJsonMapper<T>;
    function WithDefault(const Value: TValue): IJsonMapper<T>;
    function WithConverter(Func: TJsonValueConverter): IJsonMapper<T>;
    function Validate(Func: TJsonValueValidator): IJsonMapper<T>;
    function Apply(const JsonStr: string): T;
    function ToJsonDJOM(const Obj: T): string;
    function JSONArrayToList<T>(arr: TJSONArray): TList<T>;

  end;

  function ExtractNestedValue(Json: TJSONValue; const Path: string): TJSONValue;
  function JsonToTValue(val: TJSONValue): TValue;

implementation

uses
  System.TypInfo;

{ funcoes auxiliares}
function ExtractNestedValue(Json: TJSONValue; const Path: string): TJSONValue;
var
  Parts: TArray<string>;
  Value: TJSONValue;
  Part: string;
begin
  Result := nil;
  Value := Json;
  Parts := Path.Split(['.']);

  for Part in Parts do
  begin
    if not (Value is TJSONObject) then
      Exit(nil);

    Value := TJSONObject(Value).GetValue(Part);
    if Value = nil then
      Exit(nil);
  end;

  // ⚠️ Aqui é o lugar certo para tratar o tipo
  if (Value is TJSONArray) then
    Result := TJSONArray.ParseJSONValue(TJSONString(Value).ToJson)
  else
    Result := Value;

end;

function JsonToTValue(val: TJSONValue): TValue;
var
  intVal: Integer;
  dblVal: Double;
begin
  if val is TJSONTrue then
    Result := TValue.From<Boolean>(True)
  else if val is TJSONFalse then
    Result := TValue.From<Boolean>(False)
  else if val is TJSONNumber then
  begin
    // Tenta como Integer primeiro
    if TryStrToInt(val.Value, intVal) then
      Result := TValue.From<Integer>(intVal)
    else if TryStrToFloat(val.Value, dblVal) then
      Result := TValue.From<Double>(dblVal)
    else
      raise Exception.CreateFmt('Valor numérico inválido: %s', [val.Value]);
  end
  else if val is TJSONString then
    Result := TValue.From<string>(TJSONString(val).Value)
  else
    Result := TValue.FromVariant(val.Value); // fallback
end;


{ TJsonMapper<T> }

constructor TJsonMapper<T>.Create;
begin
  inherited;
  FFields := TObjectList<TFieldMapping>.Create(True);
end;

destructor TJsonMapper<T>.Destroy;
begin
  FFields.Free;
  inherited;
end;

function TJsonMapper<T>.Field(const JsonField: string): IJsonMapper<T>;
begin
  FCurrentMapping := TFieldMapping.Create;
  FCurrentMapping.JsonField := JsonField;
  Result := Self;
end;

function TJsonMapper<T>.JSONArrayToList<T>(arr: TJSONArray): TList<T>;
var
  item: TJSONValue;
  list: TList<T>;
begin
  list := TList<T>.Create;
  for item in arr do
    list.Add(TValue.FromVariant(item.Value).AsType<T>);
  Result := list;
end;

function TJsonMapper<T>.ToProp(const PropName: string): IJsonMapper<T>;
begin
  if not Assigned(FCurrentMapping) then
    raise Exception.Create('Field must be called before ToProp.');

  FCurrentMapping.PropName := PropName;
  FFields.Add(FCurrentMapping);
  Result := Self;
end;

function TJsonMapper<T>.WithDefault(const Value: TValue): IJsonMapper<T>;
begin
  if not Assigned(FCurrentMapping) then
    raise Exception.Create('Field/ToProp must be called before WithDefault.');

  FCurrentMapping.HasDefault := True;
  FCurrentMapping.DefaultValue := Value;
  Result := Self;
end;

function TJsonMapper<T>.WithConverter(Func: TJsonValueConverter): IJsonMapper<T>;
begin
  Result := WithConverterLocal(TFunc<TValue, TValue>(Func));
end;

function TJsonMapper<T>.WithConverterLocal(const Func: TFunc<TValue, TValue>): IJsonMapper<T>;
begin
  if not Assigned(FCurrentMapping) then
    raise Exception.Create('Field/ToProp must be called before WithConverter.');

  FCurrentMapping.Converter := Func;
  Result := Self;
end;

function TJsonMapper<T>.Validate(Func: TJsonValueValidator): IJsonMapper<T>;
begin
  Result := ValidateLocal(TFunc<TValue, Boolean>(Func));
end;

function TJsonMapper<T>.ValidateLocal(Func: TFunc<TValue, Boolean>): IJsonMapper<T>;
begin
  if not Assigned(FCurrentMapping) then
    raise Exception.Create('Field/ToProp must be called before Validate.');

  FCurrentMapping.Validator := Func;
  Result := Self;
end;
function TJsonMapper<T>.Apply(const JsonStr: string): T;
var
  ctx: TRttiContext;
  rttiType: TRttiType;
  obj: T;
  json: TJSONObject;
  mapping: TFieldMapping;
  val: TJSONValue;
  prop: TRttiProperty;
  value: TValue;
  propType: TRttiType;
//  list: TList<T>;
  item: TJSONValue;
begin
  obj := T.Create;
  ctx := TRttiContext.Create;
  json := TJSONObject.ParseJSONValue(JsonStr) as TJSONObject;

  try
    rttiType := ctx.GetType(T.ClassInfo);

    for mapping in FFields do
    begin
      val := ExtractNestedValue(json, mapping.JsonField);

      if Assigned(val) then
      begin
        prop := rttiType.GetProperty(mapping.PropName);
        if not Assigned(prop) then
          Continue;

        propType := prop.PropertyType;

        // Detecta se é lista + JSON array
        if (val is TJSONArray) and propType.ToString.Contains('TList<System.string>') then
        begin
          var list := TList<System.string>.Create;
          for item in TJSONArray(val) do
            list.Add(item.Value); // TJSONString.Value

          value := TValue.From<TList<string>>(list);
        end
        else
          value := JsonToTValue(val);
      end
      else if mapping.HasDefault then
        value := mapping.DefaultValue
      else
        Continue;

      if Assigned(mapping.Converter) then
        value := mapping.Converter(value);

      if Assigned(mapping.Validator) and not mapping.Validator(value) then
        raise Exception.CreateFmt('Invalid value for field %s', [mapping.JsonField]);

      prop := rttiType.GetProperty(mapping.PropName);
      if Assigned(prop) and prop.IsWritable then
        prop.SetValue(TObject(obj), value);
    end;

    Result := obj;
  finally
    json.Free;
  end;
end;

function TJsonMapper<T>.ToJsonDJOM(const Obj: T): string;
var
  ctx: TRttiContext;
  rttiType: TRttiType;
  mapping: TFieldMapping;
  prop: TRttiProperty;
  value: TValue;
  jsonObj: TJSONObject;
begin
  ctx := TRttiContext.Create;
  rttiType := ctx.GetType(T.ClassInfo);
  jsonObj := TJSONObject.Create;

  try
    for mapping in FFields do
    begin
      prop := rttiType.GetProperty(mapping.PropName);
      if Assigned(prop) and prop.IsReadable then
      begin
        value := prop.GetValue(TObject(Obj));
        if Assigned(mapping.Converter) then
          value := mapping.Converter(value);

        jsonObj.AddPair(mapping.JsonField, TJSONString.Create(value.ToString));
      end;
    end;

    Result := jsonObj.ToJSON;
  finally
    jsonObj.Free;
  end;
end;

end.

