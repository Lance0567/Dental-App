unit uAdminSetup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uUserModal,
  uAppointmentModal;

type
  TfrmAdminSetup = class(TForm)
    fUserModal: TfUserModal;
    procedure fUserModalbtnCancelClick(Sender: TObject);
    procedure fUserModalbtnCloseClick(Sender: TObject);
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

{ Cancel Button }
procedure TfrmAdminSetup.fUserModalbtnCancelClick(Sender: TObject);
begin
  fUserModal.btnCancelClick(Sender);
  frmAdminSetup.Close;
  frmAdminSetup := nil;
end;

{ Close Button }
procedure TfrmAdminSetup.fUserModalbtnCloseClick(Sender: TObject);
begin
  fUserModal.btnCloseClick(Sender);
  frmAdminSetup.Close;
  frmAdminSetup := nil;
end;

end.
