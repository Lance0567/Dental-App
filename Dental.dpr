program Dental;

uses
  System.StartUpCopy,
  FMX.Forms,
  uLogin in 'forms\uLogin.pas' {frmLogin},
  uMain in 'forms\uMain.pas' {frmMain},
  uDm in 'data module\uDm.pas' {dm: TDataModule},
  uDashboard in 'frames\uDashboard.pas' {fDashboard: TFrame},
  uPatients in 'frames\uPatients.pas' {fPatients: TFrame},
  uAppointments in 'frames\uAppointments.pas' {fAppointments: TFrame},
  uPatientModal in 'modals\uPatientModal.pas' {fPatientModal: TFrame},
  uGlobal in 'global\uGlobal.pas',
  uUsers in 'frames\uUsers.pas' {fUsers: TFrame},
  uUserProfile in 'frames\uUserProfile.pas' {fUserProfile: TFrame},
  uUserModal in 'modals\uUserModal.pas' {fUserModal: TFrame},
  uUserDetails in 'modals\uUserDetails.pas' {fUserDetails: TFrame},
  uUpdateProfilePhoto in 'modals\uUpdateProfilePhoto.pas' {fUpdateProfilePhoto: TFrame},
  uAppointmentModal in 'modals\uAppointmentModal.pas' {fAppointmentModal: TFrame},
  uToolbar in 'frames\uToolbar.pas' {fToolbar: TFrame},
  uAdminSetup in 'forms\uAdminSetup.pas' {frmAdminSetup},
  uContactInfo in 'modals\uContactInfo.pas' {fContactInfo: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tdm, dm);
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.Run;
end.
