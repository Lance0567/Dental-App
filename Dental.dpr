program Dental;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'forms\uMain.pas' {frmMain},
  uDm in 'data module\uDm.pas' {dm: TDataModule},
  uDashboard in 'frames\uDashboard.pas' {Frame1: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
