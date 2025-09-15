unit uUserModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.ImgList,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  System.Skia, FMX.Skia;

type
  TfUserModal = class(TFrame)
    lytContentH: TLayout;
    rBackground: TRectangle;
    rModalInfo: TRectangle;
    ScrollBox1: TScrollBox;
    lytUserH: TLayout;
    lytFullName: TLayout;
    lbFullName: TLabel;
    eFullName: TEdit;
    lytTitle: TLayout;
    lbTitle: TLabel;
    btnClose: TSpeedButton;
    lytPatientProfile: TLayout;
    lytProfilePhoto: TLayout;
    lytPhotoButton: TLayout;
    lytPhotoButtonH: TLayout;
    cProfilePhoto: TCircle;
    gIcon: TGlyph;
    lNameH: TLabel;
    btnPhotoUpload: TCornerButton;
    btnCamera: TCornerButton;
    lProfileUploadDesc: TLabel;
    lytEmailAddress: TLayout;
    lEmailAddress: TLabel;
    eEmailAddress: TEdit;
    lProfilePhoto: TLabel;
    lPersonalInfo: TLabel;
    lytPhoneNumber: TLayout;
    lContactNumber: TLabel;
    ePhoneNumber: TEdit;
    rUser: TRectangle;
    rRoleAndAccess: TRectangle;
    lytRoleAndAccessH: TLayout;
    lytButtonSaveH: TLayout;
    btnCreateUser: TCornerButton;
    lTag: TLabel;
    btnCancel: TCornerButton;
    lytRole: TLayout;
    lRole: TLabel;
    cbRole: TComboBox;
    lRoleInput: TLabel;
    lytStatus: TLayout;
    lStatus: TLabel;
    cbStatus: TComboBox;
    lStatusInput: TLabel;
    slRoleAndAccess: TSkLabel;
    Layout1: TLayout;
    lDepartment: TLabel;
    eDepartment: TEdit;
    procedure btnCloseClick(Sender: TObject);
    procedure cbRoleChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure cbStatusMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure cbRoleMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain;

procedure TfUserModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

procedure TfUserModal.cbRoleChange(Sender: TObject);
begin
  lRoleInput.Text := cbRole.Text;
end;

{ Prevents Mouse wheel on Role }
procedure TfUserModal.cbRoleMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  Handled := True; // Prevents the combo box from scrolling
end;

{ Prevents Mouse wheel on Status }
procedure TfUserModal.cbStatusMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  Handled := True; // Prevents the combo box from scrolling
end;

{ Frame Resize }
procedure TfUserModal.FrameResize(Sender: TObject);
begin
  // Modal content margins
  if (frmMain.ClientHeight >= 520) AND (frmMain.ClientWidth >= 870) then
  begin
    rModalInfo.Margins.Left := 310;
    rModalInfo.Margins.Right := 310;
    rModalInfo.Margins.Top := 60;
    rModalInfo.Margins.Bottom := 60;
  end;

  if (frmMain.ClientHeight <= 510) AND (frmMain.ClientWidth <= 860) then
  begin
    rModalInfo.Margins.Left := 70;
    rModalInfo.Margins.Right := 70;
    rModalInfo.Margins.Top := 30;
    rModalInfo.Margins.Bottom := 30;
  end;
end;

end.
