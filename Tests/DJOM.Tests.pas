unit DJOM.Tests;

interface

uses
  Winapi.Windows, Winapi.Messages, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  DJOM.Converters, DJOM.Validations, DJOM.Types, DJOM.Mapper,
  DJOM.Interfaces.Mapper, DJOM.Tests.Users;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ButtonValidations: TButton;
    ButtonConverters: TButton;
    ButtonNestedFields: TButton;
    ButtonNestedDeep: TButton;
    ButtonToJson: TButton;
    ButtonListTest: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure ButtonConvertersClick(Sender: TObject);
    procedure ButtonValidationsClick(Sender: TObject);
    procedure ButtonNestedFieldsClick(Sender: TObject);
    procedure ButtonNestedDeepClick(Sender: TObject);
    procedure ButtonToJsonClick(Sender: TObject);
    procedure ButtonListTestClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  System.SysUtils, System.Rtti;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
    .Field('user_name').ToProp('UserName')
    .Field('age').ToProp('Age')
    .Field('ativo').ToProp('Ativo');

  user := mapper.Apply('{"user_name":"Diego","age":35,"ativo":true}');
  ShowMessage(user.UserName + ' - ' + user.Age.ToString + ' - ' + BoolToStr(user.Ativo, True));
  user.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin

   mapper := TJsonMapper<TUser>.Create()
  .Field('user_name').ToProp('UserName')
  .Field('age').ToProp('Age').WithDefault(18)
  .Field('ativo').ToProp('Ativo').WithDefault(True);


  user := mapper.Apply('{"user_name":"Diego"}');
  ShowMessage(user.UserName + ' - ' + user.Age.ToString + ' - ' + BoolToStr(user.Ativo, True));
  user.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
    .Field('user_name').ToProp('UserName')
    .Field('age').ToProp('Age').WithDefault(18)
    .Field('ativo').ToProp('Ativo').WithDefault(True)
    .Field('data').ToProp('Nascimento')
      .WithConverter(
        function(const V: TValue): TValue
        begin
          Result := StrToDate(V.AsString);
        end
      );

  user := mapper.Apply('{"user_name":"Diego","data":"01/01/2000"}');

  ShowMessage(
    Format('%s - %d - %s - %s',
      [user.UserName, user.Age, BoolToStr(user.Ativo, True), DateToStr(user.Nascimento)]
    )
  );

  user.Free;
end;




procedure TForm1.Button4Click(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
  .Field('age').ToProp('Age')
    .WithDefault(0)
    .WithConverter( TJsonValueConverter(
      function(const V: TValue): TValue
      begin
        Result := Abs(V.AsInteger);
      end)
    )
    .Validate(
      TJsonValueValidator(function(const V: TValue): Boolean
      begin
        Result := V.AsInteger <= 130;
      end)
    );

  try
    user := mapper.Apply('{"age":999}');
    ShowMessage(user.Age.ToString);
    user.Free;
  except
    on E: Exception do
      ShowMessage('Erro ao aplicar JSON: ' + E.Message);
  end;
end;

procedure TForm1.ButtonConvertersClick(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
    .Field('nome').ToProp('Nome')
      .WithConverter(TConverters.Trim())
      .WithConverter(TConverters.UpperCase())
    .Field('data').ToProp('Nascimento')
      .WithConverter(TConverters.ToDate());

  user := mapper.Apply('{"nome":"  diego  ", "data":"01/01/2000"}');

  ShowMessage(Format('Nome: %s | Data: %s',
    [user.UserName, DateToStr(user.Nascimento)]));

  user.Free;
end;

procedure TForm1.ButtonListTestClick(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
  emailList: string;
  email: string;
begin
  mapper := TJsonMapper<TUser>.Create
    .Field('emails').ToProp('Emails');

  user := mapper.Apply('{"emails": ["a@a.com", "b@b.com", "c@a.com"]}');

  emailList := '';
  for email in user.Emails do
    emailList := emailList + email + sLineBreak;

  ShowMessage('Emails carregados:' + sLineBreak + emailList);

  user.Free;
end;

procedure TForm1.ButtonNestedDeepClick(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
    .Field('user.endereco.cidade').ToProp('Cidade');

  user := mapper.Apply('{"user": { "endereco": { "cidade": "São Paulo" } } }');

  ShowMessage('Cidade: ' + user.Cidade);
  user.Free;
end;

procedure TForm1.ButtonNestedFieldsClick(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
    .Field('user.nome').ToProp('UserName')
    .Field('user.ativo').ToProp('Ativo');

  user := mapper.Apply('{"user": { "nome": "Diego", "ativo": true } }');

  ShowMessage(Format('Nome: %s | Ativo: %s',
    [user.UserName, BoolToStr(user.Ativo, True)]));

  user.Free;
end;



procedure TForm1.ButtonToJsonClick(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
  json: string;
begin
  user := TUser.Create;
  user.UserName := 'Diego';
  user.Age := 35;
  user.Ativo := True;
  user.Email := 'diego@email.com';

  mapper := TJsonMapper<TUser>.Create
    .Field('user_name').ToProp('UserName')
    .Field('age').ToProp('Age')
    .Field('ativo').ToProp('Ativo')
    .Field('email').ToProp('Email');

  json := mapper.ToJsonDJOM(user);
  ShowMessage(json);

  user.Free;
end;

procedure TForm1.ButtonValidationsClick(Sender: TObject);
var
  mapper: IJsonMapper<TUser>;
  user: TUser;
begin
  mapper := TJsonMapper<TUser>.Create()
    .Field('email').ToProp('Email')
      .Validate(TValidations.Required())
      .Validate(TValidations.MaxLength(50))
    .Field('age').ToProp('Age')
      .Validate(TValidations.Range(0, 130));

  try
    user := mapper.Apply('{"email":"teste@email.com", "age":29}');
    ShowMessage(Format('Email: %s | Idade: %d',
      [user.Email, user.Age]));
    user.Free;
  except
    on E: Exception do
      ShowMessage('Erro: ' + E.Message);
  end;
end;


end.
