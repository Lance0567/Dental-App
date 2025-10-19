unit uAdminSetup;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, uUserModal,
  uAppointmentModal;

type
  TfrmAdminSetup = class(TForm)
    fUserModal: TfUserModal;
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

end.
