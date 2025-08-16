program Dental;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'forms\uMain.pas' {frmMain},
  uDm in 'data module\uDm.pas' {dm: TDataModule},
  uDashboard in 'frames\uDashboard.pas' {fDashboard: TFrame},
  uPatients in 'frames\uPatients.pas' {fPatients: TFrame},
  uAppointments in 'frames\uAppointments.pas' {fAppointments: TFrame},
  uPatientModal in 'modals\uPatientModal.pas' {fPatientModal: TFrame},
  uGlobal in 'global\uGlobal.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.
