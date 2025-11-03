unit uAdminSetup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  uUserModal, uAppointmentModal;

type
  TfrmAdminSetup = class(TForm)
    fUserModal: TfUserModal;
    procedure fUserModalbtnCancelClick(Sender: TObject);
    procedure fUserModalbtnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure fUserModalbtnSaveUserClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAdminSetup: TfrmAdminSetup;

implementation

{$R *.fmx}

uses uDm;

{ OnClose }
procedure TfrmAdminSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := TCloseAction(2);
  frmAdminSetup := nil;
end;

{ OnResize Form }
procedure TfrmAdminSetup.FormResize(Sender: TObject);
begin
  // Modal content margins
  if (frmAdminSetup.ClientWidth >= 1920) then
  begin
    fUserModal.rModalInfo.Margins.Left := 700;
    fUserModal.rModalInfo.Margins.Right := 700;
    fUserModal.rModalInfo.Margins.Top := 150;
    fUserModal.rModalInfo.Margins.Bottom := 150;
  end
  else if (frmAdminSetup.ClientWidth >= 1366) then
  begin
    fUserModal.rModalInfo.Margins.Left := 440;
    fUserModal.rModalInfo.Margins.Right := 440;
    fUserModal.rModalInfo.Margins.Top := 75;
    fUserModal.rModalInfo.Margins.Bottom := 75;
  end
  else if (frmAdminSetup.ClientWidth <= 860) then
  begin
    fUserModal.rModalInfo.Margins.Left := 120;
    fUserModal.rModalInfo.Margins.Right := 120;
    fUserModal.rModalInfo.Margins.Top := 50;
    fUserModal.rModalInfo.Margins.Bottom := 50;
  end;

  // Lock the form
  if frmAdminSetup.ClientWidth <= 754 then
    frmAdminSetup.ClientWidth := 755;
end;

{ Cancel Button }
procedure TfrmAdminSetup.fUserModalbtnCancelClick(Sender: TObject);
begin
  fUserModal.btnCancelClick(Sender);

  // Then release main form safely
  if Assigned(frmAdminSetup) then
  begin
    Close;  // Triggers OnClose which frees the form
    frmAdminSetup := nil;
  end;
end;

{ Close Button }
procedure TfrmAdminSetup.fUserModalbtnCloseClick(Sender: TObject);
begin
  fUserModal.btnCloseClick(Sender);

  // Then release main form safely
  if Assigned(frmAdminSetup) then
  begin
    Close;  // Triggers OnClose which frees the form
    frmAdminSetup := nil;
  end;
end;

procedure TfrmAdminSetup.fUserModalbtnSaveUserClick(Sender: TObject);
begin
  fUserModal.btnSaveUserClick(Sender);
end;

end.
