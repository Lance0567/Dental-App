unit uUserModal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Memo.Types, FMX.ListBox, FMX.DateTimeCtrls, FMX.Edit, FMX.ImgList,
  FMX.Objects, FMX.ScrollBox, FMX.Memo, FMX.Controls.Presentation, FMX.Layouts,
  System.Skia, FMX.Skia, FMX.Effects, Data.DB;

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
    lytContactNumber: TLayout;
    lContactNumber: TLabel;
    eContactNumber: TEdit;
    rUser: TRectangle;
    rRoleAndAccess: TRectangle;
    lytRoleAndAccessH: TLayout;
    lytButtonSaveH: TLayout;
    btnSaveUser: TCornerButton;
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
    lytDepartment: TLayout;
    lDepartment: TLabel;
    eDepartment: TEdit;
    imgProfilePhoto: TImage;
    rImageFrame: TRectangle;
    crFullName: TCalloutRectangle;
    gFullName: TGlyph;
    lFullNameW: TLabel;
    ShadowEffect1: TShadowEffect;
    crEmailAddress: TCalloutRectangle;
    gEmailAddress: TGlyph;
    lEmailAddressW: TLabel;
    ShadowEffect2: TShadowEffect;
    crContactNumber: TCalloutRectangle;
    gContactNumber: TGlyph;
    lContactNumberW: TLabel;
    ShadowEffect3: TShadowEffect;
    lytUsername: TLayout;
    lUserName: TLabel;
    eUsername: TEdit;
    crUsername: TCalloutRectangle;
    gUsername: TGlyph;
    lUsernameW: TLabel;
    ShadowEffect4: TShadowEffect;
    lytPassword: TLayout;
    lPassword: TLabel;
    ePassword: TEdit;
    crPassword: TCalloutRectangle;
    gPassword: TGlyph;
    lPasswordW: TLabel;
    ShadowEffect5: TShadowEffect;
    procedure btnCloseClick(Sender: TObject);
    procedure cbRoleChange(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure cbStatusMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure cbRoleMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveUserClick(Sender: TObject);
  private
    { Private declarations }
  public
    RecordStatus: String;
    procedure ClearItems;
    { Public declarations }
  end;

implementation

{$R *.fmx}

uses uDm, uMain, uGlobal;

{ Clear Fields }
procedure TfUserModal.ClearItems;
begin
  // Fields
  eFullName.Text := '';
  eUsername.Text := '';
  ePassword.Text := '';
  eEmailAddress.Text := '';
  eContactNumber.Text := '';
  cbRole.ItemIndex := 0;
  eDepartment.Text := '';
  cbStatus.ItemIndex := 0;
  imgProfilePhoto.Bitmap := nil; // set image to empty
end;

{ Cancel Button }
procedure TfUserModal.btnCancelClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Close Button }
procedure TfUserModal.btnCloseClick(Sender: TObject);
begin
  Self.Visible := False;
end;

{ Create User }
procedure TfUserModal.btnSaveUserClick(Sender: TObject);
var
  ms: TMemoryStream;
  HasError: Boolean;
  FirstInvalidPos: Single;
begin
  HasError := False;
  FirstInvalidPos := -1;

  // FullName validation
  if eFullName.Text = '' then
  begin
    AdjustLayoutHeight(lytFullname, 95);
    crFullName.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eFullname.Position.Y;
    HasError := True;
  end
  else
    crFullName.Visible := False;

  // Username validation
  if eUsername.Text = '' then
  begin
    AdjustLayoutHeight(lytUsername, 95);
    crUsername.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eUsername.Position.Y;
    HasError := True;
  end
  else
    crUsername.Visible := False;

  // Password validation
  if ePassword.Text = '' then
  begin
    AdjustLayoutHeight(lytPassword, 95);
    crPassword.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := ePassword.Position.Y;
    HasError := True;
  end
  else
    crPassword.Visible := False;

  // Email validation
  if eEmailAddress.Text = '' then
  begin
    AdjustLayoutHeight(lytEmailAddress, 95);
    crEmailAddress.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eEmailAddress.Position.Y;
    HasError := True;
  end
  else
    crEmailAddress.Visible := False;

  // Contact Number validation
  if eContactNumber.Text = '' then
  begin
    AdjustLayoutHeight(lytContactNumber, 95);
    crContactNumber.Visible := True;
    if FirstInvalidPos = -1 then
      FirstInvalidPos := eContactNumber.Position.Y;
    HasError := True;
  end
  else
    crContactNumber.Visible := False;

  // Save image to LONGBLOB
  if Assigned(imgProfilePhoto.Bitmap) and not imgProfilePhoto.Bitmap.IsEmpty then
  begin
    ms := TMemoryStream.Create;
    try
      imgProfilePhoto.Bitmap.SaveToStream(ms);
      ms.Position := 0;
      TBlobField(dm.qPatients.FieldByName('profile_pic')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
  end;

  // Stop if any error is found
  if HasError = True then
  begin
    ScrollBox1.ViewportPosition := PointF(0, FirstInvalidPos - 50);
    Exit;
  end;

  // Handle record state
  if RecordStatus = 'Add' then
    dm.qPatients.Append
  else
    dm.qPatients.Edit;

  // Fields to save
  dm.qUsers.FieldByName('name').AsString := eFullName.Text;
  dm.qUsers.FieldByName('username').AsString := eUsername.Text;
  dm.qUsers.FieldByName('password')
end;

{ Role On Change }
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
