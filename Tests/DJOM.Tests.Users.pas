unit DJOM.Tests.Users;

interface

uses
  System.Generics.Collections;
type
  TUser = class
  private
    FNome: string;
    FIdade: Integer;
    FAtivo: Boolean;
    FNascimento: TDate;
    FEmail: string;
    FCidade: string;
    FEmails: TList<string>;
  public
    property UserName: string read FNome write FNome;
    property Age: Integer read FIdade write FIdade;
    property Ativo: Boolean read FAtivo write FAtivo;
    property Nascimento: TDate read FNascimento write FNascimento;
    property Email: string read FEmail write FEmail;
    property Cidade: string read FCidade write FCidade;
    property Emails: TList<string> read FEmails write FEmails;
    constructor Create;
    destructor Destroy; override;
  end;
implementation

{ TUser }

constructor TUser.Create;
begin
  inherited;
  FEmails := TList<string>.Create;
end;

destructor TUser.Destroy;
begin
  FEmails.Free;
  inherited;
end;

end.
