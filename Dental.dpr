program Dental;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'forms\uMain.pas' {frmMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
