program DJOM.Demo;

uses
  Vcl.Forms,
  DJOM.Tests in '..\Tests\DJOM.Tests.pas' {Form1},
  DJOM.Mapper in '..\Source\DJOM.Mapper.pas',
  DJOM.Converters in '..\Source\DJOM.Converters.pas',
  DJOM.Validations in '..\Source\DJOM.Validations.pas',
  DJOM.Types in '..\Source\DJOM.Types.pas',
  DJOM.Fields.Mapper in '..\Source\DJOM.Fields.Mapper.pas',
  DJOM.Interfaces.Mapper in '..\Source\DJOM.Interfaces.Mapper.pas',
  DJOM.Tests.Users in '..\Tests\DJOM.Tests.Users.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
